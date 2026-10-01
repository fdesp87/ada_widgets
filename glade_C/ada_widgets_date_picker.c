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

#include "ada_widgets_date_picker.h"

//---------------------------------
//  date picker property to string
//---------------------------------
const char *
ada_widgets_date_picker_prop_to_string (gint id)
{
  switch (id)
    {
    case PROP_MIN_DATE:
      return "PROP_MIN_DATE";
    case PROP_MAX_DATE:
      return "PROP_MAX_DATE";
    default:
      return "PROP_???";
    }
}
