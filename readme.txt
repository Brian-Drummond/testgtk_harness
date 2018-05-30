-----------------------------------------------------------------------

Main program and project are harness.adb and harness.gpr.

To use, copy the create_xxx package you want to test into this folder, 
and edit its name into the "with/use" clauses in harness.adb.

Some packages may also need the Common package (common.ads,adb) and 
specific resource files (testgtk.rc, bitmaps etc).

create_builder originally used the gtkbuilder_example.xml example. 
However this includes one button "on_print_to_console" whose handlers 
are somewhere else in the TestGTK code. To overcome this, edit 
create_builder.adb as below to use the supplied "harness_example.xml" 
file without this button.

-- Default_Filename : constant String := "gtkbuilder_example.xml";
   Default_Filename : constant String := "harness_example.xml";

Build instructions :

mkdir obj
(before the first build)
gnatmake -P harness.gpr

License : this example harness is supplied under the same license as the 
TestGTK example.

-----------------------------------------------------------------------

