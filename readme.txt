------------------------------------------------------------------------

RATIONALE:

Starting with gtkada or any new GUI toolkit can be daunting. 

Some fairly trivial tutorial examples can be found in "examples" but
they are often incomplete, e.g. they don't all make the calls required 
to shut themselves down properly.

There is one large demo program, testgtk, found in "testgtk", which gives 
a good example of how many of the tools available in GTKAda (such as 
scrollbars, Cairo drawing) etc work. Build it and see what each tool does.

Having found a useful example tool in Testgtk, this harness makes it easier
to extract that tool into a simple but reasonably complete stand-alone 
program, which can serve as the starting point for your widget or application.

Folders  "examples" and "testgtk" are in the GTKAda source directory. 
If you installed GTKAda from Debian packages, they are installed to 
/usr/share/doc/libgtkada-doc/examples/ but currently this only seems to contain
testgtk.gz.

------------------------------------------------------------------------

Prerequisites

The following has been built and tested on Debian Stretch, with Gnat 6.3 and 
GTKAda 3.8.3 installed from the Debian packages 
libgtkada-bin libgtkada-doc libgtkada3.8.3 libgtkada3.8.3-dev

GTKAda is also available via Adacore's github page
https://github.com/AdaCore/gtkada
or via downloads from libre.adacore.com

------------------------------------------------------------------------

Main program and project are harness.adb and harness.gpr.

To use, first "git clone" this repo into a new directory.

Copy the create_xxx package (.ads,.adb files) you want to test (e.g. 
create_calendar.ads, create_calendar.adb) into this folder, 
and edit its name into the "with/use" clauses in harness.adb.

Some packages may also need the Common package (common.ads,adb) and 
specific resource files (testgtk.rc, bitmaps etc). The Cairo example 
package requires the Testcairo_Drawing package.

Build instructions :

mkdir obj
(only needed before the first build)
gnatmake -P harness.gpr
or 
gprbuild harness.gpr

If build fails because of further missing resources, get them from the 
TestGTK package.

------------------------------------------------------------------------

CHANGES: 30 May 2018
	Updated from GTKAda-2.4.14 to GTKAda-3.8.3
	Brought under git version control

------------------------------------------------------------------------

NOTE regarding the create_builder example.

create_builder originally used the gtkbuilder_example.xml example. 
However this includes one button "on_print_to_console" whose handlers 
are somewhere else in the TestGTK code. To overcome this, edit 
create_builder.adb as below to use the supplied "harness_example.xml" 
file without this button.

-- Default_Filename : constant String := "gtkbuilder_example.xml";
   Default_Filename : constant String := "harness_example.xml";

------------------------------------------------------------------------

NOTE regarding .gitignore

By default, it ignores the create_xxx package files as they are not part 
of the harness. If you use this project as the starting point for your own, 
just edit .gitignore to track them.

------------------------------------------------------------------------

License : this example harness is supplied under the same license as the 
TestGTK example. Enjoy.

-----------------------------------------------------------------------
