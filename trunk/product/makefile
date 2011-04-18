
projects	:= \
	src/project_1/\
	src/project_2/\

.PHONY: all clean

all :
	+@for i in $(projects); do make -C $$i --no-print-directory; done

clean: 
	+@for i in $(projects); do make -C $$i clean --no-print-directory; done
