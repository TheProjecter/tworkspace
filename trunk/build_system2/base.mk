#------------------------------------------------------------------------------
#
# Common stuff that all Unison makefiles include at the start.
#
#------------------------------------------------------------------------------

ifeq "$(OS)" ""
    export OS := $(shell uname)
endif
ifndef VOBS
    ifeq "$(OS)" "Windows_NT"
        export VOBS := $(shell perl -e "if (($$vr = `cleartool pwv -root`) eq \"\") {$$vr = \"V:\\\\\" . `cleartool pwv -s`;} print $$vr;")
    else
        export VOBS := /vobs
    endif
endif

UOD = UOD

# The location of executables that we use. Set absolute paths so that
# we don't depend on the user's path environment variable.

ifeq "$(OS)" "Windows_NT"
    TR          := C:/apps/mkstk/mksnt/tr.exe
    UNAME       := C:/apps/mkstk/mksnt/uname.exe
else
    AR          := /usr/bin/ar
    ARCH        := /bin/arch
    AWK         := /usr/bin/awk
    CC          := /usr/bin/gcc4
    CHMOD       := /bin/chmod
    CP          := /bin/cp
    CT          := /usr/atria/bin/cleartool
    CUT         := /usr/bin/cut
    CXX         := /usr/bin/g++4
    FIND        := /usr/bin/find
    GREP        := /bin/grep
    LD          := /usr/bin/g++4
    LN          := /bin/ln
    LEX         := /usr/bin/flex
    MKDIR       := /bin/mkdir
    PERL        := /usr/bin/perl
    PURIFY      := /opt/pure/purify
    PURECOV     := /opt/pure/purecov
    QUANTIFY    := /opt/pure/quantify
    RM          := /bin/rm
    SED         := /bin/sed
    TAR         := /bin/tar
    TEST        := /usr/bin/test
    TOUCH       := /bin/touch
    TR          := /usr/bin/tr
    UNAME       := /bin/uname
    YACC        := /vobs/vendor/Yacc++/Version2.4/linux/ltx/bin/yxx
endif


#------------------------------------------------------------------------------
# Pre-defined variables
#------------------------------------------------------------------------------

# What is the architecture name?

ifndef ARCH_NAME
    ifeq "$(OS)" "Windows_NT"
        export ARCH_NAME := $(shell $(UNAME) -srv | $(TR) " " "_")
    else
        export ARCH_NAME := $(shell $(ARCH))_$(shell $(UNAME) | $(TR) "[A-Z]" "[a-z]")_$(shell $(UNAME) -r | $(PERL) -pe "s/-.*//")
    endif
endif

ifndef KERNEL_RELEASE
    export KERNEL_RELEASE := $(shell $(UNAME) -r | $(CUT) -d- -f1)
endif

# Set some standard location variables. It is normal to
# have TARGET_NAME already set in the environment.

# Override the environment which is usually set to DNT.
export TESTER := FX1

ifndef RELEASE_DIR
    export RELEASE_DIR := /opt/ltx/releases
endif

ifndef TARGET_NAME
    export TARGET_NAME := $(shell $(CT) pwv -s)
endif
ifeq "$(TARGET_NAME)" "development"
    export TARGET_NAME := $(shell $(CT) pwv -s)
endif

ifndef TARGET_DEST
    export TARGET_DEST := $(RELEASE_DIR)/$(TARGET_NAME)
endif

ifndef ARCH_DEST
    export ARCH_DEST := $(TARGET_DEST)/$(ARCH_NAME)
endif

ifndef WORKING_DEST
    export WORKING_DEST := $(TARGET_DEST)/working/$(ARCH_NAME)
endif

ifndef INHOUSE
    export INHOUSE := $(TARGET_DEST)/inhouse/$(ARCH_NAME)
endif

ifndef UNIT_TEST_DEST
    export UNIT_TEST_DEST := $(WORKING_DEST)/Stage3.TRIL.$(TESTER)/trillium/unit_test
endif

include /vobs/lc-comp/cosmos/environment/make/paths.mk


# Are we doing a debug or an optimized build?
# Don't do the grep someday ??

ifndef BUILD_TYPE
    CM_MK := $(WORKING_DEST)/CM.mk
    ifeq ($(shell if $(TEST) -f $(CM_MK); then $(GREP) -c Debug.mk $(CM_MK); fi), 1)
        export BUILD_TYPE := dbg
    else
        export BUILD_TYPE := opt
    endif
endif

ifndef LOCAL_DEST
    export LOCAL_DEST := $(ARCH_NAME)/$(BUILD_TYPE)
endif

ifndef RELEASE_DEST
    export RELEASE_DEST := /vobs/release/$(BUILD_TYPE)
endif


#------------------------------------------------------------------------------
# Purify etc.
#------------------------------------------------------------------------------

ifeq "$(DO_PURIFY)" "text"
    PRELD := $(PURIFY) -ignore-signals=SIGUSR1,SIGUSR2,SIGHUP,SIGINT,SIGALRM,SIGPOLL -always-use-cache-dir -cache-dir=$(WORKING_DEST)/pure/purify/cache -chain-length=10 -log-file=$(WORKING_DEST)/pure/purify/logs/%V.log -append-logfile $(PRELD)
