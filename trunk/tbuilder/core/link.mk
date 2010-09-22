
.PHONY: link
link:
	@echo -n "Linking... " 
	@$(LINKER) $(LINKER_FLAGS) $(CPP_OBJ_FILES) $(CUDA_OBJ_FILES) -o $(BIN_PATH)/$(PROJECT) 
	@echo "Done"
