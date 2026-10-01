-------------------------------------------------------------------------------
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
--  LICENSE.GLP and LICENSE.LGPL. If not, see <http:--www.gnu.org-licenses-> --                              --
-------------------------------------------------------------------------------
with Glib.Properties;          use Glib.Properties;
with Glib.Properties.Creation; use Glib.Properties.Creation;
with Glib.Object;              use Glib.Object;
with Glade_Binding.Widget;

with Ada_Widgets.Time_Picker.Implem;

package body Ada_Widgets.Time_Picker.Glade is

   -------------------------------------------
   --  SET_PROPERTY                         --
   -------------------------------------------
   procedure Set_Property (Adtor        : Adaptor;
                           Object       : GObject_Ptr;
                           Id           : chars_ptr;
                           Value_Access : access GValue) is
      Prop_Spec : constant Param_Spec := null;
      Prop_Id   : Property_Id := 0;
      Id_Str    : constant String := Interfaces.C.Strings.Value (Id);
      Stub      : GObject_Record;
   begin
      if Id_Str = "time-zone" then
         Prop_Id := PROP_TIME_ZONE;
      end if;
      if Prop_Id = PROP_TIME_ZONE then
         Ada_Log ("ada_widgets.time_picker.glade.set_property: "
                  & "id=" & Id_Str
                  & ", object=" & Type_Name (Get_Type (Get_User_Data (-Object, Stub)))
                  & "(" & To_Hex (Object'Image) & ")");

         Ada_Widgets.Time_Picker.Implem.Set_Property
           (Object        => Object,
            Prop_Id       => Prop_Id,
            Value         => Value_Access.all,
            Property_Spec => Prop_Spec);
         return;
      end if;

      --  general case
      --  Ada_Log ("ada_widgets.time_picker.glade.set_property: "
      --           & "Id=" & Id_Str & ASCII.LF
      --           & Blanks & "adaptor=" & Value (Get_Name (Adtor))
      --           & " (" & To_Hex (Adtor'Image) & ")" & ASCII.LF
      --           & Blanks & "object=" & Type_Name (Get_Type (Get_User_Data (-Object, Stub)))
      --           & " (" & To_Hex (Object'Image) & ")");
      declare
         Parent_Adtor       : Adaptor;
         Parent_Adtor_Class : Adaptor_Class;
      begin
         Parent_Adtor := Get_Parent_Adaptor (Adtor);
         if Parent_Adtor /= null then
            Parent_Adtor_Class := Get_Adaptor_Class (Parent_Adtor);
            if Parent_Adtor_Class /= null
              and then Parent_Adtor_Class.Set_Property /= null
            then
               Parent_Adtor_Class.Set_Property (Parent_Adtor, Object, Id, Value_Access);
            end if;
         end if;
      end;

   end Set_Property;

   -------------------------------------------
   --  GET_PROPERTY                         --
   -------------------------------------------
   procedure Get_Property (Adtor        : Adaptor;
                           Object       : GObject_Ptr;
                           Id           : chars_ptr;
                           Value_Access : access GValue) is
      Prop_Spec : constant Param_Spec := null;
      Prop_Id   : Property_Id := 0;
      Id_Str    : constant String := Interfaces.C.Strings.Value (Id);
      Stub      : GObject_Record;
   begin
      if Id_Str = "time-zone" then
         Prop_Id := PROP_TIME_ZONE;
      end if;
      if Prop_Id = PROP_TIME_ZONE then
         Ada_Log ("ada_widgets.time_picker.glade.get_property: "
                  & "Id=" & Id_Str
                  & ", object=" & Type_Name (Get_Type (Get_User_Data (-Object, Stub)))
                  & "(" & To_Hex (Object'Image) & ")");

         Ada_Widgets.Time_Picker.Implem.Get_Property
           (Object        => Object,
            Prop_Id       => Prop_Id,
            Value         => Value_Access.all,
            Property_Spec => Prop_Spec);
         return;
      end if;

      --  general case
      --  Ada_Log ("ada_widgets.time_picker.glade.get_property: "
      --           & "Id=" & Id_Str & ASCII.LF
      --           & Blanks & "adaptor=" & Value (Get_Name (Adtor))
      --           & " (" & To_Hex (Adtor'Image) & ")" & ASCII.LF
      --           & Blanks & "object=" & Type_Name (Get_Type (Get_User_Data (-Object, Stub)))
      --           & " (" & To_Hex (Object'Image) & ")");
      declare
         Parent_Adtor       : Adaptor;
         Parent_Adtor_Class : Adaptor_Class;
      begin
         Parent_Adtor := Get_Parent_Adaptor (Adtor);
         if Parent_Adtor /= null then
            Parent_Adtor_Class := Get_Adaptor_Class (Parent_Adtor);
            if Parent_Adtor_Class /= null
              and then Parent_Adtor_Class.Get_Property /= null
            then
               Parent_Adtor_Class.Get_Property (Parent_Adtor, Object, Id, Value_Access);
            end if;
         end if;
      end;

   end Get_Property;

   -------------------------------------------
   --       POST CREATE                     --
   -------------------------------------------
   procedure Post_Create (Adtor   : Adaptor;
                          Object  : GObject_Ptr;
                          Reason  : Glade_Create_Reason) is
      Stub : GObject_Record;
   begin
      Ada_Log ("ada_widgets.time_picker.glade.post_create: " & ASCII.LF
               & Blanks & "adaptor=" & Value (Get_Name (Adtor))
               & " (" & To_Hex (Adtor'Image) & ")" & ASCII.LF
               & Blanks & "object=" & Type_Name (Get_Type (Get_User_Data (-Object, Stub)))
               & " (" & To_Hex (Object'Image) & ")" & ASCII.LF
               & Blanks & "reason=" & Reason'Image);

      if Reason = Glade_Create_Load or Reason = Glade_Create_User or Reason = Glade_Create_Copy
      then
         Glade_Binding.Widget.Push_Superuser;
         Ada_Widgets.Time_Picker.Implem.Build (Object => Get_User_Data (-Object, Stub),
                                            Show   => True);
         Glade_Binding.Widget.Pop_Superuser;
      end if;

   end Post_Create;

end Ada_Widgets.Time_Picker.Glade;
