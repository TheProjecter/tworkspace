
projects	:= \
	src/project_1/\
	src/project_2/\
	src/project_3/\

export customer_dir	:= $(CURDIR)
export build_system	= $(BLD_SSTM)

.PHONY: all clean

all :
	+@for i in $(projects); do \
		make -C $$i; \
	done

test:
	+@for i in $(projects); do \
		make -C $$i/unit_tests; \
		make -C $$i/unit_tests check; \
	done
	
clean: 
	+@for i in $(projects); do \
		make -C $$i clean; \
	done

distclean: 
	+@for i in $(projects); do \
		make -C $$i distclean; \
		make -C $$i/unit_tests distclean; \
	done

check:
	+@for i in $(projects); do \
		make -C $$i check; \
	done
	
