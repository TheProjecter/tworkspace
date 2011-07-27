#------------------------------------------------------------------------------
#
# Include this makefile if you need to recursively decend into other makefiles.
#
# Note: the SUB_DIRS make variable may be set before including this file.
#
#------------------------------------------------------------------------------

ifndef SUB_DIRS
    SUB_DIRS := $(patsubst %/,%,$(dir $(wildcard */Makefile)))
endif

define sub-make
    $(SUBMAKE) --directory=$(dir $@) $(notdir $@)
endef

prebuild::   $(addsuffix /prebuild,   $(SUB_DIRS))
compile::    $(addsuffix /compile,    $(SUB_DIRS))
library::    $(addsuffix /library,    $(SUB_DIRS))
executable:: $(addsuffix /executable, $(SUB_DIRS))
postbuild::  $(addsuffix /postbuild,  $(SUB_DIRS))
buildtest::  $(addsuffix /buildtest,  $(SUB_DIRS))
runtest::    $(addsuffix /runtest,    $(SUB_DIRS))
clean::      $(addsuffix /clean,      $(SUB_DIRS))

%/prebuild::
	$(sub-make)

%/compile::
	$(sub-make)

%/library::
	$(sub-make)

%/executable::
	$(sub-make)

%/postbuild::
	$(sub-make)

%/buildtest::
	$(sub-make)

%/runtest::
	$(sub-make)

%/clean::
	$(sub-make)

.NOTPARALLEL:	%/prebuild %/library %/postbuild
