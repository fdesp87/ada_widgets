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
--  LICENSE.GLP and LICENSE.LGPL. If not, see <http:--www.gnu.org-licenses-> --                              --
-------------------------------------------------------------------------------
with Glib;                use Glib;
with Glib.Object;         use Glib.Object;
with Glib.Values;
with Glib.Properties;
with Glib.Properties.Creation; use Glib.Properties.Creation;
with Gtk.Enums;
with Gtk.Image;
with Gtk.Box;
with Gtk.Handlers;
with Gtk.Css_Provider;    use Gtk.Css_Provider;
with Gtk.Style_Provider;  use Gtk.Style_Provider;
with Gtk.Style_Context;
with Gdk.Screen;
with Glib.Error;
with Gtk.Widget;

with Ada.Characters.Handling;
with Ada.Calendar;

with Glib.Type_Conversion_Hooks;

package body Gtk_Ada_Date_Picker is

   package Widget_Focus_Handlers is new Gtk.Handlers.User_Return_Callback
     (Gtk.Widget.Gtk_Widget_Record, Boolean, Ada_Date_Picker);

   package Picker_Handlers is new Gtk.Handlers.User_Callback
     (Gtk.Button.Gtk_Button_Record, Ada_Date_Picker);

   package Calendar_Handlers is new Gtk.Handlers.User_Callback
     (Gtk.Calendar.Gtk_Calendar_Record, Ada_Date_Picker);

   package Entry_Handlers is new Gtk.Handlers.User_Callback
     (Gtk.GEntry.Gtk_Entry_Record, Ada_Date_Picker);

   -----------------------------------------------------------------------------
   PROP_MIN_DATE : constant Property_Id := 1;
   PROP_MAX_DATE : constant Property_Id := 2;

   procedure Set_Property (Object        : access Glib.Object.GObject_Record'Class;
                           Prop_Id       : Property_Id;
                           Value         : Glib.Values.GValue;
                           Property_Spec : Param_Spec);

   procedure Set_Property (Object        : access Glib.Object.GObject_Record'Class;
                           Prop_Id       : Property_Id;
                           Value         : Glib.Values.GValue;
                           Property_Spec : Param_Spec) is
      Widget : constant Ada_Date_Picker := Ada_Date_Picker (Object);
      Str    : constant String := Glib.Values.Get_String (Value);
      pragma Unreferenced (Property_Spec);
   begin
      case Prop_Id is
         when PROP_MIN_DATE =>
            Set_Min_Date (Widget, Str);
         when PROP_MAX_DATE =>
            Set_Max_Date (Widget, Str);
         when others =>
            null;
      end case;
   end Set_Property;

   -----------------------------------------------------------------------------
   procedure Get_Property (Object        : access Glib.Object.GObject_Record'Class;
                           Prop_Id       : Property_Id;
                           Value         : out Glib.Values.GValue;
                           Property_Spec : Param_Spec);

   procedure Get_Property (Object        : access Glib.Object.GObject_Record'Class;
                           Prop_Id       : Property_Id;
                           Value         : out Glib.Values.GValue;
                           Property_Spec : Param_Spec) is
      Widget : constant Ada_Date_Picker := Ada_Date_Picker (Object);
      pragma Unreferenced (Property_Spec);
   begin
      case Prop_Id is
         when PROP_MIN_DATE =>
            Glib.Values.Set_String (Value, Widget.Min_Date);
         when PROP_MAX_DATE =>
            Glib.Values.Set_String (Value, Widget.Max_Date);
         when others =>
            null;
      end case;
   end Get_Property;

   -----------------------------------------------------------------------------
   Klass : aliased Glib.Object.Ada_GObject_Class := Glib.Object.Uninitialized_Class;

   procedure Class_Init (Self : GObject_Class);
   pragma Convention (C, Class_Init);
   procedure Class_Init (Self : GObject_Class) is
   begin
      Set_Properties_Handlers (Self, Set_Property'Access, Get_Property'Access);

      Install_Property
        (Class_Record  => Self,
         Prop_Id       => PROP_MIN_DATE,
         Property_Spec => Gnew_String
             (Name    => "min-date",
              Nick    => "Min Date",
              Blurb   => "Minimum allowed date",
              Default => "1901-01-01",
              Flags   => Param_Readable or Param_Writable));

      Install_Property
        (Class_Record  => Self,
         Prop_Id       => PROP_MAX_DATE,
         Property_Spec => Gnew_String
           (Name    => "max-date",
            Nick    => "Max Date",
            Blurb   => "Maximum allowed date",
            Default => "2399-12-31",
            Flags   => Param_Readable or Param_Writable));
   end Class_Init;

   -----------------------------------------------------------------------------
   function Get_Type return Glib.GType;
   pragma Convention (C, Get_Type);
   function Get_Type return Glib.GType is
   begin
      if Klass = Glib.Object.Uninitialized_Class then
         if Glib.Object.Initialize_Class_Record
           (Ancestor     => Gtk.Frame.Get_Type,
            Class_Record => Klass'Access,
            Type_Name    => "AdaDatePicker",
            Class_Init   => Class_Init'Access)
         then
            null;
         end if;
      end if;
      return Klass.The_Type;
   end Get_Type;

   -----------------------------------------------------------------------------
   package Type_Conversion_Ada_Date_Picker is
     new Glib.Type_Conversion_Hooks.Hook_Registrator
       (Gtk_Ada_Date_Picker.Get_Type'Access, Ada_Date_Picker_Record);
   pragma Unreferenced (Type_Conversion_Ada_Date_Picker);

   -----------------------------------------------------------------------------
   --  When using GtkBuilder, place this call after Gtk.Main.Init
   procedure Init is
      Dummy : Glib.GType;
   begin
      Dummy := Gtk_Ada_Date_Picker.Get_Type;
   end Init;

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
   function Date_Less_Or_Equal (Date1, Date2 : String) return Boolean;
   function Date_Less_Or_Equal (Date1, Date2 : String) return Boolean is
   begin
      return Date1 <= Date2;
   end Date_Less_Or_Equal;

   -----------------------------------------------------------------------------
   function Is_Valid_Format (Date_Str : String) return Boolean;
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

   -----------------------------------------------------------------------------
   procedure Set_Min_Date (Widget   : not null access Ada_Date_Picker_Record;
                           Date_Str : String) is
   begin
      if Is_Valid_Format (Date_Str) then
         Widget.Min_Date := Date_Str;
      end if;
   end Set_Min_Date;

   -----------------------------------------------------------------------------
   procedure Set_Max_Date (Widget   : not null access Ada_Date_Picker_Record;
                           Date_Str : String) is
   begin
      if Is_Valid_Format (Date_Str) then
         Widget.Max_Date := Date_Str;
      end if;
   end Set_Max_Date;

   -----------------------------------------------------------------------------
   procedure Copy_Calendar_To_Entries (Picker : Ada_Date_Picker);
   procedure Copy_Calendar_To_Entries (Picker : Ada_Date_Picker) is
      Year        : aliased Guint;
      Month       : aliased Guint;
      Day         : aliased Guint;
      Y_Val       : Integer;
      M_Val       : Integer;
      D_Val       : Integer;
      Y_Str       : String (1 .. 4);
      Min_Year    : constant Integer := Integer'Value (Picker.Min_Date (1 .. 4));
      Max_Year    : constant Integer := Integer'Value (Picker.Max_Date (1 .. 4));
   begin
      Picker.Calendar.Get_Date (Year, Month, Day);
      Y_Val := Integer (Year);

      if Y_Val < Min_Year then
         Picker.Calendar.Select_Month (Month, Guint (Min_Year));
         return;
      elsif Y_Val > Max_Year then
         Picker.Calendar.Select_Month (Month, Guint (Max_Year));
         return;
      end if;

      Y_Str := Integer'Image (Y_Val)(2 .. 5);
      Picker.Year_Entry.Set_Text (Y_Str);
      Picker.Year_Entry.Set_Position (0);

      M_Val := Integer (Month) + 1;
      if M_Val < 10 then
         Picker.Month_Entry.Set_Text ("0" & Character'Val (Character'Pos ('0') + M_Val));
      else
         declare
            M_Str : constant String := Integer'Image (M_Val);
         begin
            Picker.Month_Entry.Set_Text (M_Str (M_Str'First + 1 .. M_Str'Last));
         end;
      end if;

      D_Val := Integer (Day);
      if D_Val < 10 then
         Picker.Day_Entry.Set_Text ("0" & Character'Val (Character'Pos ('0') + D_Val));
      else
         declare
            D_Str : constant String := Integer'Image (D_Val);
         begin
            Picker.Day_Entry.Set_Text (D_Str (D_Str'First + 1 .. D_Str'Last));
         end;
      end if;
   end Copy_Calendar_To_Entries;

   -----------------------------------------------------------------------------
   function On_Entry_Focus_Out (Widget : access Gtk.Widget.Gtk_Widget_Record'Class;
                                Picker : Ada_Date_Picker) return Boolean;
   function On_Entry_Focus_Out (Widget : access Gtk.Widget.Gtk_Widget_Record'Class;
                                Picker : Ada_Date_Picker) return Boolean is
      pragma Unreferenced (Widget);
      Test_Date : constant String := Get_Date (Picker);
   begin
      if not Set_Date (Picker, Test_Date) then
         Copy_Calendar_To_Entries (Picker);
      else
         declare
            Y_Val : constant Integer := Integer'Value (Picker.Year_Entry.Get_Text);
            M_Val : constant Integer := Integer'Value (Picker.Month_Entry.Get_Text);
            D_Val : constant Integer := Integer'Value (Picker.Day_Entry.Get_Text);
         begin
            Picker.Calendar.Select_Month (Guint (M_Val - 1), Guint (Y_Val));
            Picker.Calendar.Select_Day (Guint (D_Val));
         end;
      end if;
      return False;
   end On_Entry_Focus_Out;

   -----------------------------------------------------------------------------
   procedure On_Entry_Activate (GEntry  : access Gtk.GEntry.Gtk_Entry_Record'Class;
                                Picker : Ada_Date_Picker);
   procedure On_Entry_Activate (GEntry  : access Gtk.GEntry.Gtk_Entry_Record'Class;
                                Picker : Ada_Date_Picker) is
      pragma Unreferenced (GEntry);
      Test_Date : constant String := Get_Date (Picker);
   begin
      if not Set_Date (Picker, Test_Date) then
         Copy_Calendar_To_Entries (Picker);
      else
         declare
            Y_Val : constant Integer := Integer'Value (Picker.Year_Entry.Get_Text);
            M_Val : constant Integer := Integer'Value (Picker.Month_Entry.Get_Text);
            D_Val : constant Integer := Integer'Value (Picker.Day_Entry.Get_Text);
         begin
            Picker.Calendar.Select_Month (Guint (M_Val - 1), Guint (Y_Val));
            Picker.Calendar.Select_Day (Guint (D_Val));
         end;
      end if;
   end On_Entry_Activate;

   -----------------------------------------------------------------------------
   procedure On_Button_Clicked (Button : access Gtk.Button.Gtk_Button_Record'Class;
                                Picker : Ada_Date_Picker);
   procedure On_Button_Clicked (Button : access Gtk.Button.Gtk_Button_Record'Class;
                                Picker : Ada_Date_Picker) is
      pragma Unreferenced (Button);
   begin
      if Picker.Popover.Get_Visible then
         Picker.Popover.Hide;
      else
         Picker.Popover.Show_All;
      end if;
   end On_Button_Clicked;

   -----------------------------------------------------------------------------
   function Get_Calendar_Date_Str (Picker : Ada_Date_Picker) return String;
   function Get_Calendar_Date_Str (Picker : Ada_Date_Picker) return String is
      Year  : aliased Guint;
      Month : aliased Guint;
      Day   : aliased Guint;
      Y_Val : Integer;
      M_Val : Integer;
      D_Val : Integer;
      TDate : String (1 .. 10);
      Y_Str : String (1 .. 4);
   begin
      Picker.Calendar.Get_Date (Year, Month, Day);
      Y_Val := Integer (Year);
      M_Val := Integer (Month) + 1;
      D_Val := Integer (Day);

      Y_Str := Integer'Image (Y_Val)(2 .. 5);
      TDate (1 .. 4) := Y_Str;
      TDate (5) := '-';

      if M_Val < 10 then
         TDate (6) := '0';
         TDate (7) := Character'Val (Character'Pos ('0') + M_Val);
      else
         declare
            M_Str : constant String := Integer'Image (M_Val);
         begin
            TDate (6 .. 7) := M_Str (M_Str'First + 1 .. M_Str'Last);
         end;
      end if;

      TDate (8) := '-';

      if D_Val < 10 then
         TDate (9) := '0';
         TDate (10) := Character'Val (Character'Pos ('0') + D_Val);
      else
         declare
            D_Str : constant String := Integer'Image (D_Val);
         begin
            TDate (9 .. 10) := D_Str (D_Str'First + 1 .. D_Str'Last);
         end;
      end if;

      return TDate;
   end Get_Calendar_Date_Str;

   -----------------------------------------------------------------------------
   procedure On_Calendar_Day_Selected (Calendar : access Gtk.Calendar.Gtk_Calendar_Record'Class;
                                       Picker   : Ada_Date_Picker);
   procedure On_Calendar_Day_Selected (Calendar : access Gtk.Calendar.Gtk_Calendar_Record'Class;
                                       Picker   : Ada_Date_Picker) is
      pragma Unreferenced (Calendar);
      Test_Date : constant String := Get_Calendar_Date_Str (Picker);
   begin
      if not Date_Less_Or_Equal (Picker.Min_Date, Test_Date) or else
         not Date_Less_Or_Equal (Test_Date, Picker.Max_Date)
      then
         declare
            Current_Valid : constant String := Get_Date (Picker);
            Cur_Y         : constant Integer := Integer'Value (Current_Valid (1 .. 4));
            Cur_M         : constant Integer := Integer'Value (Current_Valid (6 .. 7));
            Cur_D         : constant Integer := Integer'Value (Current_Valid (9 .. 10));
         begin
            Picker.Calendar.Select_Month (Guint (Cur_M - 1), Guint (Cur_Y));
            Picker.Calendar.Select_Day (Guint (Cur_D));
         end;
      else
         Copy_Calendar_To_Entries (Picker);
      end if;
   end On_Calendar_Day_Selected;

   -----------------------------------------------------------------------------
   procedure On_Calendar_Day_Selected_Double_Click
     (Calendar : access Gtk.Calendar.Gtk_Calendar_Record'Class;
      Picker   : Ada_Date_Picker);
   procedure On_Calendar_Day_Selected_Double_Click
     (Calendar : access Gtk.Calendar.Gtk_Calendar_Record'Class;
      Picker   : Ada_Date_Picker) is
      pragma Unreferenced (Calendar);
      Test_Date : constant String := Get_Calendar_Date_Str (Picker);
   begin
      if not Date_Less_Or_Equal (Picker.Min_Date, Test_Date) or else
         not Date_Less_Or_Equal (Test_Date, Picker.Max_Date)
      then
         declare
            Current_Valid : constant String := Get_Date (Picker);
            Cur_Y         : constant Integer := Integer'Value (Current_Valid (1 .. 4));
            Cur_M         : constant Integer := Integer'Value (Current_Valid (6 .. 7));
            Cur_D         : constant Integer := Integer'Value (Current_Valid (9 .. 10));
         begin
            Picker.Calendar.Select_Month (Guint (Cur_M - 1), Guint (Cur_Y));
            Picker.Calendar.Select_Day (Guint (Cur_D));
         end;
      else
         Copy_Calendar_To_Entries (Picker);
         Picker.Popover.Hide;
      end if;
   end On_Calendar_Day_Selected_Double_Click;

   -----------------------------------------------------------------------------
   procedure On_Calendar_Month_Changed (Calendar : access Gtk.Calendar.Gtk_Calendar_Record'Class;
                                        Picker   : Ada_Date_Picker);
   procedure On_Calendar_Month_Changed (Calendar : access Gtk.Calendar.Gtk_Calendar_Record'Class;
                                        Picker   : Ada_Date_Picker) is
      pragma Unreferenced (Calendar);
      Test_Date : constant String := Get_Calendar_Date_Str (Picker);
      Min_Year  : constant Integer := Integer'Value (Picker.Min_Date (1 .. 4));
      Max_Year  : constant Integer := Integer'Value (Picker.Max_Date (1 .. 4));
      Y_Val     : constant Integer := Integer'Value (Test_Date (1 .. 4));
   begin
      if Y_Val < Min_Year then
         Picker.Calendar.Select_Month (Guint (Integer'Value (Picker.Min_Date (6 .. 7)) - 1),
                                       Guint (Min_Year));
         return;
      elsif Y_Val > Max_Year then
         Picker.Calendar.Select_Month (Guint (Integer'Value (Picker.Max_Date (6 .. 7)) - 1),
                                       Guint (Max_Year));
         return;
      end if;

      Copy_Calendar_To_Entries (Picker);
   end On_Calendar_Month_Changed;

   -----------------------------------------------------------------------------
   procedure Load_The_Date (Widget : not null access Ada_Date_Picker_Record);
   procedure Load_The_Date (Widget : not null access Ada_Date_Picker_Record) is
      Now     : constant Ada.Calendar.Time := Ada.Calendar.Clock;
      Year    : Ada.Calendar.Year_Number;
      Month   : Ada.Calendar.Month_Number;
      Day     : Ada.Calendar.Day_Number;
      Seconds : Ada.Calendar.Day_Duration;
      Y_Str   : String (1 .. 4);
   begin
      Ada.Calendar.Split (Now, Year, Month, Day, Seconds);

      Y_Str := Integer'Image (Year)(2 .. 5);
      Widget.Year_Entry.Set_Text (Y_Str);
      Widget.Year_Entry.Set_Position (0);

      if Month < 10 then
         Widget.Month_Entry.Set_Text ("0" & Character'Val (Character'Pos ('0') + Month));
      else
         declare
            M_Str : constant String := Integer'Image (Month);
         begin
            Widget.Month_Entry.Set_Text (M_Str (M_Str'First + 1 .. M_Str'Last));
         end;
      end if;

      if Day < 10 then
         Widget.Day_Entry.Set_Text ("0" & Character'Val (Character'Pos ('0') + Day));
      else
         declare
            D_Str : constant String := Integer'Image (Day);
         begin
            Widget.Day_Entry.Set_Text (D_Str (D_Str'First + 1 .. D_Str'Last));
         end;
      end if;

      Widget.Calendar.Select_Month (Guint (Month - 1), Guint (Year));
      Widget.Calendar.Select_Day (Guint (Day));
   end Load_The_Date;

   -----------------------------------------------------------------------------
   procedure Load_CSS;
   procedure Load_CSS is
      DatePicker_CSS : constant String :=
                         "frame#Date_Picker_Frame {"
                         & "    border-style: none;"
                         & "    padding: 0px;"
                         & "}"
                         & "box#Date_Picker_HBox {"
                         & "    border-style: none;"
                         & "    background-color: transparent;"
                         & "}"
                         & "entry#Date_Picker_Year_Entry,"
                         & "entry#Date_Picker_Month_Entry,"
                         & "entry#Date_Picker_Day_Entry {"
                         & "    padding-top: 2px;"
                         & "    padding-bottom: 2px;"
                         & "    min-height: 22px;"
                         & "    border-radius: 0px;"
                         & "    margin-right: -1px;"
                         & "}"
                         & "button#Date_Picker_Button {"
                         & "    padding-top: 0px;"
                         & "    padding-bottom: 0px;"
                         & "    min-height: 22px;"
                         & "    border-radius: 0px;"
                         & "}";

      Provider : Gtk_Css_Provider;
      Error    : aliased Glib.Error.GError;
      Success  : Boolean;
   begin
      Gtk_New (Provider);
      Success := Provider.Load_From_Data (DatePicker_CSS, Error'Access);

      if Success then
         Gtk.Style_Context.Add_Provider_For_Screen
           (Screen   => Gdk.Screen.Get_Default,
            Provider => +Provider,
            Priority => Gtk.Style_Provider.Priority_Application);
      else
         raise Program_Error;
      end if;
   end Load_CSS;

   -----------------------------------------------------------------------------
   procedure Gtk_New (Widget : out Ada_Date_Picker) is
   begin
      Widget := new Ada_Date_Picker_Record;
      Gtk_Ada_Date_Picker.Initialize (Widget  => Widget);
   end Gtk_New;

   -----------------------------------------------------------------------------
   procedure Initialize (Widget : not null access Ada_Date_Picker_Record) is
      Calendar_Icon : Gtk.Image.Gtk_Image;
      HBox          : Gtk.Box.Gtk_Box;
      Context       : Gtk.Style_Context.Gtk_Style_Context;
   begin
      --  1. As initialize can be called not only from gtk_new, the call is
      --  ignored it is already initialized
      if Widget.Year_Entry /= null then
         return;
      end if;

      --  2. Initialize the widget as a Gtk_Frame
      Gtk.Frame.Initialize (Frame => Widget, Label => "");
      Widget.Set_Name ("Date_Picker_Frame");
      Widget.Set_Shadow_Type (Gtk.Enums.Shadow_None);

      --  3. Create an internal horizontal box to hold entries and button
      Gtk.Box.Gtk_New (HBox, Gtk.Enums.Orientation_Horizontal, 0);
      HBox.Set_Name ("Date_Picker_HBox");

      -- 4. Set the hbox style
      Context := Gtk.Style_Context.Get_Style_Context (HBox);
      Context.Add_Class ("linked");
      Widget.Add (HBox);

      --  5. Nothing

      --  6. Create and configure year entry
      Gtk.GEntry.Gtk_New (Widget.Year_Entry);
      Widget.Year_Entry.Set_Width_Chars (4);
      Widget.Year_Entry.Set_Max_Width_Chars (4);
      Widget.Year_Entry.Set_Max_Length (4);
      Widget.Year_Entry.Set_Alignment (0.5);
      Widget.Year_Entry.Set_Overwrite_Mode (True);
      Widget.Year_Entry.Set_Size_Request (Width  => 50,
                                          Height => -1);
      HBox.Pack_Start (Child   => Widget.Year_Entry,
                       Expand  => False,
                       Fill    => False,
                       Padding => 0);

      --  7. Create and configure month entry
      Gtk.GEntry.Gtk_New (Widget.Month_Entry);
      Widget.Month_Entry.Set_Width_Chars (4);
      Widget.Month_Entry.Set_Max_Width_Chars (2);
      Widget.Month_Entry.Set_Max_Length (2);
      Widget.Month_Entry.Set_Alignment (0.5);
      Widget.Month_Entry.Set_Overwrite_Mode (True);
      Widget.Month_Entry.Set_Size_Request (Width  => 20,
                                           Height => -1);
      HBox.Pack_Start (Child   => Widget.Month_Entry,
                       Expand  => False,
                       Fill    => False,
                       Padding => 0);

      --  8. Create and configure day entry
      Gtk.GEntry.Gtk_New (Widget.Day_Entry);
      Widget.Day_Entry.Set_Width_Chars (4);
      Widget.Day_Entry.Set_Max_Width_Chars (2);
      Widget.Day_Entry.Set_Max_Length (2);
      Widget.Day_Entry.Set_Alignment (0.5);
      Widget.Day_Entry.Set_Overwrite_Mode (True);
      Widget.Day_Entry.Set_Size_Request (Width  => 20,
                                         Height => -1);
      HBox.Pack_Start (Child   => Widget.Day_Entry,
                       Expand  => False,
                       Fill    => False,
                       Padding => 0);

      --  9. Create the button and assign the icon
      Gtk.Button.Gtk_New (Widget.Button);
      Gtk.Image.Gtk_New_From_Icon_Name (Calendar_Icon,
                                        "office-calendar",
                                        Gtk.Enums.Icon_Size_Button);
      Widget.Button.Set_Image (Calendar_Icon);
      HBox.Pack_Start (Child   => Widget.Button,
                       Expand  => False,
                       Fill    => False,
                       Padding => 0);

      --  10. Connect the signal to the button
      Picker_Handlers.Connect
        (Widget.Button,
         "clicked",
         Picker_Handlers.To_Marshaller (On_Button_Clicked'Access),
         Ada_Date_Picker (Widget));

      --  11. Nothing

      --  12. Nothing

      --  13. Load the CSS for the widget. It is idempotent
      Load_CSS;

      --  14. Create the calendar
      Gtk.Calendar.Gtk_New (Widget.Calendar);
      Load_The_Date (Widget);

      --  15. Create the Popover attached to the Button
      Gtk.Popover.Gtk_New (Widget.Popover, Widget.Button);
      Widget.Popover.Add (Widget.Calendar);

      --  16. Connect signals
      Calendar_Handlers.Connect
        (Widget.Calendar,
         "day-selected",
         Calendar_Handlers.To_Marshaller (On_Calendar_Day_Selected'Access),
         Ada_Date_Picker (Widget));

      Calendar_Handlers.Connect
        (Widget.Calendar,
         "day-selected-double-click",
         Calendar_Handlers.To_Marshaller (On_Calendar_Day_Selected_Double_Click'Access),
         Ada_Date_Picker (Widget));

      Calendar_Handlers.Connect
        (Widget.Calendar,
         "month-changed",
         Calendar_Handlers.To_Marshaller (On_Calendar_Month_Changed'Access),
         Ada_Date_Picker (Widget));

      Entry_Handlers.Connect
        (Widget.Year_Entry,
         "activate",
         Entry_Handlers.To_Marshaller (On_Entry_Activate'Access),
         Ada_Date_Picker (Widget));

      Entry_Handlers.Connect
        (Widget.Month_Entry,
         "activate",
         Entry_Handlers.To_Marshaller (On_Entry_Activate'Access),
         Ada_Date_Picker (Widget));

      Entry_Handlers.Connect
        (Widget.Day_Entry,
         "activate",
         Entry_Handlers.To_Marshaller (On_Entry_Activate'Access),
         Ada_Date_Picker (Widget));

      Widget_Focus_Handlers.Connect
        (Widget.Year_Entry,
         "focus-out-event",
         Widget_Focus_Handlers.To_Marshaller (On_Entry_Focus_Out'Access),
         Ada_Date_Picker (Widget));

      Widget_Focus_Handlers.Connect
        (Widget.Month_Entry,
         "focus-out-event",
         Widget_Focus_Handlers.To_Marshaller (On_Entry_Focus_Out'Access),
         Ada_Date_Picker (Widget));

      Widget_Focus_Handlers.Connect
        (Widget.Day_Entry,
         "focus-out-event",
         Widget_Focus_Handlers.To_Marshaller (On_Entry_Focus_Out'Access),
         Ada_Date_Picker (Widget));

      --  17. Show the calendar
      Widget.Calendar.Show_All;

      -- 18. Nothing
   end Initialize;

   -----------------------------------------------------------------------------
   function Get_Date (Widget : not null access Ada_Date_Picker_Record) return String is
      TDate : String (1 .. 10) := "0001-01-01";
      Y_Str : constant String := Widget.Year_Entry.Get_Text;
      M_Str : constant String := Widget.Month_Entry.Get_Text;
      D_Str : constant String := Widget.Day_Entry.Get_Text;
   begin
      if Y_Str'Length in 1 .. 4 then
         TDate (5 - Y_Str'Length .. 4) := Y_Str;
      end if;

      if M_Str'Length in 1 .. 2 then
         TDate (8 - M_Str'Length .. 7) := M_Str;
      end if;

      if D_Str'Length in 1 .. 2 then
         TDate (11 - D_Str'Length .. 10) := D_Str;
      end if;

      return TDate;
   end Get_Date;

   -----------------------------------------------------------------------------
   function Set_Date (Widget    : not null access Ada_Date_Picker_Record;
                      Some_Date : String) return Boolean is
      S : constant Integer := Some_Date'First;
   begin
      if not Is_Valid_Format (Some_Date) then
         return False;
      end if;

      if not Date_Less_Or_Equal (Widget.Min_Date, Some_Date) or else
         not Date_Less_Or_Equal (Some_Date, Widget.Max_Date)
      then
         return False;
      end if;

      Widget.Year_Entry.Set_Text (Some_Date (S .. S + 3));
      Widget.Month_Entry.Set_Text (Some_Date (S + 5 .. S + 6));
      Widget.Day_Entry.Set_Text (Some_Date (S + 8 .. S + 9));
      return True;
   end Set_Date;

end Gtk_Ada_Date_Picker;
