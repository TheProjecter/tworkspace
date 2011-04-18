
library: $(bin_path)lib_$(target).so

$(bin_path)lib_$(target).so : $(obj_files)
	@$(ld) --shared $(lflags) $^ -o $@
	@echo "LD $^ -> $@"
