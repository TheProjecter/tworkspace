
MKF_DIR		:= $(BLDR_DIR)/core
TMPL_DIR	:= $(BLDR_DIR)/templates

.PHONY: sub_project
sub_project: 
	@$(INFO) " Enter the sub-project name: "; read P; mkdir -p src/$${P}; cp $(TMPL_DIR)/src_makefile src/$${P}/makefile; cp $(TMPL_DIR)/src_main src/$${P}/main.cpp; $(MKF_DIR)/scripts/code.sh "$(MKF_DIR)/scripts/" " $${P}"; cp makefile ___makefile.tmp___; echo "PROJECTS 	+= $${P}\n" > makefile; cat ___makefile.tmp___ >> makefile; rm ___makefile.tmp___; /bin/bash $(MKF_DIR)/scripts/info.sh $(MKF_DIR)/scripts/ " was created successfully."; echo; /bin/bash $(MKF_DIR)/scripts/info.sh $(MKF_DIR)/scripts/ " makefile was replaced"; echo;
