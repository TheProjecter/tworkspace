#------------------------------------------------------------------------------
#
# Include this makefile if you need to build a library.
#
# The TARGET make variable must be set before including this file.
#
# The CPPDEFS, CPPINCS and CPPSOURCES variables may be set before including
# this file.
#
#------------------------------------------------------------------------------

# Variables.

ifndef CPPSOURCES
    CPPSOURCES := $(wildcard *.cpp)
endif

ifndef CPPOBJECTS
    CPPOBJECTS := $(CPPSOURCES:%.cpp=$(LOCAL_DEST)/%.o)
endif

ifndef CSOURCES
#CSOURCES := $(wildcard *.c)
endif

ifndef COBJECTS
    COBJECTS := $(CSOURCES:%.c=$(LOCAL_DEST)/%.o)
endif

ifndef BIN_DEST
    BIN_DEST := $(ARCH_DEST)/bin
endif

CPPDEFS := $(CPPDEFS)

CPPINCS := $(CPPINCS)

LIBPATHS := $(LIBPATHS) -L$(ARCH_DEST)/lib -Wl,-rpath=$(ARCH_DEST)/lib

LDFLAGS :=

# Rules.

ifeq "$(OS)" "Windows_NT"
else

executable::   $(BIN_DEST)/$(TARGET)

$(BIN_DEST)/$(TARGET): $(LOCAL_DEST)/$(TARGET)
	$(copy-file)

$(LOCAL_DEST)/$(TARGET):	$(CPPOBJECTS) $(COBJECTS)
	$(MKDIR) -p $(dir $@)
	$(RM) -f $@
	$(PRELD) $(LD) $(LDFLAGS) $? $(LIBPATHS) $(LIBS) -o $@

compile::	$(CPPOBJECTS) $(COBJECTS)

$(LOCAL_DEST)/%.o:  %.cpp
	$(MKDIR) -p $(dir $@)
	$(PRECXX) $(CXX) $(CXXFLAGS) $(WOPTIONS) $(OPTIMIZATION_OPTIONS) $(CPPDEFS) $(CPPINCS) -c -o $@ $<

$(LOCAL_DEST)/%.o:  %.c
	$(MKDIR) -p $(dir $@)
	$(PRECXX) $(CXX) $(CXXFLAGS) $(WOPTIONS) $(OPTIMIZATION_OPTIONS) $(CPPDEFS) $(CPPINCS) -c -o $@ $<

clean::
	$(RM) -rf $(ARCH_NAME)
	$(RM) -rf $(BIN_DEST)/$(TARGET)

endif

