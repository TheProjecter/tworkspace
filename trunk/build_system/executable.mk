
executable: $(bin_path)$(target)

$(bin_path)$(target) : $(obj_files)
	@$(ld) $(lflags) $^ -o $@
	@echo "LD $^ -> $@"

