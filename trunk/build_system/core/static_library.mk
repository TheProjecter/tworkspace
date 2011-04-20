
static_library: $(bin_path)lib_$(target).a

$(bin_path)lib_$(target).a : $(obj_files)
	@$(ar) cr $@ $^
	@$(ranlib) $@ 
	@echo "AR $< -> $@"
