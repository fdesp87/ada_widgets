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
package Ada_Widgets.Time_Picker is
   pragma Elaborate_Body;

   PROP_TIME_ZONE : constant := 1;

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
   for Time_Zone'Size use Glib.Gint'Size;
   pragma Convention (C, Time_Zone);

end Ada_Widgets.Time_Picker;
