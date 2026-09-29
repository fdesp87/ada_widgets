-------------------------------------------------------------------------------
--                          A d a   W i d g e t s                            --
--                                                                           --
--                     Copyright (C) 2026 Juan L. Freniche                   --
--                                                                           --
--  This program is free software;  you can redistribute it and-or modify it --
--  under terms of the  GNU General Public License  : published by the Free  --
--  Software  Foundation;  either version 3,  or (at your  option) any later --
--  version. It is is distributed in the hope that it will be useful,        --
--  but WITHOUT ANY WARRANTY;  without even the implied warranty of MERCHAN- --
--  TABILITY or FITNESS FOR A PARTICULAR PURPOSE.                            --
--                                                                           --
--  You should have received a copy of the GNU General Public License along  --
--  with this program; see the file COPYING3.                                --
--  If not, see <http:--www.gnu.org-licenses->.                              --
-------------------------------------------------------------------------------

with Gtk.Widget;

package body Gtk_Additions is

   -------------------------------
   --  CHECK FIRST              --
   -------------------------------
   Has_Child : Boolean := False;

   procedure Check_First (Widget : not null access Gtk.Widget.Gtk_Widget_Record'Class);
   procedure Check_First (Widget : not null access Gtk.Widget.Gtk_Widget_Record'Class) is
      pragma Unreferenced (Widget);
   begin
      Has_Child := True;
   end Check_First;

   -------------------------------
   --  HAS CHILDREN             --
   -------------------------------
   function Has_Children (C : Gtk_Container) return Boolean is
      Local : Boolean;
   begin
      Forall (C, Check_First'Access);

      Local := Has_Child;
      Has_Child := False;
      return Local;

   end Has_Children;

end Gtk_Additions;
