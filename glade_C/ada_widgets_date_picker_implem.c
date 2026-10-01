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
#include "ada_widgets_date_picker_implem.h"


/*----------------------------------------------------------------------------*/
static void
ada_widgets_date_picker_implem_on_calendar_button_clicked (
    GtkButton *button,
    gpointer user_data)
{
    GtkWidget *dialog = gtk_message_dialog_new (
        NULL,
        GTK_DIALOG_MODAL | GTK_DIALOG_DESTROY_WITH_PARENT,
        GTK_MESSAGE_INFO,
        GTK_BUTTONS_OK,
        "Calendar Selector Info\n\n"
        "The calendar selector will be available for the application."
    );

  gtk_window_set_title (GTK_WINDOW (dialog), "AdaDatePicker");
  gtk_dialog_run (GTK_DIALOG (dialog));
  gtk_widget_destroy (dialog);
}

/*----------------------------------------------------------------------------*/
static void
Load_Date_CSS (void)
{
  static gboolean date_css_loaded = FALSE;

  if (date_css_loaded)
    return;

  Ada_Log ("ada_widgets_date_picker_implem.load_css");


  const gchar *DatePicker_CSS = "box#Date_Picker_HBox {"
                                "    border-style: none;"
                                "    background-color: transparent;"
                                "}"
                                "entry#Date_Picker_Year_Entry,"
                                "entry#Date_Picker_Month_Entry,"
                                "entry#Date_Picker_Day_Entry {"
                                "    padding-top: 2px;"
                                "    padding-bottom: 2px;"
                                "    min-height: 22px;"
                                "    border-radius: 0px;"
                                "    margin-right: -1px;"
                                "}"
                                "button#Date_Picker_Button {"
                                "    padding-top: 0px;"
                                "    padding-bottom: 0px;"
                                "    min-height: 22px;"
                                "    border-radius: 0px;"
                                "}";

  GtkCssProvider *provider = gtk_css_provider_new ();
    GError *error = NULL;

    gtk_css_provider_load_from_data (provider, DatePicker_CSS, -1, &error);

    if (error) {
        Ada_Log ("Error loading CSS: %s", error->message);
        g_error_free (error);
        g_object_unref (provider);
        return;
    }

    gtk_style_context_add_provider_for_screen (
        gdk_screen_get_default (),
        GTK_STYLE_PROVIDER (provider),
        GTK_STYLE_PROVIDER_PRIORITY_APPLICATION
    );

    g_object_unref (provider);
    date_css_loaded = TRUE;
}

