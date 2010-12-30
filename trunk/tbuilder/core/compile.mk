
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

OBJ_FILES 	:= $(subst .cpp,.o,$(CPP_FILES)) 
OBJ_PATHS	:= $(addprefix $(OBJ_DIR)/$(PROJECT_NAME)/,$(OBJ_FILES)) 
DEPS		:= $(subst .cpp,.d,$(CPP_FILES))
DEPS_PATHS	:= $(addprefix $(DEP_DIR)/$(PROJECT_NAME)/,$(DEPS))

.PHONY: $(DEPS_PATHS)
$(DEPS_PATHS) 	: 
	@mkdir -p $(@D)
	@g++ $(CFLAGS) -MM $(subst .d,.cpp,$(@F)) \
		-MT "$(OBJ_DIR)/$(PROJECT_NAME)/$(subst .d,.o,$(@F))" -o $@

-include $(DEPS_PATHS)

$(OBJ_PATHS)	: $(notdir $(subst .o,.cpp,$@)) 
	@$(INFO) " CC $(@F) ... "
	@g++ -c $(CFLAGS) $(notdir $*.cpp) -o $@
	@$(DONE)
