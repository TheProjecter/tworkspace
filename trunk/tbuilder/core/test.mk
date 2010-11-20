
.PHONY: test
test:
	@bash $(BUILDER_ROOT)/wizards/test.sh \
		$(BUILDER_ROOT) \
		$(DEV_ROOT) \
		$(BUILDER_ROOT)/wizards/colors.sh
