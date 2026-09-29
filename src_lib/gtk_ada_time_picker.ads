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
with Glib;
with Gtk.Frame;         use Gtk.Frame;
with Gtk.Button;        use Gtk.Button;
with Gtk.GEntry;        use Gtk.GEntry;

--  Hierarchy:
--    Frame
--      Hbox
--        Hour Entry
--        Hour Button
--        Minute Entry
--        Minute Button
--        Second Entry
--        Second Button

package Gtk_Ada_Time_Picker is

   type Ada_Time_Picker_Record is new Gtk_Frame_Record with private;
   type Ada_Time_Picker is access all Ada_Time_Picker_Record'Class;

   procedure Gtk_New (Widget : out Ada_Time_Picker);
   procedure Initialize (Widget : not null access Ada_Time_Picker_Record);

   function Get_Time (Widget     : not null access Ada_Time_Picker_Record;
                      Include_Tz : Boolean := False) return String;

   function Set_Time (Widget    : not null access Ada_Time_Picker_Record;
                      Some_Time : String) return Boolean;

   type Time_Zone is
     (--  Universal
      UTC,   -- Universal Time Coordinated
      GMT,   -- Greenwich Mean Time
      --  Europe
      WET,   -- Western European Time
      WEST,  -- Western European Summer Time
      CET,   -- Central European Time
      CEST,  -- Central European Summer Time
      EET,   -- Eastern European Time
      EEST,  -- Eastern European Summer Time
      MSK,   -- Moscow Time
      BST,   -- British Summer Time
      IST,   -- Irish Standard Time
      --  Americas
      EST,   -- Eastern Standard Time
      EDT,   -- Eastern Daylight Time
      CST,   -- Central Standard Time
      CDT,   -- Central Daylight Time
      MST,   -- Mountain Standard Time
      MDT,   -- Mountain Daylight Time
      PST,   -- Pacific Standard Time
      PDT,   -- Pacific Daylight Time
      AST,   -- Atlantic Standard Time
      ADT,   -- Atlantic Daylight Time
      NST,   -- Newfoundland Standard Time
      NDT,   -- Newfoundland Daylight Time
      AKST,  -- Alaska Standard Time
      AKDT,  -- Alaska Daylight Time
      HST,   -- Hawaii Standard Time
      --  Asia / Pacific
      JST,   -- Japan Standard Time
      KST,   -- Korea Standard Time
      CSTP,  -- China Standard Time
      ISTP,  -- Indian Standard Time
      SGT,   -- Singapore Time
      HKT,   -- Hong Kong Time
      AEST,  -- Australian Eastern Standard Time
      AEDT,  -- Australian Eastern Daylight Time
      ACST,  -- Australian Central Standard Time
      ACDT,  -- Australian Central Daylight Time
      AWST,  -- Australian Western Standard Time
      NZST,  -- New Zealand Standard Time
      NZDT,  -- New Zealand Daylight Time
      --  Others
      SAST,  -- South Africa Standard Time
      CAT,   -- Central Africa Time
      EAT,   -- East Africa Time
      WAT);  -- West Africa Time
   pragma Convention (C, Time_Zone);
   for Time_Zone'Size use Glib.Gint'Size;

   procedure Set_Time_Zone (Widget  : not null access Ada_Time_Picker_Record;
                            Some_TZ : Time_Zone);

   --  When using GtkBuilder, place this call after Gtk.Main.Init so that
   --  GtkBuilder knows about this thype. Also call Initialize for each
   --  new Ada_Date_Picker object that GtkBuilder provide to the applicacion
   procedure Init;

private
   type Ada_Time_Picker_Record is new Gtk_Frame_Record with record
      Hour_Entry   : Gtk_Entry;
      Hour_Button  : Gtk_Button;
      Min_Entry    : Gtk_Entry;
      Min_Button   : Gtk_Button;
      Sec_Entry    : Gtk_Entry;
      Sec_Button   : Gtk_Button;
   end record;

end Gtk_Ada_Time_Picker;
