
clean:: .settings.mk
	$(rm) -fr $(arch_name) 
	$(rm) -f $(obj_files) 
	$(rm) -f $(dep_files)

distclean:: clean
	$(rm) -f .settings.mk
	$(rm) -f config.xml
	$(MAKE) -C ./unit_tests clean
	$(rm) -f unit_tests/.settings.mk
	$(rm) -f unit_tests/config.xml
