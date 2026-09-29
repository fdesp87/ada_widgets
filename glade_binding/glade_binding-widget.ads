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
with Interfaces.C;             use Interfaces.C;
with Interfaces.C.Strings;     use Interfaces.C.Strings;
with Interfaces.C.Extensions;  use Interfaces.C.Extensions;

with Glib.Values;
with Glib;
with Gdk.Event;
with Gtk.Tree_Model;

limited with Glade_Binding.Properties;
limited with Glade_Binding.Widget_Adaptor;
limited with Glade_Binding.Editor_Property;

package Glade_Binding.Widget is

   type Glade_Widget_Record is record
      Parent_Instance : GObject_C_Block;
      Priv            : System.Address;
   end record;
   pragma Convention (C, Glade_Widget_Record);
   for Glade_Widget_Record'Alignment use 8;
   for Glade_Widget_Record'Size use 32 * 8;
   pragma Assert (Glade_Widget_Record'Size = 32 * 8);

   type Glade_Widget is access all Glade_Widget_Record;
   pragma Convention (C, Glade_Widget);
   pragma No_Strict_Aliasing (Glade_Widget);

   ----------------------------------------------------------------------------
   --  Class (vtable)
   ----------------------------------------------------------------------------

   --  Virtual method signatures
   type Add_Child_Func is access procedure
     (Parent   : Glade_Widget;
      Child    : Glade_Widget;
      At_Mouse : Extensions.bool);
   pragma Convention (C, Add_Child_Func);

   type Remove_Child_Func is access procedure
     (Parent : Glade_Widget;
      Child  : Glade_Widget);
   pragma Convention (C, Remove_Child_Func);

   type Replace_Child_Func is access procedure
     (Parent     : Glade_Widget;
      Old_Object : GObject_Ptr;
      New_Object : GObject_Ptr);
   pragma Convention (C, Replace_Child_Func);

   type Add_Signal_Handler_Func is access procedure
     (Widget         : Glade_Widget;
      Signal_Handler : GladeSignal_Ptr);
   pragma Convention (C, Add_Signal_Handler_Func);

   type Remove_Signal_Handler_Func is access procedure
     (Widget         : Glade_Widget;
      Signal_Handler : GladeSignal_Ptr);
   pragma Convention (C, Remove_Signal_Handler_Func);

   type Change_Signal_Handler_Func is access procedure
     (Widget             : Glade_Widget;
      Old_Signal_Handler : GladeSignal_Ptr;
      New_Signal_Handler : GladeSignal_Ptr);
   pragma Convention (C, Change_Signal_Handler_Func);

   type Button_Press_Event_Func is access function
     (Widget : Glade_Widget;
      Event  : Gdk.Event.Gdk_Event) return int;
   pragma Convention (C, Button_Press_Event_Func);

   type Button_Release_Event_Func is access function
     (Widget : Glade_Widget;
      Event  : Gdk.Event.Gdk_Event) return int;
   pragma Convention (C, Button_Release_Event_Func);

   type Motion_Notify_Event_Func is access function
     (Widget : Glade_Widget;
      Event  : Gdk.Event.Gdk_Event) return int;
   pragma Convention (C, Motion_Notify_Event_Func);

   type Event_Func is access function
     (Gwidget : Glade_Widget;
      Event   : Gdk.Event.Gdk_Event) return Extensions.bool;
   pragma Convention (C, Event_Func);

   type Reserved_Func is access procedure;
   pragma Convention (C, Reserved_Func);

   type Glade_Widget_Class_Block is record
      Parent_Class          : Byte_Storage (0 .. 135);

      Add_Child             : Add_Child_Func;
      Remove_Child          : Remove_Child_Func;
      Replace_Child         : Replace_Child_Func;

      Add_Signal_Handler    : Add_Signal_Handler_Func;
      Remove_Signal_Handler : Remove_Signal_Handler_Func;
      Change_Signal_Handler : Change_Signal_Handler_Func;

      Button_Press_Event    : Button_Press_Event_Func;
      Button_Release_Event  : Button_Release_Event_Func;
      Motion_Notify_Event   : Motion_Notify_Event_Func;

      Event                 : Event_Func;

      Glade_Reserved1       : Reserved_Func;
      Glade_Reserved2       : Reserved_Func;
      Glade_Reserved3       : Reserved_Func;
      Glade_Reserved4       : Reserved_Func;
      Glade_Reserved5       : Reserved_Func;
      Glade_Reserved6       : Reserved_Func;
      Glade_Reserved7       : Reserved_Func;
      Glade_Reserved8       : Reserved_Func;
   end record;

   for Glade_Widget_Class_Block use record
      Parent_Class          at 0   range 0 .. 1087;   -- 136 bytes

      Add_Child             at 136 range 0 .. 63;
      Remove_Child          at 144 range 0 .. 63;
      Replace_Child         at 152 range 0 .. 63;

      Add_Signal_Handler    at 160 range 0 .. 63;
      Remove_Signal_Handler at 168 range 0 .. 63;
      Change_Signal_Handler at 176 range 0 .. 63;

      Button_Press_Event    at 184 range 0 .. 63;
      Button_Release_Event  at 192 range 0 .. 63;
      Motion_Notify_Event   at 200 range 0 .. 63;

      Event                 at 208 range 0 .. 63;

      Glade_Reserved1       at 216 range 0 .. 63;
      Glade_Reserved2       at 224 range 0 .. 63;
      Glade_Reserved3       at 232 range 0 .. 63;
      Glade_Reserved4       at 240 range 0 .. 63;
      Glade_Reserved5       at 248 range 0 .. 63;
      Glade_Reserved6       at 256 range 0 .. 63;
      Glade_Reserved7       at 264 range 0 .. 63;
      Glade_Reserved8       at 272 range 0 .. 63;
   end record;
   for Glade_Widget_Class_Block'Size use 280 * 8;
   pragma Convention (C, Glade_Widget_Class_Block);
   pragma Assert (Glade_Widget_Class_Block'Size = 280 * 8);

   type Glade_Widget_Class is access all Glade_Widget_Class_Block;
   pragma Convention (C, Glade_Widget_Class);
   pragma No_Strict_Aliasing (Glade_Widget_Class);

   function Get_Widget_Class (Widget : Glade_Widget) return Glade_Widget_Class;

   ----------------------------------------------------------------------------
   --  General API
   ----------------------------------------------------------------------------
   pragma Warnings (Off, "involves a tagged type which does not correspond to any C type");
   pragma Warnings (Off, "does not correspond to C type");

   function Get_Type return Glib.GType;
   pragma Import (C, Get_Type, "glade_widget_get_type");

   function Get_From_Gobject (Object : GObject_Ptr)
                              return Glade_Widget;
   pragma Import (C, Get_From_Gobject, "glade_widget_get_from_gobject");

   function Add_Verify
     (Widget         : Glade_Widget;
      Child          : Glade_Widget;
      User_Feedback  : Extensions.bool) return Extensions.bool;
   pragma Import (C, Add_Verify, "glade_widget_add_verify");

   procedure Add_Child
     (Parent   : Glade_Widget;
      Child    : Glade_Widget;
      At_Mouse : Extensions.bool);
   pragma Import (C, Add_Child, "glade_widget_add_child");

   procedure Remove_Child (Parent : Glade_Widget; Child : Glade_Widget);
   pragma Import (C, Remove_Child, "glade_widget_remove_child");

   procedure Replace
     (Parent     : Glade_Widget;
      Old_Object : GObject_Ptr;
      New_Object : GObject_Ptr);
   pragma Import (C, Replace, "glade_widget_replace");

   procedure Rebuild (Gwidget : Glade_Widget);
   pragma Import (C, Rebuild, "glade_widget_rebuild");

   function Dup (Template_Widget : Glade_Widget; Exact : Extensions.bool) return Glade_Widget;
   pragma Import (C, Dup, "glade_widget_dup");

   function Get_Signal_List (Widget : Glade_Widget) return GList_Ptr;
   pragma Import (C, Get_Signal_List, "glade_widget_get_signal_list");

   procedure Copy_Signals (Widget : Glade_Widget; Template_Widget : Glade_Widget);
   pragma Import (C, Copy_Signals, "glade_widget_copy_signals");

   procedure Copy_Properties
     (Widget            : Glade_Widget;
      Template_Widget   : Glade_Widget;
      Copy_Parentless   : Extensions.bool;
      Exact             : Extensions.bool);
   pragma Import (C, Copy_Properties, "glade_widget_copy_properties");

   procedure Set_Packing_Properties (Widget : Glade_Widget; Container : Glade_Widget);
   pragma Import (C, Set_Packing_Properties, "glade_widget_set_packing_properties");

   function Get_Properties (Widget : Glade_Widget) return GList_Ptr;
   pragma Import (C, Get_Properties, "glade_widget_get_properties");

   function Get_Packing_Properties (Widget : Glade_Widget) return GList_Ptr;
   pragma Import (C, Get_Packing_Properties, "glade_widget_get_packing_properties");

   function Get_Property (Widget      : Glade_Widget;
                          Id_Property : chars_ptr) return Glade_Binding.Properties.Property;
   pragma Import (C, Get_Property, "glade_widget_get_property");

   function Get_Pack_Property (Widget      : Glade_Widget;
                               Id_Property : chars_ptr) return Glade_Binding.Properties.Property;
   pragma Import (C, Get_Pack_Property, "glade_widget_get_pack_property");

   function Dup_Properties
     (Dest_Widget      : Glade_Widget;
      Template_Props   : GList_Ptr;
      As_Load          : Extensions.bool;
      Copy_Parentless   : Extensions.bool;
      Exact             : Extensions.bool) return GList_Ptr;
   pragma Import (C, Dup_Properties, "glade_widget_dup_properties");

   procedure Remove_Property (Widget      : Glade_Widget;
                              Id_Property : chars_ptr);
   pragma Import (C, Remove_Property, "glade_widget_remove_property");

   procedure Show (Widget : Glade_Widget);
   pragma Import (C, Show, "glade_widget_show");

   procedure Hide (Widget : Glade_Widget);
   pragma Import (C, Hide, "glade_widget_hide");

   procedure Add_Signal_Handler (Widget         : Glade_Widget;
                                 Signal_Handler : GladeSignal_Ptr);
   pragma Import (C, Add_Signal_Handler, "glade_widget_add_signal_handler");

   procedure Remove_Signal_Handler (Widget         : Glade_Widget;
                                    Signal_Handler : GladeSignal_Ptr);
   pragma Import (C, Remove_Signal_Handler, "glade_widget_remove_signal_handler");

   procedure Change_Signal_Handler
     (Widget             : Glade_Widget;
      Old_Signal_Handler : GladeSignal_Ptr;
      New_Signal_Handler : GladeSignal_Ptr);
   pragma Import (C, Change_Signal_Handler, "glade_widget_change_signal_handler");

   function List_Signal_Handlers (Widget      : Glade_Widget;
                                  Signal_Name : chars_ptr) return GPtrArray_Ptr;
   pragma Import (C, List_Signal_Handlers, "glade_widget_list_signal_handlers");

   function Has_Decendant (Widget  : Glade_Widget;
                           Type_Id : Glib.GType) return Extensions.bool;
   pragma Import (C, Has_Decendant, "glade_widget_has_decendant");

   function Event (Gwidget : Glade_Widget; Event : Gdk.Event.Gdk_Event) return Extensions.bool;
   pragma Import (C, Event, "glade_widget_event");

   function Placeholder_Relation (Parent : Glade_Widget;
                                  Widget : Glade_Widget) return Extensions.bool;
   pragma Import (C, Placeholder_Relation, "glade_widget_placeholder_relation");

   function Get_Action (Widget      : Glade_Widget;
                        Action_Path : chars_ptr) return GladeWidgetAction_Ptr;
   pragma Import (C, Get_Action, "glade_widget_get_action");

   function Get_Pack_Action (Widget      : Glade_Widget;
                             Action_Path : chars_ptr) return GladeWidgetAction_Ptr;
   pragma Import (C, Get_Pack_Action, "glade_widget_get_pack_action");

   function Get_Actions (Widget : Glade_Widget) return GList_Ptr;
   pragma Import (C, Get_Actions, "glade_widget_get_actions");

   function Get_Pack_Actions (Widget : Glade_Widget) return GList_Ptr;
   pragma Import (C, Get_Pack_Actions, "glade_widget_get_pack_actions");

   function Set_Action_Sensitive
     (Widget      : Glade_Widget;
      Action_Path : chars_ptr;
      Sensitive   : Extensions.bool) return Extensions.bool;
   pragma Import (C, Set_Action_Sensitive, "glade_widget_set_action_sensitive");

   function Set_Pack_Action_Sensitive
     (Widget      : Glade_Widget;
      Action_Path : chars_ptr;
      Sensitive   : Extensions.bool) return Extensions.bool;
   pragma Import (C, Set_Pack_Action_Sensitive, "glade_widget_set_pack_action_sensitive");

   function Set_Action_Visible
     (Widget      : Glade_Widget;
      Action_Path : chars_ptr;
      Visible     : Extensions.bool) return Extensions.bool;
   pragma Import (C, Set_Action_Visible, "glade_widget_set_action_visible");

   function Set_Pack_Action_Visible
     (Widget      : Glade_Widget;
      Action_Path : chars_ptr;
      Visible     : Extensions.bool) return Extensions.bool;
   pragma Import (C, Set_Pack_Action_Visible, "glade_widget_set_pack_action_visible");

   procedure Write (Widget : Glade_Widget; Context : GladeXmlContext_Ptr; Node : GladeXmlNode_Ptr);
   pragma Import (C, Write, "glade_widget_write");

   procedure Write_Child
     (Widget  : Glade_Widget;
      Child   : Glade_Widget;
      Context : GladeXmlContext_Ptr;
      Node    : GladeXmlNode_Ptr);
   pragma Import (C, Write_Child, "glade_widget_write_child");

   procedure Write_Signals (Widget  : Glade_Widget;
                            Context : GladeXmlContext_Ptr; Node : GladeXmlNode_Ptr);
   pragma Import (C, Write_Signals, "glade_widget_write_signals");

   procedure Write_Placeholder
     (Parent  : Glade_Widget;
      Object  : GObject_Ptr;
      Context : GladeXmlContext_Ptr;
      Node    : GladeXmlNode_Ptr);
   pragma Import (C, Write_Placeholder, "glade_widget_write_placeholder");

   function Read
     (Project  : GladeProject_Ptr;
      Parent   : Glade_Widget;
      Node     : GladeXmlNode_Ptr;
      Internal : chars_ptr) return Glade_Widget;
   pragma Import (C, Read, "glade_widget_read");

   procedure Read_Child (Widget : Glade_Widget; Node : GladeXmlNode_Ptr);
   pragma Import (C, Read_Child, "glade_widget_read_child");

   procedure Write_Special_Child_Prop
     (Parent  : Glade_Widget;
      Object  : GObject_Ptr;
      Context : GladeXmlContext_Ptr;
      Node    : GladeXmlNode_Ptr);
   pragma Import (C, Write_Special_Child_Prop, "glade_widget_write_special_child_prop");

   procedure Set_Child_Type_From_Node
     (Parent : Glade_Widget;
      Child  : GObject_Ptr;
      Node   : GladeXmlNode_Ptr);
   pragma Import (C, Set_Child_Type_From_Node, "glade_widget_set_child_type_from_node");

   function Create_Editor_Property
     (Widget      : Glade_Widget;
      Property    : chars_ptr;
      Packing     : Extensions.bool;
      Use_Command : Extensions.bool)
      return Glade_Binding.Editor_Property.Editor_Prop;
   pragma Import (C, Create_Editor_Property, "glade_widget_create_editor_property");

   function Generate_Path_Name (Widget : Glade_Widget) return chars_ptr;
   pragma Import (C, Generate_Path_Name, "glade_widget_generate_path_name");

   function Is_Ancestor (Widget   : Glade_Widget;
                         Ancestor : Glade_Widget) return Extensions.bool;
   pragma Import (C, Is_Ancestor, "glade_widget_is_ancestor");

   function Depends (Widget : Glade_Widget;
                     Other  : Glade_Widget) return Extensions.bool;
   pragma Import (C, Depends, "glade_widget_depends");
   pragma Linker_Options ("-Wl,--warn-unresolved-symbols"); -- Marked as G_DEPRECATED in C

   --  function Get_Device_From_Event (Event : Gdk.Event.Gdk_Event) return GdkDevice_Ptr;
   --  pragma Import (C, Get_Device_From_Event, "glade_widget_get_device_from_event");
   --  pragma Linker_Options ("-Wl,--warn-unresolved-symbols"); -- Marked as G_DEPRECATED in C
   --  Use instead Gdk.Event.Gdk_Event_Get_Device_tool()

   procedure Ensure_Name (Widget : Glade_Widget; Project : GladeProject_Ptr; Use_Command : Extensions.bool);
   pragma Import (C, Ensure_Name, "glade_widget_ensure_name");

   ----------------------------------------------------------------------------
   --  Project and Object Property References
   ----------------------------------------------------------------------------
   procedure Add_Prop_Ref (Widget : Glade_Widget; Prop : Glade_Binding.Properties.Property);
   pragma Import (C, Add_Prop_Ref, "glade_widget_add_prop_ref");

   procedure Remove_Prop_Ref (Widget : Glade_Widget; Prop : Glade_Binding.Properties.Property);
   pragma Import (C, Remove_Prop_Ref, "glade_widget_remove_prop_ref");

   function List_Prop_Refs (Widget : Glade_Widget) return GList_Ptr;
   pragma Import (C, List_Prop_Refs, "glade_widget_list_prop_refs");

   function Has_Prop_Refs (Widget : Glade_Widget) return Extensions.bool;
   pragma Import (C, Has_Prop_Refs, "glade_widget_has_prop_refs");

   function Get_Parentless_Widget_Ref (Widget : Glade_Widget) return Glade_Binding.Properties.Property;
   pragma Import (C, Get_Parentless_Widget_Ref, "glade_widget_get_parentless_widget_ref");

   function Get_Parentless_Reffed_Widgets (Widget : Glade_Widget) return GList_Ptr;
   pragma Import (C, Get_Parentless_Reffed_Widgets, "glade_widget_get_parentless_reffed_widgets");

   ----------------------------------------------------------------------------
   --  Runtime Object Property Operations
   ----------------------------------------------------------------------------
   procedure Object_Set_Property (Widget        : Glade_Widget;
                                  Property_Name : chars_ptr;
                                  Value         : access Glib.Values.GValue);
   pragma Import (C, Object_Set_Property, "glade_widget_object_set_property");

   procedure Object_Get_Property (Widget        : Glade_Widget;
                                  Property_Name : chars_ptr;
                                  Value         : access Glib.Values.GValue);
   pragma Import (C, Object_Get_Property, "glade_widget_object_get_property");

   procedure Child_Set_Property
     (Widget        : Glade_Widget;
      Child         : Glade_Widget;
      Property_Name : chars_ptr;
      Value         : access Glib.Values.GValue);
   pragma Import (C, Child_Set_Property, "glade_widget_child_set_property");

   procedure Child_Get_Property
     (Widget        : Glade_Widget;
      Child         : Glade_Widget;
      Property_Name : chars_ptr;
      Value         : access Glib.Values.GValue);
   pragma Import (C, Child_Get_Property, "glade_widget_child_get_property");

   ----------------------------------------------------------------------------
   --  GladeProperty API Convenience Wrappers
   --  (Explicit overloading to bypass unsafe C variadic parameters)
   ----------------------------------------------------------------------------
   function Property_Get_Int
     (Widget      : Glade_Widget;
      Id_Property : chars_ptr;
      Val         : access int) return Extensions.bool;
   pragma Import (C, Property_Get_Int, "glade_widget_property_get");

   function Property_Get_Str
     (Widget      : Glade_Widget;
      Id_Property : chars_ptr;
      Val         : access chars_ptr) return Extensions.bool;
   pragma Import (C, Property_Get_Str, "glade_widget_property_get");

   function Property_Set_Int
     (Widget      : Glade_Widget;
      Id_Property : chars_ptr;
      Val         : int) return Extensions.bool;
   pragma Import (C, Property_Set_Int, "glade_widget_property_set");

   function Property_Set_Str
     (Widget      : Glade_Widget;
      Id_Property : chars_ptr;
      Val         : chars_ptr) return Extensions.bool;
   pragma Import (C, Property_Set_Str, "glade_widget_property_set");

   function Pack_Property_Get_Int
     (Widget      : Glade_Widget;
      Id_Property : chars_ptr;
      Val         : access int) return Extensions.bool;
   pragma Import (C, Pack_Property_Get_Int, "glade_widget_pack_property_get");

   function Pack_Property_Set_Int
     (Widget      : Glade_Widget;
      Id_Property : chars_ptr;
      Val         : int) return Extensions.bool;
   pragma Import (C, Pack_Property_Set_Int, "glade_widget_pack_property_set");

   function Property_Reset (Widget      : Glade_Widget;
                            Id_Property : chars_ptr) return Extensions.bool;
   pragma Import (C, Property_Reset, "glade_widget_property_reset");

   function Pack_Property_Reset (Widget      : Glade_Widget;
                                 Id_Property : chars_ptr) return Extensions.bool;
   pragma Import (C, Pack_Property_Reset, "glade_widget_pack_property_reset");

   function Property_Default (Widget      : Glade_Widget;
                              Id_Property : chars_ptr) return Extensions.bool;
   pragma Import (C, Property_Default, "glade_widget_property_default");

   function Property_Original_Default (Widget      : Glade_Widget;
                                       Id_Property : chars_ptr) return Extensions.bool;
   pragma Import (C, Property_Original_Default, "glade_widget_property_original_default");

   function Pack_Property_Default (Widget      : Glade_Widget;
                                   Id_Property : chars_ptr) return Extensions.bool;
   pragma Import (C, Pack_Property_Default, "glade_widget_pack_property_default");

   function Property_Set_Sensitive
     (Widget      : Glade_Widget;
      Id_Property : chars_ptr;
      Sensitive   : Extensions.bool;
      Reason      : chars_ptr) return Extensions.bool;
   pragma Import (C, Property_Set_Sensitive, "glade_widget_property_set_sensitive");

   function Pack_Property_Set_Sensitive
     (Widget      : Glade_Widget;
      Id_Property : chars_ptr;
      Sensitive   : Extensions.bool;
      Reason      : chars_ptr) return Extensions.bool;
   pragma Import (C, Pack_Property_Set_Sensitive, "glade_widget_pack_property_set_sensitive");

   function Property_Set_Enabled
     (Widget      : Glade_Widget;
      Id_Property : chars_ptr;
      Enabled     : Extensions.bool) return Extensions.bool;
   pragma Import (C, Property_Set_Enabled, "glade_widget_property_set_enabled");

   function Pack_Property_Set_Enabled
     (Widget      : Glade_Widget;
      Id_Property : chars_ptr;
      Enabled     : Extensions.bool) return Extensions.bool;
   pragma Import (C, Pack_Property_Set_Enabled, "glade_widget_pack_property_set_enabled");

   function Property_Set_Save_Always
     (Widget      : Glade_Widget;
      Id_Property : chars_ptr;
      Setting     : Extensions.bool) return Extensions.bool;
   pragma Import (C, Property_Set_Save_Always, "glade_widget_property_set_save_always");

   function Pack_Property_Set_Save_Always
     (Widget      : Glade_Widget;
      Id_Property : chars_ptr;
      Setting     : Extensions.bool) return Extensions.bool;
   pragma Import (C, Pack_Property_Set_Save_Always, "glade_widget_pack_property_set_save_always");

   function Property_String
     (Widget      : Glade_Widget;
      Id_Property : chars_ptr;
      Value       : access Glib.Values.GValue) return chars_ptr;
   pragma Import (C, Property_String, "glade_widget_property_string");

   function Pack_Property_String
     (Widget      : Glade_Widget;
      Id_Property : chars_ptr;
      Value       : access Glib.Values.GValue) return chars_ptr;
   pragma Import (C, Pack_Property_String, "glade_widget_pack_property_string");

   ----------------------------------------------------------------------------
   --  Accessors (Getters and Setters)
   ----------------------------------------------------------------------------
   procedure Set_Name (Widget : Glade_Widget; Name : chars_ptr);
   pragma Import (C, Set_Name, "glade_widget_set_name");

   function Get_Name (Widget : Glade_Widget) return chars_ptr;
   pragma Import (C, Get_Name, "glade_widget_get_name");

   function Get_Display_Name (Widget : Glade_Widget) return chars_ptr;
   pragma Import (C, Get_Display_Name, "glade_widget_get_display_name");

   function Has_Name (Widget : Glade_Widget) return Extensions.bool;
   pragma Import (C, Has_Name, "glade_widget_has_name");

   procedure Set_Is_Composite (Widget : Glade_Widget; Composite : Extensions.bool);
   pragma Import (C, Set_Is_Composite, "glade_widget_set_is_composite");

   function Get_Is_Composite (Widget : Glade_Widget) return Extensions.bool;
   pragma Import (C, Get_Is_Composite, "glade_widget_get_is_composite");

   procedure Set_Internal (Widget : Glade_Widget; Internal : chars_ptr);
   pragma Import (C, Set_Internal, "glade_widget_set_internal");

   function Get_Internal (Widget : Glade_Widget) return chars_ptr;
   pragma Import (C, Get_Internal, "glade_widget_get_internal");

   function Get_Object (Widget : Glade_Widget) return GObject_Ptr;
   pragma Import (C, Get_Object, "glade_widget_get_object");

   procedure Set_Project (Widget : Glade_Widget; Project : GladeProject_Ptr);
   pragma Import (C, Set_Project, "glade_widget_set_project");

   function Get_Project (Widget : Glade_Widget) return GladeProject_Ptr;
   pragma Import (C, Get_Project, "glade_widget_get_project");

   procedure Set_In_Project (Widget : Glade_Widget; In_Project : Extensions.bool);
   pragma Import (C, Set_In_Project, "glade_widget_set_in_project");

   function In_Project (Widget : Glade_Widget) return Extensions.bool;
   pragma Import (C, In_Project, "glade_widget_in_project");

   function Get_Adaptor (Widget : Glade_Widget) return Glade_Binding.Widget_Adaptor.Adaptor;
   pragma Import (C, Get_Adaptor, "glade_widget_get_adaptor");

   function Get_Parent (Widget : Glade_Widget) return Glade_Widget;
   pragma Import (C, Get_Parent, "glade_widget_get_parent");

   procedure Set_Parent (Widget : Glade_Widget; Parent : Glade_Widget);
   pragma Import (C, Set_Parent, "glade_widget_set_parent");

   function Get_Children (Widget : Glade_Widget) return GList_Ptr;
   pragma Import (C, Get_Children, "glade_widget_get_children");

   function Get_Toplevel (Widget : Glade_Widget) return Glade_Widget;
   pragma Import (C, Get_Toplevel, "glade_widget_get_toplevel");

   function Superuser return Extensions.bool;
   pragma Import (C, Superuser, "glade_widget_superuser");

   procedure Push_Superuser;
   pragma Import (C, Push_Superuser, "glade_widget_push_superuser");

   procedure Pop_Superuser;
   pragma Import (C, Pop_Superuser, "glade_widget_pop_superuser");

   procedure Verify (Widget : Glade_Widget);
   pragma Import (C, Verify, "glade_widget_verify");

   procedure Set_Support_Warning (Widget : Glade_Widget; Warning : chars_ptr);
   pragma Import (C, Set_Support_Warning, "glade_widget_set_support_warning");

   function Support_Warning (Widget : Glade_Widget) return chars_ptr;
   pragma Import (C, Support_Warning, "glade_widget_support_warning");

   procedure Lock (Widget : Glade_Widget; Locked : Glade_Widget);
   pragma Import (C, Lock, "glade_widget_lock");

   procedure Unlock (Widget : Glade_Widget);
   pragma Import (C, Unlock, "glade_widget_unlock");

   function Get_Locker (Widget : Glade_Widget) return Glade_Widget;
   pragma Import (C, Get_Locker, "glade_widget_get_locker");

   function List_Locked_Widgets (Widget : Glade_Widget) return GList_Ptr;
   pragma Import (C, List_Locked_Widgets, "glade_widget_list_locked_widgets");

   procedure Support_Changed (Widget : Glade_Widget);
   pragma Import (C, Support_Changed, "glade_widget_support_changed");

   --  function Get_Signal_Model (Widget : Glade_Widget) return GtkTreeModel_Ptr;
   function Get_Signal_Model (Widget : Glade_Widget) return Gtk.Tree_Model.Gtk_Tree_Model;
   pragma Import (C, Get_Signal_Model, "glade_widget_get_signal_model");

   function Find_Child (Widget : Glade_Widget; Name : chars_ptr) return Glade_Widget;
   pragma Import (C, Find_Child, "glade_widget_find_child");

   pragma Warnings (On, "involves a tagged type which does not correspond to any C type");
   pragma Warnings (On, "does not correspond to C type");
end Glade_Binding.Widget;
