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
with Glib.Values;
with Interfaces.C.Extensions;
with Glade_Binding.Editor_Property; use Glade_Binding.Editor_Property;

package Ada_Widgets.Date_Picker.Validation is

   package ICE renames Interfaces.C.Extensions;

   function Is_Valid_Format (Date_Str : String) return Boolean;

   function Ada_Date_Picker_Validate_Dates (Eprop : Editor_Prop;
                                            Value : access Glib.Values.GValue)
                                            return ICE.bool;

end Ada_Widgets.Date_Picker.Validation;
