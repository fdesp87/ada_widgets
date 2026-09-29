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
#include "ada_widgets_time_picker_implem.h"

static GtkWidget *
create_embedded_image (void)
{
  static const char *stepper_arrows_data[] =
    {
        "16 16 2 1",
        "  c None",
        "X c #55A630",
        "................",
        "........X.......",
        ".......XXX......",
        "......XXXXX.....",
        ".....XXXXXXX....",
        "....XXXXXXXXX...",
        "...XXXXXXXXXXX..",
        "................",
        "................",
        "...XXXXXXXXXXX..",
        "....XXXXXXXXX...",
        ".....XXXXXXX....",
        "......XXXXX.....",
        ".......XXX......",
        "........X.......",
        "................"
    };

    GdkPixbuf *pixbuf = gdk_pixbuf_new_from_xpm_data(stepper_arrows_data);
    GtkWidget *image = gtk_image_new_from_pixbuf(pixbuf);
    g_object_unref(pixbuf);

    return image;
}

/*----------------------------------------------------------------------------*/
static void
Load_Time_CSS (void)
{
  static gboolean time_css_loaded = FALSE;

  if (time_css_loaded)
    return;

  Ada_Log ("ada_widgets_time_picker_implem.load_css");

  const gchar *TimePicker_CSS = "button#Time_Picker_Hour_Button,"
                                "button#Time_Picker_Min_Button,"
                                "button#Time_Picker_Sec_Button {"
                                "    padding: 0px;"
                                "    margin: 0px;"
                                "    border: 1px solid #b5b5b5;"
                                "    min-width: 16px;"
                                "    min-height: 22px;"
                                "    border-radius: 0px;"
                                "}"
                                "entry#Time_Picker_Hour_Entry,"
                                "entry#Time_Picker_Min_Entry,"
                                "entry#Time_Picker_Sec_Entry {"
                                "    padding-top: 2px;"
                                "    padding-bottom: 2px;"
                                "    min-height: 22px;"
                                "    border-radius: 0px;"
                                "    margin-right: -1px;"
                                "}";

  GtkCssProvider *provider = gtk_css_provider_new ();
    GError *error = NULL;

    gtk_css_provider_load_from_data (provider, TimePicker_CSS, -1, &error);

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
    time_css_loaded = TRUE;
}

