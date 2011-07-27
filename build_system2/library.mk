#------------------------------------------------------------------------------
#
# Include this makefile if you need to build a library.
#
# The TARGET make variable must be set before including this file.
#
# The other variables may be set before including this file.
#
#------------------------------------------------------------------------------

# Variables.

ifndef CPPSOURCES
    CPPSOURCES := $(wildcard *.cpp)
endif

ifndef CPPOBJECTS
    CPPOBJECTS := $(CPPSOURCES:%.cpp=$(LOCAL_DEST)/%.o)
endif

ifndef CXXSOURCES
    CXXSOURCES :=
endif

ifndef CXXOBJECTS
    CXXOBJECTS := $(CXXSOURCES:%.cxx=$(LOCAL_DEST)/%.o)
endif

ifndef CSOURCES
    CSOURCES := $(wildcard *.c)
endif

ifndef COBJECTS
    COBJECTS := $(CSOURCES:%.c=$(LOCAL_DEST)/%.o)
endif

# The default name of the library is the same as the name of the directory

ifndef TARGET
    PWD := $(shell pwd)
    TARGET := $(notdir $(PWD))
endif

ifndef LIB_DEST
    LIB_DEST := $(ARCH_DEST)/lib
endif

RELEASE_LIB_DEST := $(RELEASE_DEST)/$(ARCH_NAME)/$(subst $(ARCH_DEST)/,,$(LIB_DEST))

CPPDEFS := $(CPPDEFS)
CPPINCS := $(CPPINCS) \
	-I$(BOOST_DIR)/include

ifndef PCH
    PCH := $(wildcard pch.h)
endif

ifneq "$(PCH)" ""
	PCHINC := -include $(LOCAL_DEST)/$(PCH)
    GCH := $(LOCAL_DEST)/$(PCH).gch
endif

LIBPATHS := $(LIBPATHS) \
	-L$(RELEASE_DEST)/$(ARCH_NAME)/lib \
	-Wl,-rpath=$(RELEASE_DEST)/$(ARCH_NAME)/lib \
	-Wl,-R'$$ORIGIN'/../lib

LIBPATHS:=$(sort $(LIBPATHS))
ARCHPATHS:= $(strip $(filter -L$(ARCH_DEST)%,$(LIBPATHS)))
# add rpath for libraries located in
#   example for '$$ORIGIN'/../.. ??
#   $(ARCH_DEST)/idrivers/<generic>/<physical>/
#   $(ARCH_DEST)/plugins/hw/optional/$(TESTER_TYPE)/
LIBPATHS+=\
	-Wl,-rpath,'$$ORIGIN'/. \
	$(subst -L$(ARCH_DEST),'$$ORIGIN'/../..,$(ARCHPATHS:%=-Wl,-rpath,%)) \
	$(subst -L$(ARCH_DEST),'$$ORIGIN'/../../..,$(ARCHPATHS:%=-Wl,-rpath,%)) \
	$(subst -L$(ARCH_DEST),'$$ORIGIN'/../../../..,$(ARCHPATHS:%=-Wl,-rpath,%)) \
	-Wl,-rpath=$(ARCH_DEST)/lib/DMD \

ifndef LDFLAGS
    LDFLAGS := -Wl,--enable-new-dtags
endif
ifndef ARFLAGS
    ARFLAGS := -rs
endif 

# Rules.

ifeq "$(OS)" "Windows_NT"
else

library::   $(LIB_DEST)/lib$(TARGET).so

ifdef AR_TARGET
library::   $(LIB_DEST)/lib$(AR_TARGET).a
endif

$(LIB_DEST)/%.so: $(RELEASE_LIB_DEST)/%.so
	$(copy-file)

$(RELEASE_LIB_DEST)/%.so: $(CPPOBJECTS) $(COBJECTS) $(CXXOBJECTS)
	$(MKDIR) -p $(dir $@)
	$(RM) -f $@
	$(PRELD) $(LD) $(LDFLAGS) $? $(LIBPATHS) $(LIBS) -shared -o $@

$(LIB_DEST)/%.a: $(RELEASE_LIB_DEST)/%.a
	$(copy-file)

$(RELEASE_LIB_DEST)/%.a: $(CPPOBJECTS) $(COBJECTS) $(CXXOBJECTS)
	$(MKDIR) -p $(dir $@)
	$(RM) -f $@
	$(PRELD) $(AR) $(ARFLAGS) $@ $?

compile::	$(CPPOBJECTS) $(COBJECTS) $(CXXOBJECTS)

$(LOCAL_DEST)/%.o:  %.cpp $(GCH)
	$(MKDIR) -p $(dir $@)
	$(PRECXX) $(CXX) $(CXXFLAGS) $(WOPTIONS) $(OPTIMIZATION_OPTIONS) $(CPPDEFS) $(CPPINCS) $(PCHINC) -fPIC -c -o $@ $<

$(LOCAL_DEST)/%.o:  %.c
	$(MKDIR) -p $(dir $@)
	$(PRECXX) $(CXX) $(CXXFLAGS) $(WOPTIONS) $(OPTIMIZATION_OPTIONS) $(CPPDEFS) $(CPPINCS) -fPIC -c -o $@ $<

$(LOCAL_DEST)/%.o:  %.cxx $(GCH)
	$(MKDIR) -p $(dir $@)
	$(PRECXX) $(CXX) $(CXXFLAGS) $(WOPTIONS) $(OPTIMIZATION_OPTIONS) $(CPPDEFS) $(CPPINCS) $(PCHINC) -fPIC -c -o $@ $<

$(GCH):	$(PCH)
	$(MKDIR) -p $(dir $@)
	$(CXX) $(CXXFLAGS) $(WOPTIONS) $(OPTIMIZATION_OPTIONS) $(CPPDEFS) $(CPPINCS) -fPIC -o $@ $<

clean::
	$(RM) -rf $(LOCAL_DEST)
	$(RM) -rf $(LIB_DEST)/lib$(TARGET).so

endif
