
MKF_DIR		:= $(BLDR_DIR)/core
TMPL_DIR	:= $(BLDR_DIR)/templates

.PHONY: sub_project project
project: sub_project

sub_project: 
	@$(INFO) " Enter the first sub-project name: "; read P; if [ "$${P}" = "" ]; then $(ERROR) "You didn't type the project name"; $(ENDL); else if [ -d "src/$${P}" ]; then $(ERROR) " There is another sub-project with the name "; $(CODE) "$${P}"; $(ENDL); else $(INFO) " Enter the test name of sub-project "; $(CODE) "$${P}: (test_$${P}) "; read T; if [ "$${T}" = "" ]; then T=test_$${P}; fi; mkdir -p src/$${P}; cp $(TMPL_DIR)/src_makefile src/$${P}/makefile; cp $(TMPL_DIR)/src_main src/$${P}/main.cpp; cp makefile ___makefile.tmp___; echo "PROJECTS 	+= $${P}\nTESTS 	+= $${T}\n\n" > makefile; cat ___makefile.tmp___ >> makefile; rm ___makefile.tmp___; $(INFO) " was created successfully."; echo; $(INFO) " top makefile was replaced"; echo; mkdir -p tst/$${T}/inputs; mkdir -p tst/$${T}/outputs; echo "BLDR_DIR  := $(BLDR_DIR)\nexport MKF_DIR  := $(BLDR_DIR)/core\n" > tst/$${T}/makefile; cat $(TMPL_DIR)/tst_makefile >> tst/$${T}/makefile; cp $(TMPL_DIR)/src_main tst/$${T}/main.cpp; fi; fi
	
#@$(INFO) " Enter the sub-project name: "; read P; if [ -d "src/$${P}" ]; then $(ERROR) " There is another sub-project with the name $${P}: "; else $(INFO) " Enter the test name of sub-project "; $(CODE) "$${P}: (test_$${P}) "; read T; mkdir -p src/$${P}; cp $(TMPL_DIR)/src_makefile src/$${P}/makefile; cp $(TMPL_DIR)/src_main src/$${P}/main.cpp; $(MKF_DIR)/scripts/code.sh "$(MKF_DIR)/scripts/" " $${P}"; cp makefile ___makefile.tmp___; echo "PROJECTS 	+= $${P}\n" > makefile; cat ___makefile.tmp___ >> makefile; rm ___makefile.tmp___; /bin/bash $(MKF_DIR)/scripts/info.sh $(MKF_DIR)/scripts/ " was created successfully."; echo; /bin/bash $(MKF_DIR)/scripts/info.sh $(MKF_DIR)/scripts/ " makefile was changed"; echo; fi
	
