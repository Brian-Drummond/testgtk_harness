with Gtk.Widget;       use Gtk.Widget;
with Gtk.Window;
with Gtk.Frame;


package Main_Frame is

   type Main_Window_Record is new Gtk.Window.Gtk_Window_Record with
      record
         Frame       : Gtk.Frame.GTK_Frame;
      end record;
   type Main_Window is access all Main_Window_Record'Class;

   procedure Gtk_New (Win : out Main_Window);
   procedure Initialize (Win : access Main_Window_Record'Class);

   type Help_Function is access function return String;

   procedure Set_Help (Func : Help_Function);

   procedure Display_Help (Button : access Gtk_Widget_Record'Class);

   procedure Destroy_Help (Button : access Gtk_Widget_Record'Class);

end Main_Frame;
