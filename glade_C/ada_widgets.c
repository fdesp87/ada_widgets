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
#include "ada_widgets.h"

#define SPACES_10 "          "
#define SPACES_40 SPACES_10 SPACES_10 SPACES_10 SPACES_10
const gchar Blanks[41] = SPACES_40;

/*----------------------------------------------------------------------------*/
static inline gboolean Ada_Widgets_Verbose(void) {
    static gboolean checked = FALSE;
    static gboolean enabled = FALSE;

    if (!checked) {
        const gchar *env = g_getenv("ADA_WIDGETS_VERBOSE");
        enabled = (env != NULL && g_strcmp0(env, "1") == 0);
        checked = TRUE;
    }
    return enabled;
}

/*----------------------------------------------------------------------------*/
void Ada_Log(const gchar *format, ...) {
    if (Ada_Widgets_Verbose()) {
        va_list args;
        va_start(args, format);

        g_logv("Ada Widgets", G_LOG_LEVEL_MESSAGE, format, args);

        va_end(args);
    }
}

/*----------------------------------------------------------------------------*/
void
show_error_dialog (const gchar *title, const gchar *message)
{
    GtkWidget *dialog = gtk_message_dialog_new (
        NULL,
        GTK_DIALOG_MODAL | GTK_DIALOG_DESTROY_WITH_PARENT,
        GTK_MESSAGE_ERROR,
        GTK_BUTTONS_OK,
        "%s", message
    );
    gtk_window_set_title (GTK_WINDOW (dialog), title);
    gtk_dialog_run (GTK_DIALOG (dialog));
    gtk_widget_destroy (dialog);
}
