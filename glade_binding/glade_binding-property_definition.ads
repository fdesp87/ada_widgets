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
--  Binding based on glade-3.40 (glade-property-def.h)
-------------------------------------------------------------------------------
with Interfaces.C;            use Interfaces.C;
with Interfaces.C.Strings;    use Interfaces.C.Strings;
with Interfaces.C.Extensions; use Interfaces.C.Extensions;
with Glib;                    use Glib;
with Glib.Values;

package Glade_Binding.Property_Definition is

   ------------------------------------------------------------------
   --  Opaque type
   ------------------------------------------------------------------
   type Property_Def_Record is limited null record;
   type Property_Def is access all Property_Def_Record;
   pragma Convention (C, Property_Def);
   pragma No_Strict_Aliasing (Property_Def);

   ------------------------------------------------------------------
   --  Basic API needed by the DatePicker editor
   ------------------------------------------------------------------
   function Get_Type return GType;
   pragma Import (C, Get_Type, "glade_property_def_get_type");

   function Get_Id (Def : Property_Def) return chars_ptr;
   pragma Import (C, Get_Id, "glade_property_def_id");

   function Get_Name (Def : Property_Def) return chars_ptr;
   pragma Import (C, Get_Name, "glade_property_def_get_name");

   function Get_Tooltip (Def : Property_Def) return chars_ptr;
   pragma Import (C, Get_Tooltip, "glade_property_def_get_tooltip");

   function Get_Is_Packing (Def : Property_Def) return Extensions.bool;
   pragma Import (C, Get_Is_Packing, "glade_property_def_get_is_packing");

   function Get_Virtual (Def : Property_Def) return Extensions.bool;
   pragma Import (C, Get_Virtual, "glade_property_def_get_virtual");

   function Get_Construct_Only (Def : Property_Def) return Extensions.bool;
   pragma Import (C, Get_Construct_Only, "glade_property_def_get_construct_only");

   function Get_Default (Def : Property_Def) return access constant Glib.Values.GValue;
   pragma Import (C, Get_Default, "glade_property_def_get_default");

   function Get_Original_Default (Def : Property_Def) return access constant Glib.Values.GValue;
   pragma Import (C, Get_Original_Default, "glade_property_def_get_original_default");

   --  Add more functions later if needed (make_gvalue_from_string, etc.)

end Glade_Binding.Property_Definition;
