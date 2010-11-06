
.PHONY: test
test:
	@bash $(BUILDER_ROOT)/wizards/test.sh $(BUILDER_ROOT) $(TEST_DIR) $(DEV_ROOT)
