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
#ifndef ADA_TIME_PICKER_GLADE_H
#define ADA_TIME_PICKER_GLADE_H

#include "ada_widgets_time_picker.h"

/*----------------------------------------------------------------------------*/
/* GET TYPE                                                                   */
/*----------------------------------------------------------------------------*/
G_MODULE_EXPORT GType
ada_widgets_time_picker_glade_get_type (void)
  __asm__ ("ada_time_picker_get_type");
// Note: It is mandatory to keep the exported symbol as it is written

/*----------------------------------------------------------------------------*/
/* POST CREATE                                                                */
/*----------------------------------------------------------------------------*/
G_MODULE_EXPORT void
ada_widgets_time_picker_glade_post_create (GladeWidgetAdaptor *adaptor,
                                           GObject            *object,
                                           GladeCreateReason   reason);

/*----------------------------------------------------------------------------*/
/* SET PROPERTY                                                               */
/*----------------------------------------------------------------------------*/
G_MODULE_EXPORT void
ada_widgets_time_picker_glade_set_property (GladeWidgetAdaptor *adaptor,
                                            GObject            *object,
                                            const gchar        *id,
                                            const GValue       *value);

/*----------------------------------------------------------------------------*/
/* GET PROPERTY                                                               */
/*----------------------------------------------------------------------------*/
G_MODULE_EXPORT void
ada_widgets_time_picker_glade_get_property (GladeWidgetAdaptor *adaptor,
                                            GObject *object,
                                            const gchar *id,
                                            GValue *value);

#endif /* ADA_TIME_PICKER_GLADE_H */
