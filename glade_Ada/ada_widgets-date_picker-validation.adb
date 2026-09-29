-------------------------------------------------------------------------------
--                          A d a   W i d g e t s                            --
--                                                                           --
--                     Copyright (C) 2026 Juan L. Freniche                   --
--                                                                           --
--  This program is free software;  you can redistribute it and-or modify it --
--  under terms of the  GNU General Public License and/or the GNU Lesser     --
--  General Public License, published by the Free Software  Foundation;      --
--  either versions 3,  or (at your  option) any later version.              --
--  It is is distributed in the hope that it will be useful, but             --
--  WITHOUT ANY WARRANTY;  without even the implied warranty of MERCHAN-     --
--  TABILITY or FITNESS FOR A PARTICULAR PURPOSE.                            --
--                                                                           --
--  You should have received a copy of the GNU General Public License and of --
--  the GNU Lesser General Public License along with this program; see files --
--  LICENSE.GLP and LICENSE.LGPL. If not, see <http:--www.gnu.org-licenses-> --
-------------------------------------------------------------------------------
with Interfaces.C;
with Interfaces.C.Strings;
with Ada.Characters.Handling;
with Glib;
with Glib.Object;                   use Glib.Object;
with Glib.Values;                   use Glib.Values;
with Glade_Binding;
with Glade_Binding.Properties;          use Glade_Binding.Properties;
with Glade_Binding.Property_Definition; use Glade_Binding.Property_Definition;
with Glade_Binding.Widget;              use Glade_Binding.Widget;

