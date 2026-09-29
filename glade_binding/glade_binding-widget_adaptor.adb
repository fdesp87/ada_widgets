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
with Glib.Object;
with System.Address_To_Access_Conversions;
with Ada.Unchecked_Conversion;
with Glib.Types;

package body Glade_Binding.Widget_Adaptor is
   use System;

   -----------------------------------------------------------------------------
   type G_Type_Instance_Record is record
      G_Class : System.Address;
   end record;
   pragma Convention (C, G_Type_Instance_Record);

   package Instance_Conversions is new System.Address_To_Access_Conversions
     (Object => G_Type_Instance_Record);

   package Class_Conversions is new System.Address_To_Access_Conversions
     (Object => Adaptor_Class_Record);

   -----------------------------------------------------------------------------
   function Get_Adaptor_Class (Adtor : Adaptor) return Adaptor_Class is

      Instance_Ptr : constant Instance_Conversions.Object_Pointer :=
                       Instance_Conversions.To_Pointer (Adtor.all'Address);
   begin
      if Adtor = null then
         return null;
      end if;

      if Instance_Ptr.G_Class = System.Null_Address then
         return null;
      end if;

      return Adaptor_Class (Class_Conversions.To_Pointer (Instance_Ptr.G_Class));
   end Get_Adaptor_Class;

   -----------------------------------------------------------------------------
   function Get_Base_Adaptor_Class return Adaptor_Class is
      function To_Address is new Ada.Unchecked_Conversion
        (Source => Glib.Object.GObject_Class,
         Target => System.Address);

      T : constant Glib.GType := Glade_Binding.Widget_Adaptor.Get_Type;
      K : constant Glib.Object.GObject_Class := Glib.Types.Class_Peek (T);
      C : constant Adaptor_Class := Adaptor_Class
        (Class_Conversions.To_Pointer (To_Address (K)));
   begin
      return C;
   end Get_Base_Adaptor_Class;

end Glade_Binding.Widget_Adaptor;
