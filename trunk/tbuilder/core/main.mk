
SHELL		= /bin/sh

PROJECTS_PATHS 	= $(addprefix src/,$(PROJECTS))

.PHONY: all
all 		: $(PROJECTS_PATHS)

.PHONY: $(PROJECTS_PATHS)
$(PROJECTS_PATHS) : 
	@mkdir -p $(OBJ_DIR)/$(notdir $@)
	@mkdir -p $(BIN_DIR)
	@mkdir -p $(LIB_DIR)
	@mkdir -p $(DEP_DIR)/$(notdir $@)
	@make -C $@ --no-print-directory
