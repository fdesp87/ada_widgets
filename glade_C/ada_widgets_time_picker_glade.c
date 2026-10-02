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
/* GET TYPE                                                                   */
/*----------------------------------------------------------------------------*/
G_MODULE_EXPORT GType
ada_widgets_time_picker_glade_get_type (void)
{
  Ada_Log ("ada_widgets_time_picker_glade_get_type");
  ada_widgets_time_picker_implem_get_type();
}


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
           Blanks, G_OBJECT_TYPE_NAME (object), (void *)object, Blanks,
           (int)reason);

  if ((reason = GLADE_CREATE_LOAD) || (reason = GLADE_CREATE_COPY)
        || (reason = GLADE_CREATE_USER))
    {
      glade_widget_push_superuser ();
      ada_widgets_time_picker_implem_build (object, FALSE);
      glade_widget_pop_superuser ();
    }
}
