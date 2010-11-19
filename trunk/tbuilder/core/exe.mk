
OBJ_FILES_ 		:= $(patsubst %.cpp,%.o,$(CPP_FILES))
DEPENDENCY_FILES_ 	:= $(patsubst %.cpp,%.d,$(CPP_FILES))

CURRENT_OBJ_DIR	:= $(OBJ_PATH)/$(PROJECT_NAME)
CURRENT_DEP_DIR := $(DEP_PATH)/$(PROJECT_NAME)

CPP_OBJ_FILES	:= $(addprefix $(CURRENT_OBJ_DIR)/,$(OBJ_FILES_))
DEPENDENCY_FILES:= $(addprefix $(CURRENT_DEP_DIR)/,$(DEPENDENCY_FILES_))


ifeq ($(cuda),enable)
CUDA_OBJ_FILES_ := $(patsubst %.cu,%.o,$(CUDA_FILES))
CUDA_OBJ_FILES	:= $(addprefix $(CURRENT_OBJ_DIR)/cuda/,$(CUDA_OBJ_FILES_))
endif

ifneq ($(debug),enable)
DEBUGER = 
endif

.PHONY: exe
exe: create_directories compile link run_script $(DEV_ROOT)/.settings 

.PHONY: run_script
run_script : 
	@echo "#! /bin/bash\n" >$(DEV_ROOT)/run
	@echo "export DEV_ROOT="$(DEV_ROOT)"\n" >>$(DEV_ROOT)/run
	@echo "$(DEBUGER) $(BIN_PATH)/$(PROJECT_NAME)" >> $(DEV_ROOT)/run;
	@echo 'if [ "$$1"  == "tester" ]; then' >> $(DEV_ROOT)/run
	@echo '$(DEV_ROOT)/$(TEST_DIR)/tester.sh $(TEST_DIR)' >> $(DEV_ROOT)/run
	@echo "fi" >> $(DEV_ROOT)/run
	@chmod a+x $(DEV_ROOT)/run>> $(DEV_ROOT)/run

.PHONY : create_directories
create_directories :
	@echo -n "Creating Directories... " 
	@mkdir -p $(CURRENT_OBJ_DIR)
	@mkdir -p $(CURRENT_OBJ_DIR)/cuda
	@mkdir -p $(CURRENT_DEP_DIR)
	@mkdir -p $(BIN_PATH)
	@echo "Done"

-include $(DEPENDENCY_FILES)

.PHONY: compile
compile: $(DEPENDENCY_FILES) $(CPP_OBJ_FILES) $(CUDA_OBJ_FILES) 
	@echo -n "Compiling... "
	@echo "Done"

.PHONY: $(DEPENDENCY_FILES)
$(CURRENT_DEP_DIR)/%.d : %.cpp $(DEV_ROOT)/.settings
	@$(CPP_COMPILER) $(CPP_COMPILER_FLAGS) -MM $< -MF $@ -MT '$@ \
		$(subst .d,.o,$@)' 

$(CURRENT_OBJ_DIR)/%.o : %.cpp $(DEV_ROOT)/.settings
	@$(CPP_COMPILER) $(CPP_COMPILER_FLAGS) -c $< -o $@
 
$(CURRENT_OBJ_DIR)/cuda/%.o : %.cu $(DEV_ROOT)/.settings
	@$(CUDA_COMPILER) $(CUDA_COMPILER_FLAGS) $< -o $@

include $(BUILDER_ROOT)/core/link.mk
