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
with Gtk.Frame;         use Gtk.Frame;
with Gtk.Calendar;      use Gtk.Calendar;
with Gtk.Button;        use Gtk.Button;
with Gtk.GEntry;        use Gtk.GEntry;
with Gtk.Popover;       use Gtk.Popover;

--  Hierarchy:
--    Frame
--      Hbox
--        Year Entry
--        Month Entry
--        Day Entry
--        Button
--          Image
--    Popover (Floating container attached to the Button)
--      Calendar

package Gtk_Ada_Date_Picker is

   type Ada_Date_Picker_Record is new Gtk_Frame_Record with private;
   type Ada_Date_Picker is access all Ada_Date_Picker_Record'Class;

   procedure Gtk_New (Widget : out Ada_Date_Picker);
   procedure Initialize (Widget : not null access Ada_Date_Picker_Record);

   function Get_Date (Widget : not null access Ada_Date_Picker_Record) return String;
   function Set_Date (Widget    : not null access Ada_Date_Picker_Record;
                      Some_Date : String) return Boolean;

   procedure Set_Min_Date (Widget   : not null access Ada_Date_Picker_Record;
                           Date_Str : String);
   procedure Set_Max_Date (Widget   : not null access Ada_Date_Picker_Record;
                           Date_Str : String);

   --  When using GtkBuilder, place this call after Gtk.Main.Init so that
   --  GtkBuilder knows about this thype. Also call Initialize for each
   --  new Ada_Date_Picker object that GtkBuilder provide to the applicacion
   procedure Init;

private

   type Ada_Date_Picker_Record is new Gtk_Frame_Record with record
      Year_Entry    : Gtk_Entry;
      Month_Entry   : Gtk_Entry;
      Day_Entry     : Gtk_Entry;
      Button        : Gtk_Button;
      Popover       : Gtk_Popover;
      Calendar      : Gtk_Calendar;
      Min_Date      : String (1 .. 10) := "1901-01-01";
      Max_Date      : String (1 .. 10) := "2399-12-31";
   end record;

end Gtk_Ada_Date_Picker;
