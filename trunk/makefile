    
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


bldr_path	:= $(shell pwd)/tbuilder
utilities_path	:= $(shell pwd)/utilities

core_path	:= $(bldr_path)/core
tmpl_path	:= $(bldr_path)/templates

include $(core_path)/macros.mk

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
	@read P; \
	if [ "$${P}" = "" ]; then \
		$(ERROR) " You didn't type the project name."; $(ENDL); \
	else if [ ! -d "$${P}" ]; then \
		mkdir -p $${P}; \
		echo "export bldr_path	:= $(bldr_path)" > $${P}/makefile;\
		echo "utilities_path := $(utilities_path)" >> $${P}/makefile;\
		echo "include $(core_path)/macros.mk" >> $${P}/makefile;\
		cat $(tmpl_path)/first_time_makefile >> $${P}/makefile; \
		$(CODE) " $${P}"; \
		$(INFO) " project was created successfully."; $(ENDL);\
	else \
		$(ERROR) " There is another project with the name "; $(ENDL); \
		$(CODE) $${P}; fi; fi

.PHONY: remove
remove: clean

.PHONY: clean
clean: 
	@$(INFO) " Enter the project name you want to remove: "
	@read P; \
	if [ -d "$${P}" ]; then \
		rm -fr $${P}; \
		$(CODE) " $${P}"; \
		$(INFO) " was removed successfully."; $(ENDL); \
	else if [ "$${P}" = "" ]; then \
		$(ERROR) " You didn't type the the project name"; $(ENDL); \
		else \
			$(ERROR) " There is no project named "; \
			$(CODE) "$${P}"; $(ENDL); \
		fi; \
	fi

.PHONY: tar
tar: 
	@$(INFO) " Enter the project name you want to tar: "
	@read P; \
	if [ "$${P}" = "" ]; then \
		$(ERROR) " You didn't type the project name."; $(ENDL); \
	else if [ -d "$${P}" ]; then \
		if [ -d "$${P}/src" ]; then \
			make -C $${P} distclean --no-print-directory; \
			cp $${P}/makefile __$${P}__tmp_makefile; \
			sed s/export\ core_path\.\*/export\ core_path\:\=\$$\(shell\ pwd\)\\/\.\.\\/tbuilder\\/core/ __$${P}__tmp_makefile > $${P}/makefile; \
			tar cjf $${P}.tar.bz2 $${P} $(notdir $(bldr_path)); \
			cp __$${P}__tmp_makefile $${P}/makefile; \
			rm __$${P}__tmp_makefile; \
			$(CODE) " $${P}.tar.bz2"; \
			$(INFO) " was created successfully."; $(ENDL) \
		else  \
			$(CODE) "  $${P}"; \
			$(INFO) " is an empty project, there is no wise to create the tar of it. "; $(ENDL); \
		fi; \
	else  \
		$(INFO) " There is no project named "; \
		$(CODE) $${P}; $(ENDL); \
	fi; \
	fi
