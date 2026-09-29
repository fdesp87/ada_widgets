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
#ifndef ADA_WIDGETS_DATE_PICKER_IMPLEM_H
#define ADA_WIDGETS_DATE_PICKER_IMPLEM_H

#include "ada_widgets_date_picker.h"

/*----------------------------------------------------------------------------*/
/* ADA DATE PICKER                                                            */
/*----------------------------------------------------------------------------*/
typedef struct _AdaDatePicker AdaDatePicker;
typedef struct _AdaDatePickerClass AdaDatePickerClass;

struct _AdaDatePicker
{
  GtkFrame parent_instance;
};

struct _AdaDatePickerClass
{
  GtkFrameClass parent_class;
};

/*----------------------------------------------------------------------------*/
/* GET TYPE                                                                   */
/*----------------------------------------------------------------------------*/
G_MODULE_EXPORT GType
ada_widgets_date_picker_implem_get_type (void)
  __asm__ ("ada_date_picker_get_type");
// Note: It is mandatory to keep the exported symbol as it is

/*----------------------------------------------------------------------------*/
/* BUILD                                                                      */
/*----------------------------------------------------------------------------*/
void ada_widgets_date_picker_implem_build (GObject *object, gboolean show);

/*----------------------------------------------------------------------------*/
/* SET PROPERTY                                                               */
/*----------------------------------------------------------------------------*/
static void
ada_widgets_date_picker_implem_set_property (GObject *object,
                                             guint prop_id,
                                             const GValue *value,
                                             GParamSpec *pspec);

/*----------------------------------------------------------------------------*/
/* GET PROPERTY                                                               */
/*----------------------------------------------------------------------------*/
static void
ada_widgets_date_picker_implem_get_property (GObject *object,
                                             guint prop_id,
                                             GValue *value,
                                             GParamSpec *pspec);

#endif /* ADA_WIDGETS_DATE_PICKER_IMPLEM_H */