endif
ifeq "$(DO_PURIFY)" "gui"
    PRELD := $(PURIFY) -ignore-signals=SIGUSR1,SIGUSR2,SIGHUP,SIGINT,SIGALRM,SIGPOLL -always-use-cache-dir -cache-dir=$(WORKING_DEST)/pure/purify/cache -chain-length=10 $(PRELD)
endif

ifeq "$(DO_PURECOV)" "text"
    PRELD := $(PURECOV) -ignore-signals=SIGUSR1,SIGUSR2,SIGHUP,SIGINT,SIGALRM,SIGPOLL -always-use-cache-dir -cache-dir=$(WORKING_DEST)/pure/purecov/cache -counts-file=$(WORKING_DEST)/pure/purecov/pcv/%V.pcv -log-file=$(WORKING_DEST)/pure/purecov/logs/%V.log $(PRELD)
endif

ifeq "$(DO_QUANTIFY)" "text"
    PRELD := $(QUANTIFY) -ignore-signals=SIGUSR1,SIGUSR2,SIGHUP,SIGINT,SIGALRM,SIGPOLL -always-use-cache-dir -cache-dir=$(WORKING_DEST)/pure/quantify/cache -write-export-file=$(WORKING_DEST)/pure/quantify/qv/%V.%p.%n -write-summary-file=$(WORKING_DEST)/pure/quantify/logs/%V.%p.%n -logfile=$(WORKING_DEST)/pure/quantify/logs/%V.%p.log -windows=no $(PRELD)
endif
ifeq "$(DO_QUANTIFY)" "gui"
    PRELD := $(QUANTIFY) -ignore-signals=SIGUSR1,SIGUSR2,SIGHUP,SIGINT,SIGALRM,SIGPOLL -always-use-cache-dir -cache-dir=$(WORKING_DEST)/pure/quantify/cache $(PRELD)
endif


#------------------------------------------------------------------------------
# Common stuff
#------------------------------------------------------------------------------

WOPTIONS := -fmessage-length=0 -funsigned-bitfields -fPIC -Werror -Wwrite-strings -Wreturn-type -Wno-unused-value # -fcheck-new -Wno-error

ifeq "$(BUILD_TYPE)" "dbg"
    OPTIMIZATION_OPTIONS := -g -DDEBUG_BUILD
else
    OPTIMIZATION_OPTIONS := -O2
endif

define copy-file
    $(TEST) -d $(TARGET_DEST)
    $(MKDIR) -p $(dir $@)
    $(CP) --remove-destination --preserve=mode $< $@
endef

define copy-file-or-directory
    $(TEST) -d $(TARGET_DEST)
    $(MKDIR) -p $(dir $@)
    if $(TEST) -d $<; then $(MKDIR) -p $@; else $(CP) --remove-destination --preserve=mode $< $@; fi
endef

define copy-file-or-link
    $(TEST) -d $(TARGET_DEST)
    $(MKDIR) -p $(dir $@)
    $(CP) --no-dereference --remove-destination --preserve=mode $< $@
endef

SUBMAKE := $(MAKE) -k RELEASE_DIR=$(RELEASE_DIR) TARGET_NAME=$(TARGET_NAME) TESTER=$(TESTER) 


#------------------------------------------------------------------------------
#
# Highest level targets.
#
# The order is important so that things build in the correct sequence when
# performing parallel builds. For example, if we just defined
#
#     rebuild: clean install
#
# Then the install could run while clean is still running in parallel.
#
#------------------------------------------------------------------------------

all:
	$(SUBMAKE) prebuild
	$(SUBMAKE) compile
	$(SUBMAKE) library
	$(SUBMAKE) executable
	$(SUBMAKE) postbuild
	$(SUBMAKE) buildtest
	$(SUBMAKE) runtest

build:
	$(SUBMAKE) prebuild
	$(SUBMAKE) compile
	$(SUBMAKE) library
	$(SUBMAKE) executable
	$(SUBMAKE) postbuild

test:
	$(SUBMAKE) buildtest
	$(SUBMAKE) runtest

rebuild:
	$(SUBMAKE) clean
	$(SUBMAKE) prebuild
	$(SUBMAKE) compile
	$(SUBMAKE) library
	$(SUBMAKE) executable
	$(SUBMAKE) postbuild

retest:
	$(SUBMAKE) clean
	$(SUBMAKE) buildtest
	$(SUBMAKE) runtest

# Double-colon targets. These can be augmented in the individual makefiles.
# Build targets...

prebuild::

compile::

library::

executable::

postbuild::

# Test targets...

buildtest::

runtest::

# Other stuff...

doc::

clean::

# We want these targets to be executed serially even in a parallel build.

.NOTPARALLEL: all build test rebuild retest
.NOTPARALLEL: prebuild library postbuild

# We want these targets to be executed even if there happens to be a file or
# directory with the same name.

.PHONY: prebuild compile library executable postbuild buildtest runtest
.PHONY: all build test rebuild retest

