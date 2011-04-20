
binary :=
ifeq ($(binary_type),shared_library)
	binary := shared_library
endif
ifeq ($(binary_type),static_library)
	binary := static_library
endif
ifeq ($(binary_type),exe)
	binary := executable
endif

ifeq ($(build_type),debug)
	CFLAGS	+= -g -DDEBUG
else
	CFLAGS	+= -O2
endif

.PHONY: prebuild compile shared_library executable postbuild check clean \
		distclean
.PHONY: all

all: .settings.mk prebuild compile $(binary) postbuild

.settings.mk:
	@$(build_system)/tools/configure > $@

-include .settings.mk
bin_path	:= $(arch_name)/$(build_type)/

.NOTPARALLEL: all 
.NOTPARALLEL: prebuild $(binary) postbuild

include $(build_system)/core/compile.mk
include $(build_system)/core/check.mk
include $(build_system)/core/executable.mk
include $(build_system)/core/shared_library.mk
include $(build_system)/core/static_library.mk
include $(build_system)/core/clean.mk
