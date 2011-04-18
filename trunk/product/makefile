
projects	:= \
	src/project_1/\
	src/project_2/\

export customer_dir	:= $(CURDIR)
export build_system := $(CURDIR)/../build_system

.PHONY: all clean

all :
	+@for i in $(projects); do make -C $$i --no-print-directory; done

clean: 
	+@for i in $(projects); do make -C $$i clean --no-print-directory; done
