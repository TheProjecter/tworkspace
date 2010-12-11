
SHELL		= /bin/sh

include $(MKF_DIR)/macros.mk

.PHONY: exe
exe : $(DEPS_PATHS) $(DEV_ROOT)/run $(BIN_DIR)/$(PROJECT_NAME)

include $(MKF_DIR)/compile.mk

$(DEV_ROOT)/run :  
	@$(INFO) " GEN run ... "
	@echo "#!/bin/bash" > $(DEV_ROOT)/run
	@echo "export LD_LIBRARY_PATH=$(LIB_DIR)" >> $(DEV_ROOT)/run
	@echo $(BIN_DIR)/$(PROJECT_NAME) >> $(DEV_ROOT)/run
	@chmod a+x  $(DEV_ROOT)/run
	@$(DONE)

$(BIN_DIR)/$(PROJECT_NAME) : $(OBJ_PATHS) 
	@$(INFO) " LD $(@F) ... "
	@g++ $(LFLAGS) $^ -o $@ 
	@$(DONE)
