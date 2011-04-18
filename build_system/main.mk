
include $(customer_dir)/.settings.mk

bin_path	:=$(arch_name)/$(build_type)/

ifeq "$(build_type)" "debug"
	cflags += -g -DDEBUG
else
	cflags += -O2
endif

ifeq "$(binary_type)" "library"
	binary = library
else
	binary = executable
endif

.PHONY: prebuild library postbuild buildtest runtest compile clean executable
.PHONY: all build test rebuild retest

all: prebuild compile $(binary) postbuild buildtest runtest

build: prebuild compile library executable postbuild

test: buildtest runtest

rebuild: clean prebuild compile library executable postbuild

retest: buildtest runtest

prebuild::
postbuild::
buildtest:: 
runtest:: 

.NOTPARALLEL: all build test rebuild retest
.NOTPARALLEL: prebuild library postbuild

include $(build_system)/compile.mk
include $(build_system)/executable.mk
include $(build_system)/library.mk
include $(build_system)/clean.mk
