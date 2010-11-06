
BUILDER_NAME	= tbuilder
BUILDER_DIR 	= $(shell pwd)/$(BUILDER_NAME)

.PHONY: default
default:
	@echo "You shell use one of the following ways to make a project"
	@echo "make project name=\"NAME_OF_PROJECT\""

.PHONY: project
project:
	@/bin/bash $(BUILDER_DIR)/wizards/project_creation.sh $(BUILDER_DIR) $(shell pwd) $(name) $(type)

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

