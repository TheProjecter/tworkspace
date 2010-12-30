    
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.

#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.

#   You should have received a copy of the GNU General Public License
#   along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
#   Author Tigran Hovhannisyan - tigran.co.cc


BLDR_DIR	:= $(shell pwd)/tbuilder

MKF_DIR		:= $(BLDR_DIR)/core
TMPL_DIR	:= $(BLDR_DIR)/templates

include $(MKF_DIR)/macros.mk

.PHONY: wrong_arguments
wrong_arguments:
	@$(INFO) " You should type one of the the followings:" 
	@$(ENDL)
	@$(CODE) " make project" 
	@$(INFO) " - to create new project"
	@$(ENDL)
	@$(CODE) " make clean" 
	@$(ENDL)
	@$(CODE) " make remove" 
	@$(INFO) " - to remove one of the projects"
	@$(ENDL)
	@$(CODE) " make tar" 
	@$(INFO) " - to tar one of the projects"
	@$(ENDL)

.PHONY: project
project:
	@$(INFO) " Enter new project name: "
	@read P; if [ ! -d "$${P}" ]; then mkdir -p $${P}; echo "export BLDR_DIR	:= $(BLDR_DIR)\n \ninclude $(MKF_DIR)/macros.mk" > $${P}/makefile; cat $(TMPL_DIR)/first_time_makefile >> $${P}/makefile; $(CODE) " $${P}"; $(INFO) " project was created successfully."; echo; else $(ERROR) " There is another project with the name "; $(CODE) $${P}; fi

.PHONY: remove
remove: clean

.PHONY: clean
clean: 
	@$(INFO) " Enter the name of project you want to remove: "
	@read P; if [ -d "$${P}" ]; then rm -fr $${P}; $(CODE) " $${P}"; $(INFO) " was removed successfully."; echo; else if [ "$${P}" = "" ]; then $(ERROR) " You didn't type the name of the Project"; else $(ERROR) " There is no project named "; $(CODE) "$${P}"; $(ENDL); fi; fi

.PHONY: tar
tar: 
	@$(INFO) " Enter the name of project you want to tar: "
	@read P; if [ -d "$${P}" ]; then if [ -d "$${P}/src" ]; then make -C $${P} clean --no-print-directory; cp $${P}/makefile __$${P}__tmp_makefile; sed s/export\ MKF_DIR\.\*/export\ MKF_DIR\:\=\$$\(shell\ pwd\)\\/\.\.\\/tbuilder\\/core/ __$${P}__tmp_makefile > $${P}/makefile; tar cjf $${P}.tar.bz2 $${P} $(notdir $(BLDR_DIR)); cp __$${P}__tmp_makefile $${P}/makefile; rm __$${P}__tmp_makefile; $(CODE) " $${P}.tar.bz2"; $(INFO) " was created successfully."; echo; else  $(CODE) "  $${P}"; $(INFO) " is an empty project, there is no wise to create the tar of it. "; echo; fi; else  $(INFO) " There is no project named "; $(CODE) $${P}; echo; fi
