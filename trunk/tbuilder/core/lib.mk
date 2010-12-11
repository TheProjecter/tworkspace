
SHELL		= /bin/sh

LIB_NAME	=  $(LIB_DIR)/lib$(PROJECT_NAME).so

include $(MKF_DIR)/macros.mk

.PHONY: lib
lib : $(DEPS_PATHS) $(LIB_NAME)


include $(MKF_DIR)/compile.mk
	
$(LIB_NAME) : $(OBJ_PATHS) 
	@$(INFO) " LD $(@F) ... "
	@g++ $(LFLAGS) --shared $^ -o $@
	@$(DONE)
