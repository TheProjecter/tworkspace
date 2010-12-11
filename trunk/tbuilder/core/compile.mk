
OBJ_FILES 	:= $(subst .cpp,.o,$(CPP_FILES)) 
OBJ_PATHS	:= $(addprefix $(OBJ_DIR)/$(PROJECT_NAME)/,$(OBJ_FILES)) 
DEPS		:= $(subst .cpp,.d,$(CPP_FILES))
DEPS_PATHS	:= $(addprefix $(DEP_DIR)/$(PROJECT_NAME)/,$(DEPS))

.PHONY: $(DEPS_PATHS)
$(DEPS_PATHS) 	: 
	@g++ $(CFLAGS) -MM $(subst .d,.cpp,$(@F)) \
		-MT "$(OBJ_DIR)/$(PROJECT_NAME)/$(subst .d,.o,$(@F))" -o $@

-include $(DEPS_PATHS)

$(OBJ_PATHS)	: $(notdir $(subst .o,.cpp,$@)) 
	@$(INFO) " CC $(@F) ... "
	@g++ -c $(CFLAGS) $(notdir $*.cpp) -o $@
	@$(DONE)
