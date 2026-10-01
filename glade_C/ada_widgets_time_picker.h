/*-----------------------------------------------------------------------------
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
-----------------------------------------------------------------------------*/
#ifndef ADA_TIME_PICKER_H
#define ADA_TIME_PICKER_H

#include "ada_widgets.h"

enum
{
  PROP_TIME_ZONE = 1
};

const char *
ada_widgets_time_picker_time_zone_prop_to_string (gint id);

typedef enum
{
  /* Universal */
  ADA_TIME_ZONE_UTC = 0, /* Universal Time Coordinated */
  ADA_TIME_ZONE_GMT,     /* Greenwich Mean Time */

  /* Europe */
  ADA_TIME_ZONE_WET,  /* Western European Time */
  ADA_TIME_ZONE_WEST, /* Western European Summer Time */
  ADA_TIME_ZONE_CET,  /* Central European Time */
  ADA_TIME_ZONE_CEST, /* Central European Summer Time */
  ADA_TIME_ZONE_EET,  /* Eastern European Time */
  ADA_TIME_ZONE_EEST, /* Eastern European Summer Time */
  ADA_TIME_ZONE_MSK,  /* Moscow Time */
  ADA_TIME_ZONE_BST,  /* British Summer Time */
  ADA_TIME_ZONE_IST,  /* Irish Standard Time */

  /* Americas */
  ADA_TIME_ZONE_EST,  /* Eastern Standard Time */
  ADA_TIME_ZONE_EDT,  /* Eastern Daylight Time */
  ADA_TIME_ZONE_CST,  /* Central Standard Time */
  ADA_TIME_ZONE_CDT,  /* Central Daylight Time */
  ADA_TIME_ZONE_MST,  /* Mountain Standard Time */
  ADA_TIME_ZONE_MDT,  /* Mountain Daylight Time */
  ADA_TIME_ZONE_PST,  /* Pacific Standard Time */
  ADA_TIME_ZONE_PDT,  /* Pacific Daylight Time */
  ADA_TIME_ZONE_AST,  /* Atlantic Standard Time */
  ADA_TIME_ZONE_ADT,  /* Atlantic Daylight Time */
  ADA_TIME_ZONE_NST,  /* Newfoundland Standard Time */
  ADA_TIME_ZONE_NDT,  /* Newfoundland Daylight Time */
  ADA_TIME_ZONE_AKST, /* Alaska Standard Time */
  ADA_TIME_ZONE_AKDT, /* Alaska Daylight Time */
  ADA_TIME_ZONE_HST,  /* Hawaii Standard Time */

  /* Asia / Pacific */
  ADA_TIME_ZONE_JST,  /* Japan Standard Time */
  ADA_TIME_ZONE_KST,  /* Korea Standard Time */
  ADA_TIME_ZONE_CSTP, /* China Standard Time */
  ADA_TIME_ZONE_ISTP, /* Indian Standard Time */
  ADA_TIME_ZONE_SGT,  /* Siconst char *
ada_time_zone_to_string (gint tz);
ngapore Time */
  ADA_TIME_ZONE_HKT,  /* Hong Kong Time */
  ADA_TIME_ZONE_AEST,    /* Australian Eastern Standard Time */
  ADA_TIME_ZONE_AEDT,    /* Australian Eastern Daylight Time */
  ADA_TIME_ZONE_ACST,    /* Australian Central Standard Time */
  ADA_TIME_ZONE_ACDT,    /* Australian Central Daylight Time */
  ADA_TIME_ZONE_AWST,    /* Australian Western Standard Time */
  ADA_TIME_ZONE_NZST,    /* New Zealand Standard Time */
  ADA_TIME_ZONE_NZDT,    /* New Zealand Daylight Time */

  /* Others */
  ADA_TIME_ZONE_SAST,    /* South Africa Standard Time */
  ADA_TIME_ZONE_CAT,     /* Central Africa Time */
  ADA_TIME_ZONE_EAT,     /* East Africa Time */
  ADA_TIME_ZONE_WAT      /* West Africa Time */
} AdaTimeZone;

const char *
ada_widgets_time_picker_time_zone_to_string (gint tz);

#endif /* ADA_TIME_PICKER_H */
