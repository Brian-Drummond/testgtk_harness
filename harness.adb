-----------------------------------------------------------------------
--          GtkAda - Ada95 binding for the Gimp Toolkit              --
--                                                                   --
--                     Copyright (C) 1998-1999                       --
--        Emmanuel Briot, Joel Brobecker and Arnaud Charlet          --
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

with Gtk.Main;
with Gtk.Rc;
with Main_Frame;

-- substitute any Create_xxx from testgtk here
-- Use clause exposes its Help and Run subprograms

--with Create_Canvas;           use Create_Canvas;
with Create_Calendar;          use Create_Calendar;	

procedure Harness is
   Win : Main_Frame.Main_Window;

begin
--   Gtk.Main.Set_Locale; -- what happened to Set_Locale in Gtkada 3.8.3?
   Gtk.Main.Init;
--   Gtk.Rc.Parse ("testgtkrc");
   Main_Frame.Gtk_New (Win);
   Main_Frame.Show_All (Win);

   Main_Frame.Set_Help(Help'access);

   Run(Win.Frame);
   
   Gtk.Main.Main;
end Harness;