/*----------------------------------------------------------------------------*/
void
ada_widgets_time_picker_implem_build (GObject *object, gboolean show)
{
   Ada_Log ("ada_widgets_time_picker_implem.build: \n"
                   "%sobject=%s (%p)",
                   Blanks, G_OBJECT_TYPE_NAME (object), (void *)object);

  GtkFrame *frame = GTK_FRAME (object);
  gtk_frame_set_shadow_type (frame, GTK_SHADOW_NONE);
  gtk_widget_set_name (GTK_WIDGET (frame), "Time_Picker_Frame");
  gtk_frame_set_label (frame, NULL);

  GtkWidget *child = gtk_bin_get_child (GTK_BIN (frame));
  GtkBox *hbox = NULL;

  if (GTK_IS_BOX (child))
    {
      hbox = GTK_BOX (child);
    }
  else
    {
      if (child)
        gtk_container_remove (GTK_CONTAINER (frame), child);

      hbox = GTK_BOX (gtk_box_new (GTK_ORIENTATION_HORIZONTAL, 0));
      gtk_widget_set_name (GTK_WIDGET (hbox), "Time_Picker_HBox");
      gtk_container_add (GTK_CONTAINER (frame), GTK_WIDGET (hbox));
    }

  GtkStyleContext *context = gtk_widget_get_style_context (GTK_WIDGET (hbox));
  gtk_style_context_add_class (context, "linked");

  if (gtk_container_get_children (GTK_CONTAINER (hbox)) == NULL)
    {
      GtkWidget *entry_hour = gtk_entry_new ();
      gtk_widget_set_name (entry_hour, "Time_Picker_Hour_Entry");
      gtk_entry_set_width_chars (GTK_ENTRY (entry_hour), 3);
      gtk_entry_set_max_length (GTK_ENTRY (entry_hour), 2);
      gtk_entry_set_alignment (GTK_ENTRY (entry_hour), 0.5);
      gtk_entry_set_placeholder_text (GTK_ENTRY (entry_hour), "HH");
      gtk_box_pack_start (hbox, entry_hour, FALSE, FALSE, 0);

      GtkWidget *hour_button = gtk_button_new ();
      gtk_widget_set_name (hour_button, "Time_Picker_Hour_Button");
      gtk_container_add (GTK_CONTAINER (hour_button), create_embedded_image ());
      gtk_box_pack_start (hbox, hour_button, FALSE, FALSE, 0);

      GtkWidget *entry_min = gtk_entry_new ();
      gtk_widget_set_name (entry_min, "Time_Picker_Min_Entry");
      gtk_entry_set_width_chars (GTK_ENTRY (entry_min), 4);
      gtk_entry_set_max_length (GTK_ENTRY (entry_min), 2);
      gtk_entry_set_alignment (GTK_ENTRY (entry_min), 0.5);
      gtk_entry_set_placeholder_text (GTK_ENTRY (entry_min), "mm");
      gtk_box_pack_start (hbox, entry_min, FALSE, FALSE, 0);

      GtkWidget *min_button = gtk_button_new ();
      gtk_widget_set_name (min_button, "Time_Picker_Min_Button");
      gtk_container_add (GTK_CONTAINER (min_button), create_embedded_image ());
      gtk_box_pack_start (hbox, min_button, FALSE, FALSE, 0);

      GtkWidget *entry_sec = gtk_entry_new ();
      gtk_widget_set_name (entry_sec, "Time_Picker_Sec_Entry");
      gtk_entry_set_width_chars (GTK_ENTRY (entry_sec), 2);
      gtk_entry_set_max_length (GTK_ENTRY (entry_sec), 2);
      gtk_entry_set_alignment (GTK_ENTRY (entry_sec), 0.5);
      gtk_entry_set_placeholder_text (GTK_ENTRY (entry_sec), "ss");
      gtk_box_pack_start (hbox, entry_sec, FALSE, FALSE, 0);

      GtkWidget *sec_button = gtk_button_new ();
      gtk_widget_set_name (sec_button, "Time_Picker_Sec_Button");
      gtk_container_add (GTK_CONTAINER (sec_button), create_embedded_image ());
      gtk_box_pack_start (hbox, sec_button, FALSE, FALSE, 0);

      g_object_set_data (object, "ada-time-hour-ref", entry_hour);
      g_object_set_data (object, "ada-time-min-ref", entry_min);
      g_object_set_data (object, "ada-time-sec-ref", entry_sec);

      gtk_widget_set_sensitive (entry_hour, FALSE);
      gtk_widget_set_sensitive (entry_min, FALSE);
      gtk_widget_set_sensitive (entry_sec, FALSE);
    }
  Load_Time_CSS ();
  if (show) {
      gtk_widget_show_all (GTK_WIDGET (object));
    }
}

/*----------------------------------------------------------------------------*/
static void
ada_widgets_time_picker_implem_set_property (GObject *object,
                                             guint prop_id,
                                             const GValue *value,
                                             GParamSpec *pspec)
{
   Ada_Log ("ada_widgets_time_picker_implem_set_property "
                   "object=%s (%p)"
                   ", id=%u",
                   G_OBJECT_TYPE_NAME (object), (void *)object,
                   prop_id);

  switch (prop_id)
    {
    case PROP_TIME_ZONE:
      {
        AdaTimeZone tz = (AdaTimeZone) g_value_get_enum (value);

        g_object_set_data (object, "ada-picker-time-zone",
                           GINT_TO_POINTER (tz));
      }
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
    }
}

