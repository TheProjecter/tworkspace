
projects	:= \
	src/project_1/\
	src/project_2/\

export customer_dir	:= $(CURDIR)
export build_system := $(CURDIR)/../build_system

.PHONY: all clean

all :
	+@for i in $(projects); do \
		make -C $$i --no-print-directory; \
	done

test:
	+@for i in $(projects); do \
		make -C $$i/unit_tests --no-print-directory; \
		make -C $$i/unit_tests check --no-print-directory; \
	done
	
clean: 
	+@for i in $(projects); do \
		make -C $$i clean --no-print-directory; \
	done

distclean: 
	+@for i in $(projects); do \
		make -C $$i distclean --no-print-directory; \
		make -C $$i/unit_tests distclean --no-print-directory; \
	done

check:
	+@for i in $(projects); do \
		make -C $$i check --no-print-directory; \
	done
	
