
ifneq "$(wildcard .settings.mk)" ".settings.mk"
$(shell $(build_system)/configure)
endif
include .settings.mk
bin_path	:= $(arch_name)/$(build_type)/

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

all: prebuild compile $(binary) postbuild

.NOTPARALLEL: all 
.NOTPARALLEL: prebuild $(binary) postbuild

include $(build_system)/compile.mk
include $(build_system)/check.mk
include $(build_system)/executable.mk
include $(build_system)/library.mk
include $(build_system)/clean.mk
