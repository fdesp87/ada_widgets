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
with Glade_Binding.Widget;
with Interfaces.C.Strings;

with Ada_Widgets.Date_Picker.Implem;

package body Ada_Widgets.Date_Picker.Glade is

   package ICS renames Interfaces.C.Strings;

   -------------------------------------------
   --  GET TYPE                             --
   -------------------------------------------
   function Get_Type return Glib.GType is
   begin
      Ada_Log ("ada_widgets.date_picker.glade.get_type");
      return Ada_Widgets.Date_Picker.Implem.Get_Type;
   end Get_Type;

   -------------------------------------------
   --       POST CREATE                     --
   -------------------------------------------
   procedure Post_Create (Adtor   : Adaptor;
                          Object  : GObject_Ptr;
                          Reason  : Glade_Create_Reason) is
   begin
      Ada_Log ("ada_widgets.date_picker.glade.post_create: " & ASCII.LF
               & Blanks & "adaptor=" & ICS.Value (Get_Name (Adtor))
               & " (" & To_Hex (Adtor'Image) & ")" & ASCII.LF
               & Blanks & "object=" & Type_Name (Get_Type (Object))
               & " (" & To_Hex (Object'Image) & ")" & ASCII.LF
               & Blanks & "reason=" & Reason'Image);

      if Reason = Glade_Create_Load or Reason = Glade_Create_User or Reason = Glade_Create_Copy
      then
         Glade_Binding.Widget.Push_Superuser;
         Ada_Widgets.Date_Picker.Implem.Build (Object => Object,
                                               Show   => False);
         Glade_Binding.Widget.Pop_Superuser;
      end if;

   end Post_Create;

end Ada_Widgets.Date_Picker.Glade;
