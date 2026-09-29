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
#include "ada_widgets_date_picker_editor.h"
#include "ada_widgets_date_picker_validation.h"

/* -------------------------------------------------------------------------- */
/*  Declarations                                                              */
/* -------------------------------------------------------------------------- */

typedef struct _GladeEPropDatepicker      GladeEPropDatepicker;
typedef struct _GladeEPropDatepickerClass GladeEPropDatepickerClass;

struct _GladeEPropDatepicker
{
  GladeEditorProperty parent_instance;

  /* We keep our own pointer to the entry because
   * glade_editor_property_get_input() does not exist in Glade 3.40
   * and the 'input' member is private.
   */
  GtkWidget *entry;
};

struct _GladeEPropDatepickerClass
{
  GladeEditorPropertyClass parent_class;
};

G_DEFINE_TYPE (GladeEPropDatepicker, glade_eprop_datepicker, GLADE_TYPE_EDITOR_PROPERTY)

#define GLADE_TYPE_EPROP_DATEPICKER            (glade_eprop_datepicker_get_type ())
#define GLADE_EPROP_DATEPICKER(obj)            (G_TYPE_CHECK_INSTANCE_CAST ((obj), GLADE_TYPE_EPROP_DATEPICKER, GladeEPropDatepicker))
#define GLADE_EPROP_DATEPICKER_CLASS(klass)    (G_TYPE_CHECK_CLASS_CAST ((klass),  GLADE_TYPE_EPROP_DATEPICKER, GladeEPropDatepickerClass))
#define GLADE_IS_EPROP_DATEPICKER(obj)         (G_TYPE_CHECK_INSTANCE_TYPE ((obj), GLADE_TYPE_EPROP_DATEPICKER))
#define GLADE_IS_EPROP_DATEPICKER_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass),  GLADE_TYPE_EPROP_DATEPICKER))
#define GLADE_EPROP_DATEPICKER_GET_CLASS(obj)  (G_TYPE_INSTANCE_GET_CLASS ((obj),  GLADE_TYPE_EPROP_DATEPICKER, GladeEPropDatepickerClass))

/* -------------------------------------------------------------------------- */
/*  Callbacks                                                                 */
/* -------------------------------------------------------------------------- */

static void
ada_widgets_date_picker_editor_commit (GtkEntry *entry, GladeEditorProperty *eprop)
{
  gchar *text = g_strdup (gtk_entry_get_text (entry));
  g_strstrip (text);

  GladeProperty *property;
  GladePropertyDef *pdef;
  const gchar *prop_id = NULL;
  gboolean is_target_prop = FALSE;
  GValue value = G_VALUE_INIT;
  GValue old_value = G_VALUE_INIT;
  const gchar *old_text = NULL;

  property = glade_editor_property_get_property (eprop);
  if (property != NULL)
    {
      pdef = glade_property_get_def (property);
      if (pdef != NULL)
        prop_id = glade_property_def_id (pdef);
    }

  if (prop_id && (g_strcmp0 (prop_id, "min-date") == 0 || g_strcmp0 (prop_id, "max-date") == 0))
    is_target_prop = TRUE;

  g_value_init (&value, G_TYPE_STRING);
  g_value_set_string (&value, text);

  if (ada_date_picker_validate_dates (eprop, &value, NULL))
    {
      glade_editor_property_commit (eprop, &value);
      gtk_entry_set_text (entry, text);
      g_value_unset (&value);
      g_free (text);

      return;
    }

  g_value_unset (&value);
  g_free (text);

  if (property != NULL)
    {
      glade_property_get_value (property, &old_value);

      if (G_VALUE_HOLDS_STRING (&old_value))
        old_text = g_value_get_string (&old_value);

      if (old_text != NULL)
        {
          if (is_target_prop)
            Ada_Log ("commit_datepicker [%s]: restoring previous value \"%s\"",
                             prop_id, old_text);

          gtk_entry_set_text (entry, old_text);
        }

      g_value_unset (&old_value);
    }
}

