
ifeq "$(binary_type)" "library"
check:
else
check: compile $(binary)
	$(bin_path)$(target)
endif
