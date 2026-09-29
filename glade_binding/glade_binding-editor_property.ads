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
--  This binding is based on glade-3.40, licensed under GNU GPL version 2    --
-------------------------------------------------------------------------------
with System;
with Interfaces.C;             use Interfaces.C;
with Interfaces.C.Strings;     use Interfaces.C.Strings;
with Interfaces.C.Extensions;  use Interfaces.C.Extensions;
with Ada.Unchecked_Conversion;
with Glib;
with Glib.Values;

limited with Glade_Binding.Widget;
with Glade_Binding.Properties;          use Glade_Binding.Properties;
with Glade_Binding.Property_Definition; use Glade_Binding.Property_Definition;

package Glade_Binding.Editor_Property is

   package ICE renames Interfaces.C.Extensions;

   ------------------------------------------------------------------
   --  Basic types
   ------------------------------------------------------------------
   type Editor_Prop_Record is record
      Filler : Byte_Storage (0 .. 47);
   end record;
   for Editor_Prop_Record'Size use 48 * 8;
   pragma Convention (C, Editor_Prop_Record);
   pragma Assert (Editor_Prop_Record'Size = 48 * 8);

   type Editor_Prop is access all Editor_Prop_Record;
   pragma Convention (C, Editor_Prop);
   pragma No_Strict_Aliasing (Editor_Prop);

   function New_Eprop
     (Typ         : Glib.GType;
      Prop_Name1  : Chars_Ptr;
      Prop_Value1 : System.Address;
      Prop_Name2  : Chars_Ptr;
      Prop_Value2 : ICE.bool) return Editor_Prop;

   ------------------------------------------------------------------
   --  Generic instantiations
   ------------------------------------------------------------------
   generic
      type Extra_Data is private;

   package Editor_Property_Extension is

      type Extra_Prop_Record is record
         Filler : Editor_Prop_Record;
         Extra  : Extra_Data;
      end record;
      pragma Convention (C, Extra_Prop_Record);

      type Extra_Eprop is access all Extra_Prop_Record;
      pragma Convention (C, Extra_Eprop);

      function New_Extra_Eprop
        (Typ         : Glib.GType;
         Prop_Name1  : Chars_Ptr;
         Prop_Value1 : System.Address;
         Prop_Name2  : Chars_Ptr;
         Prop_Value2 : ICE.bool) return Extra_Eprop;

      function "+" is new Ada.Unchecked_Conversion
        (Source => Editor_Prop,
         Target => Extra_Eprop);

      function "-" is new Ada.Unchecked_Conversion
        (Source => Extra_Eprop,
         Target => Editor_Prop);

   end Editor_Property_Extension;

   ------------------------------------------------------------------
   --  Class (vtable)
   ------------------------------------------------------------------
   -- Virtual methods (exact signatures from glade-editor-property.h)

   type Load_Func is access procedure (Eprop : Editor_Prop;
                                       Prop  : Property);
   pragma Convention (C, Load_Func);

   --  The C implementation returns a GtkWidget *, but the Ada binding uses
   --  Glade_Widget as the raw C pointer type.  Do not replace this with the
   --  GtkAda Gtk_Widget type, which is an Ada wrapper containing the C pointer.
   type Create_Input_Func is access function (Eprop : Editor_Prop)
                                              return Glade_Binding.Widget.Glade_Widget;
   pragma Convention (C, Create_Input_Func);

   type Commit_Func is access procedure (Eprop : Editor_Prop;
                                         Value : access Glib.Values.GValue);
   pragma Convention (C, Commit_Func);

   type Changed_Func is access procedure (Eprop : Editor_Prop;
                                         Prop  : Property);
   pragma Convention (C, Changed_Func);

   type Padding_Array is
     array (0 .. 3) of System.Address;
   pragma Convention (C, Padding_Array);

   type Editor_Property_Class_Record is record
      Parent_Class : Byte_Storage (0 .. 1007);
      Load         : Load_Func;
      Create_Input : Create_Input_Func;
      Commit       : Commit_Func;
      Changed      : Changed_Func;
      Padding      : Padding_Array;
   end record;
   pragma Convention (C, Editor_Property_Class_Record);

   for Editor_Property_Class_Record use record
      Parent_Class at 0    range 0 .. 8063;
      Load         at 1008 range 0 .. 63;
      Create_Input at 1016 range 0 .. 63;
      Commit       at 1024 range 0 .. 63;
      Changed      at 1032 range 0 .. 63;
      Padding      at 1040 range 0 .. 255;
   end record;
   for Editor_Property_Class_Record'Size use 1072 * 8;

   type Editor_Property_Class is access all Editor_Property_Class_Record;
   pragma Convention (C, Editor_Property_Class);
   pragma No_Strict_Aliasing (Editor_Property_Class);

   ------------------------------------------------------------------
   --  Public API
   ------------------------------------------------------------------
   function Get_Type return Glib.GType;
   pragma Import (C, Get_Type, "glade_editor_property_get_type");

   procedure Load (Eprop : Editor_Prop;
                   Prop  : Property);
   pragma Import (C, Load, "glade_editor_property_load");

   procedure Load_By_Widget (Eprop  : Editor_Prop;
                             Widget : Glade_Binding.Widget.Glade_Widget);
   pragma Import (C, Load_By_Widget, "glade_editor_property_load_by_widget");

   procedure Commit (Eprop : Editor_Prop;
                     Value : access Glib.Values.GValue);
   pragma Import (C, Commit, "glade_editor_property_commit");

   procedure Commit_No_Callback (Eprop : Editor_Prop;
                                 Value : access Glib.Values.GValue);
   pragma Import (C, Commit_No_Callback, "glade_editor_property_commit_no_callback");

   procedure Set_Custom_Text (Eprop       : Editor_Prop;
                              Custom_Text : chars_ptr);
   pragma Import (C, Set_Custom_Text, "glade_editor_property_set_custom_text");

   function Get_Custom_Text (Eprop : Editor_Prop) return chars_ptr;
   pragma Import (C, Get_Custom_Text, "glade_editor_property_get_custom_text");

   procedure Set_Disable_Check (Eprop         : Editor_Prop;
                                Disable_Check : ICE.bool);
   pragma Import (C, Set_Disable_Check, "glade_editor_property_set_disable_check");

   function Get_Disable_Check (Eprop : Editor_Prop)
                               return ICE.bool;
   pragma Import (C, Get_Disable_Check, "glade_editor_property_get_disable_check");

   function Get_Item_Label (Eprop : Editor_Prop)
                            return Glade_Binding.Widget.Glade_Widget;
   pragma Import (C, Get_Item_Label, "glade_editor_property_get_item_label");

   function Get_Property_Def (Eprop : Editor_Prop)
                              return Property_Def;
   pragma Import (C, Get_Property_Def, "glade_editor_property_get_property_def");

   function Get_Property (Eprop : Editor_Prop)
                          return Property;
   pragma Import (C, Get_Property, "glade_editor_property_get_property");

   function Loading (Eprop : Editor_Prop)
                     return ICE.bool;
   pragma Import (C, Loading, "glade_editor_property_loading");

   ------------------------------------------------------------------
   --  Utility dialogs
   ------------------------------------------------------------------
   function Show_I18n_Dialog (Parent       : Glade_Binding.Widget.Glade_Widget;
                              Text         : access chars_ptr;
                              Context      : access chars_ptr;
                              Comment      : access chars_ptr;
                              Translatable : access ICE.bool)
                              return ICE.bool;
   pragma Import (C, Show_I18n_Dialog, "glade_editor_property_show_i18n_dialog");

   function Show_Resource_Dialog (Project  : GladeProject_Ptr;
                                  Parent   : Glade_Binding.Widget.Glade_Widget;
                                  Filename : access chars_ptr) return ICE.bool;
   pragma Import (C, Show_Resource_Dialog, "glade_editor_property_show_resource_dialog");

   function Show_Object_Dialog (Project          : GladeProject_Ptr;
                                Title            : chars_ptr;
                                Parent           : Glade_Binding.Widget.Glade_Widget;
                                Object_Type      : Glib.GType;
                                Exception_Widget : Glade_Binding.Widget.Glade_Widget;
                                Object           : access Glade_Binding.Widget.Glade_Widget)
                                return ICE.bool;
   pragma Import (C, Show_Object_Dialog, "glade_editor_property_show_object_dialog");

   ------------------------------------------------------------------
   --  Subclassing support
   ------------------------------------------------------------------
   function Class_Peek_Parent (Class : Editor_Property_Class)
                               return Editor_Property_Class;
   pragma Import (C, Class_Peek_Parent, "g_type_class_peek_parent");

end Glade_Binding.Editor_Property;
