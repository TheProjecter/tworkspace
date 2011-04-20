
executable: $(bin_path)$(target)

$(bin_path)$(target) : $(obj_files)
	@$(ld) $(LFLAGS) $^ -o $@
	@echo "LD $^ -> $@"
