#------------------------------------------------------------------------------
#
# Include this makefile if you need to buidl other makefiles in the same
# directory.
#
# Note: the MAKEFILES make variable may be set before including this file.
#
#------------------------------------------------------------------------------

ifndef MAKEFILES
	MAKEFILES := $(wildcard Makefile.*)
endif

define sibling-make
	$(SUBMAKE) -f $(basename $@) $(subst .,,$(suffix $@))
endef

prebuild::   $(addsuffix .prebuild,   $(MAKEFILES))
compile::    $(addsuffix .compile,    $(MAKEFILES))
library::    $(addsuffix .library,    $(MAKEFILES))
executable:: $(addsuffix .executable, $(MAKEFILES))
postbuild::  $(addsuffix .postbuild,  $(MAKEFILES))
buildtest::  $(addsuffix .buildtest,  $(MAKEFILES))
runtest::    $(addsuffix .runtest,    $(MAKEFILES))
clean::      $(addsuffix .clean,      $(MAKEFILES))

%.prebuild::
	$(sibling-make)

%.compile::
	$(sibling-make)

%.library::
	$(sibling-make)

%.executable::
	$(sibling-make)

%.postbuild::
	$(sibling-make)

%.buildtest::
	$(sibling-make)

%.runtest::
	$(sibling-make)

%.clean::
	$(sibling-make)

.NOTPARALLEL:   %.prebuild %.library %.postbuild

