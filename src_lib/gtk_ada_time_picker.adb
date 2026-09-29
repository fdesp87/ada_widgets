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
with Gtk.Widget;
with Gtk.Image;
with Gtk.Box;
with Gtk.Handlers;
with Gtk.Css_Provider;    use Gtk.Css_Provider;
with Gtk.Style_Provider;  use Gtk.Style_Provider;
with Gtk.Style_Context;
with Gdk.Screen;
with Gdk.Event;           use Gdk.Event;
with Gdk.Pixbuf;          use Gdk.Pixbuf;
with Glib.Error;
with Glib.Main;
with Ada.Calendar;
with GNAT.Calendar;
with Gtkada.Types;

with Glib.Type_Conversion_Hooks;
with Glib.Generic_Properties;

package body Gtk_Ada_Time_Picker is

   use type Glib.Main.G_Source_Id;

   -------------------------------------------
   --  TIMEZONE PROPERTIES                  --
   -------------------------------------------
   package Time_Zone_Properties is new
     Glib.Generic_Properties.Generic_Enumeration_Property
       ("AdaTimeZone", Time_Zone);

   -------------------------------------------
   --  SET PROPERTY                         --
   -------------------------------------------
   package Time_User_Data is new Glib.Object.User_Data (Data_Type => Time_Zone);

   PROP_TIME_ZONE : constant Property_Id := 1;

   procedure Set_Property (Object        : access Glib.Object.GObject_Record'Class;
                           Prop_Id       : Property_Id;
                           Value         : Glib.Values.GValue;
                           Property_Spec : Param_Spec);

   procedure Set_Property (Object        : access Glib.Object.GObject_Record'Class;
                           Prop_Id       : Property_Id;
                           Value         : Glib.Values.GValue;
                           Property_Spec : Param_Spec) is
      Dummy  : Boolean;
      pragma Unreferenced (Property_Spec);
   begin
      case Prop_Id is
         when PROP_TIME_ZONE =>
            declare
               TZ : constant Time_Zone :=
                      Time_Zone_Properties.Get_Enum (Value);
            begin
               Time_User_Data.Set (Object => Object,
                                   Data   => TZ,
                                   Id     => "ada-picker-time-zone");

            end;
         when others =>
            null;
      end case;
   end Set_Property;

   -------------------------------------------
   --  GET PROPERTY                         --
   -------------------------------------------
   procedure Get_Property (Object        : access Glib.Object.GObject_Record'Class;
                           Prop_Id       : Property_Id;
                           Value         : out Glib.Values.GValue;
                           Property_Spec : Param_Spec);

   procedure Get_Property (Object        : access Glib.Object.GObject_Record'Class;
                           Prop_Id       : Property_Id;
                           Value         : out Glib.Values.GValue;
                           Property_Spec : Param_Spec) is
      pragma Unreferenced (Property_Spec);
   begin
      case Prop_Id is
         when PROP_TIME_ZONE =>
            declare
               TZ : constant Time_Zone :=
                      Time_User_Data.Get (Object  => Object,
                                          Id      => "ada-picker-time-zone",
                                          Default => UTC);
            begin
               Time_Zone_Properties.Set_Enum (Value, TZ);
            end;
         when others =>
            null;
      end case;
   end Get_Property;

   -------------------------------------------
   --  CLASS INIT                           --
   -------------------------------------------
   Klass : aliased Glib.Object.Ada_GObject_Class := Glib.Object.Uninitialized_Class;

   procedure Class_Init (Self : GObject_Class);
   pragma Convention (C, Class_Init);
   procedure Class_Init (Self : GObject_Class) is
   begin
      Set_Properties_Handlers (Self, Set_Property'Access, Get_Property'Access);

      Install_Property
        (Class_Record  => Self,
         Prop_Id       => PROP_TIME_ZONE,
         Property_Spec => Time_Zone_Properties.Gnew_Enum
           (Name      => "time-zone",
            Nick      => "Time Zone",
            Blurb     => "Time Zone",
            Default   => UTC,
            Flags     => Param_Readable or Param_Writable));
   end Class_Init;

   -------------------------------------------
   --  GET TYPE                             --
   -------------------------------------------
   function Get_Type return Glib.GType;
   pragma Convention (C, Get_Type);
   function Get_Type return Glib.GType is
   begin
      if Klass = Glib.Object.Uninitialized_Class then
         if Glib.Object.Initialize_Class_Record
           (Ancestor     => Gtk.Frame.Get_Type,
            Class_Record => Klass'Access,
            Type_Name    => "AdaTimePicker",
            Class_Init   => Class_Init'Access)
         then
            null;
         end if;
      end if;
      return Klass.The_Type;
   end Get_Type;

   -------------------------------------------
   --  TYPE CONVERSION HOOK                 --
   -------------------------------------------
   package Type_Conversion_Ada_Time_Picker is
     new Glib.Type_Conversion_Hooks.Hook_Registrator
       (Gtk_Ada_Time_Picker.Get_Type'Access, Ada_Time_Picker_Record);
   pragma Unreferenced (Type_Conversion_Ada_Time_Picker);

   -------------------------------------------
   --  INIT                                 --
   -------------------------------------------
   --  When using GtkBuilder, place this call after Gtk.Main.Init
   procedure Init is
      Dummy : Glib.GType;
   begin
      Dummy := Gtk_Ada_Time_Picker.Get_Type;
   end Init;

   -------------------------------------------
   --  CREATE EMBEDDED IMAGE                --
   -------------------------------------------
   function Create_Embedded_Image return Gtk.Image.Gtk_Image;
   function Create_Embedded_Image return Gtk.Image.Gtk_Image is
      use Gtkada.Types;

      Stepper_Arrows_Data : Chars_Ptr_Array :=
        New_String ("16 16 2 1") +
          "  c None" +
          "X c #55A630" +
          "................" +
          "........X......." +
          ".......XXX......" +
          "......XXXXX....." +
          ".....XXXXXXX...." +
          "....XXXXXXXXX..." +
          "...XXXXXXXXXXX.." +
          "................" +
          "................" +
          "...XXXXXXXXXXX.." +
          "....XXXXXXXXX..." +
          ".....XXXXXXX...." +
          "......XXXXX....." +
          ".......XXX......" +
          "........X......." +
          "................";

      Pixbuf : Gdk.Pixbuf.Gdk_Pixbuf;
      Image  : Gtk.Image.Gtk_Image;
   begin
      Pixbuf := Gdk_New_From_Xpm_Data (Stepper_Arrows_Data);

      Image := Gtk.Image.Gtk_Image_New_From_Pixbuf (Pixbuf);

      Glib.Object.Unref
        (Glib.Object.GObject_Record (Pixbuf.all)'Access);
      Free (Stepper_Arrows_Data);

      return Image;
   end Create_Embedded_Image;

   -----------------------------------------------------------------------------
   package Widget_Focus_Handlers is new Gtk.Handlers.User_Return_Callback
     (Gtk.Widget.Gtk_Widget_Record, Boolean, Ada_Time_Picker);

   package Button_Event_Handlers is new Gtk.Handlers.User_Return_Callback
     (Gtk.Widget.Gtk_Widget_Record, Boolean, Ada_Time_Picker);

   package Entry_Handlers is new Gtk.Handlers.User_Callback
     (Gtk.GEntry.Gtk_Entry_Record, Ada_Time_Picker);

   -----------------------------------------------------------------------------
   function Is_Valid_Time (Hour, Min, Sec : Integer) return Boolean;
   function Is_Valid_Time (Hour, Min, Sec : Integer) return Boolean is
   begin
      return Hour >= 0 and then Hour <= 23 and then
             Min >= 0 and then Min <= 59 and then
             Sec >= 0 and then Sec <= 59;
   end Is_Valid_Time;

   -----------------------------------------------------------------------------
   procedure Format_Two_Digits (Val : Integer; Str : out String);
   procedure Format_Two_Digits (Val : Integer; Str : out String) is
   begin
      if Val < 10 then
         Str (Str'First) := '0';
         Str (Str'Last)  := Character'Val (Character'Pos ('0') + Val);
      else
         declare
            Temp : constant String := Integer'Image (Val);
         begin
            Str (Str'First) := Temp (Temp'First + 1);
            Str (Str'Last)  := Temp (Temp'Last);
         end;
      end if;
   end Format_Two_Digits;

   -----------------------------------------------------------------------------
   procedure Load_The_Time (Widget : Ada_Time_Picker);
   procedure Load_The_Time (Widget : Ada_Time_Picker) is
      Now                 : constant Ada.Calendar.Time := Ada.Calendar.Clock;
      Time_Picker_Hour    : constant Integer := GNAT.Calendar.Hour (Now);
      Time_Picker_Min     : constant Integer := GNAT.Calendar.Minute (Now);
      Time_Picker_Sec     : constant Integer :=
                              Integer (GNAT.Calendar.Second (Now));
      H_Str, M_Str, S_Str : String (1 .. 2);
   begin
      Format_Two_Digits (Time_Picker_Hour, H_Str);
      Format_Two_Digits (Time_Picker_Min,  M_Str);
      Format_Two_Digits (Time_Picker_Sec,  S_Str);

      Widget.Hour_Entry.Set_Text (H_Str);
      Widget.Min_Entry.Set_Text (M_Str);
      Widget.Sec_Entry.Set_Text (S_Str);
   end Load_The_Time;

   -----------------------------------------------------------------------------
   function On_Entry_Focus_Out
     (Widget : access Gtk.Widget.Gtk_Widget_Record'Class;
      Picker : Ada_Time_Picker) return Boolean;
   function On_Entry_Focus_Out
     (Widget : access Gtk.Widget.Gtk_Widget_Record'Class;
      Picker : Ada_Time_Picker) return Boolean
   is
      pragma Unreferenced (Widget);
      Test_Time : constant String := Get_Time (Picker);
   begin
      if not Set_Time (Picker, Test_Time) then
         Load_The_Time (Picker);
      end if;
      return False;
   end On_Entry_Focus_Out;

   -----------------------------------------------------------------------------
   procedure On_Entry_Activate
     (GEntry : access Gtk.GEntry.Gtk_Entry_Record'Class;
      Picker : Ada_Time_Picker);
   procedure On_Entry_Activate
     (GEntry : access Gtk.GEntry.Gtk_Entry_Record'Class;
      Picker : Ada_Time_Picker)
   is
      pragma Unreferenced (GEntry);
      Test_Time : constant String := Get_Time (Picker);
   begin
      if not Set_Time (Picker, Test_Time) then
         Load_The_Time (Picker);
      end if;
   end On_Entry_Activate;

   -----------------------------------------------------------------------------
   procedure Adjust_Field (Picker     : Ada_Time_Picker;
                           Field_Type : Character;
                           Y_Click    : Glib.Gdouble;
                           Height     : Glib.Gint);
   procedure Adjust_Field (Picker     : Ada_Time_Picker;
                           Field_Type : Character;
                           Y_Click    : Glib.Gdouble;
                           Height     : Glib.Gint) is
      H, M, S : Integer;
      Is_Up   : constant Boolean := (Y_Click < (Glib.Gdouble (Height) * 0.40));
      Is_Down : constant Boolean := (Y_Click > (Glib.Gdouble (Height) * 0.60));
   begin
      begin
         H := Integer'Value (Picker.Hour_Entry.Get_Text);
      exception
         when others =>
            H := 0;
      end;

      begin
         M := Integer'Value (Picker.Min_Entry.Get_Text);
      exception
         when others =>
            M := 0;
      end;

      begin
         S := Integer'Value (Picker.Sec_Entry.Get_Text);
      exception
         when others =>
            S := 0;
      end;

      if Field_Type = 'H' then
         if Is_Up then
            H := (H + 1) mod 24;
         elsif Is_Down then
            H := (H + 23) mod 24;
         else
            H := 0;
         end if;

      elsif Field_Type = 'M' then
         if Is_Up then
            M := M + 1;
            if M > 59 then
               M := 0;
               H := (H + 1) mod 24;
            end if;
         elsif Is_Down then
            M := M - 1;
            if M < 0 then
               M := 59;
               H := (H + 23) mod 24;
            end if;
         else
            M := 0;
         end if;

      elsif Field_Type = 'S' then
         if Is_Up then
            S := S + 1;
            if S > 59 then
               S := 0;
               M := M + 1;
               if M > 59 then
                  M := 0;
                  H := (H + 1) mod 24;
               end if;
            end if;
         elsif Is_Down then
            S := S - 1;
            if S < 0 then
               S := 59;
               M := M - 1;
               if M < 0 then
                  M := 59;
                  H := (H + 23) mod 24;
               end if;
            end if;
         else
            S := 0;
         end if;
      end if;

      declare
         H_Str, M_Str, S_Str : String (1 .. 2);
      begin
         Format_Two_Digits (H, H_Str);
         Format_Two_Digits (M, M_Str);
         Format_Two_Digits (S, S_Str);

         Picker.Hour_Entry.Set_Text (H_Str);
         Picker.Min_Entry.Set_Text (M_Str);
         Picker.Sec_Entry.Set_Text (S_Str);
      end;
   end Adjust_Field;

   Current_Picker : Ada_Time_Picker := null;
   Current_Field  : Character  := ' ';
   Current_Y      : Glib.Gdouble := 0.0;
   Current_Height : Glib.Gint  := 0;
   Active_Timeout : Glib.Main.G_Source_Id := 0;

   -----------------------------------------------------------------------------
   function Repeat_Callback return Boolean;
   function Repeat_Callback return Boolean is
   begin
      if Current_Picker /= null then
         Adjust_Field (Current_Picker, Current_Field, Current_Y, Current_Height);
         return True;
      else
         Active_Timeout := 0;
         return False;
      end if;
   end Repeat_Callback;

   -----------------------------------------------------------------------------
   function On_Button_Press
     (Widget : access Gtk.Widget.Gtk_Widget_Record'Class;
      Event  : Gdk.Event.Gdk_Event;
      Picker : Ada_Time_Picker;
      Field  : Character) return Boolean;
   function On_Button_Press
     (Widget : access Gtk.Widget.Gtk_Widget_Record'Class;
      Event  : Gdk.Event.Gdk_Event;
      Picker : Ada_Time_Picker;
      Field  : Character) return Boolean
   is
      Allocation : Gtk.Widget.Gtk_Allocation;
      X_Click    : aliased Glib.Gdouble;
   begin
      Get_Coords (Event, X_Click, Current_Y);
      Widget.Get_Allocation (Allocation);
      Current_Height := Allocation.Height;
      Current_Picker := Picker;
      Current_Field  := Field;

      Adjust_Field (Picker, Field, Current_Y, Current_Height);

      if Active_Timeout = 0 then
         Active_Timeout := Glib.Main.Timeout_Add (150, Repeat_Callback'Access);
      end if;

      return True;
   end On_Button_Press;

   -----------------------------------------------------------------------------
   function On_Hour_Button_Press
     (Widget : access Gtk.Widget.Gtk_Widget_Record'Class;
      Event  : Gdk.Event.Gdk_Event;
      Picker : Ada_Time_Picker) return Boolean;
   function On_Hour_Button_Press
     (Widget : access Gtk.Widget.Gtk_Widget_Record'Class;
      Event  : Gdk.Event.Gdk_Event;
      Picker : Ada_Time_Picker) return Boolean
   is
   begin
      return On_Button_Press (Widget, Event, Picker, 'H');
   end On_Hour_Button_Press;

   -----------------------------------------------------------------------------
   function On_Min_Button_Press
     (Widget : access Gtk.Widget.Gtk_Widget_Record'Class;
      Event  : Gdk.Event.Gdk_Event;
      Picker : Ada_Time_Picker) return Boolean;
   function On_Min_Button_Press
     (Widget : access Gtk.Widget.Gtk_Widget_Record'Class;
      Event  : Gdk.Event.Gdk_Event;
      Picker : Ada_Time_Picker) return Boolean
   is
   begin
      return On_Button_Press (Widget, Event, Picker, 'M');
   end On_Min_Button_Press;

   -----------------------------------------------------------------------------
   function On_Sec_Button_Press
     (Widget : access Gtk.Widget.Gtk_Widget_Record'Class;
      Event  : Gdk.Event.Gdk_Event;
      Picker : Ada_Time_Picker) return Boolean;
   function On_Sec_Button_Press
     (Widget : access Gtk.Widget.Gtk_Widget_Record'Class;
      Event  : Gdk.Event.Gdk_Event;
      Picker : Ada_Time_Picker) return Boolean
   is
   begin
      return On_Button_Press (Widget, Event, Picker, 'S');
   end On_Sec_Button_Press;

   -----------------------------------------------------------------------------
   function On_Button_Release
     (Widget : access Gtk.Widget.Gtk_Widget_Record'Class;
      Event  : Gdk.Event.Gdk_Event;
      Picker : Ada_Time_Picker) return Boolean;
   function On_Button_Release
     (Widget : access Gtk.Widget.Gtk_Widget_Record'Class;
      Event  : Gdk.Event.Gdk_Event;
      Picker : Ada_Time_Picker) return Boolean
   is
      pragma Unreferenced (Widget, Event, Picker);
   begin
      Current_Picker := null;
      Active_Timeout := 0;
      return True;
   end On_Button_Release;

   -------------------------------------------
   --  LOAD CSS                             --
   -------------------------------------------
   procedure Load_CSS;
   procedure Load_CSS is
      TimePicker_CSS : constant String :=
         "frame#Time_Picker_Frame {"
         & "    border-style: none;"
         & "    padding: 0px;"
         & "}"
         & "box#Time_Picker_HBox {"
         & "    border-style: none;"
         & "    background-color: transparent;"
         & "}"
         & "button#Time_Picker_Hour_Button,"
         & "button#Time_Picker_Min_Button,"
         & "button#Time_Picker_Sec_Button {"
         & "    padding: 0px;"
         & "    margin: 0px;"
         & "    border: 1px solid #b5b5b5;"
         & "    min-width: 16px;"
         & "    min-height: 22px;"
         & "}"
         & "entry#Time_Picker_Hour_Entry,"
         & "entry#Time_Picker_Min_Entry,"
         & "entry#Time_Picker_Sec_Entry {"
         & "    padding-top: 2px;"
         & "    padding-bottom: 2px;"
         & "    min-height: 22px;"
         & "}";

      Provider : Gtk_Css_Provider;
      Error    : aliased Glib.Error.GError;
      Success  : Boolean;
   begin
      Gtk_New (Provider);
      Success := Provider.Load_From_Data (TimePicker_CSS, Error'Access);

      if Success then
         Gtk.Style_Context.Add_Provider_For_Screen
           (Screen   => Gdk.Screen.Get_Default,
            Provider => +Provider,
            Priority => Gtk.Style_Provider.Priority_Application);
      else
         null;
      end if;
   end Load_CSS;

   -------------------------------------------
   --  GTK NEW                              --
   -------------------------------------------
   procedure Gtk_New (Widget : out Ada_Time_Picker) is
   begin
      Widget := new Ada_Time_Picker_Record;
      Gtk_Ada_Time_Picker.Initialize (Widget => Widget);
   end Gtk_New;

   -------------------------------------------
   --  INITIALIZE                           --
   -------------------------------------------
   procedure Initialize (Widget : not null access Ada_Time_Picker_Record) is

      Self    : constant Ada_Time_Picker := Ada_Time_Picker (Widget);
      Img_H   : Gtk.Image.Gtk_Image;
      Img_M   : Gtk.Image.Gtk_Image;
      Img_S   : Gtk.Image.Gtk_Image;
      HBox    : Gtk.Box.Gtk_Box;
      Context : Gtk.Style_Context.Gtk_Style_Context;
   begin
      --  1. As initialize can be called not only fromgtk_new, the call is
      --  ignored it is already initialized
      if Widget.Hour_Entry /= null then
         return;
      end if;

      --  2. Initialize the main widget as a Gtk_Frame
      Gtk.Frame.Initialize (Frame => Widget, Label => "");
      Widget.Set_Name ("Time_Picker_Frame");
      Widget.Set_Shadow_Type (Gtk.Enums.Shadow_None);

      --  3. Create an internal horizontal box to hold entries and buttons
      Gtk.Box.Gtk_New (HBox, Gtk.Enums.Orientation_Horizontal, 0);
      HBox.Set_Name ("Time_Picker_HBox");
      Widget.Add (HBox);

      --  4. Set the hbox style
      Context := Gtk.Style_Context.Get_Style_Context (HBox);
      Context.Add_Class ("linked");

      --  5. Nothing

      --  6. Create and pack the hour entry and its button
      Gtk.GEntry.Gtk_New (Widget.Hour_Entry);
      Widget.Hour_Entry.Set_Name ("Time_Picker_Hour_Entry");
      Widget.Hour_Entry.Set_Width_Chars (4);
      Widget.Hour_Entry.Set_Max_Length (2);
      Widget.Hour_Entry.Set_Alignment (0.5);
      Widget.Hour_Entry.Set_Overwrite_Mode (True);
      HBox.Pack_Start (Widget.Hour_Entry,
                       Expand  => False,
                       Fill    => False,
                       Padding => 0);

      Gtk.Button.Gtk_New (Widget.Hour_Button);
      Widget.Hour_Button.Set_Name ("Time_Picker_Hour_Button");
      Img_H := Create_Embedded_Image;
      Widget.Hour_Button.Add (Img_H);
      HBox.Pack_Start (Widget.Hour_Button,
                       Expand  => False,
                       Fill    => False,
                       Padding => 0);

      --  7. Create and pack the minute entry and its button
      Gtk.GEntry.Gtk_New (Widget.Min_Entry);
      Widget.Min_Entry.Set_Name ("Time_Picker_Min_Entry");
      Widget.Min_Entry.Set_Width_Chars (4);
      Widget.Min_Entry.Set_Max_Length (2);
      Widget.Min_Entry.Set_Alignment (0.5);
      Widget.Min_Entry.Set_Overwrite_Mode (True);
      HBox.Pack_Start (Widget.Min_Entry,
                       Expand  => False,
                       Fill    => False,
                       Padding => 0);

      Gtk.Button.Gtk_New (Widget.Min_Button);
      Widget.Min_Button.Set_Name ("Time_Picker_Min_Button");
      Img_M := Create_Embedded_Image;
      Widget.Min_Button.Add (Img_M);
      HBox.Pack_Start (Widget.Min_Button,
                       Expand  => False,
                       Fill    => False,
                       Padding => 0);

      --  8. Create and pack the second entry and its button
      Gtk.GEntry.Gtk_New (Widget.Sec_Entry);
      Widget.Sec_Entry.Set_Name ("Time_Picker_Sec_Entry");
      Widget.Sec_Entry.Set_Width_Chars (4);
      Widget.Sec_Entry.Set_Max_Length (2);
      Widget.Sec_Entry.Set_Alignment (0.5);
      Widget.Sec_Entry.Set_Overwrite_Mode (True);
      HBox.Pack_Start (Widget.Sec_Entry,
                       Expand  => False,
                       Fill    => False,
                       Padding => 0);

      Gtk.Button.Gtk_New (Widget.Sec_Button);
      Widget.Sec_Button.Set_Name ("Time_Picker_Sec_Button");
      Img_S := Create_Embedded_Image;
      Widget.Sec_Button.Add (Img_S);
      HBox.Pack_Start (Widget.Sec_Button,
                       Expand  => False,
                       Fill    => False,
                       Padding => 0);

      --  9. Nothing

      --  10. Nothing

      --  11. Load custom CSS styles
      Load_CSS;

      --  12. Connect button press and release event signals
      Widget.Hour_Button.Add_Events (Button_Press_Mask or Button_Release_Mask);
      Button_Event_Handlers.Connect
        (Widget.Hour_Button, "button-press-event",
         Button_Event_Handlers.To_Marshaller (On_Hour_Button_Press'Access),
         Ada_Time_Picker (Widget));

      Button_Event_Handlers.Connect
        (Widget.Hour_Button, "button-release-event",
         Button_Event_Handlers.To_Marshaller (On_Button_Release'Access),
         Ada_Time_Picker (Widget));

      Widget.Min_Button.Add_Events (Button_Press_Mask or Button_Release_Mask);
      Button_Event_Handlers.Connect
        (Widget.Min_Button, "button-press-event",
         Button_Event_Handlers.To_Marshaller (On_Min_Button_Press'Access),
         Ada_Time_Picker (Widget));

      Button_Event_Handlers.Connect
        (Widget.Min_Button, "button-release-event",
         Button_Event_Handlers.To_Marshaller (On_Button_Release'Access),
         Ada_Time_Picker (Widget));

      Widget.Sec_Button.Add_Events (Button_Press_Mask or Button_Release_Mask);
      Button_Event_Handlers.Connect
        (Widget.Sec_Button, "button-press-event",
         Button_Event_Handlers.To_Marshaller (On_Sec_Button_Press'Access),
         Ada_Time_Picker (Widget));

      Button_Event_Handlers.Connect
        (Widget.Sec_Button, "button-release-event",
         Button_Event_Handlers.To_Marshaller (On_Button_Release'Access),
         Ada_Time_Picker (Widget));

      --  13. Connect activation (Enter key) signals on the entries
      Entry_Handlers.Connect
        (Widget.Hour_Entry, "activate",
         Entry_Handlers.To_Marshaller (On_Entry_Activate'Access),
         Ada_Time_Picker (Widget));

      Entry_Handlers.Connect
        (Widget.Min_Entry, "activate",
         Entry_Handlers.To_Marshaller (On_Entry_Activate'Access),
         Ada_Time_Picker (Widget));

      Entry_Handlers.Connect
        (Widget.Sec_Entry, "activate",
         Entry_Handlers.To_Marshaller (On_Entry_Activate'Access),
         Ada_Time_Picker (Widget));

      --  14. Connect focus-out event signals on the entries
      Widget_Focus_Handlers.Connect
        (Widget.Hour_Entry, "focus-out-event",
         Widget_Focus_Handlers.To_Marshaller (On_Entry_Focus_Out'Access),
         Ada_Time_Picker (Widget));

      Widget_Focus_Handlers.Connect
        (Widget.Min_Entry, "focus-out-event",
         Widget_Focus_Handlers.To_Marshaller (On_Entry_Focus_Out'Access),
         Ada_Time_Picker (Widget));

      Widget_Focus_Handlers.Connect
        (Widget.Sec_Entry, "focus-out-event",
         Widget_Focus_Handlers.To_Marshaller (On_Entry_Focus_Out'Access),
         Ada_Time_Picker (Widget));

      --  15. Nothing

      --  16. Load the default system time
      Load_The_Time (Self);
   end Initialize;

   -------------------------------------------
   --  GET TIME                             --
   -------------------------------------------
   function Get_Time
     (Widget     : not null access Ada_Time_Picker_Record;
      Include_Tz : Boolean := False) return String
   is
      Value     : Glib.Values.GValue;
      Base_Time : constant String :=
        Widget.Hour_Entry.Get_Text & ":" &
        Widget.Min_Entry.Get_Text  & ":" &
        Widget.Sec_Entry.Get_Text;
   begin
      if Include_Tz then
         Get_Property (Object        => Widget,
                       Prop_Id       => PROP_TIME_ZONE,
                       Value         => Value,
                       Property_Spec => null);
         return Base_Time & " " & Time_Zone_Properties.Get_Enum (Value)'Image;
      else
         return Base_Time;
      end if;
   end Get_Time;

   -------------------------------------------
   --  SET TIME                             --
   -------------------------------------------
   function Set_Time (Widget    : not null access Ada_Time_Picker_Record;
                      Some_Time : String) return Boolean
   is
      H, M, S : Integer;
      F       : constant Integer := Some_Time'First;
   begin
      if Some_Time'Length < 8 then
         return False;
      end if;

      if Some_Time (F + 2) /= ':'
        or else Some_Time (F + 5) /= ':'
      then
         return False;
      end if;

      begin
         H := Integer'Value (Some_Time (F     .. F + 1));
         M := Integer'Value (Some_Time (F + 3 .. F + 4));
         S := Integer'Value (Some_Time (F + 6 .. F + 7));
      exception
         when others =>
            return False;
      end;

      if not Is_Valid_Time (H, M, S) then
         return False;
      end if;

      if Some_Time'Length > 8 then
         if Some_Time (F + 8) /= ' ' then
            return False;
         end if;

         declare
            TZ_Part : constant String    := Some_Time (F + 9 .. Some_Time'Last);
            TZ      : constant Time_Zone := Time_Zone'Value (TZ_Part);
         begin
            Set_Time_Zone (Widget, TZ);
         exception
            when others =>
               return False;
         end;
      end if;

      declare
         H_Str, M_Str, S_Str : String (1 .. 2);
      begin
         Format_Two_Digits (H, H_Str);
         Format_Two_Digits (M, M_Str);
         Format_Two_Digits (S, S_Str);

         Widget.Hour_Entry.Set_Text (H_Str);
         Widget.Min_Entry.Set_Text (M_Str);
         Widget.Sec_Entry.Set_Text (S_Str);
      end;

      return True;
   end Set_Time;

   -------------------------------------------
   --  SET TIME ZONE                        --
   -------------------------------------------
   procedure Set_Time_Zone (Widget  : not null access Ada_Time_Picker_Record;
                            Some_TZ : Time_Zone) is
      Value : Glib.Values.GValue;
   begin
      Time_Zone_Properties.Set_Enum (Value, Some_TZ);
      Set_Property (Object        => Widget,
                    Prop_Id       => PROP_TIME_ZONE,
                    Value         => Value,
                    Property_Spec => null);
   end Set_Time_Zone;

end Gtk_Ada_Time_Picker;