/*----------------------------------------------------------------------------*/
/* BUILD                                                                      */
/*----------------------------------------------------------------------------*/
void
ada_widgets_date_picker_implem_build (GObject *object,
                                      gboolean show)
{
  Ada_Log ("ada_widgets_date_picker_implem.build: "
           "object=%s (%p)",
           G_OBJECT_TYPE_NAME (object), (void *)object);

  GtkFrame *frame = GTK_FRAME (object);
  gtk_frame_set_shadow_type (frame, GTK_SHADOW_NONE);
  gtk_widget_set_name (GTK_WIDGET (frame), "Date_Picker_Frame");
  gtk_frame_set_label (frame, NULL);

  GtkWidget *child = gtk_bin_get_child (GTK_BIN (frame));
  GtkWidget *hbox = NULL;

  if (GTK_IS_BOX (child))
    {
      hbox = child;
    }
  else
    {
      if (child)
        gtk_container_remove (GTK_CONTAINER (frame), child);

      hbox = gtk_box_new (GTK_ORIENTATION_HORIZONTAL, 0);
      gtk_widget_set_name (hbox, "Date_Picker_HBox");
      gtk_container_add (GTK_CONTAINER (frame), hbox);
    }

  GtkStyleContext *context = gtk_widget_get_style_context (hbox);
  gtk_style_context_add_class (context, "linked");

  if (gtk_container_get_children (GTK_CONTAINER (hbox)) == NULL)
    {
      GtkWidget *entry_yyyy = gtk_entry_new ();
      gtk_widget_set_name (entry_yyyy, "Date_Picker_Year_Entry");
      gtk_entry_set_placeholder_text (GTK_ENTRY (entry_yyyy), "YYYY");
      gtk_entry_set_width_chars (GTK_ENTRY (entry_yyyy), 5);
      gtk_entry_set_max_length (GTK_ENTRY (entry_yyyy), 4);
      gtk_entry_set_alignment (GTK_ENTRY (entry_yyyy), 0.5);
      gtk_entry_set_overwrite_mode (GTK_ENTRY (entry_yyyy), TRUE);
      gtk_box_pack_start (GTK_BOX (hbox), entry_yyyy, TRUE, TRUE, 0);

      GtkWidget *entry_mm = gtk_entry_new ();
      gtk_widget_set_name (entry_mm, "Date_Picker_Month_Entry");
      gtk_entry_set_placeholder_text (GTK_ENTRY (entry_mm), "MM");
      gtk_entry_set_width_chars (GTK_ENTRY (entry_mm), 4);
      gtk_entry_set_max_length (GTK_ENTRY (entry_mm), 2);
      gtk_entry_set_alignment (GTK_ENTRY (entry_mm), 0.5);
      gtk_entry_set_overwrite_mode (GTK_ENTRY (entry_mm), TRUE);
      gtk_box_pack_start (GTK_BOX (hbox), entry_mm, FALSE, FALSE, 0);

      GtkWidget *entry_dd = gtk_entry_new ();
      gtk_widget_set_name (entry_dd, "Date_Picker_Day_Entry");
      gtk_entry_set_placeholder_text (GTK_ENTRY (entry_dd), "DD");
      gtk_entry_set_width_chars (GTK_ENTRY (entry_dd), 4);
      gtk_entry_set_max_length (GTK_ENTRY (entry_dd), 2);
      gtk_entry_set_alignment (GTK_ENTRY (entry_dd), 0.5);
      gtk_entry_set_overwrite_mode (GTK_ENTRY (entry_dd), TRUE);
      gtk_box_pack_start (GTK_BOX (hbox), entry_dd, FALSE, FALSE, 0);

      GtkWidget *button = gtk_button_new ();
      gtk_widget_set_name (button, "Date_Picker_Button");
      GtkWidget *image = gtk_image_new_from_icon_name ("x-office-calendar",
                                                       GTK_ICON_SIZE_BUTTON);
      gtk_container_add (GTK_CONTAINER (button), image);
      gtk_box_pack_start (GTK_BOX (hbox), button, FALSE, FALSE, 0);

      g_signal_connect (button, "clicked",
                        G_CALLBACK (ada_widgets_date_picker_implem_on_calendar_button_clicked),
                        object);

      g_object_set_data (object, "ada-picker-button-ref", button);
      g_object_set_data (object, "ada-picker-year-ref", entry_yyyy);
      g_object_set_data (object, "ada-picker-month-ref", entry_mm);
      g_object_set_data (object, "ada-picker-day-ref", entry_dd);

      gtk_widget_set_sensitive (entry_yyyy, FALSE);
      gtk_widget_set_sensitive (entry_mm, FALSE);
      gtk_widget_set_sensitive (entry_dd, FALSE);
    }
  Load_Date_CSS ();
  if (show) {
      gtk_widget_show_all (GTK_WIDGET (object));
    }
}

/*----------------------------------------------------------------------------*/
/* SET PROPERTY                                                               */
/*----------------------------------------------------------------------------*/
static void
ada_widgets_date_picker_implem_set_property (GObject *object,
                                             guint prop_id,
                                             const GValue *value,
                                             GParamSpec *pspec)
{

  switch (prop_id)
    {
    case PROP_MIN_DATE:
    case PROP_MAX_DATE:
      {
        const gchar *value_str = g_value_get_string (value);
        const gchar *new_date = value_str;
        if (!new_date)
          {
            return;
          }
        const gchar *data_key = (prop_id == PROP_MIN_DATE)
                                  ? "ada-picker-min-date"
                                  : "ada-picker-max-date";
        g_object_set_data_full (object, data_key,
                                g_strdup (g_value_get_string (value)),
                                (GDestroyNotify)g_free);
        Ada_Log ("ada_widgets_date_picker_implem_set_property: "
                 "id=%s, value=%s"
                 ", object=%s (%p)",
                 ada_widgets_date_picker_prop_to_string (prop_id),
                 value_str ? value_str : "(null)",
                 G_OBJECT_TYPE_NAME (object), (void *)object);
      }
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
    }
}

