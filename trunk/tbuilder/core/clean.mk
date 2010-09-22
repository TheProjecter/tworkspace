
.PHONY : clean

clean:
	@echo -n "Cleaning... " 
	@rm -fr $(OBJ_PATH)
	@rm -fr $(BIN_PATH)
	@rm -fr $(DEV_ROOT)/run
	@echo "Done"