package body Ada_Widgets.Date_Picker.Validation is

   package IC  renames Interfaces.C;
   package ICS renames Interfaces.C.Strings; use ICS;

   -----------------------------------------------------------------------------
   function Is_Leap_Year (Year : Integer) return Boolean;
   function Is_Leap_Year (Year : Integer) return Boolean is
   begin
      return (Year mod 4 = 0 and then Year mod 100 /= 0) or else (Year mod 400 = 0);
   end Is_Leap_Year;

   -----------------------------------------------------------------------------
   function Days_In_Month (Year : Integer; Month : Integer) return Integer;
   function Days_In_Month (Year : Integer; Month : Integer) return Integer is
   begin
      case Month is
         when 1 | 3 | 5 | 7 | 8 | 10 | 12 =>
            return 31;
         when 4 | 6 | 9 | 11 =>
            return 30;
         when 2 =>
            if Is_Leap_Year (Year) then
               return 29;
            else
               return 28;
            end if;
         when others =>
            return 0;
      end case;
   end Days_In_Month;

   -----------------------------------------------------------------------------
   -- IS VALID FORMAT
   -----------------------------------------------------------------------------
   function Is_Valid_Format (Date_Str : String) return Boolean is
      S     : constant Integer := Date_Str'First;
      Y_Val : Integer;
      M_Val : Integer;
      D_Val : Integer;
   begin
      if Date_Str'Length /= 10 then
         return False;
      end if;

      if Date_Str (S + 4) /= '-' or else Date_Str (S + 7) /= '-' then
         return False;
      end if;

      declare
         Y_Str : constant String := Date_Str (S .. S + 3);
         M_Str : constant String := Date_Str (S + 5 .. S + 6);
         D_Str : constant String := Date_Str (S + 8 .. S + 9);
      begin
         for C of Y_Str loop
            if not Ada.Characters.Handling.Is_Digit (C) then
               return False;
            end if;
         end loop;

         for C of M_Str loop
            if not Ada.Characters.Handling.Is_Digit (C) then
               return False;
            end if;
         end loop;

         for C of D_Str loop
            if not Ada.Characters.Handling.Is_Digit (C) then
               return False;
            end if;
         end loop;

         Y_Val := Integer'Value (Y_Str);
         M_Val := Integer'Value (M_Str);
         D_Val := Integer'Value (D_Str);
      end;

      return Y_Val in 1901 .. 2399 and then
             M_Val in 1 .. 12      and then
             D_Val in 1 .. Days_In_Month (Y_Val, M_Val);

   exception
      when others =>
         return False;
   end Is_Valid_Format;

   ------------------------------------------------------------------
   --  Thin imports of the C helpers that already exist
   ------------------------------------------------------------------
   function G_Date_Valid_Dmy
     (Day   : Glib.Guint;
      Month : Glib.Guint;
      Year  : Glib.Guint) return ICE.bool;
   pragma Import (C, G_Date_Valid_Dmy, "g_date_valid_dmy");

   ------------------------------------------------------------------
   --  Validate format + calendar validity (YYYY-MM-DD only)
   --  Returns:
   --    0 = ok
   --    1 = wrong format
   --    2 = invalid date (day/month/year)
   ------------------------------------------------------------------
   function Validate_Date_Format (Date_Str : ICS.chars_ptr) return Integer;
   function Validate_Date_Format (Date_Str : ICS.chars_ptr) return Integer is
      Year, Month, Day : Glib.Guint := 0;
      Str              : constant String :=
                           (if Date_Str = Null_Ptr then "" else Value (Date_Str));

      use IC;
   begin
      if Str'Length = 0 then
         return 0;   -- empty is accepted by the format check
      end if;

      --  Exact format YYYY-MM-DD
      if Str'Length /= 10
         or else Str (Str'First + 4) /= '-'
         or else Str (Str'First + 7) /= '-'
      then
         return 1;
      end if;

      begin
         Year  := Glib.Guint'Value (Str (Str'First     .. Str'First + 3));
         Month := Glib.Guint'Value (Str (Str'First + 5 .. Str'First + 6));
         Day   := Glib.Guint'Value (Str (Str'First + 8 .. Str'First + 9));
      exception
         when others =>
            return 1;
      end;

      if G_Date_Valid_Dmy (Day, Month, Year) = False then
         return 2;
      end if;

      return 0;
   end Validate_Date_Format;

   ------------------------------------------------------------------
   --  Core validation (mirrors ada_date_picker_validate_date_value)
   ------------------------------------------------------------------
   Showing_Error : Boolean := False;   -- reentrancy guard

   function Validate_Date_Value
     (Object   : Glade_Binding.GObject_Ptr;
      Prop_Id  : chars_ptr;
      New_Date : chars_ptr) return Boolean;
   function Validate_Date_Value
     (Object   : Glade_Binding.GObject_Ptr;
      Prop_Id  : chars_ptr;
      New_Date : chars_ptr) return Boolean
   is

      Is_Min       : Boolean;
      Other_Date   : chars_ptr := Null_Ptr;
      Actual_Other : chars_ptr;
      Val_Res      : Integer;
      Cmp          : Integer;
      Gwidget      : Glade_Widget;
      Other_Prop   : Glade_Binding.Properties.Property;
      Other_Value  : aliased GValue;
      Other_Id     : constant String :=
        (if Prop_Id /= Null_Ptr and then Value (Prop_Id) = "min-date"
         then "max-date" else "min-date");

      use type IC.size_t;
      use type Glib.GType;
      use type Glade_Binding.GObject_Ptr;
   begin
      --  Reentrancy protection
      if Showing_Error then
         return False;
      end if;

      Val_Res := Validate_Date_Format (New_Date);

      if Val_Res = 1 then
         Showing_Error := True;
         Show_Error_Dialog
           ("Date Picker Error",
            "Invalid date format." & ASCII.LF & ASCII.LF &
            "Use the format YYYY-MM-DD");
         Showing_Error := False;
         return False;
      elsif Val_Res = 2 then
         Showing_Error := True;
         Show_Error_Dialog ("Date Picker Error", "Invalid date");
         Showing_Error := False;
         return False;
      end if;

      --  Range check 1901-01-01 .. 2399-12-31
      if New_Date /= Null_Ptr then
         declare
            S : constant String := Value (New_Date);
         begin
            if S < "1901-01-01" or else S > "2399-12-31" then
               Showing_Error := True;
               Show_Error_Dialog
                 ("Date Picker Error",
                  "Date out of range." & ASCII.LF & ASCII.LF &
                  "Dates must be between 1901-01-01 and 2399-12-31");
               Showing_Error := False;
               return False;
            end if;
         end;
      end if;

      if Object = null or else Prop_Id = Null_Ptr then
         return True;
      end if;

      Is_Min := Value (Prop_Id) = "min-date";

      --  Obtain the other property through the GladeWidget
      Gwidget := Get_From_Gobject (Object);
      if Gwidget /= null then
         Other_Prop := Get_Property (Gwidget, New_String (Other_Id));
         if Other_Prop /= null then
            Get_Value (Other_Prop, Other_Value'Access);
            if Type_Of (Other_Value) = Glib.GType_String then
               Other_Date := New_String (Get_String (Other_Value));
            end if;
            Unset (Other_Value);
         end if;
      end if;

      Actual_Other := Other_Date;
      if Actual_Other = Null_Ptr
        or else ICS.Strlen (Actual_Other) = 0
      then
         Actual_Other := New_String
           (if Is_Min then "2399-12-31" else "1901-01-01");
      end if;

      if Validate_Date_Format (Actual_Other) = 0
         and then New_Date /= Null_Ptr
      then
         declare
            New_S   : constant String := Value (New_Date);
            Other_S : constant String := Value (Actual_Other);
         begin
            if New_S < Other_S then
               Cmp := -1;
            elsif New_S > Other_S then
               Cmp := 1;
            else
               Cmp := 0;
            end if;
         end;

         if Is_Min and then Cmp > 0 then
            Showing_Error := True;
            Show_Error_Dialog
              ("Date Picker Error",
               "Minimum date cannot be later than maximum date.");
            Showing_Error := False;
            return False;
         end if;

         if not Is_Min and then Cmp < 0 then
            Showing_Error := True;
            Show_Error_Dialog
              ("Date Picker Error",
               "Maximum date cannot be earlier than minimum date.");
            Showing_Error := False;
            return False;
         end if;
      end if;

      return True;
   end Validate_Date_Value;

   ------------------------------------------------------------------
   --  Entry point used by the editor
   ------------------------------------------------------------------
   function Ada_Date_Picker_Validate_Dates (Eprop : Editor_Prop;
                                            Value : access GValue)
                                            return ICE.bool
   is

      Prop     : constant Property := Get_Property (Eprop);
      Pdef     : Property_Def;
      Prop_Id  : chars_ptr := Null_Ptr;
      New_Date : chars_ptr;
      Gwidget  : Glade_Widget;
      Object   : Glade_Binding.GObject_Ptr := null;
   begin
      if Prop = null then
         return IC.True;
      end if;

      Pdef := Get_Def (Prop);
      if Pdef /= null then
         Prop_Id := Get_Id (Pdef);
      end if;

      New_Date := ICS.New_String (Get_String (Value.all));

      Gwidget := Get_Widget (Prop);
      if Gwidget /= null then
         Object := Get_Object (Gwidget);
      end if;

      if not Validate_Date_Value (Object, Prop_Id, New_Date) then
         --  Restore the previous value in the editor
         Eprop.Load (Prop);
         return IC.False;
      end if;

      return IC.True;
   end Ada_Date_Picker_Validate_Dates;

end Ada_Widgets.Date_Picker.Validation;
