
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

include $(MKF_DIR)/macros.mk

.PHONY: exe ntg
exe : $(DEPS_PATHS) $(DEV_ROOT)/run ntg $(BIN_DIR)/$(PROJECT_NAME)

ntg:
	@donothing=1

$(DEV_ROOT)/run :  
	@echo "#!/bin/bash" > $(DEV_ROOT)/run
	@echo "export LD_LIBRARY_PATH=$(LIB_DIR)" >> $(DEV_ROOT)/run
	@chmod a+x  $(DEV_ROOT)/run

include $(MKF_DIR)/compile.mk

$(BIN_DIR)/$(PROJECT_NAME) : $(OBJ_PATHS) 
	@echo $@ >> $(DEV_ROOT)/run
	@$(INFO) " LD $(@F) ... "
	@g++ $(LFLAGS) $^ -o $@ 
	@$(DONE)

