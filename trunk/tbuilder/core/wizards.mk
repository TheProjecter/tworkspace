
name=$1

.PHONY: class
class:
	@bash $(BUILDER_ROOT)/wizards/class_creator.sh \
		$(DEV_ROOT) \
		$(SOURCES) \
		$(BUILDER_ROOT)/wizards/colors.sh \
		$(name) 
