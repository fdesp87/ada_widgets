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
with Interfaces;    use Interfaces;
with Glib.Messages; use Glib.Messages;
with Gtk.Message_Dialog; use Gtk.Message_Dialog;
with Gtk.Dialog;         use Gtk.Dialog;
with Gtk.Enums;          use Gtk.Enums;
with Glib;               use Glib;

package body Ada_Widgets is

   -------------------------------
   --  TO HEX                   --
   -------------------------------
   function To_Hex (Input : String) return String is
      Val          : Long_Long_Integer;
      Unsigned_Val : Unsigned_64;
      Hex_Chars    : constant array (0 .. 15) of Character :=
                       ('0', '1', '2', '3', '4', '5', '6', '7',
                       '8', '9', 'A', 'B', 'C', 'D', 'E', 'F');
      Temp         : Unsigned_64;
      Result       : String (1 .. 16);
      Hex_Input    : constant String := Input;
      First        : Positive;
      Last         : Natural;
   begin
      -- Ada access representation:
      -- "(access 5DB57A5F64D0)"
      if Input'Length >= 9
        and then Input (Input'First .. Input'First + 7) = "(access "
        and then Input (Input'Last) = ')'
      then
         First := Input'First + 8;
         Last  := Input'Last - 1;

         -- Convert hexadecimal digits manually.
         Unsigned_Val := 0;

         for I in First .. Last loop
            Unsigned_Val := Unsigned_Val * 16;

            case Input (I) is
               when '0' .. '9' =>
                  Unsigned_Val :=
                    Unsigned_Val + Unsigned_64
                      (Character'Pos (Input (I)) - Character'Pos ('0'));

               when 'A' .. 'F' =>
                  Unsigned_Val :=
                    Unsigned_Val + Unsigned_64
                      (Character'Pos (Input (I)) - Character'Pos ('A') + 10);

               when 'a' .. 'f' =>
                  Unsigned_Val :=
                    Unsigned_Val + Unsigned_64
                      (Character'Pos (Input (I)) - Character'Pos ('a') + 10);

               when others =>
                  return "ERROR: invalid hexadecimal entry";
            end case;
         end loop;

      else
         -- Existing behaviour: decimal input.
         Val := Long_Long_Integer'Value (Hex_Input);

         if Val < 0 then
            Unsigned_Val := Unsigned_64'Mod (Val);
         else
            Unsigned_Val := Unsigned_64 (Val);
         end if;
      end if;

      Temp := Unsigned_Val;

      for I in reverse Result'Range loop
         Result (I) := Hex_Chars (Integer (Temp mod 16));
         Temp := Temp / 16;
      end loop;

      return "16#" & Result & "#";

   exception
      when others =>
         return "ERROR: invalid entry or out of range: " & Input;
   end To_Hex;

   -------------------------------
   --  Ada LOG                  --
   -------------------------------
   procedure Ada_Log (Msg : String) is
   begin
      if Verbose then
         Log ("Ada Widgets", Log_Level_Message, MSg);
      end if;
   end Ada_Log;

   -------------------------------
   --  SHOW ERROR DIALOG        --
   -------------------------------
   procedure Show_Error_Dialog (Title   : String;
                                Message : String) is
      Dialog : Gtk_Message_Dialog;
   begin
      Gtk_New
        (Dialog   => Dialog,
         Parent   => null,
         Flags    => Modal,
         The_Type => Message_Error,
         Buttons  => Buttons_Ok,
         Message  => Message);

      Set_Title (Dialog, Title);
      Set_Position (Dialog, Win_Pos_Center_On_Parent);

      declare
         Response : constant Gtk_Response_Type := Run (Dialog);
         pragma Unreferenced (Response);
      begin
         null;
      end;

      Destroy (Dialog);
   end Show_Error_Dialog;

end Ada_Widgets;
