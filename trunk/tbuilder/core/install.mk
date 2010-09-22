
.PHONY: install
install:
	@if [ ! -d $(PREFIX) ]; then \
		mkdir $(PREFIX); \
	fi
	@if [ ! -d $(PREFIX)/bin ]; then \
		mkdir $(PREFIX)/bin; \
	fi
	@for i in $(PROJECTS); do \
		I=$$(basename $$i); \
		cp -f $(BIN_PATH)/$$I $(PREFIX)/bin/$$I; \
		echo "Installed $$I project."; \
	done;

.PHONY: uninstall
uninstall:
	@for i in $(PROJECTS); do \
		I=$$(basename $$i); \
		rm -f $(PREFIX)/bin/$$I; \
		echo "Removed $$I project."; \
	done;

.PHONY : check
check :
	make uninstall; make clean; make; make install; make run_script;
	@for i in $(PROJECTS); do \
		I=$$(basename $$i); \
		$(PREFIX)/bin/$$I; \
	done;

