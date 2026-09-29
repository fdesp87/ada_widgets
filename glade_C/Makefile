#-------------------------------------------------------------------------------
#--                          A d a   W i d g e t s                            --
#--                                                                           --
#--                     Copyright (C) 2026 Juan L. Freniche                   --
#--                                                                           --
#--  This program is free software;  you can redistribute it and-or modify it --
#--  under terms of the  GNU General Public License and/or the GNU Lesser     --
#--  General Public License, published by the Free Software  Foundation;      --
#--  either versions 3,  or (at your  option) any later version.              --
#--  It is is distributed in the hope that it will be useful, but             --
#--  WITHOUT ANY WARRANTY;  without even the implied warranty of MERCHAN-     --
#--  TABILITY or FITNESS FOR A PARTICULAR PURPOSE.                            --
#--                                                                           --
#--  You should have received a copy of the GNU General Public License and of --
#--  the GNU Lesser General Public License along with this program; see files --
#--  LICENSE.GLP and LICENSE.LGPL. If not, see <http:--www.gnu.org-licenses-> --                              --
#-------------------------------------------------------------------------------

# Variables
GPRBUILD = gprbuild
GPRCLEAN = gprclean
PROJECT  = ./ada_widgets.gpr
LIB_NAME = ./lib/libada_widgets.so
XML_FILE = ./ada_widgets.xml
INSTALL_DIR = $(HOME)/.local/share/glade
SYSTEM_ICON_DIR = /usr/share/glade/pixmaps/hicolor/16x16/actions

# Target: Compile the library in Optimized mode (default first target)
all-optim:
	@echo "Compiling with gprbuild (Optimize)..."
	@$(GPRBUILD) -P $(PROJECT) -XBUILD=Optimize

# Target: Compile the library in Debug mode
all-debug:
	@echo "Compiling with gprbuild (Debug)..."
	@$(GPRBUILD) -P $(PROJECT) -XBUILD=Debug

# Target: Install files
install: all-optim
	@echo "Creating destination directories..."
	@mkdir -p $(INSTALL_DIR)
	@mkdir -p $(INSTALL_DIR)/catalogs
	@mkdir -p $(INSTALL_DIR)/modules
	@echo "Checking XML file..."
	@if cmp -s "$(XML_FILE)" "$(INSTALL_DIR)/catalogs/ada_widgets.xml"; then \
		echo "XML file is already identical, skipping copy."; \
	else \
		echo "Installing $(XML_FILE) to $(INSTALL_DIR)/catalogs..."; \
		cp $(XML_FILE) $(INSTALL_DIR)/catalogs/; \
	fi
	@echo "Checking Library file..."
	@if cmp -s "$(LIB_NAME)" "$(INSTALL_DIR)/modules/libada_widgets.so"; then \
		echo "Library file is already identical, skipping copy."; \
	else \
		echo "Installing $(LIB_NAME) to $(INSTALL_DIR)/modules..."; \
		cp $(LIB_NAME) $(INSTALL_DIR)/modules/; \
	fi

# Clean temporary build files
clean:
	@echo "Cleaning..."
	@$(GPRCLEAN) -P $(PROJECT)
	@echo "Removing installed files..."
	@rm -f $(INSTALL_DIR)/catalogs/ada_widgets.xml
	@rm -f $(INSTALL_DIR)/modules/libada_widgets.so

.PHONY: all-optim all-debug install clean
