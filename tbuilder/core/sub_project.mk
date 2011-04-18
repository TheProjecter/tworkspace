
core_path	:= $(bldr_path)/core
tmpl_path	:= $(bldr_path)/templates

.PHONY: sub_project project
project: sub_project

sub_project: 
	@$(INFO) " Enter the first sub-project name: "; \
	read P; \
	if [ "$${P}" = "" ]; then \
		$(ERROR) "You didn't type the project name"; $(ENDL); \
	else if [ -d "src/$${P}" ]; then \
		$(ERROR) " There is another sub-project with the name "; \
		$(CODE) "$${P}" $(ENDL); \
	else \
		$(INFO) " Enter the test name of sub-project "; \
		$(CODE) "$${P}: (test_$${P}) "; \
		read T; \
		if [ "$${T}" = "" ]; then \
			T=test_$${P}; \
		fi; \
		mkdir -p src/$${P}; \
		cp $(tmpl_path)/src_makefile src/$${P}/makefile; \
		cp $(tmpl_path)/src_main src/$${P}/main.cpp; \
		cp makefile ___makefile.tmp___; \
		echo "projects += $${P}" > makefile; \
		echo "tests    += $${T}" >> makefile; \
		cat ___makefile.tmp___ >> makefile; \
		rm ___makefile.tmp___; \
		$(INFO) " was created successfully."; $(ENDL); \
		$(INFO) " top makefile was replaced"; $(ENDL); \
		mkdir -p tst/$${T}/inputs; \
		mkdir -p tst/$${T}/outputs; \
		tst_mkf=tst/$${T}/makefile; \
		echo "bldr_path  := $(bldr_path)" > $${tst_mkf}; \
		echo "utilities_path := $(utilities_path)" >> $${tst_mkf}; \
		echo "export core_path  := $(bldr_path)/core" >> $${tst_mkf}; \
		echo "export product_root  := $(shell pwd)" >> $${tst_mkf}; \
		cat $(tmpl_path)/tst_makefile >> $${tst_mkf}; \
		cp $(tmpl_path)/src_main tst/$${T}/main.cpp; \
	fi; fi
