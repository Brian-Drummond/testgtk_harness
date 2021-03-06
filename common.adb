-----------------------------------------------------------------------
--          GtkAda - Ada95 binding for the Gimp Toolkit              --
--                                                                   --
--                     Copyright (C) 1998-1999                       --
--        Emmanuel Briot, Joel Brobecker and Arnaud Charlet          --
--                     Copyright (C) 2003-2006 AdaCore               --
--                                                                   --
-- This library is free software; you can redistribute it and/or     --
-- modify it under the terms of the GNU General Public               --
-- License as published by the Free Software Foundation; either      --
-- version 2 of the License, or (at your option) any later version.  --
--                                                                   --
-- This library is distributed in the hope that it will be useful,   --
-- but WITHOUT ANY WARRANTY; without even the implied warranty of    --
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU --
-- General Public License for more details.                          --
--                                                                   --
-- You should have received a copy of the GNU General Public         --
-- License along with this library; if not, write to the             --
-- Free Software Foundation, Inc., 59 Temple Place - Suite 330,      --
-- Boston, MA 02111-1307, USA.                                       --
--                                                                   --
-----------------------------------------------------------------------

with Gtk.Menu;             use Gtk.Menu;
with Gtk.Radio_Menu_Item;  use Gtk.Radio_Menu_Item;
with Gtk.Enums;            use Gtk.Enums;
with Gdk.Color;            use Gdk.Color;

with Ada.Strings.Fixed;

package body Common is

   -------------------------
   --  Build_Option_Menu  --
   -------------------------

   procedure Build_Option_Menu
     (Omenu   : out Gtk.Option_Menu.Gtk_Option_Menu;
      Gr      : in out Widget_SList.GSlist;
      Items   : Chars_Ptr_Array;
      History : Gint;
      Cb      : Widget_Handler.Marshallers.Void_Marshaller.Handler)

   is
      Menu      : Gtk_Menu;
      Menu_Item : Gtk_Radio_Menu_Item;

   begin
      Gtk.Option_Menu.Gtk_New (Omenu);
      Gtk_New (Menu);

      for I in Items'Range loop
         Gtk_New (Menu_Item, Gr, ICS.Value (Items (I)));
         Widget_Handler.Object_Connect (Menu_Item, "activate",
                                        Widget_Handler.To_Marshaller (Cb),
                                        Slot_Object => Menu_Item);
         Gr := Get_Group (Menu_Item);
         Append (Menu, Menu_Item);
         if Gint (I) = History then
            Set_Active (Menu_Item, True);
         end if;
         Show (Menu_Item);
      end loop;
      Gtk.Option_Menu.Set_Menu (Omenu, Menu);
      Gtk.Option_Menu.Set_History (Omenu, History);
   end Build_Option_Menu;


   --------------------
   -- Destroy_Window --
   --------------------

   procedure Destroy_Window (Win : access Gtk.Window.Gtk_Window_Record'Class;
                             Ptr : in Gtk_Window_Access) is
      pragma Warnings (Off, Win);
   begin
      Ptr.all := null;
   end Destroy_Window;

   --------------------
   -- Destroy_Dialog --
   --------------------

   procedure Destroy_Dialog (Win : access Gtk.Dialog.Gtk_Dialog_Record'Class;
                             Ptr : in Gtk_Dialog_Access) is
      pragma Warnings (Off, Win);
   begin
      Ptr.all := null;
   end Destroy_Dialog;

   --------------
   -- Image_Of --
   --------------

   function Image_Of (I : in Gint) return String is
   begin
      return Ada.Strings.Fixed.Trim (Gint'Image (I), Ada.Strings.Left);
   end Image_Of;

end Common;
