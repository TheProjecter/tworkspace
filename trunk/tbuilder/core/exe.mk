
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

.PHONY: exe run
exe : $(DEPS_PATHS) run $(BIN_DIR)/$(PROJECT_NAME)

include $(MKF_DIR)/compile.mk

run :  
	@echo $(BIN_DIR)/$(PROJECT_NAME) >> $(DEV_ROOT)/run

$(BIN_DIR)/$(PROJECT_NAME) : $(OBJ_PATHS) 
	@$(INFO) " LD $(@F) ... "
	@g++ $(LFLAGS) $^ -o $@ 
	@$(DONE)

