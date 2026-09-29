# ada_widgets
Ada custom widgets for Gtk3: date picker and time picker.

Gtk3 provide a native calendar but there are not native date pickers nor time pickers.

Components in the distribution
------------------------------
- the Ada Widgets source library, in Ada. Included the sources, the gpr and the Makefile
- the interface to Glade in C. Included the XML, the C sources with the xml, gpr and Makefile
- the interface to Glade in Ada. Included the XML, the C sources with the xml, gpr and Makefile
- the icons for the Glade interface, really copies of the ones distributed with Gtk libraries
- Demo1 program. This demo uses the Ada_Widgets library directly
- Demo2 program. This demo uses the Ada_Widgets library with GtkBuilder
- The Glade UI Ada binding. This binding covers all that was needed, however it is not complete. It is
  used by the interface to Glade in Ada.

Dependencies
------------

You should have the following tools installed:

- The GNAT Ada Compilation System, including GNAT Studio.. Ada Core Technologies (ACT) 
Community editions are OK
- GTK Libraries
- Glade
- The GtkAda library also from ACT

Building
--------
Use the gpr and Makefiles provided.

You can install the Ada Widgets library in the GNAT tree.

If using it with the GtkBuilder, as the custom widgets, when instantiated by GtkBuilder, are 
not initialized automatially, it is necessary to place a call to initialice. This is a limitation 
of gtkada. See demo2.

The Glade interface (xml and either the C or the Ada libraries) should be installed as Glade indicates.
These two Ada and C libraries are functionally equivalents.

Using
-----
The demo1 and demo2 Ada programs show how to use, either in a direct form or using GtkBuilder.

For demo2 you need to install the Ada Widgets source library in the GNAT tree.

Glade support: if you install the xml and the Ada or C library in the appropriate places (see Glade) and the icons,
these Ada widgets will be available in the Glade editor, in the custom widgets page (accessed with the three
vertical points). Glade previewer is also supported.

Bug reports
-----------
Please send questions and bug reports to the author. Of course, any help/contributions are
welcome.
