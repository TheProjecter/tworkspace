
.PHONY : clean

clean:
	@bash $(BUILDER_ROOT)/wizards/clean.sh \
		$(OBJ_PATH) \
		$(BIN_PATH) \
		$(DEV_ROOT) \
		$(BUILDER_ROOT)/wizards/colors.sh
