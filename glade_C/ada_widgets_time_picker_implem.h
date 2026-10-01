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
#ifndef ADA_TIME_PICKER_IMPLEM_H
#define ADA_TIME_PICKER_IMPLEM_H

#include "ada_widgets_time_picker.h"

/*----------------------------------------------------------------------------*/
/* ADA TIME PICKER                                                            */
/*----------------------------------------------------------------------------*/
typedef struct _AdaTimePicker AdaTimePicker;
typedef struct _AdaTimePickerClass AdaTimePickerClass;

struct _AdaTimePicker
{
  GtkFrame parent_instance;
};

struct _AdaTimePickerClass
{
  GtkFrameClass parent_class;
};

/*----------------------------------------------------------------------------*/
/* GET TYPE                                                                   */
/*----------------------------------------------------------------------------*/
GType ada_widgets_time_picker_implem_get_type (void);

/*----------------------------------------------------------------------------*/
/* GET TYPE                                                                   */
/*----------------------------------------------------------------------------*/
GType
ada_widgets_time_picker_implem_time_zone_get_type (void);

/*----------------------------------------------------------------------------*/
/* BUILD                                                                      */
/*----------------------------------------------------------------------------*/
void
ada_widgets_time_picker_implem_build (GObject *object, gboolean show);

/*----------------------------------------------------------------------------*/
/* SET PROPERTY                                                               */
/*----------------------------------------------------------------------------*/
static void
ada_widgets_time_picker_implem_set_property (GObject *object,
                                             guint prop_id,
                                             const GValue *value,
                                             GParamSpec *pspec);

/*----------------------------------------------------------------------------*/
/* GET PROPERTY                                                               */
/*----------------------------------------------------------------------------*/
static void
ada_widgets_time_picker_implem_get_property (GObject *object,
                                             guint prop_id,
                                             GValue *value,
                                             GParamSpec *pspec);

#endif /* ADA_TIME_PICKER_IMPLEM_H */
