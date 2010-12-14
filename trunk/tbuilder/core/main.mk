
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

SHELL		= /bin/sh

PROJECTS_PATHS 	= $(addprefix src/,$(PROJECTS))

.PHONY: all
all 		: $(dev_root)/run $(PROJECTS_PATHS)

$(dev_root)/run :  
	@$(INFO) " GEN run ... "
	@echo "#!/bin/bash" > $(DEV_ROOT)/run
	@echo "export LD_LIBRARY_PATH=$(LIB_DIR)" >> $(DEV_ROOT)/run
	@chmod a+x  $(DEV_ROOT)/run
	@$(DONE)

.PHONY: $(PROJECTS_PATHS)
$(PROJECTS_PATHS) : 
	@mkdir -p $(OBJ_DIR)/$(notdir $@)
	@mkdir -p $(BIN_DIR)
	@mkdir -p $(LIB_DIR)
	@mkdir -p $(DEP_DIR)/$(notdir $@)
	@make -C $@ --no-print-directory

