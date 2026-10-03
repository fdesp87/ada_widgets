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
with Ada.Calendar;
with GNAT.Calendar.Time_IO;      use GNAT.Calendar.Time_IO;

with Gtk.Enums;
with Gtk.Image;
with Gtk.Container;              use Gtk.Container;
with Gtk.Box;                    use Gtk.Box;
with Gtk.GEntry;                 use Gtk.GEntry;
with Gtk.Button;                 use Gtk.Button;
with Gtk.Widget;                 use Gtk.Widget;
with Gtk.Css_Provider;           use Gtk.Css_Provider;
with Gtk.Style_Provider;         use Gtk.Style_Provider;
with Gtk.Style_Context;
with Gdk.Screen;
with Gtk.Handlers;
with Gtkada.Dialogs;             use Gtkada.Dialogs;
with Gtk.Container.Additions;    use Gtk.Container.Additions;

with Glib.Object;
with Glib.Values;
with Glib.Properties;
with Glib.Properties.Creation;
with Glib.Error;
with Glib.Type_Conversion_Hooks;

with Ada_Widgets.Date_Picker.Validation;

package body Ada_Widgets.Date_Picker.Implem is

   package IC  renames Interfaces.C;
   package ICS renames Interfaces.C.Strings;

   package Picker_Handlers is new Gtk.Handlers.User_Callback
     (Gtk.Button.Gtk_Button_Record, Glib.Object.GObject);

   -------------------------------------------
   --  BUTTON AND ENTRY USER DATA           --
   -------------------------------------------
   package Button_User_Data is new Glib.Object.User_Data (Gtk_Button);
   package Entry_User_Data  is new Glib.Object.User_Data (Gtk_Entry);

   -------------------------------------------
   --  DATE USER DATA                       --
   -------------------------------------------
   subtype TDate is String (1 .. 10);
   package Date_User_Data is new Glib.Object.User_Data (Data_Type => TDate);

   -------------------------------------------
   --  SET PROPERTY                         --
   -------------------------------------------
   procedure Set_Property (Object        : GObject_Ptr;
                           Prop_Id       : Glib.Properties.Creation.Property_Id;
                           Value         : Glib.Values.GValue;
                           Property_Spec : Param_Spec);
   procedure Set_Property (Object        : GObject_Ptr;
                           Prop_Id       : Glib.Properties.Creation.Property_Id;
                           Value         : Glib.Values.GValue;
                           Property_Spec : Param_Spec) is
      pragma Unreferenced (Property_Spec);
      Stub : Glib.Object.GObject_Record;
      Ada_Object : constant Glib.Object.GObject :=
                     Glib.Object.Get_User_Data (-Object, Stub);
   begin
      case Prop_Id is
         when PROP_MIN_DATE =>
            declare
               Str : constant String := Glib.Values.Get_String (Value);
            begin
               Ada_Log ("ada_widgets.date_picker.implem.set_property: "
                        & "prop_id=" & Prop_To_String (Prop_Id)
                        & ", value=" & Str
                        & ", object=" & Type_Name (Get_Type (Object))
                        & " (" & To_Hex (Object'Image) & ")");

               if Ada_Widgets.Date_Picker.Validation.Is_Valid_Format (Str) then
                  Date_User_Data.Set (Object => Ada_Object,
                                      Data   => Str,
                                      Id     => "ada-picker-min-date");
               else
                  Date_User_Data.Set (Object => Ada_Object,
                                      Data   => "1901-01-01",
                                      Id     => "ada-picker-min-date");
               end if;
            end;

         when PROP_MAX_DATE =>
            declare
               Str : constant String := Glib.Values.Get_String (Value);
            begin
               Ada_Log ("ada_widgets.date_picker.implem.set_property: "
                        & "prop_id=" & Prop_To_String (Prop_Id)
                        & ", value=" & Str
                        & ", object=" & Type_Name (Get_Type (Object))
                        & " (" & To_Hex (Object'Image) & ")");

               if Ada_Widgets.Date_Picker.Validation.Is_Valid_Format (Str) then
                  Date_User_Data.Set (Object => Ada_Object,
                                      Data   => Str,
                                      Id     => "ada-picker-max-date");
               else
                  Date_User_Data.Set (Object => Ada_Object,
                                      Data   => "2399-12-31",
                                      Id     => "ada-picker-max-date");
               end if;
            end;

         when others =>
               null;
      end case;

   end Set_Property;

   -------------------------------------------
   --  GET PROPERTY                         --
   -------------------------------------------
   procedure Get_Property (Object        : GObject_Ptr;
                           Prop_Id       : Glib.Properties.Creation.Property_Id;
                           Value         : out Glib.Values.GValue;
                           Property_Spec : Param_Spec);
   procedure Get_Property (Object        : GObject_Ptr;
                           Prop_Id       : Glib.Properties.Creation.Property_Id;
                           Value         : out Glib.Values.GValue;
                           Property_Spec : Param_Spec) is
      pragma Unreferenced (Property_Spec);
      Stub : Glib.Object.GObject_Record;
      Ada_Object : constant Glib.Object.GObject :=
                     Glib.Object.Get_User_Data (-Object, Stub);
   begin
      case Prop_Id is
         when PROP_MIN_DATE =>
            declare
               Str : constant String :=
                       Date_User_Data.Get (Object  => Ada_Object,
                                           Id      => "ada-picker-min-date",
                                           Default => "1901-01-01");
            begin
               Ada_Log ("ada_widgets.date_picker.implem.get_property: "
                        & "prop_id=" & Prop_To_String (Prop_Id)
                        & ", value=" & Str
                        & ", object=" & Type_Name (Get_Type (Object))
                        & " (" & To_Hex (Object'Image) & ")");

              Glib.Values.Set_String (Value, Str);
            end;

         when PROP_MAX_DATE =>
            declare
               Str : constant String :=
                       Date_User_Data.Get (Object  => Ada_Object,
                                           Id      => "ada-picker-max-date",
                                           Default => "2300-12-31");
            begin
               Ada_Log ("ada_widgets.date_picker.implem.get_property: "
                        & "prop_id=" & Prop_To_String (Prop_Id)
                        & ", value=" & Str
                        & ", object=" & Type_Name (Get_Type (Object))
                        & " (" & To_Hex (Object'Image) & ")");

               Glib.Values.Set_String (Value, Str);
            end;
         when others =>
            null;
      end case;
   end Get_Property;

   -------------------------------------------
   --  TYPE CONVERSION HOOK                 --
   -------------------------------------------
   package Type_Conversion_Ada_Date_Picker is
     new Glib.Type_Conversion_Hooks.Hook_Registrator
       (Ada_Widgets.Date_Picker.Implem.Get_Type'Access, Ada_Date_Picker_Record);
   pragma Unreferenced (Type_Conversion_Ada_Date_Picker);

   -------------------------------------------
   --  CLASS INIT                           --
   -------------------------------------------
   Klass : Glib.GType := Glib.GType_None;

   procedure Class_Init (Self : Glib.Object.GObject_Class);
   pragma Convention (C, Class_Init);

   procedure Class_Init (Self : Glib.Object.GObject_Class) is
      Class_Ptr : constant GObject_Class_Ptr := -Self;
   begin
      Ada_Log ("ada_widgets.date_picker.implem.class_init: "
               & "class=" & Type_Name (Class_Ptr.Type_Class.G_Type)
               & " (" & To_Hex (Class_Ptr'Image) & ")");

      Class_Ptr.Set_Property := Set_Property'Access;
      Class_Ptr.Get_Property := Get_Property'Access;

      Glib.Properties.Creation.Install_Property
        (Class_Record  => Self,
         Prop_Id       => PROP_MIN_DATE,
         Property_Spec => Glib.Properties.Creation.Gnew_String
             (Name    => "min-date",
              Nick    => "Min Date",
              Blurb   => "Minimum allowed date",
              Default => "1901-01-01",
              Flags   => Param_Readable or Param_Writable));

      Glib.Properties.Creation.Install_Property
        (Class_Record  => Self,
         Prop_Id       => PROP_MAX_DATE,
         Property_Spec => Glib.Properties.Creation.Gnew_String
           (Name    => "max-date",
            Nick    => "Max Date",
            Blurb   => "Maximum allowed date",
            Default => "2399-12-31",
            Flags   => Param_Readable or Param_Writable));

      declare
         Prop_List : constant Glib.Param_Spec_Array
           := Glib.Object.Class_List_Properties (Self);
         Found : Boolean := False;
      begin
         if Prop_List'Length = 0 then
            Ada_Log ("ada_widgets.date_picker.implem.class_init: no properties");
         else
            for I in Prop_List'Range loop
               if Glib.Properties.Creation.Owner_Type (Prop_List (I)) =
                 Class_Ptr.Type_Class.G_Type
               then
                  if not Found then
                     Found := True;
                     Ada_Log ("ada_widgets.date_picker.implem.class_init: own properties:");
                  end if;
                  Ada_Log (Blanks & Glib.Properties.Creation.Pspec_Name (Prop_List (I)));
               end if;
            end loop;
            if not Found then
               Ada_Log ("ada_widgets.date_picker.implem.class_init: no own properties");
           end if;
         end if;
      end;
   end Class_Init;

   -------------------------------------------
   --  INSTANCE INIT                        --
   -------------------------------------------
   procedure Instance_Init (Object : GObject_Ptr;
                            GClass : Glib.Object.GObject_Class);
   pragma Convention (C, Instance_Init);

   procedure Instance_Init (Object : GObject_Ptr;
                            GClass : Glib.Object.GObject_Class) is
      Class_Ptr : constant GObject_Class_Ptr := -GClass;
   begin
      Ada_Log ("ada_widgets.date_picker.implem.instance_init: "
               & "object=" & Type_Name (Get_Type (Object))
               & "(" & To_Hex (Object'Image) & ")"
               & ", class=" & Type_Name (Class_Ptr.Type_Class.G_Type)
               & " (" & To_Hex (Class_Ptr'Image) & ")");

      Build (Object => Object,
             Show   => True);
   end Instance_Init;

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
            Base_Init       => null,
            Base_Finalize   => null,
            Class_Init      => Class_Init'Access,
            Class_Finalize  => null,
            Class_Data      => System.Null_Address,
            Instance_Size   => IC.unsigned_short (Parent_Query.Instance_Size),
            N_Preallocs     => 0,
            Instance_Init   => Instance_Init'Access,
            Value_Table     => System.Null_Address);

         Text := ICS.New_String ("AdaDatePicker");

         Klass :=
           G_Type_Register_Static
             (Parent_Type => Gtk.Frame.Get_Type,
              Type_Name   => Text,
              Info        => Type_Info'Access,
              Flags       => 0);

         IC.Strings.Free (Text);

         Ada_Log ("ada_widgets.date_picker.implem.get_type: "
                  & "type=" & Type_Name (Klass)
                  & " (" & To_Hex (Glib.GType'Image (Klass)) & ")");
      end if;

      return Klass;
   end Get_Type;

   -----------------------------------
   --  CALENDAR BUTTON HANDLER      --
   -----------------------------------
   procedure On_Calendar_Button_Clicked
     (Some_Button : access Gtk.Button.Gtk_Button_Record'Class;
      User_Data   : Glib.Object.GObject);
   procedure On_Calendar_Button_Clicked
     (Some_Button : access Gtk.Button.Gtk_Button_Record'Class;
      User_Data   : Glib.Object.GObject)
   is
      pragma Unreferenced (Some_Button, User_Data);
      Response : Message_Dialog_Buttons;
   begin
      Response := Message_Dialog
        (Msg            =>
           "Calendar Selector Info" & ASCII.LF & ASCII.LF
           & "The calendar selector will be available for the application.",
         Dialog_Type    => Information,
         Buttons        => Button_OK,
         Title          => "AdaDatePicker");

   end On_Calendar_Button_Clicked;

   -------------------------------------------
   --  CSS LOAD                         --
   -------------------------------------------
   Css_Date_Loaded : Boolean := False;

   procedure Load_Date_CSS;
   procedure Load_Date_CSS is
      DatePicker_CSS : constant String :=
                         "box#Date_Picker_HBox {"
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
      if Css_Date_Loaded then
         return;
      end if;

      Ada_Log ("ada_widgets.date_picker.implem.load_date_css");

      Gtk_New (Provider);

      Success := Provider.Load_From_Data (DatePicker_CSS, Error'Access);
      if not Success then
         Ada_Log ("ada_widgets.date_picker.implem.load_date_css: error"
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
      Css_Date_Loaded := True;
   end Load_Date_CSS;

   -------------------------------------------
   --  BUILD                                --
   -------------------------------------------
   procedure Build (Object : not null GObject_Ptr;
                    Show   : Boolean) is
      Cal_Icon     : Gtk.Image.Gtk_Image;
      Context      : Gtk.Style_Context.Gtk_Style_Context;
      Widget       : Gtk_Frame;
      HBox         : Gtk_Box;
      Year_Entry   : Gtk_Entry;
      Month_Entry  : Gtk_Entry;
      Day_Entry    : Gtk_Entry;
      The_Button   : Gtk_Button;
      Child        : Gtk_Widget;
      Now          : Ada.Calendar.Time;
      Stub         : Glib.Object.GObject_Record;
      Ada_Object   : constant Glib.Object.GObject :=
                       Glib.Object.Get_User_Data (-Object, Stub);
   begin
      Ada_Log ("ada_widgets.date_picker.implem.build: "
               & "object=" & Type_Name (Get_Type (Object))
               & " (" & To_Hex (Object'Image) & ")");

      -- 0. Get current date/time
      Now := Ada.Calendar.Clock;

      --  1. Cast the object to a Gtk Frame
      Widget := Gtk_Frame (Ada_Object);

      --  2. Initialize the widget Gtk_Frame
      Widget.Set_Shadow_Type (Gtk.Enums.Shadow_None);
      Widget.Set_Name ("Date_Picker_Frame");
      Widget.Set_Label ("");

      --  3. See there is a child box, otherwise create one
      Child := Widget.Get_Child;
      if Child /= null and then Child.all in Gtk_Box_Record'Class then
         HBox := Gtk_Box (Child);
      else
         if Child /= null then
            Gtk_Container (Ada_Object).Remove (Child);
         end if;
         Gtk.Box.Gtk_New (HBox, Gtk.Enums.Orientation_Horizontal, 0);
         HBox.Set_Name ("Date_Picker_HBox");
         Widget.Add (HBox);
      end if;

      --  4. Set the hbox style
      Context := Gtk.Style_Context.Get_Style_Context (HBox);
      Context.Add_Class ("linked");

      --  5. if hbox had children, show and return
      if Has_Children (Gtk_Container (HBox)) then
        if Show then
            Widget.Show_All;
         end if;
         return;
      end if;

      --  6. Create and configure year entry
      Gtk.GEntry.Gtk_New (Year_Entry);
      Year_Entry.Set_Name ("Date_Picker_Year_Entry");
      Year_Entry.Set_Placeholder_Text (Image (Now, "%Y"));
      Year_Entry.Set_Width_Chars (4);
      Year_Entry.Set_Max_Length (4);
      Year_Entry.Set_Alignment (0.5);
      Year_Entry.Set_Overwrite_Mode (True);
      HBox.Pack_Start (Child   => Year_Entry,
                       Expand  => False,
                       Fill    => False,
                       Padding => 0);

      --  7. Create and configure month entry
      Gtk.GEntry.Gtk_New (Month_Entry);
      Month_Entry.Set_Name ("Date_Picker_Month_Entry");
      Month_Entry.Set_Placeholder_Text (Image (Now, "%m"));
      Month_Entry.Set_Width_Chars (2);
      Month_Entry.Set_Max_Length (2);
      Month_Entry.Set_Alignment (0.5);
      Month_Entry.Set_Overwrite_Mode (True);
      HBox.Pack_Start (Child   => Month_Entry,
                       Expand  => False,
                       Fill    => False,
                       Padding => 0);

      --  8. Create and configure day entry
      Gtk.GEntry.Gtk_New (Day_Entry);
      Day_Entry.Set_Name ("Date_Picker_Day_Entry");
      Day_Entry.Set_Placeholder_Text (Image (Now, "%d"));
      Day_Entry.Set_Width_Chars (2);
      Day_Entry.Set_Max_Length (2);
      Day_Entry.Set_Alignment (0.5);
      Day_Entry.Set_Overwrite_Mode (True);
      HBox.Pack_Start (Child   => Day_Entry,
                       Expand  => False,
                       Fill    => False,
                       Padding => 0);

      --  9. Create the button and assign the icon and the button
      Gtk.Button.Gtk_New (The_Button);
      The_Button.Set_Name ("Date_Picker_Button");
      Gtk.Image.Gtk_New_From_Icon_Name (Cal_Icon,
                                        "x-office-calendar",
                                        Gtk.Enums.Icon_Size_Button);
      The_Button.Set_Image (Cal_Icon);
      HBox.Pack_Start (Child   => The_Button,
                       Expand  => False,
                       Fill    => False,
                       Padding => 0);

      --  10. Connect the signal to the button
      Picker_Handlers.Connect
        (Widget    => The_Button,
         Name      => "clicked",
         Marsh     => Picker_Handlers.To_Marshaller (On_Calendar_Button_Clicked'Access),
         User_Data => Ada_Object);

      --  11. Set data
      Button_User_Data.Set (Ada_Object, The_Button,  "ada-picker-button-ref");
      Entry_User_Data.Set  (Ada_Object, Year_Entry,  "ada-picker-year-ref");
      Entry_User_Data.Set  (Ada_Object, Month_Entry, "ada-picker-month-ref");
      Entry_User_Data.Set  (Ada_Object, Day_Entry,   "ada-picker-day-ref");

      --  12. Change sensitiveness
      Year_Entry.Set_Sensitive (False);
      Month_Entry.Set_Sensitive (False);
      Day_Entry.Set_Sensitive (False);

      --  13. Load the CSS for the widget. It is idempotent
      Load_Date_CSS;

      --  14. Nothing

      --  15. Nothing

      --  16. Nothing

      --  17. Nothing

      --  18. Show all
      if Show then
         Widget.Show_All;
      end if;
   end Build;

end Ada_Widgets.Date_Picker.Implem;
