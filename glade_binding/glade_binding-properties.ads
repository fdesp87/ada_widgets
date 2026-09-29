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
with Interfaces.C;            use Interfaces.C;
with Interfaces.C.Extensions; use Interfaces.C.Extensions;
with Glib.Values;
with Glib;
with Glade_Binding.Widget;
with Glade_Binding.Property_Definition; use Glade_Binding.Property_Definition;

package Glade_Binding.Properties is

   ------------------------------------------------------------------
   --  Opaque type
   ------------------------------------------------------------------
   type Property_Record is record
      Filler : Byte_Storage (0 .. 31);
   end record;
   for Property_Record'Size use 32 * 8;
   pragma Convention (C, Property_Record);
   pragma Assert (Property_Record'Size = 32 * 8);

   type Property is access all Property_Record;
   pragma Convention (C, Property);
   pragma No_Strict_Aliasing (Property);

   ------------------------------------------------------------------
   --  Basic API needed by the DatePicker editor
   ------------------------------------------------------------------
   function Get_Type return Glib.GType;
   pragma Import (C, Get_Type, "glade_property_get_type");

   function Get_Def (Prop : Property) return Property_Def;
   pragma Import (C, Get_Def, "glade_property_get_def");

   procedure Get_Value
     (Prop  : Property;
      Value : access Glib.Values.GValue);
   pragma Import (C, Get_Value, "glade_property_get_value");

   function Set_Value
     (Prop  : Property;
      Value : access constant Glib.Values.GValue) return Extensions.bool;
   pragma Import (C, Set_Value, "glade_property_set_value");

   procedure Reset (Prop : Property);
   pragma Import (C, Reset, "glade_property_reset");

   function Default (Prop : Property) return Extensions.bool;
   pragma Import (C, Default, "glade_property_default");

   function Get_Widget (Prop : Property) return Glade_Binding.Widget.Glade_Widget;
   pragma Import (C, Get_Widget, "glade_property_get_widget");

   function Get_Sensitive (Prop : Property) return Extensions.bool;
   pragma Import (C, Get_Sensitive, "glade_property_get_sensitive");

   function Get_Enabled (Prop : Property) return Extensions.bool;
   pragma Import (C, Get_Enabled, "glade_property_get_enabled");

   --  Add more functions later if needed

end Glade_Binding.Properties;
