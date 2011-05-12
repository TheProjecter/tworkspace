
config_file = $(CURDIR)/config.xml

.PHONY: optimize
optimize::
	@$(build_system)/tools/configure -gwcc > $(CURDIR)/.settings.mk
	@echo "<data>" > $(config_file)
	@echo "<prefix>/</prefix>" >> $(config_file)
	@echo "<makefiles>$(CURDIR)/makefile</makefiles>" >> $(config_file)
	@echo "<analyzes>analyzes.xml</analyzes>" >> $(config_file)
	@echo "<log>analyzes.log</log>" >> $(config_file)
	@echo "<tempdir>/tmp</tempdir>" >> $(config_file)
	@echo "<varname>CFLAGS</varname>" >> $(config_file)
	@echo "</data>" >> $(config_file)
	@$(build_system)/tools/optimizer/run -config=$(CURDIR)/config.xml -path=$(build_system)/tools/optimizer/
	@$(rm) -f analyzes.xml
	@$(rm) -f config.xml
	@$(rm) -f *gwcc_out*
	@$(build_system)/tools/configure > $(CURDIR)/.settings.mk
