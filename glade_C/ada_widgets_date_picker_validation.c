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
#include "ada_widgets_date_picker_validation.h"

/*----------------------------------------------------------------------------*/
// This is a subroutine of ada_date_picker_validate_date_value
int
is_valid_format (const gchar *date_str)
{
  if (!date_str)
    return 1;

  GRegex *regex = g_regex_new ("^\\d{4}-\\d{2}-\\d{2}$", 0, 0, NULL);
  gboolean match = g_regex_match (regex, date_str, 0, NULL);
  g_regex_unref (regex);

  if (!match)
    return 1;

  guint year = 0, month = 0, day = 0;
  if (sscanf (date_str, "%u-%u-%u", &year, &month, &day) != 3)
    {
      return 1;
    }

  if (!g_date_valid_dmy ((GDateDay)day, (GDateMonth)month, (GDateYear)year))
    {
      return 2;
    }

  return 0;
}

/*----------------------------------------------------------------------------*/
// this is a subroutine of ada_date_picker_validate_dates
/*----------------------------------------------------------------------------*/
gboolean
ada_date_picker_validate_date_value (GObject *object,
                                     const gchar *prop_id,
                                     const gchar *new_date)
{
  static gboolean showing_error = FALSE;   /* <-- reenty`protection */
  gboolean is_min;
  gchar *other_date = NULL;
  const gchar *actual_other_date;
  int cmp;
  int val_res;

  if (showing_error)
    return FALSE;

  val_res = is_valid_format (new_date);
  if (val_res == 1)
    {
      showing_error = TRUE;
      show_error_dialog ("Date Picker Error", "Invalid date format.\n\n"
                                              "Use the format YYYY-MM-DD");
      showing_error = FALSE;
      return FALSE;
    }
  else if (val_res == 2)
    {
      showing_error = TRUE;
      show_error_dialog ("Date Picker Error", "Invalid date");
      showing_error = FALSE;
      return FALSE;
    }

  if (g_strcmp0 (new_date, "1901-01-01") < 0 ||
      g_strcmp0 (new_date, "2399-12-31") > 0)
    {
      showing_error = TRUE;
      show_error_dialog ("Date Picker Error",
                         "Date out of range.\n\n"
                         "Dates must be between 1901-01-01 and 2399-12-31");
      showing_error = FALSE;
      return FALSE;
    }

  if (!object || !prop_id)
    return TRUE;

  is_min = (g_strcmp0 (prop_id, "min-date") == 0);

  /* get value ot the other property */
  GladeWidget *gwidget = glade_widget_get_from_gobject (object);
  if (gwidget)
    {
      const gchar *other_id = is_min ? "max-date" : "min-date";
      GladeProperty *other_prop = glade_widget_get_property (gwidget, other_id);

      if (other_prop)
        {
          GValue value = G_VALUE_INIT;
          glade_property_get_value (other_prop, &value);
          if (G_VALUE_HOLDS_STRING (&value))
            other_date = g_value_dup_string (&value);
          g_value_unset (&value);
        }
    }

  actual_other_date = other_date;
  if (!actual_other_date || g_strcmp0 (actual_other_date, "") == 0)
    {
      actual_other_date = is_min ? "2399-12-31" : "1901-01-01";
    }

  if (is_valid_format (actual_other_date) == 0)
    {
      cmp = g_strcmp0 (new_date, actual_other_date);

      if (is_min && cmp > 0)
        {
          showing_error = TRUE;
          show_error_dialog ("Date Picker Error",
                             "Minimum date cannot be later than maximum date.");
          showing_error = FALSE;
          g_free (other_date);
          return FALSE;
        }
      if (!is_min && cmp < 0)
        {
          showing_error = TRUE;
          show_error_dialog (
            "Date Picker Error",
            "Maximum date cannot be earlier than minimum date.");
          showing_error = FALSE;
          g_free (other_date);
          return FALSE;
        }
    }

  g_free (other_date);
  return TRUE;
}

/*----------------------------------------------------------------------------*/
/* VALIDATE DATES                                                             */
/*----------------------------------------------------------------------------*/
gboolean
ada_date_picker_validate_dates (GladeEditorProperty *eprop, GValue *value,
                                gpointer user_data)
{
    GladeProperty *prop = glade_editor_property_get_property (eprop);
    GladePropertyDef *pdef = glade_property_get_def (prop);
    const gchar *prop_id = glade_property_def_id (pdef);
    const gchar *new_date = g_value_get_string (value);

    GladeWidget *gwidget = glade_property_get_widget (prop);
    GObject *object = glade_widget_get_object (gwidget);

    if (!ada_date_picker_validate_date_value (object, prop_id, new_date)) {
        glade_editor_property_load (eprop, prop);
        return FALSE;
    }

    return TRUE;
}
