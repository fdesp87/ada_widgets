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

#include "ada_widgets_date_picker_glade.h"
#include "ada_widgets_date_picker_implem.h"

/*----------------------------------------------------------------------------*/
/* GET TYPE                                                                   */
/*----------------------------------------------------------------------------*/
G_MODULE_EXPORT GType
ada_widgets_date_picker_glade_get_type (void)
{
  Ada_Log ("ada_widgets_date_picker_glade_get_type");
  ada_widgets_date_picker_implem_get_type();
}

/*----------------------------------------------------------------------------*/
/* POST CREATE                                                                */
/*----------------------------------------------------------------------------*/
G_MODULE_EXPORT void
ada_widgets_date_picker_glade_post_create (GladeWidgetAdaptor *adaptor,
                                           GObject *object,
                                           GladeCreateReason reason)
{
  Ada_Log ("glade_ada_widgets_date_picker_glade_post_create:\n"
           "%sadaptor=%s (%p)\n"
           "%sobject=%s (%p)\n"
           "%sreason=%d",
           Blanks, glade_widget_adaptor_get_name (adaptor), (void *)adaptor,
           Blanks, G_OBJECT_TYPE_NAME (object), (void *)object, Blanks,
           (int)reason);
  if ((reason = GLADE_CREATE_LOAD) || (reason = GLADE_CREATE_COPY)
        || (reason = GLADE_CREATE_USER))
    {
      glade_widget_push_superuser ();
      ada_widgets_date_picker_implem_build (object, FALSE);
      glade_widget_pop_superuser ();
    }
}

/*----------------------------------------------------------------------------*/
/* SET PROPERTY                                                               */
/*----------------------------------------------------------------------------*/
//  G_MODULE_EXPORT void
//  ada_widgets_date_picker_glade_set_property (GladeWidgetAdaptor *adaptor,
//                                              GObject *object,
//                                              const gchar *id,
//                                              const GValue *value)
//  {
//
//    if (g_strcmp0 (id, "min-date") == 0 || g_strcmp0 (id, "max-date") == 0)
//     {
//       const gchar *value_str = g_value_get_string (value);
//       const gchar *new_date = value_str;
//       if (!new_date)
//         {
//           return;
//         }
//       const gchar *data_key = (g_strcmp0 (id, "min-date") == 0)
//                                 ? "ada-picker-min-date"
//                                 : "ada-picker-max-date";
//
//       g_object_set_data_full (object, data_key, g_strdup (new_date),
//                               (GDestroyNotify)g_free);
//
//       Ada_Log ("ada_widgets_date_picker_glade_set_property "
//                "id=%s, value=%s\n"
//                "%sobject=%s (%p)", id, value_str ? value_str : "(null)",
//                Blanks, G_OBJECT_TYPE_NAME (object), (void *)object);
//     }
//   else
//     {
//       // Ada_Log ("ada_widgets_date_picker_glade_set_property "
//       //          "id=%s\n"
//       //          "%sadaptor=%s (%p)\n"
//       //          "%sobject=%s (%p)",
//       //          id,
//       //          Blanks, glade_widget_adaptor_get_name (adaptor), (void *)adaptor,
//       //          Blanks, G_OBJECT_TYPE_NAME (object), (void *)object);
//
//       GladeWidgetAdaptor *parent_adaptor
//         = glade_widget_adaptor_get_parent_adaptor (adaptor);
//       if (parent_adaptor)
//         {
//         GladeWidgetAdaptorClass *parent_class
//           = GLADE_WIDGET_ADAPTOR_GET_CLASS (parent_adaptor);
//         if (parent_class && parent_class->set_property)
//           {
//             parent_class->set_property (parent_adaptor, object, id, value);
//           }
//         }
//     }
// }

/*----------------------------------------------------------------------------*/
/* GET PROPERTY                                                               */
/*----------------------------------------------------------------------------*/
// G_MODULE_EXPORT void
// ada_widgets_date_picker_glade_get_property (GladeWidgetAdaptor *adaptor,
//                                             GObject *object,
//                                             const gchar *id,
//                                             GValue *value)
// {
//   if (g_strcmp0 (id, "min-date") == 0 || g_strcmp0 (id, "max-date") == 0)
//     {
//       const gchar *data_key = (g_strcmp0 (id, "min-date") == 0)
//                                 ? "ada-picker-min-date"
//                                 : "ada-picker-max-date";
//
//       const gchar *saved_date = g_object_get_data (object, data_key);
//       const gchar *default_val = (g_strcmp0 (id, "min-date") == 0) ? "1901-01-01" : "2399-12-31";
//
//       const gchar *val_to_return = saved_date ? saved_date : default_val;
//
//       Ada_Log ("glade_ada_widgets_date_picker_glade_get_property "
//                        "id=%s, value=%s"
//                        ", object=%s (%p)",
//                        id, val_to_return,
//                        G_OBJECT_TYPE_NAME (object), (void *)object);
//
//       g_value_set_string (value, val_to_return);
//     }
//   else
//     {
//       // Ada_Log ("glade_ada_widgets_date_picker_glade_get_property "
//       //                  "id=%s",
//       //                  "%sadaptor=%s (%p)\n",
//       //                  "%sobject=%s (%p)",
//       //                  id,
//       //                  Blanks, glade_widget_adaptor_get_name (adaptor), (void *)adaptor,
//       //                  G_OBJECT_TYPE_NAME (object), (void *)object);
//
//       GladeWidgetAdaptor *parent_adaptor
//         = glade_widget_adaptor_get_parent_adaptor (adaptor);
//       if (parent_adaptor)
//         {
//           GladeWidgetAdaptorClass *parent_class
//             = GLADE_WIDGET_ADAPTOR_GET_CLASS (parent_adaptor);
//           if (parent_class && parent_class->get_property)
//             {
//               parent_class->get_property (parent_adaptor, object, id, value);
//             }
//         }
//     }
// }
