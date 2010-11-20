
.PHONY: link
link:
	@$(BUILDER_ROOT)/wizards/colored_echo.sh \
		$(BUILDER_ROOT)/wizards/colors.sh \
		"message_done" \
		" Linking... " 
	@$(LINKER) $(CPP_OBJ_FILES) $(CUDA_OBJ_FILES) -o $(BIN_PATH)/$(PROJECT_NAME) $(LINKER_FLAGS) 
	@$(BUILDER_ROOT)/wizards/colored_echo.sh \
		$(BUILDER_ROOT)/wizards/colors.sh \
		"done" \
