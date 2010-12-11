
include $(MKF_DIR)/macros.mk

.PHONY: clean
clean:
	@$(INFO) " Cleaning ... "
	@rm -fr $(BIN_DIR)
	@rm -fr $(OBJ_DIR)
	@rm -fr $(LIB_DIR)
	@rm -fr $(DEP_DIR)
	@rm -fr $(DEV_ROOT)/run
	@rm -fr $(DEV_ROOT)/gmon.out
	@$(DONE)
