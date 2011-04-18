
clean:: .settings.mk
	$(rm) -fr $(arch_name) 
	$(rm) -f $(obj_files) 
	$(rm) -f $(dep_files)

distclean:: clean
	$(rm) -f .settings.mk
