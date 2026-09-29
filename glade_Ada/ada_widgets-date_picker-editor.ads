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
with Interfaces.C.Extensions;
with Glade_Binding.Widget_Adaptor;       use Glade_Binding.Widget_Adaptor;
with Glade_Binding.Property_Definition;  use Glade_Binding.Property_Definition;
with Glade_Binding.Editor_Property;      use Glade_Binding.Editor_Property;

package Ada_Widgets.Date_Picker.Editor is

   package ICE renames Interfaces.C.Extensions;

   ------------------------------------------------------------------
   --  Catalog entry point
   --  This is the function that must be registered in the Glade
   --  XML catalog (normally via a <glade-widget-adaptor> or
   --  <glade-widget-class> entry that points to it).
   ------------------------------------------------------------------
   function Glade_Ada_Date_Picker_Create_Eprop
     (Adtor       : Adaptor;
      Def         : Property_Def;
      Use_Command : ICE.bool) return Editor_Prop;
   pragma Export (C, Glade_Ada_Date_Picker_Create_Eprop,
                  "ada_widgets_date_picker_editor_create_eprop");

end Ada_Widgets.Date_Picker.Editor;
