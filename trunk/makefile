
BUILDER_NAME	= tbuilder
BUILDER_DIR 	= $(shell pwd)/$(BUILDER_NAME)

.PHONY: default
default:
	@$(BUILDER_DIR)/wizards/colored_echo.sh \
		$(BUILDER_DIR)/wizards/colors.sh \
		"warning" \
		"You should use one of the following ways to make a project"
	@$(BUILDER_DIR)/wizards/colored_echo.sh \
		$(BUILDER_DIR)/wizards/colors.sh \
		"message" \
		"make project name=\"NAME_OF_PROJECT\""

.PHONY: project
project:
	@/bin/bash $(BUILDER_DIR)/wizards/project_creation.sh \
		$(BUILDER_DIR) \
		$(shell pwd) \
		$(BUILDER_DIR)/wizards/colors.sh \
		$(name) \
		$(type)


.PHONY: tarball
tarball:
	@tar cjf $(name).tbz2 $(name) $(BUILDER_NAME)

.PHONY: clean
clean:
	@rm -fr *.tbz *.tar.*
	@rm -fr $(BUILDER_DIR)/bin
	@rm -fr $(BUILDER_DIR)/obj
	@rm -fr $(BUILDER_DIR)/dep
	@rm -fr $(BUILDER_DIR)/tst

