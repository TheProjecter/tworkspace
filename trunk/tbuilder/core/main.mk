
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

include $(core_path)/macros.mk

projects_paths 	= $(addprefix src/,$(projects))

.PHONY: all
all 		: $(projects_paths)

ifeq ($(build_type),"debug")
cflags += -ggdb
lflags += -ggdb
endif

.PHONY: $(projects_paths)
$(projects_paths) : 
	@echo "#!/bin/bash" > $(product_root)/run
	@echo "export LD_LIBRARY_PATH=$(lib_dir)" >> $(product_root)/run
	@echo $(bin_dir)/$(notdir $(projects_paths)) >> $(product_root)/run
	@chmod a+x  $(product_root)/run
	@mkdir -p $(obj_dir)/$(notdir $@)
	@mkdir -p $(bin_dir)
	@mkdir -p $(lib_dir)
	@mkdir -p $(dep_dir)/$(notdir $@)
ifeq ($(build_type),"debug") 
	@$(INFO) "debug" 
	@$(ENDL)
	@make -C $@ 
else
ifeq ($(build_type),"release")
	@$(INFO) "release" 
	@$(ENDL)
	@make -C $@ --no-print-directory
else
	@$(INFO) "profile" 
	@$(ENDL)
	@make -C $@ --no-print-directory
endif
endif


test_paths	:= $(addprefix $(product_root)/tst/,$(tests))

.PHONY: test rm_reports
test: rm_reports $(test_paths)

rm_reports: 
	@rm -f $(product_root)/test_results.txt

.PHONY: $(test_paths)
$(test_paths) : 
	@make -C $@ --no-print-directory
	@$(bash) $@/run


.PHONY: cow
cow:
	@echo "  ^__^ "
	@echo "  (oo)\_______ "
	@echo "  (__)\        )\/\ " 
	@echo "       ||----w | "
	@echo "       ||     || "
