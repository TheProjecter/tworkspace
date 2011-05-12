
obj_files	:= $(subst .cpp,.o,$(cpp_files))
dep_files	:= $(subst .cpp,.d,$(cpp_files))

compile : $(obj_files)

$(obj_files) : | $(bin_path)
$(bin_path) :
	@$(mkdir) -p $(bin_path)

%.o : %.cpp
	@$(CXX) -c -MMD $(CFLAGS) $< $(CPPFLAGS)
	@echo "CC $< -> $@"

-include dummy_include $(wildcard *.d)
