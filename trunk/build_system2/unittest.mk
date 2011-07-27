#------------------------------------------------------------------------------
#
# Include this makefile if you need to build a simple stand-alone unit test.
#
# The CPPSOURCES, CPPOBJECTS and DIFFARGS variables may be set before
# including this file.
#
#------------------------------------------------------------------------------

# Variables.

ifndef CPPSOURCES
    CPPSOURCES := $(wildcard *.cpp)
endif

ifndef CPPOBJECTS
    CPPOBJECTS := $(CPPSOURCES:%.cpp=$(LOCAL_DEST)/%.o)
endif

ifndef DIFFARGS
    DIFFARGS := -w -c -p
endif

# Rules.

buildtest:: $(LOCAL_DEST)/unittest

$(LOCAL_DEST)/unittest:	$(CPPOBJECTS)
	$(PRELD) $(LD) -L$(RELEASE_DEST)/$(ARCH_NAME)/lib -Wl,-rpath=$(RELEASE_DEST)/$(ARCH_NAME)/lib $(LIBS) $^ -o $@

$(LOCAL_DEST)/%.o:	%.cpp
	$(MKDIR) -p $(dir $@)
	$(PRECXX) $(CXX) $(CCFLAGS) $(WOPTIONS) $(OPTIMIZATION_OPTIONS) $(CPPDEFS) $(CPPINCS) -c -o $@ $<

runtest:: $(LOCAL_DEST)/unittest $(LOCAL_DEST)/unittest.ut_out

$(LOCAL_DEST)/%.ut_out:	$(LOCAL_DEST)/%
	(cd $(dir $@); $(notdir $<) $(TESTARGS) 1> $(notdir $@) 2> $(notdir $(@:ut_out=ut_err)))
	$(INHOUSE)/bin/SmartDiff $(DIFFARGS) $*.gold $@ $*.err_gold $(@:ut_out=ut_err)

clean::
	$(RM) -rf $(ARCH_NAME)

