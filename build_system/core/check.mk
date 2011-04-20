
ifeq "$(binary)" "executable"
check: compile $(binary)
	$(bin_path)$(target)
else
check:
endif
