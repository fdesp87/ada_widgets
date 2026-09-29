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

ifndef prefix
    GNATMAKE_PATH := $(realpath $(shell which gnatmake 2>/dev/null))
    ifneq ($(GNATMAKE_PATH),)
        prefix := $(patsubst %/,%,$(dir $(dir $(GNATMAKE_PATH))))
    else
        $(error Error: GNAT is not installed, not in PATH, and prefix is not defined)
    endif
endif

all-libs:
	gprbuild -Pada_widgets -XGTKADA_BUILD=relocatable -j4
	gprbuild -Pada_widgets -XGTKADA_BUILD=static-pic -j4
	gprbuild -Pada_widgets -XGTKADA_BUILD=static -j4

install-libs:
ifneq (,$(wildcard $(IPREFIX)/share/gpr/manifests/ada_widgets))
	gprinstall -f --uninstall --prefix=$(prefix) ada_widgets
endif
	gprinstall -Pada_widgets -p -f -XGTKADA_BUILD=relocatable --build-name=relocatable \
			--build-var=Ada_Widgets,LIBRARY_TYPE --prefix=${prefix}
	gprinstall -Pada_widgets -p -f -XGTKADA_BUILD=static-pic  --build-name=static-pic  \
			--build-var=Ada_Widgets,LIBRARY_TYPE --prefix=${prefix}
	gprinstall -Pada_widgets -p -f -XGTKADA_BUILD=static      --build-name=static \
			--build-var=Ada_Widgets,LIBRARY_TYPE --prefix=${prefix}
 
clean:
	rm -Rf ali
	rm -Rf lib
	rm -Rf obj
