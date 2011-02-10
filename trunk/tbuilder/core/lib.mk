
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

lib_name	=  $(lib_dir)/lib$(project_name).so

include $(core_path)/macros.mk

.PHONY: lib ntg
lib : ntg $(DEPS_PATHS) $(LIB_NAME)

ntg:
	@donothing=1


include $(core_path)/compile.mk
	
$(lib_name) : $(obj_paths) 
	@$(INFO) " LD $(@F) ... "
	@g++ $(lflags) --shared $^ -o $@
	@echo ">>>>"$@
	@$(DONE)
