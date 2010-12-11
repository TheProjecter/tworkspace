
BLDR_DIR	:= $(shell pwd)/tbuilder

MKF_DIR		:= $(BLDR_DIR)/core
TMPL_DIR	:= $(BLDR_DIR)/templates

include $(MKF_DIR)/macros.mk

.PHONY: wrong_arguments
wrong_arguments:
	@$(INFO) " You should type one of the the followings:" 
	@$(ENDL)
	@$(CODE) " make project" 
	@$(INFO) " - to create new project"
	@$(ENDL)
	@$(CODE) " make clean" 
	@$(ENDL)
	@$(CODE) " make remove" 
	@$(INFO) " - to remove one of the projects"
	@$(ENDL)
	@$(CODE) " make tar" 
	@$(INFO) " - to tar one of the projects"
	@$(ENDL)

.PHONY: project
project:
	@$(INFO) " Enter new project name: "
	@read P; if [ ! -d "$${P}" ]; then mkdir -p $${P}; echo "export BLDR_DIR	:= $(BLDR_DIR)\n \ninclude $(MKF_DIR)/macros.mk" > $${P}/makefile; cat $(TMPL_DIR)/first_time_makefile >> $${P}/makefile; /bin/bash $(MKF_DIR)/scripts/code.sh "$(MKF_DIR)/scripts/" " $${P}"; /bin/bash $(MKF_DIR)/scripts/info.sh $(MKF_DIR)/scripts/ " project was created successfully."; echo; else echo " There is another project with the name $${P}."; fi

.PHONY: remove
remove: clean

.PHONY: clean
clean: 
	@/bin/bash $(MKF_DIR)/scripts/info.sh $(MKF_DIR)/scripts/ " Enter the name of project you want to remove: "
	@read P; if [ -d "$${P}" ]; then rm -fr $${P}; /bin/bash $(MKF_DIR)/scripts/code.sh "$(MKF_DIR)/scripts/" " $${P}"; /bin/bash $(MKF_DIR)/scripts/info.sh $(MKF_DIR)/scripts/ " was removed successfully."; echo; else /bin/bash $(MKF_DIR)/scripts/info.sh $(MKF_DIR)/scripts/ " There is no project named "; /bin/bash $(MKF_DIR)/scripts/code.sh "$(MKF_DIR)/scripts/" $${P}; echo; fi

.PHONY: tar
tar: 
	@/bin/bash $(MKF_DIR)/scripts/info.sh $(MKF_DIR)/scripts/ " Enter the name of project you want to tar: "
	@read P; if [ -d "$${P}" ]; then if [ -d "$${P}/src" ]; then make -C $${P} clean --no-print-directory; cp $${P}/makefile __$${P}__tmp_makefile; sed s/export\ MKF_DIR\.\*/export\ MKF_DIR\:\=\$$\(shell\ pwd\)\\/\.\.\\/tbuilder\\/core/ __$${P}__tmp_makefile > $${P}/makefile; tar cjf $${P}.tar.bz2 $${P} $(notdir $(BLDR_DIR)); cp __$${P}__tmp_makefile $${P}/makefile; rm __$${P}__tmp_makefile; /bin/bash $(MKF_DIR)/scripts/code.sh "$(MKF_DIR)/scripts/" " $${P}.tar.bz2"; /bin/bash $(MKF_DIR)/scripts/info.sh $(MKF_DIR)/scripts/ " was created successfully."; echo; else  /bin/bash $(MKF_DIR)/scripts/code.sh $(MKF_DIR)/scripts/ "  $${P}"; /bin/bash $(MKF_DIR)/scripts/info.sh $(MKF_DIR)/scripts/ " is an empty project, there is no wise to create the tar of it. "; echo; fi; else  /bin/bash $(MKF_DIR)/scripts/info.sh $(MKF_DIR)/scripts/ " There is no project named "; /bin/bash $(MKF_DIR)/scripts/code.sh "$(MKF_DIR)/scripts/" $${P}; echo; fi
