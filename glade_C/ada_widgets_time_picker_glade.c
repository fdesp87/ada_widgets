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
#include "ada_widgets_time_picker_glade.h"
#include "ada_widgets_time_picker_implem.h"

/*----------------------------------------------------------------------------*/
/*  GET TYPE                                                                  */
/*----------------------------------------------------------------------------*/
// GType
// ada_widgets_time_picker_glade_get_type (void)
// {
//   Ada_Log ("ada_widgets_time_picker_glade_get_type");
//   return ada_widgets_time_picker_implem_get_type();
// }

/*----------------------------------------------------------------------------*/
/* POST CREATE                                                                */
/*----------------------------------------------------------------------------*/
G_MODULE_EXPORT void
ada_widgets_time_picker_glade_post_create (GladeWidgetAdaptor *adaptor,
                                           GObject            *object,
                                           GladeCreateReason   reason)
{
  Ada_Log ("ada_widgets_time_picker_glade_post_create:\n"
                   "%sadaptor=%s (%p),\n"
                   "%sobject=%s (%p),\n"
                   "%sreason=%d",
                   Blanks, glade_widget_adaptor_get_name (adaptor), (void *)adaptor,
                   Blanks, G_OBJECT_TYPE_NAME (object), (void *)object,
                   Blanks, (int)reason);

  glade_widget_push_superuser ();
  ada_widgets_time_picker_implem_build (object, FALSE);
  glade_widget_pop_superuser ();
}

/*----------------------------------------------------------------------------*/
/* SET PROPERTY                                                               */
/*----------------------------------------------------------------------------*/
G_MODULE_EXPORT void
ada_widgets_time_picker_glade_set_property (GladeWidgetAdaptor *adaptor,
                                            GObject            *object,
                                            const gchar        *id,
                                            const GValue       *value)
{
  if (g_strcmp0 (id, "time-zone") == 0)
    {
      AdaTimeZone time_zone = (AdaTimeZone) g_value_get_enum (value);

      g_object_set_data (object,
                         "ada-picker-time-zone",
                         GINT_TO_POINTER (time_zone));

      Ada_Log ("ada_widgets_time_picker_glade_set_property:\n"
                       "%sid=%s,\n"
                       "%svalue (enum)=%d,\n"
                       "%sobject=%s (%p)",
                       Blanks, id,
                       Blanks, (int) time_zone,
                       Blanks, G_OBJECT_TYPE_NAME (object), (void *)object);
    }
  else
    {
      GladeWidgetAdaptor *parent_adaptor =
        glade_widget_adaptor_get_parent_adaptor (adaptor);

      if (parent_adaptor != NULL)
        {
          GladeWidgetAdaptorClass *parent_class =
            GLADE_WIDGET_ADAPTOR_GET_CLASS (parent_adaptor);

          if (parent_class != NULL && parent_class->set_property != NULL)
            parent_class->set_property (parent_adaptor, object, id, value);
        }
    }
}

/*----------------------------------------------------------------------------*/
/* GET PROPERTY                                                               */
/*----------------------------------------------------------------------------*/
G_MODULE_EXPORT void
ada_widgets_time_picker_glade_get_property (GladeWidgetAdaptor *adaptor,
                                            GObject *object,
                                            const gchar *id,
                                            GValue *value)
{
    if (g_strcmp0 (id, "time-zone") == 0)
    {
        gpointer saved_tz = g_object_get_data (object, "ada-picker-time-zone");

        AdaTimeZone time_zone = saved_tz ? GPOINTER_TO_INT (saved_tz) : ADA_TIME_ZONE_UTC;

        Ada_Log ("ada_widgets_time_picker_glade_get_property "
                         "id=%s, value (enum)=%d"
                         ", object=%s (0x%016lx)",
                         id, (int) time_zone,
                         G_OBJECT_TYPE_NAME (object),
                         (void *)object);

        g_value_set_enum (value, time_zone);
    }
    else
    {
        GladeWidgetAdaptor *parent_adaptor
          = glade_widget_adaptor_get_parent_adaptor (adaptor);
        if (parent_adaptor)
        {
            GladeWidgetAdaptorClass *parent_class
            = GLADE_WIDGET_ADAPTOR_GET_CLASS (parent_adaptor);
            if (parent_class && parent_class->get_property)
            {
                parent_class->get_property (parent_adaptor, object, id, value);
            }
        }
    }
}
