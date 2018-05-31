with Gtk.Main;
with Gtk.Box;             use Gtk.Box;
with Gtk.Button;          use Gtk.Button;
with Gtk.Dialog;          use Gtk.Dialog;
with Gtk.Enums;           use Gtk.Enums;
with Gtk.Frame;           use Gtk.Frame;
with Gtk.Handlers;        --use Gtk.Handlers;
with Gtk.Hbutton_Box;     use Gtk.Hbutton_Box;
with Gtk.Label;           use Gtk.Label;
with Gtk.Paned;           use Gtk.Paned;

with Gtk.Style;           use Gtk.Style;
with Gtk.Widget;          use Gtk.Widget;

with Help_Dialog;

package body Main_Frame is

   package Widget_Handler is new Gtk.Handlers.Callback (Gtk_Widget_Record);
   package Window_Cb is new Gtk.Handlers.Callback (Gtk_Widget_Record);
   package Return_Window_Cb is new Gtk.Handlers.Return_Callback
     (Gtk_Widget_Record, Boolean);

   procedure Exit_Main (Object : access Gtk_Widget_Record'Class);
   function Delete_Event      (Object : access Gtk_Widget_Record'Class) return Boolean;

   procedure Gtk_New (Win : out Main_Window) is
   begin
      Win := new Main_Window_Record;
      Initialize (Win);
   end Gtk_New;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize (Win : access Main_Window_Record'Class) is
      --Frame    : Gtk.Frame.Gtk_Frame;
      Label    : Gtk.Label.Gtk_Label;
      Vbox     : Gtk.Box.Gtk_Box;
      Style    : Gtk_Style;
      Button   : Gtk.Button.Gtk_Button;
      Bbox     : Gtk.Hbutton_Box.Gtk_Hbutton_Box;
      Paned    : Gtk_Paned;

   begin
      Gtk_New (Win.Frame);
      Gtk.Window.Initialize (Win, Gtk.Enums.Window_Toplevel);
      Set_Default_Size (Win, 800, 600);
      Window_Cb.Connect (Win, "destroy",
                         Window_Cb.To_Marshaller (Exit_Main'Access));
      Return_Window_Cb.Connect
        (Win, "delete_event",
         Return_Window_Cb.To_Marshaller (Delete_Event'Access));

      --  The global box
      Gtk_New_Vbox (Vbox, Homogeneous => False, Spacing => 0);
      Add (Win, Vbox);

      --  Label
      Style := Copy (Get_Style (Win));
      -- Set_Font_Description (Style, From_String ("Helvetica 12"));
      -- Another GTKAda3.3 change : but do we need Helvetica?

      Gtk_New (Label, "Drawing demonstration");
      Set_Style (Label, Style);
      Pack_Start (Vbox, Label, Expand => False, Fill => False, Padding => 10);

      Gtk_New_Hpaned (Paned);
      Add (Vbox, Paned);

      Set_Shadow_Type
        (Win.Frame, The_Type => Gtk.Enums.Shadow_None);
      Pack1 (Paned, Win.Frame);

      --Set_Position (Paned, 100);

      --  Button box for the buttons at the bottom
      --  Gtk_New_Hbox (Bbox, Homogeneous => True, Spacing => 10);
      Gtk_New (Bbox);
      Set_Layout (Bbox, Buttonbox_Spread);
      Set_Spacing (Bbox, 40);

      Gtk_New (Button, "Help");
      Pack_Start (Bbox, Button, Expand => True, Fill => False);
      Widget_Handler.Connect
        (Button, "clicked",
         Widget_Handler.To_Marshaller (Help_Dialog.Display_Help'Access));

      Gtk_New (Button, "Quit");
      Pack_Start (Bbox, Button, Expand => True, Fill => False);
      Window_Cb.Object_Connect
         (Button, "clicked",
          Window_Cb.To_Marshaller (Exit_Main'Access), Win);

      Pack_End (Vbox, Bbox, Expand => False, Padding => 5);

      --  Display everything
      Show_All (Vbox);

   end Initialize;

   -----------------
   --  Exit_Main  --
   -----------------

   procedure Exit_Main (Object : access Gtk_Widget_Record'Class) is
   begin
      Destroy (Object);
      Gtk.Main.Main_Quit;
   end Exit_Main;

   ------------------
   -- Delete_Event --
   ------------------

   function Delete_Event
     (Object : access Gtk_Widget_Record'Class) return Boolean
   is
      pragma Unreferenced (Object);
   begin
      --  We could return True to force the user to kill the window through the
      --  "Quit" button, as opposed to the icon in the title bar.
      return False;
   end Delete_Event;

end Main_Frame;
