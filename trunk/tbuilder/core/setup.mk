
MAKEFILES	:= $(addsuffix /makefile,$(PROJECTS))

-include $(MAKEFILES)

LINKER_FLAGS__ 	:= $(filter -l%,$(LINKER_FLAGS))
LINKER_FLAGS_ 	:= $(patsubst -l%,%,$(LINKER_FLAGS__))

.PHONY : setup
setup :
	@NOT_FOUNDED_PKGS=0; 
	@for i in $(LINKER_FLAGS_); do \
		echo -n "Searching for $$i:\t"; \
		pkg-config --exists $$i; \
		if [ $$? -eq 0 ]; then \
		echo "found"; \
		else \
		echo "not found"; \
		NOT_FOUNDED_PKGS=1;\
		fi; \
	done
	@if [ "$(NOT_FOUNDED_PKGS)"=="1" ]; then exit 1; fi;
