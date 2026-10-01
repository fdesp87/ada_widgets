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
with Glib;                         use Glib;
with Glib.Values;                  use Glib.Values;
with Glib_Additions;               use Glib_Additions;

with Interfaces.C.Strings;         use Interfaces.C.Strings;

with Glade_Binding;                use Glade_Binding;
with Glade_Binding.Widget_Adaptor; use Glade_Binding.Widget_Adaptor;

package Ada_Widgets.Time_Picker.Glade is
   pragma Warnings (Off, "involves a tagged type which does not correspond to any C type");

   -------------------------------------------
   --  SET_PROPERTY                         --
   -------------------------------------------
   procedure Set_Property (Adtor        : Adaptor;
                           Object       : GObject_Ptr;
                           Id           : chars_ptr;
                           Value_Access : access GValue);
   pragma Export (C, Set_Property, "ada_widgets_time_picker_glade_set_property");

   -------------------------------------------
   --  GET_PROPERTY                         --
   -------------------------------------------
   procedure Get_Property (Adtor        : Adaptor;
                           Object       : GObject_Ptr;
                           Id           : chars_ptr;
                           Value_Access : access GValue);
   pragma Export (C, Get_Property, "ada_widgets_time_picker_glade_get_property");

   -------------------------------------------
   --  POST CREATE                          --
   -------------------------------------------
   procedure Post_Create (Adtor   : Adaptor;
                          Object  : GObject_Ptr;
                          Reason  : Glade_Create_Reason);
   pragma Export (C, Post_Create, "ada_widgets_time_picker_glade_post_create");

   pragma Warnings (On, "involves a tagged type which does not correspond to any C type");
end Ada_Widgets.Time_Picker.Glade;