/*----------------------------------------------------------------------------*/
static void
ada_widgets_time_picker_implem_get_property (GObject *object,
                                             guint prop_id,
                                             GValue *value,
                                             GParamSpec *pspec)
{
  Ada_Log ("ada_widgets_time_picker_implem_get_property "
                   "object=%s (%p)"
                   ", id=%u",
                   G_OBJECT_TYPE_NAME (object), (void *)object,
                   prop_id);

  switch (prop_id)
    {
    case PROP_TIME_ZONE:
      {
        gpointer saved_tz = g_object_get_data (object, "ada-picker-time-zone");
        AdaTimeZone tz = saved_tz ? GPOINTER_TO_INT (saved_tz) : ADA_TIME_ZONE_UTC;
        g_value_set_enum (value, tz);
      }
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
    }
}

/*----------------------------------------------------------------------------*/
GType
ada_widgets_time_picker_implem_time_zone_get_type (void)
{
  static volatile gsize g_define_type_id__volatile = 0;
  static GType etype = 0;

  if (g_once_init_enter (&g_define_type_id__volatile))
    {
      if (G_UNLIKELY (etype == 0))
        {
          static const GEnumValue values[] = {
            /* Universal */
            { ADA_TIME_ZONE_UTC, "Universal Time Coordinated", "UTC" },
            { ADA_TIME_ZONE_GMT, "Greenwich Mean Time", "GMT" },
            /* Europe */
            { ADA_TIME_ZONE_WET, "Western European Time", "WET" },
            { ADA_TIME_ZONE_WEST, "Western European Summer Time", "WEST" },
            { ADA_TIME_ZONE_CET, "Central European Time", "CET" },
            { ADA_TIME_ZONE_CEST, "Central European Summer Time", "CEST" },
            { ADA_TIME_ZONE_EET, "Eastern European Time", "EET" },
            { ADA_TIME_ZONE_EEST, "Eastern European Summer Time", "EEST" },
            { ADA_TIME_ZONE_MSK, "Moscow Time", "MSK" },
            { ADA_TIME_ZONE_BST, "British Summer Time", "BST" },
            { ADA_TIME_ZONE_IST, "Irish Standard Time", "IST" },
            /* Americas */
            { ADA_TIME_ZONE_EST, "Eastern Standard Time", "EST" },
            { ADA_TIME_ZONE_EDT, "Eastern Daylight Time", "EDT" },
            { ADA_TIME_ZONE_CST, "Central Standard Time", "CST" },
            { ADA_TIME_ZONE_CDT, "Central Daylight Time", "CDT" },
            { ADA_TIME_ZONE_MST, "Mountain Standard Time", "MST" },
            { ADA_TIME_ZONE_MDT, "Mountain Daylight Time", "MDT" },
            { ADA_TIME_ZONE_PST, "Pacific Standard Time", "PST" },
            { ADA_TIME_ZONE_PDT, "Pacific Daylight Time", "PDT" },
            { ADA_TIME_ZONE_AST, "Atlantic Standard Time", "AST" },
            { ADA_TIME_ZONE_ADT, "Atlantic Daylight Time", "ADT" },
            { ADA_TIME_ZONE_NST, "Newfoundland Standard Time", "NST" },
            { ADA_TIME_ZONE_NDT, "Newfoundland Daylight Time", "NDT" },
            { ADA_TIME_ZONE_AKST, "Alaska Standard Time", "AKST" },
            { ADA_TIME_ZONE_AKDT, "Alaska Daylight Time", "AKDT" },
            { ADA_TIME_ZONE_HST, "Hawaii Standard Time", "HST" },
            /* Asia / Pacific */
            { ADA_TIME_ZONE_JST, "Japan Standard Time", "JST" },
            { ADA_TIME_ZONE_KST, "Korea Standard Time", "KST" },
            { ADA_TIME_ZONE_CSTP, "China Standard Time", "CSTP" },
            { ADA_TIME_ZONE_ISTP, "Indian Standard Time", "ISTP" },
            { ADA_TIME_ZONE_SGT, "Singapore Time", "SGT" },
            { ADA_TIME_ZONE_HKT, "Hong Kong Time", "HKT" },
            { ADA_TIME_ZONE_AEST, "Australian Eastern Standard Time", "AEST" },
            { ADA_TIME_ZONE_AEDT, "Australian Eastern Daylight Time", "AEDT" },
            { ADA_TIME_ZONE_ACST, "Australian Central Standard Time", "ACST" },
            { ADA_TIME_ZONE_ACDT, "Australian Central Daylight Time", "ACDT" },
            { ADA_TIME_ZONE_AWST, "Australian Western Standard Time", "AWST" },
            { ADA_TIME_ZONE_NZST, "New Zealand Standard Time", "NZST" },
            { ADA_TIME_ZONE_NZDT, "New Zealand Daylight Time", "NZDT" },
            /* Others */
            { ADA_TIME_ZONE_SAST, "South Africa Standard Time", "SAST" },
            { ADA_TIME_ZONE_CAT, "Central Africa Time", "CAT" },
            { ADA_TIME_ZONE_EAT, "East Africa Time", "EAT" },
            { ADA_TIME_ZONE_WAT, "West Africa Time", "WAT" },
            { 0, NULL, NULL }
          };
          etype = g_enum_register_static ("AdaTimeZone", values);

          g_once_init_leave (&g_define_type_id__volatile, etype);

          Ada_Log (
            "ada_widgets_time_picker_implem_time_zone_get_type, type=%s (%p)",
            g_type_name (etype), (void *)etype);
        }
    }
  return etype;
}

