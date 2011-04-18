
cpp_files	:= \
	main.cpp \
	testa.cpp \
	testb.cpp \
	testc.cpp \
	testd.cpp \
	teste.cpp \
	testf.cpp \
	testg.cpp \
	testh.cpp \
	testi.cpp \
	testj.cpp \
	testk.cpp \
	testl.cpp \
	testm.cpp \
	testn.cpp \
	testo.cpp \
	testp.cpp \
	testq.cpp \
	testr.cpp \
	tests.cpp \
	testt.cpp \
	testu.cpp \
	testv.cpp \
	testw.cpp \
	testx.cpp \
	testy.cpp \
	testz.cpp \

build_type	?= debug
target		:= $(notdir $(shell pwd))

# configurations
arch        := /bin/arch
cp          := /bin/cp
cut         := /usr/bin/cut
cc			:= g++
ld			:= g++
ct          := /usr/atria/bin/cleartool
find        := /usr/bin/find
grep        := /bin/grep
lex         := /usr/bin/flex
mkdir       := /bin/mkdir
perl        := /usr/bin/perl
purecov     := /opt/pure/purecov
rm          := /bin/rm
sed         := /bin/sed
tar         := /bin/tar
test        := /usr/bin/test
touch       := /bin/touch
tr          := /usr/bin/tr
uname       := /bin/uname

#Where to place result
arch_name	:= $(shell $(arch))_$(shell $(uname) | $(tr) "[A-Z]" "[a-z]")_$(shell $(uname) -r | $(perl) -pe "s/-.*//")
bin_path	:=$(arch_name)/$(build_type)/

MAKE	:= @make --no-print-directory

ifeq "$(build_type)" "debug"
	lflags += -g -DDEBUG
else
	lflags += -O2
endif

all_new: prebuild compile library executable postbuild buildtest runtest

all_old: 
	$(MAKE) prebuild 
	$(MAKE) compile 
	$(MAKE) library 
	$(MAKE) executable 
	$(MAKE) postbuild 
	$(MAKE) buildtest 
	$(MAKE) runtest

build: prebuild compile library executable postbuild

test: buildtest runtest

rebuild: clean prebuild compile library executable postbuild

retest: buildtest runtest

prebuild::
library::
postbuild::
buildtest::
runtest::

.NOTPARALLEL: all build test rebuild retest
.NOTPARALLEL: prebuild library postbuild

.PHONY: prebuild library postbuild buildtest runtest
.PHONY: all build test rebuild retest

obj_files	:= $(subst .cpp,.o,$(cpp_files))
obj_path	:= $(shell pwd)

compile : $(obj_files)

$(obj_path)/%.o : %.cpp
	@$(cc) -c $(cflags) $< -o $@
	@echo "CC $< -> $@"

executable: $(bin_path)$(target)

$(bin_path)$(target) : $(obj_files)
	@$(mkdir) -p $(bin_path)
	@$(ld) $(lflags) $^ -o $@
	@echo "LD $^ -> $@"

clean:
	$(rm) -rf $(arch_name)
	$(rm) -f $(obj_files)
