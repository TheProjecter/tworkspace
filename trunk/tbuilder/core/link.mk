
.PHONY: link
link:
	@echo -n "Linking... " 
	@$(LINKER) $(CPP_OBJ_FILES) $(CUDA_OBJ_FILES) -o $(BIN_PATH)/$(PROJECT_NAME) $(LINKER_FLAGS) 
	@echo "Done"
