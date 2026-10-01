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
with System;
with Interfaces.C;
with Interfaces.C.Strings;
with Ada.Unchecked_Conversion;
with System.Address_To_Access_Conversions;

with Glib;                     use Glib;
with Glib.Object;              use Glib.Object;
with Glib.Values;              use Glib.Values;
with Glib.GSlist;              use Glib.GSlist;
with Glib.Properties.Creation; use Glib.Properties.Creation;

package Glib_Additions is
   pragma Elaborate_Body;

   -------------------------------------------
   --  FILLING OPAQUE RECORDS
   -------------------------------------------
   type Byte_Storage is
     array (Natural range <>) of Interfaces.Unsigned_8;
   pragma Convention (C, Byte_Storage);

   -----------------------------------------
   --  GTPE CLASS
   -----------------------------------------
   type GType_Class_Block is record
      G_Type : Glib.GType;
   end record;
   for GType_Class_Block use record
      G_Type at 0 range 0 .. 63;
   end record;
   pragma Convention (C, GType_Class_Block);
   for GType_Class_Block'Alignment use 8;
   for GType_Class_Block'Size use 8 * 8;
   pragma Assert (GType_Class_Block'Size = 8 * 8);

   type GType_Class_Ptr is access all GType_Class_Block;
   pragma Convention (C, GType_Class_Ptr);
   pragma No_Strict_Aliasing (GType_Class_Ptr);

   function "+" is new Ada.Unchecked_Conversion
     (Source => System.Address,
      Target => GType_Class_Ptr);

   -----------------------------------------
   --  GTYPE INSTANCE
   -----------------------------------------
   type GType_Instance_Block is record
      G_Class : GType_Class_Ptr;
   end record;
   for GType_Instance_Block use record
      G_Class at 0 range 0 .. 63;
   end record;
   pragma Convention (C, GType_Instance_Block);
   for GType_Instance_Block'Alignment use 8;
   for GType_Instance_Block'Size use 8 * 8;
   pragma Assert (GType_Instance_Block'Size = 8 * 8);

   -------------------------------------------------
   --  GOBJECT
   --  Do not use the glib.gobjet definition
   --  Corresponds to _GObject in gobject.h line 252
   -------------------------------------------------
   type GObject_Block is record
      G_Type_Instance : GType_Instance_Block;
      Ref_Count       : Glib.Guint;
      Qdata           : System.Address;
   end record;
   for GObject_Block use record
      G_Type_Instance at  0 range 0 .. 63;
      Ref_Count       at  8 range 0 .. 63;
      Qdata           at 16 range 0 .. 63;
   end record;
   pragma Convention (C, GObject_Block);
   for GObject_Block'Alignment use 8;
   for GObject_Block'Size use 24 * 8;
   pragma Assert (GObject_Block'Size = 24 * 8);

   type GObject_Ptr is access all GObject_Block;
   pragma Convention (C, GObject_Ptr);
   pragma No_Strict_Aliasing (GObject_Ptr);

   function "-" is new Ada.Unchecked_Conversion
     (Source => GObject_Ptr,
      Target => System.Address);

   -------------------------------------------------------
   --  PROPERTY LIST
   -------------------------------------------------------
   package Property_Conversions is new System.Address_To_Access_Conversions
     (Object => Property);

   subtype Property_Ptr is Property_Conversions.Object_Pointer;

   function "+" (Addr : System.Address) return Property_Ptr
              renames Property_Conversions.To_Pointer;

   function "-" (Ptr : Property_Ptr) return System.Address
              renames Property_Conversions.To_Address;

   package Property_SList is new Generic_SList (Property_Ptr, "-", "+");

   -------------------------------------------------------
   --  G OBJECT CLASS BLOCK
   --  Corresponds to _GObjectClass in gobject.h line 322
   -------------------------------------------------------
   type Set_Property_Func is access procedure
     (Object        : GObject_Ptr;
      Prop_Id       : Property_Id;
      Value         : GValue;
      Property_Spec : Param_Spec);
   type Get_Property_Func is access procedure
     (Object        : GObject_Ptr;
      Prop_Id       : Property_Id;
      Value         : out GValue;
      Property_Spec : Param_Spec);

   type GObject_Class_Block is record
      Type_Class      : GType_Class_Block;
      Construct_Prop  : Property_SList.GSlist;  --  list of properties
      ConstructorFunc : System.Address;         --  not interested
      Set_Property    : Set_Property_Func;
      Get_Property    : Get_Property_Func;
      Filler          : Byte_Storage (0 .. 95); --  not interested
   end record;
   for GObject_Class_Block use record
      Type_Class      at  0 range 0 ..  63;
      Construct_Prop  at  8 range 0 ..  63;
      ConstructorFunc at 16 range 0 ..  63;
      Set_Property    at 24 range 0 ..  63;
      Get_Property    at 32 range 0 ..  63;
      Filler          at 40 range 0 .. 767;
   end record;
   pragma Convention (C, GObject_Class_Block);
   for GObject_Class_Block'Alignment use 8;
   for GObject_Class_Block'Size use 136 * 8;
   pragma Assert (GObject_Class_Block'Size = 136 * 8);

   type GObject_Class_Ptr is access all GObject_Class_Block;
   pragma Convention (C, GObject_Class_Ptr);
   pragma No_Strict_Aliasing (GObject_Class_Ptr);

   function Convert is new Ada.Unchecked_Conversion
     (Source => Glib.Object.GObject_Class,
      Target => GObject_Class_Ptr);

   -----------------------------------------------------------------------------
   --  G TYPE QUERY
   -----------------------------------------------------------------------------
   type GType_Query is record
      Type_Id       : Glib.GType;
      Type_Name     : Interfaces.C.Strings.chars_ptr;
      Class_Size    : Interfaces.C.unsigned;
      Instance_Size : Interfaces.C.unsigned;
   end record;
   for GType_Query use record
      Type_Id       at  0 range 0 .. 63;
      Type_Name     at  8 range 0 .. 63;
      Class_Size    at 16 range 0 .. 31;
      Instance_Size at 20 range 0 .. 31;
   end record;
   pragma Convention (C, GType_Query);
   for GType_Query'Alignment use 8;
   for GType_Query'Size use 24 * 8;
   pragma Assert (GType_Query'Size = 24 * 8);

   procedure G_Type_Query (Type_Id : Glib.GType;
                           Query   : access GType_Query);
   pragma Import (C, G_Type_Query, "g_type_query");

   -----------------------------------------------------------------------------
   --  G TYPE INFO
   -----------------------------------------------------------------------------
   type GBase_Init_Func is access procedure (G_Class : GObject_Class);
   pragma Convention (C, GBase_Init_Func);

   type GBase_Finalize_Func is access procedure (G_Class : GObject_Class);
   pragma Convention (C, GBase_Finalize_Func);

   type GClass_Finalize_Func is access procedure (G_Class : GObject_Class);
   pragma Convention (C, GClass_Finalize_Func);

   type GClass_Init_Func is access procedure (G_Class : GObject_Class);
   pragma Convention (C, GClass_Init_Func);

   type GInstanceInitFunc is access procedure (Object  : GObject_Ptr;
                                               G_Class : GObject_Class);
   pragma Convention (C, GInstanceInitFunc);

   type GType_Info is record
      Class_Size      : Interfaces.C.unsigned_short;
      --  there is a gap of 6 bytes
      Base_Init       : GBase_Init_Func;
      Base_Finalize   : GBase_Finalize_Func;
      Class_Init      : GClass_Init_Func;
      Class_Finalize  : GClass_Finalize_Func;
      Class_Data      : System.Address;
      Instance_Size   : Interfaces.C.unsigned_short;
      N_Preallocs     : Interfaces.C.unsigned_short;
      Instance_Init   : GInstanceInitFunc;
      Value_Table     : System.Address;
   end record;
   for GType_Info use record
      Class_Size      at  0 range 0 .. 15;
      Base_Init       at  8 range 0 .. 63;
      Base_Finalize   at 16 range 0 .. 63;
      Class_Init      at 24 range 0 .. 63;
      Class_Finalize  at 32 range 0 .. 63;
      Class_Data      at 40 range 0 .. 63;
      Instance_Size   at 48 range 0 .. 15;
      N_Preallocs     at 50 range 0 .. 15;
      Instance_Init   at 56 range 0 .. 63;
      Value_Table     at 64 range 0 .. 63;
   end record;
   pragma Convention (C, GType_Info);
   for GType_Info'Alignment use 8;
   for GType_Info'Size use 72 * 8;
   pragma Assert (GType_Info'Size = 72 * 8);

   type GType_Flags is mod 2 ** 32;
   pragma Assert (GType_Flags'Size = 32);

   function G_Type_Register_Static
     (Parent_Type : Glib.GType;
      Type_Name   : Interfaces.C.Strings.chars_ptr;
      Info        : access GType_Info;
      Flags       : GType_Flags) return Glib.GType;
   pragma Import
     (C, G_Type_Register_Static, "g_type_register_static");

end Glib_Additions;