/**************/
static void
ada_widgets_date_picker_editor_on_activate (
  GtkEntry *entry, GladeEditorProperty *eprop)
{
  Ada_Log ("ada_widgets_date_picker_editor_on_activate\n"
                   "%seprop=%p",
                   Blanks, (void *)eprop);

  ada_widgets_date_picker_editor_commit (entry, eprop);
}

/**************/
static gboolean
ada_widgets_date_picker_editor_on_focus_out (GtkWidget *widget, GdkEventFocus *event,
                                             GladeEditorProperty *eprop)
{
   Ada_Log ("ada_widgets_date_picker_editor_on_focus_out\n"
                   "%seprop=%p",
                   Blanks, (void *)eprop);

  ada_widgets_date_picker_editor_commit (GTK_ENTRY (widget), eprop);

  return FALSE;
}

/* -------------------------------------------------------------------------- */
/*  Virtual methods                                                           */
/* -------------------------------------------------------------------------- */

static void
ada_widgets_date_picker_editor_eprop_load (
  GladeEditorProperty *eprop,
  GladeProperty *prop)
{
  GladeEPropDatepicker *self = GLADE_EPROP_DATEPICKER (eprop);
  GtkWidget *entry;
  GValue value = G_VALUE_INIT;
  const gchar *text = NULL;
  const gchar *prop_id = NULL;
  GladePropertyDef *pdef;
  gboolean is_target_prop = FALSE;

  if (prop != NULL)
    {
      pdef = glade_property_get_def (prop);
      if (pdef != NULL)
        prop_id = glade_property_def_id (pdef);
    }

  if (prop_id != NULL)
    {
      if (prop_id
          && (g_strcmp0 (prop_id, "min-date") == 0
              || g_strcmp0 (prop_id, "max-date") == 0))
        is_target_prop = TRUE;

      if (is_target_prop)
        {
          Ada_Log (
            "ada_widgets_date_picker_editor_load [%s]\n"
            "%seprop=%p\n"
            "%sprop=%p\n"
            "%sparent_class %p\n"
            "%sparent_class_>load %p",
            prop_id, Blanks, (void *)eprop, Blanks, (void *)prop,
            Blanks,
            GLADE_EDITOR_PROPERTY_CLASS (glade_eprop_datepicker_parent_class),
            Blanks,
            GLADE_EDITOR_PROPERTY_CLASS (glade_eprop_datepicker_parent_class)
              ->load);
        }
    }

  /* Always chain up to the parent implementation first */
  GLADE_EDITOR_PROPERTY_CLASS (glade_eprop_datepicker_parent_class)
    ->load (eprop, prop);

  if (prop == NULL)
    {
      return;
    }

  entry = self->entry;
  if (!GTK_IS_ENTRY (entry))
    {
      return;
    }

  glade_property_get_value (prop, &value);

  if (G_VALUE_HOLDS_STRING (&value))
    text = g_value_get_string (&value);

  if (is_target_prop)
    {
      Ada_Log ("glade_eprop_datepicker_load [%s]:\n"
                       "%sloading text=\"%s\"",
                       prop_id,
                       Blanks, text ? text : "(null)");
    }

  gtk_entry_set_text (GTK_ENTRY (entry), text != NULL ? text : "");

  g_value_unset (&value);
}

/**********************/
static GtkWidget *
ada_widgets_date_picker_editor_create_input (GladeEditorProperty *eprop)
{
  GladeEPropDatepicker *self = GLADE_EPROP_DATEPICKER (eprop);
  GtkWidget *entry;
  GladeProperty *property;
  GladePropertyDef *pdef;
  const gchar *prop_id = NULL;

  entry = gtk_entry_new ();
  gtk_widget_show (entry);

  /* Keep our own reference so we can access it later from load() */
  self->entry = entry;

  g_signal_connect (entry, "activate",
                    G_CALLBACK (ada_widgets_date_picker_editor_on_activate), eprop);

  g_signal_connect (entry, "focus-out-event",
                    G_CALLBACK (ada_widgets_date_picker_editor_on_focus_out), eprop);

  property = glade_editor_property_get_property (eprop);
  if (property != NULL)
    {
      pdef = glade_property_get_def (property);
      if (pdef != NULL)
        prop_id = glade_property_def_id (pdef);
    }

  if (prop_id && (g_strcmp0 (prop_id, "min-date") == 0 || g_strcmp0 (prop_id, "max-date") == 0))
    {
      Ada_Log ("ada_widgets_date_picker_editor_create_input [%s]:\n"
                       "%seprop=%s (%p)\n"
                       "%sentry (%p)",
                       prop_id,
                       Blanks, G_OBJECT_TYPE_NAME (eprop), (void *)eprop,
                       Blanks, (void *)entry);
    }

  return entry;
}

