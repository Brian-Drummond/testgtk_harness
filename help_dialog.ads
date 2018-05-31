with Gtk.Widget;

package Help_Dialog is

   type Help_Function is access function return String;

   procedure Set_Help (Func : Help_Function);

   procedure Display_Help (Parent : access Gtk.Widget.Gtk_Widget_Record'Class);

end Help_Dialog;
