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
with System;
with Interfaces.C;
with Interfaces.C.Strings;
with Ada.Strings;
with Ada.Strings.Fixed;

with Ada.Unchecked_Conversion;
with Glib;
with Glib.Object;                   use Glib.Object;
with Glib.Values;                   use Glib.Values;
with Glib_Additions;                use Glib_Additions;
with Gtk.Widget;                    use Gtk.Widget;
with Gtk.GEntry;                    use Gtk.GEntry;
with Gdk.Event;                     use Gdk.Event;
with Gtk.Handlers;

with Glade_Binding;                 use Glade_Binding;
with Glade_Binding.Widget;          use Glade_Binding.Widget;
with Glade_Binding.Properties;      use Glade_Binding.Properties;

with Ada_Widgets.Date_Picker.Validation; use Ada_Widgets.Date_Picker.Validation;

package body Ada_Widgets.Date_Picker.Editor is
   package IC  renames Interfaces.C;
   package ICS renames Interfaces.C.Strings;

   package GBP renames Glade_Binding.Properties;

   -----------------------------------------------------------------------------
   --  Klass and Parent Klass
   -----------------------------------------------------------------------------
   --  Klass : aliased Glib.Object.Ada_GObject_Class := Glib.Object.Uninitialized_Class;
   Klass        : Glib.GType := Glib.GType_None;
   Parent_Klass : Editor_Property_Class := null;

   ------------------------------------------------------------------
   --  The Date Editor Property
   ------------------------------------------------------------------
   package Date_Editor_Property is new Editor_Property_Extension
     (Extra_Data => Gtk_Entry);

   ------------------------------------------------------------------
   --  Forward declarations
   ------------------------------------------------------------------
   function Glade_Eprop_Datepicker_Get_Type return Glib.GType;
   pragma Convention (C, Glade_Eprop_Datepicker_Get_Type);

   procedure Eprop_Load (Eprop : Editor_Prop;
                         Prop  : Glade_Binding.Properties.Property);
   pragma Convention (C, Eprop_Load);

   function Create_Input_Impl (Eprop : Editor_Prop) return Glade_Widget;
   pragma Convention (C, Create_Input_Impl);

   ------------------------------------------------------------------
   --  commit_datepicker
   ------------------------------------------------------------------
   procedure Commit_Datepicker (Date_Entry : Gtk_Entry;
                                Eprop      : Editor_Prop);
   procedure Commit_Datepicker (Date_Entry : Gtk_Entry;
                                Eprop      : Editor_Prop)
   is
      use Ada.Strings;
      use Ada.Strings.Fixed;

      Text      : constant String       := Trim (Get_Text (Date_Entry), Both);
      Prop      : constant GBP.Property := Get_Property (Eprop);
      Pdef      : Property_Def          := null;
      Prop_Id   : ICS.chars_ptr         := ICS.Null_Ptr;
      Is_Target : Boolean               := False;
      Val       : aliased GValue;
      Old_Value : aliased GValue;
      Old_Text  : ICS.chars_ptr;

      use type ICS.Chars_Ptr;
      use type Glib.Gtype;
   begin

      if Prop /= null then
         Pdef := Get_Def (Prop);
         if Pdef /= null then
            Prop_Id := Get_Id (Pdef);
         end if;
      end if;

      if Prop_Id /= ICS.Null_Ptr then
         declare
            Id : constant String := Interfaces.C.Strings.Value (Prop_Id);
         begin
            Is_Target := (Id = "min-date" or else Id = "max-date");
         end;
      end if;

      Init (Val, Glib.GType_String);
      Set_String (Val, Text);

      if Ada_Date_Picker_Validate_Dates (Eprop, Val'Access) then
         Commit (Eprop, Val'Access);
         Set_Text (Date_Entry, Text);
         Unset (Val);
         return;
      end if;

      Unset (Val);

      if Prop /= null then
         Get_Value (Prop, Old_Value'Access);
         if Type_Of (Old_Value) = Glib.GType_String then
            Old_Text := ICS.New_String (Get_String (Old_Value));
            if Old_Text /= ICS.Null_Ptr then
               Set_Text (Date_Entry, ICS.Value (Old_Text));
            end if;
         end if;
         Unset (Old_Value);
      end if;
   end Commit_Datepicker;

   ------------------------------------------------------------------
   --  User Data from Glib.Object
   ------------------------------------------------------------------
   package Eprop_User_Data is new Glib.Object.User_Data
     (Data_Type => Editor_Prop);

   ------------------------------------------------------------------
   --  Signal handlers
   ------------------------------------------------------------------
   package Void_Handlers is new Gtk.Handlers.Callback
     (Widget_Type => Gtk_Entry_Record);

   package Return_Handlers is new Gtk.Handlers.Return_Callback
     (Widget_Type => Gtk_Widget_Record,
      Return_Type => Boolean);

   procedure On_Activate (Date_Entry : access Gtk_Entry_Record'Class) is
      Eprop : constant Editor_Prop := Eprop_User_Data.Get (Date_EnTry,
                                                           "eprop");
   begin
      Ada_Log ("Ada_Widgets.Date_Picker.Editor.On_Activate" & ASCII.LF
               & Blanks & "Eprop=" & To_Hex (Eprop'Image));

      if Eprop /= null then
         Commit_Datepicker (Gtk_Entry (Date_Entry), Eprop);
      end if;
   end On_Activate;

   function On_Focus_Out (Widget : access Gtk_Widget_Record'Class;
                          Event  : Gdk_Event) return Boolean
   is
      pragma Unreferenced (Event);
      Eprop : constant Editor_Prop := Eprop_User_Data.Get (Widget, "eprop");
   begin
      Ada_Log ("Ada_Widgets.Date_Picker.Editor.On_Focus_Out" & ASCII.LF
               & Blanks & "Eprop=" & To_Hex (Eprop'Image));

      if Eprop /= null then
         Commit_Datepicker (Gtk_Entry (Widget), Eprop);
      end if;
      return False;
   end On_Focus_Out;

   ------------------------------------------------------------------
   --  Virtual: load
   ------------------------------------------------------------------
   procedure Eprop_Load (Eprop : Editor_Prop;
                         Prop  : Glade_Binding.Properties.Property)
   is
      use Date_Editor_Property;

      Self           : constant Date_Editor_Property.Extra_Eprop := +Eprop;
      Date_Entry     : Gtk_Entry;
      Value          : aliased GValue;
      Text           : ICS.chars_ptr := ICS.Null_Ptr;
      Prop_Id        : ICS.chars_ptr := ICS.Null_Ptr;
      Is_Target_Prop : Boolean := False;

      use type ICS.chars_ptr;
      use type Glib.GType;

   begin
      --  Get property id, if any.
      if Prop /= null then
         declare
            Pdef : constant Property_Def := Get_Def (Prop);
         begin
            if Pdef /= null then
               Prop_Id := Get_Id (Pdef);
            end if;
         end;
      end if;
      if Prop_Id /= ICS.Null_Ptr then
         declare
            Id : constant String := ICS.Value (Prop_Id);
         begin
            Is_Target_Prop := (Id = "min-date" or else Id = "max-date");
            if Is_Target_Prop then
               Ada_Log ("Ada_Widgets.Date_Picker.Editor.Eprop_Load [" & Id & "]" & ASCII.LF
                        & Blanks & "Eprop=" & To_Hex (Eprop'Image) & ASCII.LF
                        & Blanks & "Prop="
                        & (if Prop = null then "null" else To_Hex (Prop'Image))
                       );
            end if;
         end;
      end if;

      --  Always chain up to the parent implementation first.
      if Parent_Klass /= null and then Parent_Klass.Load /= null then
         Parent_Klass.Load (Eprop, Prop);
      end if;

      if Prop = null then
         return;
      end if;

      --  This is self->entry in the C implementation.
      Date_Entry := Self.Extra;

      if Date_Entry = null then
         return;
      end if;

      Get_Value (Prop, Value'Access);

      if Type_Of (Value) = Glib.GType_String then
         Text := ICS.New_String (Get_String (Value));
      end if;

      if Is_Target_Prop then
         Ada_Log ("Ada_Widgets.Date_Picker.Editor.Eprop_Load: loading text="
                  & (if Text /= ICS.Null_Ptr
                    then ICS.Value (Text)
                    else "(null)"));
      end if;

      if Text /= ICS.Null_Ptr then
         Date_Entry.Set_Text (ICS.Value (Text));
         ICS.Free (Text);
      else
         Date_Entry.Set_Text ("");
      end if;

      Unset (Value);
   end Eprop_Load;

   ------------------------------------------------------------------
   --  Virtual: create_input
   ------------------------------------------------------------------
   --  The C implementation returns a GtkWidget *, but the Ada binding uses
   --  Glade_Widget as the raw C pointer type.  Do not replace this with the
   --  GtkAda Gtk_Widget type, which is an Ada wrapper containing the C pointer.
   function Create_Input_Impl (Eprop : Editor_Prop) return Glade_Widget
   is
      use Date_Editor_Property;

      Self       : constant Date_Editor_Property.Extra_Eprop := +Eprop;
      Date_Entry : Gtk_Entry;

      function To_Glade_Widget is new Ada.Unchecked_Conversion
        (Source => System.Address,
         Target => Glade_Widget);

      use type ICS.chars_ptr;

   begin

      Gtk_New (Date_Entry);
      Show (Date_Entry);

      --  Keep our own reference so we can access it later from load()
      Self.Extra := Date_Entry;

      --  Store the eprop so the callbacks can find it
      Eprop_User_Data.Set (Date_Entry, Eprop, "eprop");

      Void_Handlers.Connect
        (Date_Entry, "activate",
         Void_Handlers.To_Marshaller (On_Activate'Access));

      Return_Handlers.Connect
        (Date_Entry, "focus-out-event",
         Return_Handlers.To_Marshaller (On_Focus_Out'Access));

      declare
         Prop      : constant Property := Get_Property (Eprop);
         Prop_Id   : ICS.chars_ptr := ICS.Null_Ptr;
         Is_Target : Boolean := False;
      begin
         --  Detect if this is min-date / max-date (for logging)
         if Prop /= null then
            declare
               Pdef : constant Property_Def := Get_Def (Prop);
            begin
               if Pdef /= null then
                  Prop_Id := Get_Id (Pdef);
                  if Prop_Id /= ICS.Null_Ptr then
                     declare
                        Id : constant String := ICS.Value (Prop_Id);
                     begin
                        Is_Target := (Id = "min-date" or else Id = "max-date");
                     end;
                  end if;
               end if;
            end;
         end if;
         if Is_Target then
            Ada_Log ("Ada_Widgets.Date_Picker.Editor.Create_Input_Impl ["
                     & (if Prop_Id /= ICS.Null_Ptr then ICS.Value (Prop_Id) else "?")
                     & "]" & ASCII.LF
                     & Blanks & "Eprop=" & To_Hex (Eprop'Image));
         end if;
      end;

      return To_Glade_Widget (Get_Object (Date_Entry));
   end Create_Input_Impl;

   ------------------------------------------------------------------
   --  GType registration
   ------------------------------------------------------------------

   procedure Instance_Init (Object  : GObject_Ptr;
                            G_Class : GObject_Class);
   pragma Convention (C, Instance_Init);

   procedure Instance_Init (Object  : GObject_Ptr;
                            G_Class : GObject_Class) is
   begin
      Ada_Log ("Ada_Widgets.Date_Picker.Editor.Instance_init: " & ASCII.LF
               & Blanks & "instance=" & To_Hex (Object'Image) & ASCII.LF
               & Blanks & "Class=" & To_Hex (G_Class'Image));
      --  Date_Entry is already null when the type is created
   end Instance_Init;

   -----------------------------------------------------------------------------
   procedure Class_Init (Self : GObject_Class);
   pragma Convention (C, Class_Init);

   procedure Class_Init (Self : GObject_Class) is
      function To_Editor_Property_Class is new Ada.Unchecked_Conversion
        (Source => GObject_Class,
         Target => Editor_Property_Class);

      Class : constant Editor_Property_Class := To_Editor_Property_Class (Self);
   begin
      Parent_Klass := Class_Peek_Parent (Class);

      Class.Create_Input := Create_Input_Impl'Access;
      Class.Load         := Eprop_Load'Access;

      Ada_Log ("Ada_Widgets.Date_Picker.Editor.Class_Init" & ASCII.LF
               & Blanks & "Class=" & To_Hex (Class'Image) & ASCII.LF
               & Blanks & "Class.Load=" & (if Class.Load = null
                 then "null"
                 else To_Hex (Class.Load'Address'Image)) & ASCII.LF
               & Blanks & "Parent_Klass=" & To_Hex (Parent_Klass'Image) & ASCII.LF
               & Blanks & "Parent_Klass.Load=" & (if Parent_Klass.Load = null
                 then "null"
                 else To_Hex (Parent_Klass.Load'Address'Image)));
   end Class_Init;

   function Glade_Eprop_Datepicker_Get_Type return Glib.GType is
      use type Glib.GType;

      Parent_Query : aliased GType_Query;
      Type_Info    : aliased GType_Info;
      Text         : Interfaces.C.Strings.chars_ptr;
   begin

      if Klass = Glib.GType_None then

         G_Type_Query
           (Glade_Binding.Editor_Property.Get_Type,
            Parent_Query'Access);

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

         Text := IC.Strings.New_String ("GladeEPropDatepicker");

         Klass :=
           G_Type_Register_Static
             (Parent_Type => Glade_Binding.Editor_Property.Get_Type,
              Type_Name   => Text,
              Info        => Type_Info'Access,
              Flags       => 0);

         IC.Strings.Free (Text);

      Ada_Log
        ("Ada_Widgets.Date_Picker.Editor."
         & "Glade_Eprop_Datepicker_Get_Type" & ASCII.LF
         & Blanks & "Type Name=" & Glib.Type_Name (Klass)
         & " (" & To_Hex (Klass'Image) & ")");
      end if;

      return Klass;
   end Glade_Eprop_Datepicker_Get_Type;


   ------------------------------------------------------------------
   --  Catalog entry point
   ------------------------------------------------------------------
   function Glade_Ada_Date_Picker_Create_Eprop (Adtor       : Adaptor;
                                                Def         : Property_Def;
                                                Use_Command : ICE.bool)
                                                return Editor_Prop
   is
      Prop_Id   : ICS.chars_ptr;
      Is_Target : Boolean := False;

      use type ICS.chars_ptr;

   begin

      if Def /= null then
         Prop_Id := Get_Id (Def);
         if Prop_Id /= ICS.Null_Ptr then
            declare
               Id : constant String := ICS.Value (Prop_Id);
            begin
               Is_Target := (Id = "min-date" or else Id = "max-date");
            end;
         end if;
      end if;

      if Is_Target then
         declare
            Eprop : Editor_Prop;

            function Def_To_Address is new Ada.Unchecked_Conversion
              (Property_Def, System.Address);

         begin

            --  create the C object and properties
            Eprop := New_Eprop
              (Typ         => Glade_Eprop_Datepicker_Get_Type,
               Prop_Name1  => ICS.New_String ("property-def"),
               Prop_Value1 => Def_To_Address (Def),
               Prop_Name2  => ICS.New_String ("use-command"),
               Prop_Value2 => Use_Command);

            declare
               Eprop_Def : constant Property_Def := Get_Property_Def (Eprop);
               Prop      : constant Property := Get_Property (Eprop);
            begin
               Ada_Log ("Ada_Widgets.Date_Picker.Editor."
                        & "Glade_Ada_Date_Picker_Create_Eprop "
                        & "[" & ICS.Value (Prop_Id) & "]" & ASCII.LF
                        & Blanks & "adaptor=" & ICS.Value (Get_Name (Adtor))
                        & " (" & To_Hex (Adtor'Image) & ")" & ASCII.LF
                        & Blanks & "Eprop=" & To_Hex (Eprop'Image) & ASCII.LF
                        & Blanks & "Def.all="
                        & (if Def = null
                          then "null"
                          else To_Hex (Def.all'Address'Image)) & ASCII.LF
                        & Blanks & "Use_Command="
                        & ICE.bool'Image (Use_Command) & ASCII.LF
                        & Blanks & "Eprop_Def.Id="
                        & ICS.Value (Get_Id (Eprop_Def)) & ASCII.LF
                        & Blanks & "Prop="
                        & (if Prop = null then "null"
                          else To_Hex (Prop'Address'Image)));
            end;


            return Eprop;
         end;
      end if;

      --  Fall back to default editor
      return Get_Base_Adaptor_Class.Create_Eprop (Adtor, Def, Use_Command);

   end Glade_Ada_Date_Picker_Create_Eprop;

end Ada_Widgets.Date_Picker.Editor;
