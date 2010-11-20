
-include $(DEV_ROOT)/.settings

.DEFAULT_GOAL			:= all

export CPP_COMPILER		:= g++
export CPP_COMPILER_FLAGS	+= -I.

export CUDA_COMPILER		:= nvcc
export CUDA_COMPILER_FLAGS	+= -arch=sm_13 --shared --compiler-options \
					'-fPIC' -g -G 

export LINKER			:= g++
export LINKER_FLAGS		+= 

export DEBUGER			:= gdb

export OBJ_PATH			:= $(BUILDER_ROOT)/obj
export BIN_PATH			:= $(BUILDER_ROOT)/bin
export DEP_PATH			:= $(BUILDER_ROOT)/dep

ifeq ($(cuda),enable)
	CPP_COMPILER_FLAGS+=-D CUDA
endif

ifeq ($(debug),enable)
	CPP_COMPILER_FLAGS+=-D DEBUG
endif

all : $(SOURCES) 

.PHONY : $(SOURCES)
$(SOURCES) :
	@$(BUILDER_ROOT)/wizards/colored_echo.sh \
		$(BUILDER_ROOT)/wizards/colors.sh \
		"message" \
		"Build "$@
	@make --no-print-directory -C $@ 

include $(BUILDER_ROOT)/core/clean.mk
include $(BUILDER_ROOT)/core/setup.mk
include $(BUILDER_ROOT)/core/install.mk
