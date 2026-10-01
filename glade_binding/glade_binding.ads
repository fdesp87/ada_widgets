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
with Glib_Additions;

package Glade_Binding is
   --  Some missing types

   -------------------------------------------
   --  Base types from GLib / GObject / GDK
   -------------------------------------------
   subtype GList_Ptr is System.Address;     --  as in glib.ads, glist is generic
   subtype GPtrArray_Ptr is System.Address; --  array of signals

   -------------------------------------------------------
   --  Specific types for internal GladeUI dependencies
   --  Binding pending
   -------------------------------------------------------
   subtype GladeCatalog_Ptr is System.Address;
   subtype GladeEditable_Ptr is System.Address;
   subtype GladeProject_Ptr is System.Address;
   subtype GladeSignal_Ptr is System.Address;
   subtype GladeSignalDef_Ptr is System.Address;
   subtype GladeWidgetAction_Ptr is System.Address;
   subtype GladeXmlContext_Ptr is System.Address;
   subtype GladeXmlNode_Ptr is System.Address;

   subtype Byte_Storage is Glib_Additions.Byte_Storage;

end Glade_Binding;
