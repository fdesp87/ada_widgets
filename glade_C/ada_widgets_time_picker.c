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
#include "ada_widgets_time_picker.h"

//---------------------------------
//  time zone property to string
//---------------------------------
const char *
ada_widgets_time_picker_time_zone_prop_to_string (gint id)
{
  switch (id)
    {
    case PROP_TIME_ZONE:
      return "PROP_TIME_ZONE";
    default:
      return "PROP_???";
    }
}

//---------------------------------
//  time zone to string
//---------------------------------
const char *
ada_widgets_time_picker_time_zone_to_string (gint tz)
{
  switch (tz)
    {
    /* Universal */
    case ADA_TIME_ZONE_UTC:
      return "ADA_TIME_ZONE_UTC";
    case ADA_TIME_ZONE_GMT:
      return "ADA_TIME_ZONE_GMT";

    /* Europe */
    case ADA_TIME_ZONE_WET:
      return "ADA_TIME_ZONE_WET";
    case ADA_TIME_ZONE_WEST:
      return "ADA_TIME_ZONE_WEST";
    case ADA_TIME_ZONE_CET:
      return "ADA_TIME_ZONE_CET";
    case ADA_TIME_ZONE_CEST:
      return "ADA_TIME_ZONE_CEST";
    case ADA_TIME_ZONE_EET:
      return "ADA_TIME_ZONE_EET";
    case ADA_TIME_ZONE_EEST:
      return "ADA_TIME_ZONE_EEST";
    case ADA_TIME_ZONE_MSK:
      return "ADA_TIME_ZONE_MSK";
    case ADA_TIME_ZONE_BST:
      return "ADA_TIME_ZONE_BST";
    case ADA_TIME_ZONE_IST:
      return "ADA_TIME_ZONE_IST";

    /* Americas */
    case ADA_TIME_ZONE_EST:
      return "ADA_TIME_ZONE_EST";
    case ADA_TIME_ZONE_EDT:
      return "ADA_TIME_ZONE_EDT";
    case ADA_TIME_ZONE_CST:
      return "ADA_TIME_ZONE_CST";
    case ADA_TIME_ZONE_CDT:
      return "ADA_TIME_ZONE_CDT";
    case ADA_TIME_ZONE_MST:
      return "ADA_TIME_ZONE_MST";
    case ADA_TIME_ZONE_MDT:
      return "ADA_TIME_ZONE_MDT";
    case ADA_TIME_ZONE_PST:
      return "ADA_TIME_ZONE_PST";
    case ADA_TIME_ZONE_PDT:
      return "ADA_TIME_ZONE_PDT";
    case ADA_TIME_ZONE_AST:
      return "ADA_TIME_ZONE_AST";
    case ADA_TIME_ZONE_ADT:
      return "ADA_TIME_ZONE_ADT";
    case ADA_TIME_ZONE_NST:
      return "ADA_TIME_ZONE_NST";
    case ADA_TIME_ZONE_NDT:
      return "ADA_TIME_ZONE_NDT";
    case ADA_TIME_ZONE_AKST:
      return "ADA_TIME_ZONE_AKST";
    case ADA_TIME_ZONE_AKDT:
      return "ADA_TIME_ZONE_AKDT";
    case ADA_TIME_ZONE_HST:
      return "ADA_TIME_ZONE_HST";

    /* Asia / Pacific */
    case ADA_TIME_ZONE_JST:
      return "ADA_TIME_ZONE_JST";
    case ADA_TIME_ZONE_KST:
      return "ADA_TIME_ZONE_KST";
    case ADA_TIME_ZONE_CSTP:
      return "ADA_TIME_ZONE_CSTP";
    case ADA_TIME_ZONE_ISTP:
      return "ADA_TIME_ZONE_ISTP";
    case ADA_TIME_ZONE_SGT:
      return "ADA_TIME_ZONE_SGT";
    case ADA_TIME_ZONE_HKT:
      return "ADA_TIME_ZONE_HKT";
    case ADA_TIME_ZONE_AEST:
      return "ADA_TIME_ZONE_AEST";
    case ADA_TIME_ZONE_AEDT:
      return "ADA_TIME_ZONE_AEDT";
    case ADA_TIME_ZONE_ACST:
      return "ADA_TIME_ZONE_ACST";
    case ADA_TIME_ZONE_ACDT:
      return "ADA_TIME_ZONE_ACDT";
    case ADA_TIME_ZONE_AWST:
      return "ADA_TIME_ZONE_AWST";
    case ADA_TIME_ZONE_NZST:
      return "ADA_TIME_ZONE_NZST";
    case ADA_TIME_ZONE_NZDT:
      return "ADA_TIME_ZONE_NZDT";

    /* Others */
    case ADA_TIME_ZONE_SAST:
      return "ADA_TIME_ZONE_SAST";
    case ADA_TIME_ZONE_CAT:
      return "ADA_TIME_ZONE_CAT";
    case ADA_TIME_ZONE_EAT:
      return "ADA_TIME_ZONE_EAT";
    case ADA_TIME_ZONE_WAT:
      return "ADA_TIME_ZONE_WAT";

    default:
      return "ADA_TIME_ZONE_???";
    }
}