/*----------------------------------------------------------------------------*/
static void
ada_widgets_time_picker_implem_class_init (AdaTimePickerClass *klass)
{
  GObjectClass *object_class = G_OBJECT_CLASS (klass);
  object_class->set_property = ada_widgets_time_picker_implem_set_property;
  object_class->get_property = ada_widgets_time_picker_implem_get_property;

  Ada_Log ("ada_widgets_time_picker_implem_class_init"
                   ", klass=%s (%p)",
                   G_OBJECT_CLASS_NAME (klass), (void *)klass);

  g_object_class_install_property (
    object_class, PROP_TIME_ZONE,
    g_param_spec_enum (
      "time-zone", "Time Zone",
      "Default time zone for the time picker (e.g., UTC, CET, EST).",
      ada_widgets_time_picker_implem_time_zone_get_type (),
      ADA_TIME_ZONE_UTC,
      G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));
}

/*----------------------------------------------------------------------------*/
G_MODULE_EXPORT void
ada_widgets_time_picker_implem_init (GObject *object)
{
  Ada_Log ("ada_widgets_time_picker_implem_init:"
                   "object=%s (%p)",
                   G_OBJECT_TYPE_NAME (object), (void *)object);
  ada_widgets_time_picker_implem_build (object, TRUE);
}

/*----------------------------------------------------------------------------*/
G_MODULE_EXPORT GType
ada_widgets_time_picker_implem_get_type (void)
{
  static volatile gsize g_define_type_id__volatile = 0;
  static GType type = 0;

  if (g_once_init_enter (&g_define_type_id__volatile))
    {
      if (G_UNLIKELY (type == 0))
        {
          const GTypeInfo info = { sizeof (AdaTimePickerClass),
                                   (GBaseInitFunc)NULL,
                                   (GBaseFinalizeFunc)NULL,
                                   (GClassInitFunc)ada_widgets_time_picker_implem_class_init,
                                   (GClassFinalizeFunc)NULL,
                                   NULL,
                                   sizeof (AdaTimePicker),
                                   0,
                                   (GInstanceInitFunc)ada_widgets_time_picker_implem_init,
                                   NULL };
          type = g_type_register_static (GTK_TYPE_FRAME,
                                         "AdaTimePicker",
                                         &info,
                                         0);

          g_once_init_leave (&g_define_type_id__volatile, type);

          Ada_Log ("ada_widgets_time_picker_implem_get_type, type=%s (%p)",
                   g_type_name (type), (void *)type);
        }
    }
  return type;
}
