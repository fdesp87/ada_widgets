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
--  This binding is based on glade-3.40, licensed under GNU GPL version 2    --
-------------------------------------------------------------------------------
with System;
with Interfaces.C;                      use Interfaces.C;
with Interfaces.C.Strings;              use Interfaces.C.Strings;
with Interfaces.C.Extensions;           use Interfaces.C.Extensions;

with Glib;
with Glib.Values;
with Glib.Module;
with Glib.Additions;                    use Glib.Additions;

with Glade_Binding.Widget;
with Glade_Binding.Property_Definition; use Glade_Binding.Property_Definition;
with Glade_Binding.Editor_Property;

package Glade_Binding.Widget_Adaptor is

   --  GladeCreateReason Enum
   type Glade_Create_Reason is
     (Glade_Create_User,
      Glade_Create_Copy,
      Glade_Create_Load,
      Glade_Create_Rebuild,
      Glade_Create_Reasons);
   pragma Convention (C, Glade_Create_Reason);

   for Glade_Create_Reason use
     (Glade_Create_User    => 0,
      Glade_Create_Copy    => 1,
      Glade_Create_Load    => 2,
      Glade_Create_Rebuild => 3,
      Glade_Create_Reasons => 4);

   --  GladeEditorPageType Enum (Required placeholder for signatures)
   type Glade_Editor_Page_Type is new int;

   ----------------------------------------------------------------------------
   --  Adaptor
   ----------------------------------------------------------------------------
   type Adaptor_Record is record
      Filler : Byte_Storage (0 .. 23);
   end record;
   for Adaptor_Record'Size use 24 * 8;
   pragma Convention (C, Adaptor_Record);
   pragma Assert (Adaptor_Record'Size = 24 * 8);

   type Adaptor is access all Adaptor_Record;
   pragma Convention (C, Adaptor);

   ----------------------------------------------------------------------------
   --  Adaptor Class and Function pointers
   ----------------------------------------------------------------------------
   type Glade_Create_Widget_Func is access function
     (Adtor               : Adaptor;
      First_Property_Name : chars_ptr;
      Var_Args            : System.Address) return Glade_Binding.Widget.Glade_Widget;
   pragma Convention (C, Glade_Create_Widget_Func);

   type Glade_Set_Property_Func is access procedure
     (Adtor         : Adaptor;
      Object        : Glib.Additions.GObject_Ptr;
      Property_Name : chars_ptr;
      Value         : access Glib.Values.GValue);
   pragma Convention (C, Glade_Set_Property_Func);

   type Glade_Get_Property_Func is access procedure
     (Adtor         : Adaptor;
      Object        : Glib.Additions.GObject_Ptr;
      Property_Name : chars_ptr;
      Value         : access Glib.Values.GValue);
   pragma Convention (C, Glade_Get_Property_Func);

   type Glade_Verify_Property_Func is access function
     (Adtor         : Adaptor;
      Object        : GObject_Ptr;
      Property_Name : chars_ptr;
      Value         : access Glib.Values.GValue) return Interfaces.C.Extensions.bool;
   pragma Convention (C, Glade_Verify_Property_Func);

   type Glade_Child_Set_Property_Func is access procedure
     (Adtor         : Adaptor;
      Container     : GObject_Ptr;
      Child         : GObject_Ptr;
      Property_Name : chars_ptr;
      Value         : access Glib.Values.GValue);
   pragma Convention (C, Glade_Child_Set_Property_Func);

   type Glade_Child_Get_Property_Func is access procedure
     (Adtor         : Adaptor;
      Container     : GObject_Ptr;
      Child         : GObject_Ptr;
      Property_Name : chars_ptr;
      Value         : access Glib.Values.GValue);
   pragma Convention (C, Glade_Child_Get_Property_Func);

   type Glade_Child_Verify_Property_Func is access function
     (Adtor         : Adaptor;
      Container     : GObject_Ptr;
      Child         : GObject_Ptr;
      Property_Name : chars_ptr;
      Value         : access Glib.Values.GValue) return Interfaces.C.Extensions.bool;
   pragma Convention (C, Glade_Child_Verify_Property_Func);

   type Glade_Add_Child_Verify_Func is access function
     (Adtor         : Adaptor;
      Container     : GObject_Ptr;
      Child         : GObject_Ptr;
      User_Feedback : Interfaces.C.Extensions.bool) return Interfaces.C.Extensions.bool;
   pragma Convention (C, Glade_Add_Child_Verify_Func);

   type Glade_Get_Children_Func is access function
     (Adtor     : Adaptor;
      Container : GObject_Ptr) return GList_Ptr;
   pragma Convention (C, Glade_Get_Children_Func);

   type Glade_Add_Child_Func is access procedure
     (Adtor     : Adaptor;
      Container : GObject_Ptr;
      Child     : GObject_Ptr);
   pragma Convention (C, Glade_Add_Child_Func);

   type Glade_Remove_Child_Func is access procedure
     (Adtor     : Adaptor;
      Container : GObject_Ptr;
      Child     : GObject_Ptr);
   pragma Convention (C, Glade_Remove_Child_Func);

   type Glade_Replace_Child_Func is access procedure
     (Adtor     : Adaptor;
      Container : GObject_Ptr;
      Old_Obj   : GObject_Ptr;
      New_Obj   : GObject_Ptr);
   pragma Convention (C, Glade_Replace_Child_Func);

   type Glade_Construct_Object_Func is access function
     (Adtor        : Adaptor;
      N_Parameters : unsigned;
      Parameters   : Glib.Param_Spec_Array)
      return GObject_Ptr;
   pragma Convention (C, Glade_Construct_Object_Func);

   type Glade_Destroy_Object_Func is access procedure
     (Adtor   : Adaptor;
      Object  : GObject_Ptr);
   pragma Convention (C, Glade_Destroy_Object_Func);

   type Glade_Post_Create_Func is access procedure
     (Adtor   : Adaptor;
      Object  : GObject_Ptr;
      Reason  : Glade_Create_Reason);
   pragma Convention (C, Glade_Post_Create_Func);

   type Glade_Get_Internal_Func is access function
     (Adtor         : Adaptor;
      Object        : GObject_Ptr;
      Internal_Name : chars_ptr) return GObject_Ptr;
   pragma Convention (C, Glade_Get_Internal_Func);

   type Glade_Action_Activate_Func is access procedure
     (Adtor       : Adaptor;
      Object      : GObject_Ptr;
      Action_Path : chars_ptr);
   pragma Convention (C, Glade_Action_Activate_Func);

   type Glade_Child_Action_Activate_Func is access procedure
     (Adtor       : Adaptor;
      Container   : GObject_Ptr;
      Object      : GObject_Ptr;
      Action_Path : chars_ptr);
   pragma Convention (C, Glade_Child_Action_Activate_Func);

   type Glade_Action_Submenu_Func is access function
     (Adtor       : Adaptor;
      Object      : GObject_Ptr;
      Action_Path : chars_ptr) return Glade_Binding.Widget.Glade_Widget;
   pragma Convention (C, Glade_Action_Submenu_Func);

   type Glade_Depends_Func is access function
     (Adtor   : Adaptor;
      Widget  : Glade_Binding.Widget.Glade_Widget;
      Another : Glade_Binding.Widget.Glade_Widget) return Interfaces.C.Extensions.bool;
   pragma Convention (C, Glade_Depends_Func);

   type Glade_Read_Widget_Func is access procedure
     (Adtor   : Adaptor;
      Widget  : Glade_Binding.Widget.Glade_Widget;
      Node    : GladeXmlNode_Ptr);
   pragma Convention (C, Glade_Read_Widget_Func);

   type Glade_Write_Widget_Func is access procedure
     (Adtor   : Adaptor;
      Widget  : Glade_Binding.Widget.Glade_Widget;
      Context : GladeXmlContext_Ptr;
      Node    : GladeXmlNode_Ptr);
   pragma Convention (C, Glade_Write_Widget_Func);

   type Glade_Create_EProp_Func is access function
     (Adtor       : Adaptor;
      Def         : Property_Def;
      Use_Command : Interfaces.C.Extensions.bool)
      return Glade_Binding.Editor_Property.Editor_Prop;
   pragma Convention (C, Glade_Create_EProp_Func);

   type Glade_String_From_Value_Func is access function
     (Adtor   : Adaptor;
      Def     : Property_Def;
      Value   : access Glib.Values.GValue) return chars_ptr;
   pragma Convention (C, Glade_String_From_Value_Func);

   type Glade_Create_Editable_Func is access function
     (Adtor   : Adaptor;
      Type_Id : Glade_Editor_Page_Type) return GladeEditable_Ptr;
   pragma Convention (C, Glade_Create_Editable_Func);

   type Glade_Reserved_Func is access procedure;
   pragma Convention (C, Glade_Reserved_Func);

   --  the class
   type Adaptor_Class_Record is record
      Parent_Class          : Byte_Storage (0 .. 135);

      Version_Since_Major   : Glib.Guint16;
      Version_Since_Minor   : Glib.Guint16;

      Default_Width         : Glib.Gint16;
      Default_Height        : Glib.Gint16;

      Flags                 : Glib.Guint;

      Padding               : Glib.Guint;

      Create_Widget          : Glade_Create_Widget_Func;
      Construct_Object       : Glade_Construct_Object_Func;
      Deep_Post_Create       : Glade_Post_Create_Func;
      Post_Create            : Glade_Post_Create_Func;
      Get_Internal_Child     : Glade_Get_Internal_Func;

      Verify_Property        : Glade_Verify_Property_Func;
      Set_Property           : Glade_Set_Property_Func;
      Get_Property           : Glade_Get_Property_Func;

      Add_Verify             : Glade_Add_Child_Verify_Func;
      Add                    : Glade_Add_Child_Func;
      Remove                 : Glade_Remove_Child_Func;
      Get_Children           : Glade_Get_Children_Func;

      Child_Verify_Property  : Glade_Child_Verify_Property_Func;
      Child_Set_Property     : Glade_Child_Set_Property_Func;
      Child_Get_Property     : Glade_Child_Get_Property_Func;
      Replace_Child          : Glade_Replace_Child_Func;

      Action_Activate        : Glade_Action_Activate_Func;
      Child_Action_Activate  : Glade_Child_Action_Activate_Func;
      Action_Submenu         : Glade_Action_Submenu_Func;
      Depends                : Glade_Depends_Func;

      Read_Widget            : Glade_Read_Widget_Func;
      Write_Widget           : Glade_Write_Widget_Func;
      Read_Child             : Glade_Read_Widget_Func;
      Write_Child            : Glade_Write_Widget_Func;

      Create_EProp           : Glade_Create_EProp_Func;
      String_From_Value      : Glade_String_From_Value_Func;
      Create_Editable        : Glade_Create_Editable_Func;

      Destroy_Object         : Glade_Destroy_Object_Func;
      Write_Widget_After     : Glade_Write_Widget_Func;

      Deprecated_Since_Major : Glib.Guint16;
      Deprecated_Since_Minor : Glib.Guint16;

      Glade_Reserved1        : Glade_Reserved_Func;
      Glade_Reserved2        : Glade_Reserved_Func;
      Glade_Reserved3        : Glade_Reserved_Func;
      Glade_Reserved4        : Glade_Reserved_Func;
      Glade_Reserved5        : Glade_Reserved_Func;
   end record;
   for Adaptor_Class_Record use record
      Parent_Class            at 0   range 0 .. 1087;

      Version_Since_Major     at 136 range 0 .. 15;
      Version_Since_Minor     at 138 range 0 .. 15;
      Default_Width           at 140 range 0 .. 15;
      Default_Height          at 142 range 0 .. 15;

      Flags                   at 144 range 0 .. 31;
      Padding                 at 148 range 0 .. 31;

      Create_Widget           at 152 range 0 .. 63;
      Construct_Object        at 160 range 0 .. 63;
      Deep_Post_Create        at 168 range 0 .. 63;
      Post_Create             at 176 range 0 .. 63;
      Get_Internal_Child      at 184 range 0 .. 63;
      Verify_Property         at 192 range 0 .. 63;
      Set_Property            at 200 range 0 .. 63;
      Get_Property            at 208 range 0 .. 63;

      Add_Verify              at 216 range 0 .. 63;
      Add                     at 224 range 0 .. 63;
      Remove                  at 232 range 0 .. 63;
      Get_Children            at 240 range 0 .. 63;
      Child_Verify_Property   at 248 range 0 .. 63;
      Child_Set_Property      at 256 range 0 .. 63;
      Child_Get_Property      at 264 range 0 .. 63;
      Replace_Child           at 272 range 0 .. 63;

      Action_Activate         at 280 range 0 .. 63;
      Child_Action_Activate   at 288 range 0 .. 63;
      Action_Submenu          at 296 range 0 .. 63;
      Depends                 at 304 range 0 .. 63;
      Read_Widget             at 312 range 0 .. 63;
      Write_Widget            at 320 range 0 .. 63;
      Read_Child              at 328 range 0 .. 63;
      Write_Child             at 336 range 0 .. 63;
      Create_EProp            at 344 range 0 .. 63;
      String_From_Value       at 352 range 0 .. 63;
      Create_Editable         at 360 range 0 .. 63;
      Destroy_Object         at 368 range 0 .. 63;
      Write_Widget_After      at 376 range 0 .. 63;

      Deprecated_Since_Major  at 384 range 0 .. 15;
      Deprecated_Since_Minor  at 386 range 0 .. 15;

      Glade_Reserved1         at 392 range 0 .. 63;
      Glade_Reserved2         at 400 range 0 .. 63;
      Glade_Reserved3         at 408 range 0 .. 63;
      Glade_Reserved4         at 416 range 0 .. 63;
      Glade_Reserved5         at 424 range 0 .. 63;
   end record;
   for Adaptor_Class_Record'Size use 432 * 8;
   pragma Convention (C, Adaptor_Class_Record);
   pragma Assert (Adaptor_Class_Record'Size = 432 * 8);

   type Adaptor_Class is access all Adaptor_Class_Record;
   pragma Convention (C, Adaptor_Class);

   function Get_Adaptor_Class (Adtor : Adaptor) return Adaptor_Class;

   function Get_Base_Adaptor_Class return Adaptor_Class;

   ----------------------------------------------------------------------------
   --  Adapter Methods and Functions API
   ----------------------------------------------------------------------------
   pragma Warnings (Off, "involves a tagged type which does not correspond to any C type");

   function Get_Type return Glib.GType;
   pragma Import (C, Get_Type, "glade_widget_adaptor_get_type");

   function Get_Object_Type (Adtor : Adaptor) return Glib.GType;
   pragma Import (C, Get_Object_Type, "glade_widget_adaptor_get_object_type");

   function Get_Parent_Adaptor (Adtor : Adaptor) return Adaptor;
   pragma Import (C, Get_Parent_Adaptor, "glade_widget_adaptor_get_parent_adaptor");

   function Get_Name (Adtor : Adaptor) return chars_ptr;
   pragma Import (C, Get_Name, "glade_widget_adaptor_get_name");

   function G_Type_Class_Peek_Parent (G_Class : System.Address) return System.Address;
   pragma Import (C, G_Type_Class_Peek_Parent, "g_type_class_peek_parent");

   function Get_Generic_Name (Adtor : Adaptor) return chars_ptr;
   pragma Import (C, Get_Generic_Name, "glade_widget_adaptor_get_generic_name");

   function Get_Display_Name (Adtor : Adaptor) return chars_ptr;
   pragma Import (C, Get_Display_Name, "glade_widget_adaptor_get_display_name");

   function Get_Title (Adtor : Adaptor) return chars_ptr;
   pragma Import (C, Get_Title, "glade_widget_adaptor_get_title");

   function Get_Icon_Name (Adtor : Adaptor) return chars_ptr;
   pragma Import (C, Get_Icon_Name, "glade_widget_adaptor_get_icon_name");

   function Get_Missing_Icon (Adtor : Adaptor) return chars_ptr;
   pragma Import (C, Get_Missing_Icon, "glade_widget_adaptor_get_missing_icon");

   function Get_Catalog (Adtor : Adaptor) return chars_ptr;
   pragma Import (C, Get_Catalog, "glade_widget_adaptor_get_catalog");

   function Get_Book (Adtor : Adaptor) return chars_ptr;
   pragma Import (C, Get_Book, "glade_widget_adaptor_get_book");

   function Get_Properties (Adtor : Adaptor) return GList_Ptr;
   pragma Import (C, Get_Properties, "glade_widget_adaptor_get_properties");

   function Get_Packing_Props (Adtor : Adaptor) return GList_Ptr;
   pragma Import (C, Get_Packing_Props, "glade_widget_adaptor_get_packing_props");

   function Get_Signals (Adtor : Adaptor) return GList_Ptr;
   pragma Import (C, Get_Signals, "glade_widget_adaptor_get_signals");

   function List_Adaptors return GList_Ptr;
   pragma Import (C, List_Adaptors, "glade_widget_adaptor_list_adaptors");

   function From_Catalog
     (Catalog    : GladeCatalog_Ptr;
      Class_Node : GladeXmlNode_Ptr;
      Module     : Glib.Module.G_Module) return Adaptor;
   pragma Import (C, From_Catalog, "glade_widget_adaptor_from_catalog");

   procedure Register (Adtor : Adaptor);
   pragma Import (C, Register, "glade_widget_adaptor_register");

   function Create_Internal
     (Parent          : Glade_Binding.Widget.Glade_Widget;
      Internal_Object : GObject_Ptr;
      Internal_Name   : chars_ptr;
      Parent_Name     : chars_ptr;
      Anarchist       : Interfaces.C.Extensions.bool;
      Reason          : Glade_Create_Reason) return Glade_Binding.Widget.Glade_Widget;
   pragma Import (C, Create_Internal, "glade_widget_adaptor_create_internal");

   function Create_Widget_Real
     (Query          : Interfaces.C.Extensions.bool;
      First_Property : chars_ptr) return Glade_Binding.Widget.Glade_Widget;
   pragma Import (C, Create_Widget_Real, "glade_widget_adaptor_create_widget_real");

   function Get_By_Name (Name : chars_ptr) return Adaptor;
   pragma Import (C, Get_By_Name, "glade_widget_adaptor_get_by_name");

   function Get_By_Type (Type_Id : Glib.GType) return Adaptor;
   pragma Import (C, Get_By_Type, "glade_widget_adaptor_get_by_type");

   function From_Pspec
     (Adtor   : Adaptor;
      Pspec   : Glib.Param_Spec) return Adaptor;
   pragma Import (C, From_Pspec, "glade_widget_adaptor_from_pspec");

   function Get_Property_Def
     (Adtor   : Adaptor;
      Name    : chars_ptr) return Property_Def;
   pragma Import (C, Get_Property_Def, "glade_widget_adaptor_get_property_def");

   function Get_Pack_Property_Def
     (Adtor   : Adaptor;
      Name    : chars_ptr) return Property_Def;
   pragma Import (C, Get_Pack_Property_Def, "glade_widget_adaptor_get_pack_property_def");

   function Default_Params
     (Adtor     : Adaptor;
      Construct : Interfaces.C.Extensions.bool;
      N_Params  : access unsigned) return Glib.Param_Spec;
   --  really the returned value is an array of pointers with N_Params.all elements
   pragma Import (C, Default_Params, "glade_widget_adaptor_default_params");

   function Construct_Object
     (Adtor        : Adaptor;
      N_Parameters : unsigned;
      Parameters   : Glib.Param_Spec) return GObject_Ptr;
   pragma Import (C, Construct_Object, "glade_widget_construct_object");

   procedure Destroy_Object
     (Adtor   : Adaptor;
      Object  : GObject_Ptr);
   pragma Import (C, Destroy_Object, "glade_widget_adaptor_destroy_object");

   procedure Post_Create
     (Adtor   : Adaptor;
      Object  : GObject_Ptr;
      Reason  : Glade_Create_Reason);
   pragma Import (C, Post_Create, "glade_widget_adaptor_post_create");

   function Get_Internal_Child
     (Adtor         : Adaptor;
      Object        : GObject_Ptr;
      Internal_Name : chars_ptr) return GObject_Ptr;
   pragma Import (C, Get_Internal_Child, "glade_widget_adaptor_get_internal_child");

   procedure Set_Property
     (Adtor         : Adaptor;
      Object        : GObject_Ptr;
      Property_Name : chars_ptr;
      Value         : Glib.Values.GValue);
   pragma Import (C, Set_Property, "glade_widget_adaptor_set_property");

   procedure Get_Property
     (Adtor         : Adaptor;
      Object        : GObject_Ptr;
      Property_Name : chars_ptr;
      Value         : Glib.Values.GValue);
   pragma Import (C, Get_Property, "glade_widget_adaptor_get_property");

   function Verify_Property
     (Adtor         : Adaptor;
      Object        : GObject_Ptr;
      Property_Name : chars_ptr;
      Value         : Glib.Values.GValue) return Interfaces.C.Extensions.bool;
   pragma Import (C, Verify_Property, "glade_widget_adaptor_verify_property");

   function Add_Verify
     (Adtor         : Adaptor;
      Container     : GObject_Ptr;
      Child         : GObject_Ptr;
      User_Feedback : Interfaces.C.Extensions.bool) return Interfaces.C.Extensions.bool;
   pragma Import (C, Add_Verify, "glade_widget_adaptor_add_verify");

   procedure Add
     (Adtor     : Adaptor;
      Container : GObject_Ptr;
      Child     : GObject_Ptr);
   pragma Import (C, Add, "glade_widget_adaptor_add");

   procedure Remove
     (Adtor     : Adaptor;
      Container : GObject_Ptr;
      Child     : GObject_Ptr);
   pragma Import (C, Remove, "glade_widget_adaptor_remove");

   function Get_Children
     (Adtor     : Adaptor;
      Container : GObject_Ptr) return GList_Ptr;
   pragma Import (C, Get_Children, "glade_widget_adaptor_get_children");

   function Has_Child
     (Adtor     : Adaptor;
      Container : GObject_Ptr;
      Child     : GObject_Ptr) return Interfaces.C.Extensions.bool;
   pragma Import (C, Has_Child, "glade_widget_adaptor_has_child");

   procedure Child_Set_Property
     (Adtor         : Adaptor;
      Container     : GObject_Ptr;
      Child         : GObject_Ptr;
      Property_Name : chars_ptr;
      Value         : Glib.Values.GValue);
   pragma Import (C, Child_Set_Property, "glade_widget_adaptor_child_set_property");

   procedure Child_Get_Property
     (Adtor         : Adaptor;
      Container     : GObject_Ptr;
      Child         : GObject_Ptr;
      Property_Name : chars_ptr;
      Value         : Glib.Values.GValue);
   pragma Import (C, Child_Get_Property, "glade_widget_adaptor_child_get_property");

   function Child_Verify_Property
     (Adtor         : Adaptor;
      Container     : GObject_Ptr;
      Child         : GObject_Ptr;
      Property_Name : chars_ptr;
      Value         : Glib.Values.GValue) return Interfaces.C.Extensions.bool;
   pragma Import (C, Child_Verify_Property, "glade_widget_adaptor_child_verify_property");

   procedure Replace_Child
     (Adtor     : Adaptor;
      Container : GObject_Ptr;
      Old_Obj   : GObject_Ptr;
      New_Obj   : GObject_Ptr);
   pragma Import (C, Replace_Child, "glade_widget_adaptor_replace_child");

   function Query (Adtor : Adaptor) return Interfaces.C.Extensions.bool;
   pragma Import (C, Query, "glade_widget_adaptor_query");

   function Get_Packing_Default
     (Child_Adaptor     : Adaptor;
      Container_Adaptor : Adaptor;
      Id                : chars_ptr) return chars_ptr;
   pragma Import (C, Get_Packing_Default, "glade_widget_adaptor_get_packing_default");

   function Is_Container (Adtor : Adaptor) return Interfaces.C.Extensions.bool;
   pragma Import (C, Is_Container, "glade_widget_adaptor_is_container");

   function Action_Add
     (Adtor       : Adaptor;
      Action_Path : chars_ptr;
      Label       : chars_ptr;
      Stock       : chars_ptr;
      Important   : Interfaces.C.Extensions.bool) return Interfaces.C.Extensions.bool;
   pragma Import (C, Action_Add, "glade_widget_adaptor_action_add");

   function Pack_Action_Add
     (Adtor       : Adaptor;
      Action_Path : chars_ptr;
      Label       : chars_ptr;
      Stock       : chars_ptr;
      Important   : Interfaces.C.Extensions.bool) return Interfaces.C.Extensions.bool;
   pragma Import (C, Pack_Action_Add, "glade_widget_adaptor_pack_action_add");

   function Action_Remove
     (Adtor       : Adaptor;
      Action_Path : chars_ptr) return Interfaces.C.Extensions.bool;
   pragma Import (C, Action_Remove, "glade_widget_adaptor_action_remove");

   function Pack_Action_Remove
     (Adtor       : Adaptor;
      Action_Path : chars_ptr) return Interfaces.C.Extensions.bool;
   pragma Import (C, Pack_Action_Remove, "glade_widget_adaptor_pack_action_remove");

   function Actions_New (Adtor : Adaptor) return GList_Ptr;
   pragma Import (C, Actions_New, "glade_widget_adaptor_actions_new");

   function Pack_Actions_New (Adtor : Adaptor) return GList_Ptr;
   pragma Import (C, Pack_Actions_New, "glade_widget_adaptor_pack_actions_new");

   procedure Action_Activate
     (Adtor       : Adaptor;
      Object      : GObject_Ptr;
      Action_Path : chars_ptr);
   pragma Import (C, Action_Activate, "glade_widget_adaptor_action_activate");

   procedure Child_Action_Activate
     (Adtor       : Adaptor;
      Container   : GObject_Ptr;
      Object      : GObject_Ptr;
      Action_Path : chars_ptr);
   pragma Import (C, Child_Action_Activate, "glade_widget_adaptor_child_action_activate");

   function Action_Submenu
     (Adtor       : Adaptor;
      Object      : GObject_Ptr;
      Action_Path : chars_ptr) return Glade_Binding.Widget.Glade_Widget;
   pragma Import (C, Action_Submenu, "glade_widget_adaptor_action_submenu");

   function Depends
     (Adtor   : Adaptor;
      Widget  : Glade_Binding.Widget.Glade_Widget;
      Another : Glade_Binding.Widget.Glade_Widget) return Interfaces.C.Extensions.bool;
   pragma Import (C, Depends, "glade_widget_adaptor_depends");

   procedure Read_Widget
     (Adtor   : Adaptor;
      Widget  : Glade_Binding.Widget.Glade_Widget;
      Node    : Glade_Binding.Widget.Glade_Widget);
   pragma Import (C, Read_Widget, "glade_widget_adaptor_read_widget");

   procedure Write_Widget
     (Adtor   : Adaptor;
      Widget  : Glade_Binding.Widget.Glade_Widget;
      Context : GladeXmlContext_Ptr;
      Node    : GladeXmlNode_Ptr);
   pragma Import (C, Write_Widget, "glade_widget_adaptor_write_widget");

   procedure Write_Widget_After
     (Adtor   : Adaptor;
      Widget  : Glade_Binding.Widget.Glade_Widget;
      Context : GladeXmlContext_Ptr;
      Node    : GladeXmlNode_Ptr);
   pragma Import (C, Write_Widget_After, "glade_widget_adaptor_write_widget_after");

   procedure Read_Child
     (Adtor   : Adaptor;
      Widget  : Glade_Binding.Widget.Glade_Widget;
      Node    : GladeXmlNode_Ptr);
   pragma Import (C, Read_Child, "glade_widget_adaptor_read_child");

   procedure Write_Child
     (Adtor   : Adaptor;
      Widget  : Glade_Binding.Widget.Glade_Widget;
      Context : GladeXmlContext_Ptr;
      Node    : GladeXmlNode_Ptr);
   pragma Import (C, Write_Child, "glade_widget_adaptor_write_child");

   function Create_Eprop
     (Adtor       : Adaptor;
      Def         : Property_Def;
      Use_Command : Interfaces.C.Extensions.bool)
      return Glade_Binding.Editor_Property.Editor_Prop;
   pragma Import (C, Create_Eprop, "glade_widget_adaptor_create_eprop");

   function Create_Eprop_By_Name
     (Adtor       : Adaptor;
      Property_Id : chars_ptr;
      Packing     : Interfaces.C.Extensions.bool;
      Use_Command : Interfaces.C.Extensions.bool)
      return Glade_Binding.Editor_Property.Editor_Prop;
   pragma Import (C, Create_Eprop_By_Name, "glade_widget_adaptor_create_eprop_by_name");

   function String_From_Value
     (Adtor   : Adaptor;
      Def     : Property_Def;
      Value   : access Glib.Values.GValue) return chars_ptr;
   pragma Import (C, String_From_Value, "glade_widget_adaptor_string_from_value");

   function Create_Editable
     (Adtor   : Adaptor;
      Type_Id : Glade_Editor_Page_Type) return GladeEditable_Ptr;
   pragma Import (C, Create_Editable, "glade_widget_adaptor_create_editable");

   function Get_Signal_Def
     (Adtor   : Adaptor;
      Name    : chars_ptr) return GladeSignalDef_Ptr;
   pragma Import (C, Get_Signal_Def, "glade_widget_get_signal_def");

   function Has_Internal_Children (Adtor : Adaptor) return Interfaces.C.Extensions.bool;
   pragma Import (C, Has_Internal_Children, "glade_widget_adaptor_has_internal_children");

   function Get_Type_Func (Adtor : Adaptor) return chars_ptr;
   pragma Import (C, Get_Type_Func, "glade_widget_adaptor_get_type_func");

   pragma Warnings (On, "involves a tagged type which does not correspond to any C type");
end Glade_Binding.Widget_Adaptor;
