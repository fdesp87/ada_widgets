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
with System;
with Interfaces;
with Glib;
with Ada.Unchecked_Conversion;

package Glade_Binding is
   --  Some missing types

   -----------------------------------------
   --  GType_Class
   -----------------------------------------
   type GType_Class_C_Block is record
      G_Type : Glib.GType;
   end record;
   pragma Convention (C, GType_Class_C_Block);
   for GType_Class_C_Block'Alignment use 8;
   for GType_Class_C_Block'Size use 8 * 8;
   pragma Assert (GType_Class_C_Block'Size = 8 * 8);

   type GType_Class_C is access all GType_Class_C_Block;
   pragma Convention (C, GType_Class_C);

   -----------------------------------------
   --  GType_Instance
   -----------------------------------------
   type GType_Instance_C_Block is record
      G_Class : GType_Class_C;
   end record;
   pragma Convention (C, GType_Instance_C_Block);
   for GType_Instance_C_Block'Alignment use 8;
   for GType_Instance_C_Block'Size use 8 * 8;
   pragma Assert (GType_Instance_C_Block'Size = 8 * 8);

   -------------------------------------------
   --  GObject
   --  Do not use the glib,gobjet definition
   -------------------------------------------
   type GObject_C_Block is record
      G_Type_Instance : GType_Instance_C_Block;
      Ref_Count       : Glib.Guint;
      Qdata           : System.Address;
   end record;
   pragma Convention (C, GObject_C_Block);
   for GObject_C_Block'Alignment use 8;
   for GObject_C_Block'Size use 24 * 8;
   pragma Assert (GObject_C_Block'Size = 24 * 8);

   type GObject_Ptr is access all GObject_C_Block;
   pragma Convention (C, GObject_Ptr);
   pragma No_Strict_Aliasing (GObject_Ptr);

   function "-" is new Ada.Unchecked_Conversion
     (Source => GObject_Ptr,
      Target => System.Address);

   --  Base types from GLib / GObject / GDK
   subtype GList_Ptr is System.Address;     --  as in glib.ads, glist is generic
   subtype GPtrArray_Ptr is System.Address; --  array of signals

   --  Specific types for internal GladeUI dependencies (pending)
   subtype GladeCatalog_Ptr is System.Address;
   subtype GladeEditable_Ptr is System.Address;
   subtype GladeProject_Ptr is System.Address;
   subtype GladeSignal_Ptr is System.Address;
   subtype GladeSignalDef_Ptr is System.Address;
   subtype GladeWidgetAction_Ptr is System.Address;
   subtype GladeXmlContext_Ptr is System.Address;
   subtype GladeXmlNode_Ptr is System.Address;

   --  To fill opaque records
   type Byte_Storage is
     array (Natural range <>) of Interfaces.Unsigned_8;
   pragma Convention (C, Byte_Storage);

end Glade_Binding;