/* -------------------------------------------------------------------------- */
/*  Class / instance initialization                                           */
/* -------------------------------------------------------------------------- */

/* -------------------------------------------------------------------------- */
/*  Class / instance initialization                                           */
/* -------------------------------------------------------------------------- */
// do not rename
static void
glade_eprop_datepicker_init (GladeEPropDatepicker *self)
{
  Ada_Log ("ada_widgets_date_picker_editor_instance_init: \n"
                   "%seprop=%s (%p)",
                   Blanks, G_OBJECT_TYPE_NAME (self), (void *)self);
  self->entry = NULL;
  Ada_Log ("glade_eprop_datepicker_instance_init end");
}

/************/
// do not rename
static void
glade_eprop_datepicker_class_init (GladeEPropDatepickerClass *klass)
{
  GladeEditorPropertyClass *eprop_class = GLADE_EDITOR_PROPERTY_CLASS (klass);

  eprop_class->create_input = ada_widgets_date_picker_editor_create_input;
  eprop_class->load = ada_widgets_date_picker_editor_eprop_load;

  Ada_Log ("ada_widgets_date_picker_editor_class_init\n"
                   "%seprop_class=%p\n"
                   "%seprop_class.Load=%p",
                   Blanks, (void *)eprop_class,
                   Blanks, (void *)eprop_class->load);
}

/* -------------------------------------------------------------------------- */
/*  Catalog entry point                                                       */
/* -------------------------------------------------------------------------- */
G_MODULE_EXPORT GladeEditorProperty *
ada_widgets_date_picker_editor_create_eprop (GladeWidgetAdaptor *adaptor,
                                             GladePropertyDef   *def,
                                             gboolean            use_command)
{

  const gchar *prop_id = glade_property_def_id (def);
  gboolean is_target = (prop_id
                        && (g_strcmp0 (prop_id, "min-date") == 0
                            || g_strcmp0 (prop_id, "max-date") == 0));

  if (is_target || g_strcmp0 (prop_id, "min-date") == 0 || g_strcmp0 (prop_id, "max-date") == 0)
    {
      // keeping the main original logic for these properties flow
      if (g_strcmp0 (prop_id, "min-date") == 0 || g_strcmp0 (prop_id, "max-date") == 0)
        {
          GladeEditorProperty *eprop
            = g_object_new (GLADE_TYPE_EPROP_DATEPICKER,
                            "property-def", def,
                            "use-command", use_command,
                            NULL);
          Ada_Log ("ada_date_picker_editor_create_eprop end\n"
                           "%seprop=%p\n"
                           "%seprop type=%s (%lu)\n"
                           "%sprop=%p\n"
                           "%sdef=%p\n"
                           "%sdef->id=%s\n"
                           "%sdef->name=%s\n"
                           "%suse_command=%d",
                           Blanks, (void *)eprop,
                           Blanks, G_OBJECT_TYPE_NAME (eprop),
                           (unsigned long)G_OBJECT_TYPE (eprop),
                           Blanks,(void *)glade_editor_property_get_property (eprop),
                           Blanks, (void *)def,
                           Blanks, glade_property_def_id (def),
                           Blanks, glade_property_def_get_name (def),
                           Blanks, (int)use_command);
          return eprop;
        }
    }

  return GLADE_WIDGET_ADAPTOR_GET_ADAPTOR_CLASS (G_TYPE_OBJECT)
    ->create_eprop (adaptor, def, use_command);

}
