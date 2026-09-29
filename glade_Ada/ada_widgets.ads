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
with Ada.Environment_Variables; use Ada.Environment_Variables;

package Ada_Widgets is

   function To_Hex (Input : String) return String;

   Verbose : constant Boolean :=
               (if Value ("ADA_WIDGETS_VERBOSE", "0") = "1" then True else False);

   Blanks  : constant String (1 .. 40) := (others => ' ');

   procedure Ada_Log (Msg : String);

   procedure Show_Error_Dialog (Title   : String;
                                Message : String);

end Ada_Widgets;
