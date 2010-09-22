
BUILDER_NAME	= tbuilder
BUILDER_DIR 	= $(shell pwd)/$(BUILDER_NAME)

.PHONY: default
default:
	@echo "You shell use one of the following ways to make a project"
	@echo "make project name=\"NAME_OF_PROJECT\""

.PHONY: project
project:
	@mkdir $(name)
	@echo "" >> $(name)/makefile
	@echo "" >> $(name)/.settings
	@mkdir $(name)/src
	@echo "" >> $(name)/src/makefile
	@cat $(BUILDER_DIR)/templates/main.cpp >> $(name)/src/main.cpp
	@cat $(BUILDER_DIR)/templates/top_makefile >> $(name)/makefile
	@cat $(BUILDER_DIR)/templates/project_makefile >> $(name)/src/makefile
	@cat $(BUILDER_DIR)/templates/settings >> $(name)/.settings

.PHONY: tarball
tarball:
	@tar cjf $(name).tbz2 $(name) $(BUILDER_NAME)

.PHONY: clean
clean:
	@rm -fr *.tbz *.tar.*
