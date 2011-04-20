
shared_library: $(bin_path)lib_$(target).so

$(bin_path)lib_$(target).so : $(obj_files)
	@$(ld) --shared $(LFLAGS) $^ -o $@
	@echo "LD $^ -> $@"
