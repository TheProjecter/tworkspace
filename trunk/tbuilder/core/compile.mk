
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

obj_files 	:= $(subst .cpp,.o,$(cpp_files)) 
obj_paths	:= $(addprefix $(obj_dir)/$(project_name)/,$(obj_files)) 
dep_files	:= $(subst .cpp,.d,$(cpp_files))
deps_paths	:= $(addprefix $(dep_dir)/$(project_name)/,$(dep_files))

.PHONY: $(deps_paths)
$(deps_paths) 	: 
	@mkdir -p $(@D)
	@g++ $(cflags) -MM $(subst .d,.cpp,$(@F)) \
		-MT "$(obj_dir)/$(project_name)/$(subst .d,.o,$(@F))" -o $@

-include $(deps_paths)

$(obj_paths)	: $(notdir $(subst .o,.cpp,$@)) 
	@$(INFO) " CC $(@F) ... "
	@g++ -c $(cflags) $(notdir $*.cpp) -o $@
	@$(DONE)
