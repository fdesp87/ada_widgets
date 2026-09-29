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
with System;
with Interfaces.C;
with Interfaces.C.Strings;

with Gtk.Enums;
with Gtk.Image;
with Gtk_Additions;            use Gtk_Additions;
with Gtk.Container;            use Gtk.Container;
with Gtk.Box;                  use Gtk.Box;
with Gtk.GEntry;               use Gtk.GEntry;
with Gtk.Button;               use Gtk.Button;
with Gtk.Widget;               use Gtk.Widget;
with Gtk.Css_Provider;         use Gtk.Css_Provider;
with Gtk.Style_Provider;       use Gtk.Style_Provider;
with Gtk.Style_Context;
with Gdk.Screen;
with Glib.Error;
with Gdk.Pixbuf;               use Gdk.Pixbuf;
with Gtkada.Types;
with Glade_Binding;            use Glade_Binding;
with Glib.Generic_Properties;  use Glib.Generic_Properties;
with Glib.Type_Conversion_Hooks;

package body Ada_Widgets.Time_Picker.Implem is

   package IC  renames Interfaces.C;
   package ICS renames Interfaces.C.Strings;

   -------------------------------------------
   --  TIMEZONE PROPERTIES                  --
   -------------------------------------------
   --  This package also register the type AdaTimeZone
   package Time_Zone_Properties is new
     Glib.Generic_Properties.Generic_Enumeration_Property
       ("AdaTimeZone", Time_Zone);

   -------------------------------------------
   --  ENTRY USER DATA                      --
   -------------------------------------------
   package Entry_User_Data is new Glib.Object.User_Data (Gtk_Entry);

   -------------------------------------------
   --  TIME USER DATA                       --
   -------------------------------------------
   package Time_User_Data is new Glib.Object.User_Data (Data_Type => Time_Zone);

   -------------------------------------------
   --  SET PROPERTY                         --
   -------------------------------------------

   procedure Set_Property (Object        : access Glib.Object.GObject_Record'Class;
                           Prop_Id       : Property_Id;
                           Value         : Glib.Values.GValue;
                           Property_Spec : Param_Spec) is
      pragma Unreferenced (Property_Spec);
   begin
      Ada_Log ("ada_widgets.time_picker.implem.set_property");

      case Prop_Id is
         when PROP_TIME_ZONE =>
            declare
               TZ : constant Time_Zone :=
                      Time_Zone_Properties.Get_Enum (Value);
            begin
               Ada_Log ("ada_widgets.time_picker.implem.set_property: "
                        & "prop_id=" & Prop_Id'Image
                        & ", value=" & Time_Zone'Image (TZ));

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
                           Property_Spec : Param_Spec) is
      pragma Unreferenced (Property_Spec);
   begin
      Ada_Log ("ada_widgets.time_picker.implem.get_property");

      case Prop_Id is
         when PROP_TIME_ZONE =>
            declare
               TZ : constant Time_Zone :=
                      Time_User_Data.Get (Object  => Object,
                                          Id      => "ada-picker-time-zone",
                                          Default => UTC);
            begin
               Ada_Log ("ada_widgets.time_picker.implem.get_property: "
                        & "prop_id=" & Prop_Id'Image
                        & ", value=" & Time_Zone'Image (TZ));

               Time_Zone_Properties.Set_Enum (Value, TZ);
            end;
         when others =>
            null;
      end case;
   end Get_Property;

   -------------------------------------------
   --  TYPE CONVERSION HOOK                 --
   -------------------------------------------
   package Type_Conversion_Ada_Time_Picker is new
     Glib.Type_Conversion_Hooks.Hook_Registrator
       (Ada_Widgets.Time_Picker.Implem.Get_Type'Access, Ada_Time_Picker_Record);
   pragma Unreferenced (Type_Conversion_Ada_Time_Picker);

   -------------------------------------------
   --  TIME ZONE GET TYPE                   --
   -------------------------------------------
   --  function Time_Zone_Get_Type return Glib.GType;
   --  function Time_Zone_Get_Type return Glib.GType is
   --  begin
   --     Ada_Log ("ada_widgets.time_picker.implem.time_zone_get_type");
   --     return Time_Zone_Properties.Get_Type;
   --  end Time_Zone_Get_Type;
   --  This function is not called as this enumerated type is created
   --  automatically by the Ada package
   --           package Time_Zone_Properties is new
   --              Glib.Generic_Properties.Generic_Enumeration_Property
   --               ("AdaTimeZone", Time_Zone);

   -------------------------------------------
   --  CLASS INIT                           --
   -------------------------------------------
   Klass : Glib.GType := Glib.GType_None;

   procedure Class_Init (Self : GObject_Class);
   pragma Convention (C, Class_Init);
   procedure Class_Init (Self : GObject_Class) is
      Class_Ptr : constant GObject_Class_Block_Ptr := Convert (Self);
   begin
      Ada_Log ("ada_widgets.time_picker.implem.class_init: "
               & "klass=" & Type_Name (Klass)
               & " (" & To_Hex (Self'Image) & ")");

      Class_Ptr.Set_Property := Set_Property'Access;
      Class_Ptr.Get_Property := Get_Property'Access;

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
   --  TIME PICKER INIT                     --
   -------------------------------------------
   procedure Time_Picker_Init (Object : GObject_Ptr;
                               GClass : GObject_Class);
   pragma Convention (C, Time_Picker_Init);
   procedure Time_Picker_Init (Object : GObject_Ptr;
                               GClass : GObject_Class) is
      Stub : GObject_Record;
   begin
      Ada_Log ("ada_widgets.time_picker.implem.time_picker_init: " & ASCII.LF
               & Blanks & "object=" & Type_Name (Get_Type (Get_User_Data (-Object, Stub)))
               & "(" & To_Hex (Object'Image) & ")" & ASCII.LF
               & Blanks & "klass=" & To_Hex (GClass'Image));

      Build (Object => Get_User_Data (-Object, Stub),
             Show   => True);
   end Time_Picker_Init;

   -------------------------------------------
   --  GET TYPE                             --
   -------------------------------------------
   function Get_Type return Glib.GType is
      Parent_Query : aliased GType_Query;
      Type_Info    : aliased GType_Info;
      Text         : ICS.chars_ptr;
   begin

      if Klass = Glib.GType_None then
         G_Type_Query (Gtk.Frame.Get_Type, Parent_Query'Access);
         Type_Info :=
           (Class_Size      => IC.unsigned_short (Parent_Query.Class_Size),
            --  Filler1         => (others => 0),
            Base_Init       => null,
            Base_Finalize   => null,
            Class_Init      => Class_Init'Access,
            Class_Finalize  => null,
            Class_Data      => System.Null_Address,
            Instance_Size   => IC.unsigned_short (Parent_Query.Instance_Size),
            N_Preallocs     => 0,
            Instance_Init   => Time_Picker_Init'Access,
            Value_Table     => System.Null_Address);

         Text := ICS.New_String ("AdaTimePicker");

         Klass :=
           G_Type_Register_Static
             (Parent_Type => Gtk.Frame.Get_Type,
              Type_Name   => Text,
              Info        => Type_Info'Access,
              Flags       => 0);

         IC.Strings.Free (Text);

         Ada_Log ("ada_widgets.time_picker.implem.get_type: "
                  & "type=" & Type_Name (Klass)
                  & " (" & To_Hex (Glib.GType'Image (Klass)) & ")");
      end if;

      return Klass;
   end Get_Type;

   -------------------------------------------
   --  CSS LOAD                            --
   -------------------------------------------
   Css_Time_Loaded : Boolean := False;

   procedure Load_Time_CSS;
   procedure Load_Time_CSS is
      TimePicker_CSS : constant String :=
                         "button#Time_Picker_Hour_Button,"
                         & "button#Time_Picker_Min_Button,"
                         & "button#Time_Picker_Sec_Button {"
                         & "    padding: 0px;"
                         & "    margin: 0px;"
                         & "    border: 1px solid #b5b5b5;"
                         & "    min-width: 16px;"
                         & "    min-height: 22px;"
                         & "    border-radius: 0px;"
                         & "}"
                         & "entry#Time_Picker_Hour_Entry,"
                         & "entry#Time_Picker_Min_Entry,"
                         & "entry#Time_Picker_Sec_Entry {"
                         & "    padding-top: 2px;"
                         & "    padding-bottom: 2px;"
                         & "    min-height: 22px;"
                         & "    border-radius: 0px;"
                         & "    margin-right: -1px;"
                         & "}";

      Provider : Gtk_Css_Provider;
      Error    : aliased Glib.Error.GError;
      Success  : Boolean;
   begin
      if Css_Time_Loaded then
         return;
      end if;

      Ada_Log ("ada_widgets.time_picker.implem.load_time_css");

      Gtk_New (Provider);
      Success := Provider.Load_From_Data (TimePicker_CSS, Error'Access);

      if not Success then
         Ada_Log ("ada_widgets.time_picker.implem.load_time_css: "
                  & Error.Get_Message);
         Glib.Error.Error_Free (Error);
         Unref (Provider);
         return;
      end if;

      Gtk.Style_Context.Add_Provider_For_Screen
        (Screen   => Gdk.Screen.Get_Default,
         Provider => +Provider,
         Priority => Gtk.Style_Provider.Priority_Application);

      Unref (Provider);
      Css_Time_Loaded := True;
   end Load_Time_CSS;

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

   -------------------------------------------
   --  BUILD                                --
   -------------------------------------------
   procedure Build (Object : not null access Glib.Object.GObject_Record'Class;
                    Show   : Boolean) is

      Img_H       : Gtk.Image.Gtk_Image;
      Img_M       : Gtk.Image.Gtk_Image;
      Img_S       : Gtk.Image.Gtk_Image;
      Context     : Gtk.Style_Context.Gtk_Style_Context;
      Widget      : Gtk_Frame;
      HBox        : Gtk.Box.Gtk_Box;
      Hour_Entry  : Gtk_Entry;
      Min_Entry   : Gtk_Entry;
      Sec_Entry   : Gtk_Entry;
      Hour_Button : Gtk_Button;
      Min_Button  : Gtk_Button;
      Sec_Button  : Gtk_Button;
      Child       : Gtk_Widget;
   begin

      Ada_Log ("ada_widgets.time_picker.implem.build: " & ASCII.LF
               & Blanks & "object=" & Type_Name (Get_Type (Object))
               & " (" & To_Hex (Glib.Object.Get_Object (Object)'Image) & ")");

      --  1. Convert the Fake object to a Gtk Frame
      Widget := Gtk_Frame (Object);

      --  2. Initialize the widget Gtk_Frame
      Widget.Set_Shadow_Type (Gtk.Enums.Shadow_None);
      Widget.Set_Name ("Time_Picker_Frame");
      Widget.Set_Label ("");

      --  3. See there is a child box, otherwise create one
      Child := Widget.Get_Child;
      if Child /= null and then Child.all in Gtk_Box_Record'Class then
         HBox := Gtk_Box (Child);
      else
         if Child /= null then
            Gtk_Container (Object).Remove (Child);
         end if;
         Gtk.Box.Gtk_New (HBox, Gtk.Enums.Orientation_Horizontal, 0);
         HBox.Set_Name ("Time_Picker_HBox");
         Widget.Add (HBox);
      end if;

      --  4. Set the hbox style
      Context := Gtk.Style_Context.Get_Style_Context (HBox);
      Context.Add_Class ("linked");

      --  5. If hbox had children, show and return
      if Has_Children (Gtk_Container (HBox)) then
         if Show then
            Widget.Show_All;
         end if;
         return;
      end if;

      --  6. Create and pack the hour entry and its button
      Gtk.GEntry.Gtk_New (Hour_Entry);
      Hour_Entry.Set_Name ("Time_Picker_Hour_Entry");
      Hour_Entry.Set_Width_Chars (4);
      Hour_Entry.Set_Max_Length (2);
      Hour_Entry.Set_Alignment (0.5);
      Hour_Entry.Set_Placeholder_Text ("HH");
      Hour_Entry.Set_Overwrite_Mode (True);
      HBox.Pack_Start (Hour_Entry,
                       Expand  => False,
                       Fill    => False,
                       Padding => 0);

      Gtk.Button.Gtk_New (Hour_Button);
      Hour_Button.Set_Name ("Time_Picker_Hour_Button");
      Img_H := Create_Embedded_Image;
      Hour_Button.Add (Img_H);
      HBox.Pack_Start (Hour_Button,
                       Expand  => False,
                       Fill    => False,
                       Padding => 0);

      --  7. Create and pack the minute entry and its button
      Gtk.GEntry.Gtk_New (Min_Entry);
      Min_Entry.Set_Name ("Time_Picker_Min_Entry");
      Min_Entry.Set_Width_Chars (4);
      Min_Entry.Set_Max_Length (2);
      Min_Entry.Set_Alignment (0.5);
      Min_Entry.Set_Placeholder_Text ("mm");
      Min_Entry.Set_Overwrite_Mode (True);
      HBox.Pack_Start (Min_Entry,
                       Expand  => False,
                       Fill    => False,
                       Padding => 0);

      Gtk.Button.Gtk_New (Min_Button);
      Min_Button.Set_Name ("Time_Picker_Min_Button");
      Img_M := Create_Embedded_Image;
      Min_Button.Add (Img_M);
      HBox.Pack_Start (Min_Button,
                       Expand  => False,
                       Fill    => False,
                       Padding => 0);

      --  8. Create and pack the second entry and its button
      Gtk.GEntry.Gtk_New (Sec_Entry);
      Sec_Entry.Set_Name ("Time_Picker_Sec_Entry");
      Sec_Entry.Set_Width_Chars (4);
      Sec_Entry.Set_Max_Length (2);
      Sec_Entry.Set_Alignment (0.5);
      Sec_Entry.Set_Placeholder_Text ("ss");
      Sec_Entry.Set_Overwrite_Mode (True);
      HBox.Pack_Start (Sec_Entry,
                       Expand  => False,
                       Fill    => False,
                       Padding => 0);

      Gtk.Button.Gtk_New (Sec_Button);
      Sec_Button.Set_Name ("Time_Picker_Sec_Button");
      Img_S := Create_Embedded_Image;
      Sec_Button.Add (Img_S);
      HBox.Pack_Start (Sec_Button,
                       Expand  => False,
                       Fill    => False,
                       Padding => 0);

      --  9. Set data
      Entry_User_Data.Set (Object, Hour_Entry, "ada-time-hour-ref");
      Entry_User_Data.Set (Object, Min_Entry,  "ada-time-min-ref");
      Entry_User_Data.Set (Object, Sec_Entry,  "ada-time-sec-ref");

      --  10. Change sensitiveness
      Hour_Entry.Set_Sensitive (False);
      Min_Entry.Set_Sensitive (False);
      Sec_Entry.Set_Sensitive (False);

      --  11. Load the CSS for the widget. It is idempotent
      Load_Time_CSS;

      --  12. Nothing

      --  13. Nothing

      --  14. Nothing

      --  15. Show the widget
      if Show then
         Widget.Show_All;
      end if;

   end Build;

end Ada_Widgets.Time_Picker.Implem;