/*----------------------------------------------------------------------------*/
/* GET PROPERTY                                                               */
/*----------------------------------------------------------------------------*/
static void
ada_widgets_date_picker_implem_get_property (GObject *object,
                                             guint prop_id,
                                             GValue *value,
                                             GParamSpec *pspec)
{
  switch (prop_id)
    {
    case PROP_MIN_DATE:
    case PROP_MAX_DATE:
      {
        const gchar *data_key = (prop_id == PROP_MIN_DATE)
                                  ? "ada-picker-min-date"
                                  : "ada-picker-max-date";
        const gchar *saved_date = g_object_get_data (object, data_key);
        const gchar *default_val = (prop_id == PROP_MIN_DATE) ? "1901-01-01" : "2399-12-31";
        const gchar *val_to_return = saved_date ? saved_date : default_val;
        Ada_Log ("ada_widgets_date_picker_implem_get_property: "
                 "prop_id=%s, value=%s"
                 ", object=%s (%p)",
                 ada_widgets_date_picker_prop_to_string (prop_id),
                 val_to_return, G_OBJECT_TYPE_NAME (object), (void *)object);

        g_value_set_string (value, val_to_return);
      }
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
    }
}

/*----------------------------------------------------------------------------*/
static void
ada_widgets_date_picker_class_init (AdaDatePickerClass *klass)
{
  Ada_Log ("ada_widgets_date_picker_class_init: "
                   "class=%s (%p)",
                   G_OBJECT_CLASS_NAME (klass), (void *)klass);

  GObjectClass *object_class = G_OBJECT_CLASS (klass);
  object_class->set_property = ada_widgets_date_picker_implem_set_property;
  object_class->get_property = ada_widgets_date_picker_implem_get_property;

  g_object_class_install_property (
      object_class,
      PROP_MIN_DATE,
      g_param_spec_string ("min-date",
                           "Minimum Date",
                           "Minimum allowed date format: YYYY-MM-DD",
                           "1901-01-01",
                           G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));

  g_object_class_install_property (
    object_class, PROP_MAX_DATE,
    g_param_spec_string (
      "max-date", "Maximum Date", "Maximum allowed date format: YYYY-MM-DD",
      "2399-12-31", G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));

  guint n_properties = 0;
  gboolean found =FALSE;
  GParamSpec **properties = g_object_class_list_properties (object_class, &n_properties);

  for (guint i = 0; i < n_properties; i++)
    {
      GParamSpec *pspec = properties[i];
      if (pspec->owner_type == G_OBJECT_CLASS_TYPE (klass))
        {
          if (!found)
            {
              found = TRUE;
              Ada_Log ("ada_widgets_date_picker_class_init: own properties:");
            }
          Ada_Log ("%s%s", Blanks, g_param_spec_get_name (pspec));
        }
    }
  if (!found)
    Ada_Log ("ada_widgets_date_picker_class_init: no own properties");

  g_free (properties);
}

/*----------------------------------------------------------------------------*/
G_MODULE_EXPORT void
ada_widgets_date_picker_instance_init (GObject *object,
                                       GObjectClass *class)
{
  Ada_Log ("ada_widgets_date_picker_implem_instance_init: "
           "object=%s (%p)"
           ", class=%s (%p)",
           G_OBJECT_TYPE_NAME (object), (void *)object,
           G_OBJECT_CLASS_NAME (class), (void *)class);

  ada_widgets_date_picker_implem_build (object, TRUE);
}

/*----------------------------------------------------------------------------*/
/* GET TYPE                                                                   */
/*----------------------------------------------------------------------------*/
GType
ada_widgets_date_picker_implem_get_type (void)
{
  static volatile gsize g_define_type_id__volatile = 0;
  static GType type = 0;

  if (g_once_init_enter (&g_define_type_id__volatile))
    {
      if (G_UNLIKELY (type == 0))
        {
          const GTypeInfo info = { sizeof (AdaDatePickerClass),
                (GBaseInitFunc)NULL,
                (GBaseFinalizeFunc)NULL,
                (GClassInitFunc)ada_widgets_date_picker_class_init,
                (GClassFinalizeFunc)NULL,
                NULL,
                sizeof (AdaDatePicker),
                0,
                (GInstanceInitFunc)ada_widgets_date_picker_instance_init,
                NULL };
          type = g_type_register_static (GTK_TYPE_FRAME, "AdaDatePicker", &info,
                                         0);
          g_once_init_leave (&g_define_type_id__volatile, type);

          Ada_Log ("ada_widgets_date_picker_implem_get_type: type=%s (%p)",
                   g_type_name (type), type);
        }
    }
  return type;
}
