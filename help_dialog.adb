with Gtk.Box;             use Gtk.Box;
with Gtk.Button;          use Gtk.Button;
with Gtk.Dialog;          use Gtk.Dialog;
with Gtk.Enums;           use Gtk.Enums;
with Gtk.Handlers;
with Gtk.Label;           use Gtk.Label;
with Gtk.Scrolled_Window; use Gtk.Scrolled_Window;
with Gtk.Text_Buffer;     use Gtk.Text_Buffer;
with Gtk.Text_View;       use Gtk.Text_View;
with Gtk.Text_Iter;       use Gtk.Text_Iter;
with Gtk.Text_Mark;       use Gtk.Text_Mark;
with Gtk.Text_Tag;        use Gtk.Text_Tag;
with Gtk.Text_Tag_Table;  use Gtk.Text_Tag_Table;
with Gtk.Widget;          use Gtk.Widget;
with Gtk.Window;

with Glib.Properties;     use Glib.Properties;
with Gdk.Color;           use Gdk.Color;
with Ada.Strings.Fixed;

package body Help_Dialog is

   package Widget_Handler is new Gtk.Handlers.Callback (Gtk_Widget_Record);

   Current_Help : Help_Function := null;
   --  Returns the help string to display,
   --  Symbols between @b and @B are displayed in bold
   --  New lines should be represented by ASCII.LF

   Help_Dialog : Gtk.Dialog.Gtk_Dialog;
   Help_Text   : Gtk.Text_Buffer.Gtk_Text_Buffer;
   --  The dialog used to display the help window

   procedure Set_Help (Func : Help_Function) is
   begin
      Current_Help := Func;
      if Help_Dialog /= null then
         declare
            W : aliased Gtk_Widget_Record;
         begin
            Display_Help (W'Access);
         end;
      end if;
   end Set_Help;

   ------------------
   -- Destroy_Help --
   ------------------

   procedure Destroy_Help (Parent : access Gtk_Widget_Record'Class) is
      -- pragma Warnings (Off, Button);
   begin
      Destroy (Help_Dialog);
      Help_Dialog := null;
   end Destroy_Help;

   ------------------
   -- Display_Help --
   ------------------

   procedure Display_Help (Parent : access Gtk_Widget_Record'Class) is
      Close     : Gtk.Button.Gtk_Button;
      Scrolled  : Gtk_Scrolled_Window;
      Label     : Gtk.Label.Gtk_Label;
      View      : Gtk_Text_View;
      Iter, Last : Gtk_Text_Iter;
      Blue_Tag, Tag  : Gtk_Text_Tag;
      Mark       : Gtk_Text_Mark;

      procedure Show_Text_With_Tag
        (Iter : in out Gtk_Text_Iter; Text : String);
      --  Insert Text in the help dialog, using Tag to set the color

      procedure Show_Text_With_Tag
        (Iter : in out Gtk_Text_Iter; Text : String)
      is
         Last : Gtk_Text_Iter;
      begin
         if Mark /= null then
            Move_Mark (Help_Text, Mark, Iter);
         else
            Mark := Create_Mark (Help_Text, "", Iter);
         end if;

         Insert (Help_Text, Iter, Text);
         if Tag /= null then
            Get_Iter_At_Mark (Help_Text, Last, Mark);
            Apply_Tag (Help_Text, Tag, Last, Iter);
         end if;
      end Show_Text_With_Tag;

   begin
      if Help_Dialog = null then
         Gtk_New (Help_Dialog);
         -- Set_Policy (Help_Dialog, Allow_Shrink => True, Allow_Grow => True,
         --            Auto_Shrink => True);
         -- find a replacement in GtkAda3.8?
         Set_Title (Help_Dialog, "testgtk help");
         Set_Default_Size (Help_Dialog, 640, 450);

         -- eliminate new "Gtk-Message: GtkDialog mapped without a transient parent." warning
         Set_Transient_For (Help_Dialog, Gtk.Window.Gtk_Window (Get_Toplevel (Parent)));

         Set_Spacing (Get_Content_Area (Help_Dialog), 3);

         Gtk_New (Label, "Information on this demo");
         Pack_Start (Get_Content_Area (Help_Dialog), Label, False, True, 0);

         Gtk_New (Scrolled);
         Pack_Start (Get_Content_Area (Help_Dialog), Scrolled, True, True, 0);
         Set_Policy (Scrolled, Policy_Automatic, Policy_Automatic);

         Gtk_New (Help_Text);
         Gtk_New (View, Help_Text);
         Add (Scrolled, View);
         Set_Editable (View, False);
         Set_Wrap_Mode (View, Wrap_Mode => Wrap_Word);

         Gtk_New (Close, "Close");
         Pack_Start (Get_Action_Area (Help_Dialog), Close, False, False);
         Widget_Handler.Object_Connect
           (Close, "clicked",
            Widget_Handler.To_Marshaller (Destroy_Help'Access),
            Slot_Object => Help_Dialog);
         Set_Can_Default(Close, True);
         Grab_Default (Close);

         Blue_Tag := Create_Tag (Help_Text, "blue");
         Set_Property (Blue_Tag, Gtk.Text_Tag.Foreground_Property, "blue");

      else
         Get_Start_Iter (Help_Text, Iter);
         Get_End_Iter   (Help_Text, Last);
         Delete (Help_Text, Iter, Last);

         Blue_Tag := Lookup (Get_Tag_Table (Help_Text), "blue");
      end if;

      Get_Start_Iter (Help_Text, Iter);
      Tag := null;

      if Current_Help = null then
         Insert (Help_Text, Iter, "No help available");
      else

         declare
            Help  : constant String := Current_Help.all;
            Pos   : Natural := Help'First;
            First : Natural;
            Blue  : Gdk_Color;
            Newline : constant String := (1 => ASCII.LF);

            Line_End : Natural;
            --  Points to the first character of the next line

         begin
            Set_Rgb (Blue, 16#0#, 16#0#, 16#FFFF#);
            -- Alloc (Get_Default_Colormap, Blue);

            loop

               --  The end of the line can be at most Max_Length character,
               --  finishing at the first previous white space. Stops at the
               --  first Newline encountered if any

               Line_End := Help'Last + 1;

               First := Ada.Strings.Fixed.Index
                 (Help (Pos .. Line_End - 1), Newline);
               if First /= 0 then
                  Line_End := First;
               end if;

               --  Scan and print the line

               while Pos < Line_End loop

                  --  Any special sections to highlight ?

                  First := Ada.Strings.Fixed.Index
                    (Help (Pos .. Line_End - 1), "@");

                  if First = 0 or First = Line_End - 1 then
                     Show_Text_With_Tag (Iter, Help (Pos .. Line_End - 1));
                     Pos := Line_End;

                  else
                     Show_Text_With_Tag (Iter, Help (Pos .. First - 1));

                     case Help (First + 1) is
                        when 'b' =>
                           Tag := Blue_Tag;
                           Pos := First + 2;
                        when 'B' =>
                           Tag := null;
                           Pos := First + 2;
                        when others =>
                           Show_Text_With_Tag (Iter, "@");
                           Pos := First + 1;
                     end case;
                  end if;
               end loop;

               Pos := Pos + 1;
               exit when Pos > Help'Last;

               Insert (Help_Text, Iter, Newline);
            end loop;
         end;
      end if;

      Show_All (Help_Dialog);
   end Display_Help;


end Help_Dialog;
