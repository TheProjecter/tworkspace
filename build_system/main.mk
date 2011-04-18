
ifeq "$(build_type)" "debug"
	cflags	+= -g -DDEBUG
else
	cflags	+= -O2
endif

ifeq "$(binary_type)" "library"
	binary	= library
else
	binary	= executable
endif

.PHONY: prebuild compile $(binary) postbuild check clean distclean
.PHONY: all

all: .settings.mk prebuild compile $(binary) postbuild

.settings.mk:
	@$(build_system)/configure > $@

-include .settings.mk
bin_path	:= $(arch_name)/$(build_type)/

.NOTPARALLEL: all 
.NOTPARALLEL: prebuild $(binary) postbuild

include $(build_system)/compile.mk
include $(build_system)/check.mk
include $(build_system)/executable.mk
include $(build_system)/library.mk
include $(build_system)/clean.mk
