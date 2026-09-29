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

package body Glade_Binding.Editor_Property is

   function New_Eprop
     (Typ         : Glib.GType;
      Prop_Name1  : Chars_Ptr;
      Prop_Value1 : System.Address;
      Prop_Name2  : Chars_Ptr;
      Prop_Value2 : ICE.bool) return Editor_Prop is

      function G_Object_New
        (Typ         : Glib.GType;
         Prop_Name1  : Chars_Ptr;
         Prop_Value1 : System.Address;
         Prop_Name2  : Chars_Ptr;
         Prop_Value2 : ICE.bool;
         Null_Name   : System.Address) return Editor_Prop;
      pragma Import (C, G_Object_New, "g_object_new");

   begin
      return G_Object_New (Typ,
                           Prop_Name1,
                           Prop_Value1,
                           Prop_Name2,
                           Prop_Value2,
                           System.Null_Address);
   end New_Eprop;

   ----------------------------------------------------------------------------
   package body Editor_Property_Extension is

      function New_Extra_Eprop
        (Typ         : Glib.GType;
         Prop_Name1  : Chars_Ptr;
         Prop_Value1 : System.Address;
         Prop_Name2  : Chars_Ptr;
         Prop_Value2 : ICE.bool) return Extra_Eprop
      is
         function G_Object_New
           (Typ         : Glib.GType;
            Prop_Name1  : Chars_Ptr;
            Prop_Value1 : System.Address;
            Prop_Name2  : Chars_Ptr;
            Prop_Value2 : ICE.bool;
            Null_Name   : System.Address) return Extra_Eprop;
            --  Null_Name   : System.Address) return System.Address;
         pragma Import (C, G_Object_New, "g_object_new");

         --  function Address_To_Extra_Eprop is new Ada.Unchecked_Conversion
         --    (System.Address, Extra_Eprop);
      begin
         --  return Address_To_Extra_Eprop
         --  (G_Object_New
         return G_Object_New (Typ,
                              Prop_Name1,
                              Prop_Value1,
                              Prop_Name2,
                              Prop_Value2,
                              System.Null_Address);
                              --  System.Null_Address));
      end New_Extra_Eprop;

   end Editor_Property_Extension;

end Glade_Binding.Editor_Property;
