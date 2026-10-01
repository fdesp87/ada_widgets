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
with Glib;                     use Glib;
with Glib.Object;              use Glib.Object;
with Glib.Values;
with Glib.Properties;
with Glib.Properties.Creation; use Glib.Properties.Creation;
with Glib_Additions;           use Glib_Additions;

with Gtk.Frame;         use Gtk.Frame;

--  Hierarchy:
--    Frame
--      Hbox (or container inside frame)
--        Hour Entry
--        Hour Button
--        Minute Entry
--        Minute Button
--        Second Entry
--        Second Button
--        Day Entry

package Ada_Widgets.Time_Picker.Implem is

   type Ada_Time_Picker_Record is new Gtk_Frame_Record with null record;
   type Ada_Time_Picker is access all Ada_Time_Picker_Record'Class;

   -------------------------------------------
   --  GET TYPE                             --
   -------------------------------------------
   function Get_Type return Glib.GType; --  of Ada_Time_Picker
   pragma Export (C, Get_Type, "ada_time_picker_get_type");
   --  Note: It is mandatory to keep the exported symbol as it is

   -------------------------------------------
   --  TIME ZONE GET TYPE                   --
   -------------------------------------------
   --  function Time_Zone_Get_Type return Glib.GType;
   --  pragma Export (C, Time_Zone_Get_Type, "ada_time_zone_get_type");
   --  This function is not called as this enumerated type is created
   --  automatically by the Ada package
   --           package Time_Zone_Properties is new
   --              Glib.Generic_Properties.Generic_Enumeration_Property
   --               ("AdaTimeZone", Time_Zone);

   -------------------------------------------
   --  BUILD                                --
   -------------------------------------------
   procedure Build (Object : not null access Glib.Object.GObject_Record'Class;
                    Show   : Boolean);

   -------------------------------------------
   --  SET PROPERTY                         --
   -------------------------------------------
   procedure Set_Property (Object        : GObject_Ptr;
                           Prop_Id       : Property_Id;
                           Value         : Glib.Values.GValue;
                           Property_Spec : Param_Spec);

   -------------------------------------------
   --  GET PROPERTY                         --
   -------------------------------------------
   procedure Get_Property (Object        : GObject_Ptr;
                           Prop_Id       : Property_Id;
                           Value         : out Glib.Values.GValue;
                           Property_Spec : Param_Spec);

end Ada_Widgets.Time_Picker.Implem;
