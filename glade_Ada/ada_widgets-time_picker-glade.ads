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
with Glib.Additions;               use Glib.Additions;


with Glade_Binding;                use Glade_Binding;
with Glade_Binding.Widget_Adaptor; use Glade_Binding.Widget_Adaptor;

package Ada_Widgets.Time_Picker.Glade is

   -------------------------------------------
   --  GET TYPE                             --
   -------------------------------------------
   function Get_Type return Glib.GType;
   pragma Export (C, Get_Type, "ada_time_picker_get_type");
   --  Note: It is mandatory to keep the exported symbol as it is

   -------------------------------------------
   --  POST CREATE                          --
   -------------------------------------------
   procedure Post_Create (Adtor   : Adaptor;
                          Object  : GObject_Ptr;
                          Reason  : Glade_Create_Reason);
   pragma Export (C, Post_Create, "ada_widgets_time_picker_glade_post_create");


end Ada_Widgets.Time_Picker.Glade;
