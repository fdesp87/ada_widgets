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
with Ada.Unchecked_Conversion;
with System;

package body Glade_Binding.Widget is

   ---------------------------------------------------------------------------
   --  Minimal implementation of Get_Widget_Class
   --
   --  Every GObject (and therefore every GladeWidget) begins with a
   --  GTypeInstance whose first field is the pointer to the class structure.
   --  This is the standard low-level technique used in pure Ada GObject
   --  bindings when we do not want to pull in higher-level GtkAda helpers.
   ---------------------------------------------------------------------------

   function Get_Widget_Class (Widget : Glade_Widget) return Glade_Widget_Class is

      type GType_Instance is record
         G_Class : System.Address;
      end record;
      pragma Convention (C, GType_Instance);

      type GType_Instance_Access is access all GType_Instance;
      pragma Convention (C, GType_Instance_Access);

      function To_Instance is
        new Ada.Unchecked_Conversion (Glade_Widget, GType_Instance_Access);

      function To_Class is
        new Ada.Unchecked_Conversion (System.Address, Glade_Widget_Class);

   begin
      if Widget = null then
         return null;
      end if;

      return To_Class (To_Instance (Widget).G_Class);
   end Get_Widget_Class;

end Glade_Binding.Widget;
