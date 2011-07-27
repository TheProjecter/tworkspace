#------------------------------------------------------------------------------
#
# Include this makefile if you need to copy files.
#
# The COPY_SOURCES and COPY_DEST make variable must be set before
# including this file.
#
#------------------------------------------------------------------------------

# Variables.

ifeq "$(COPY_SRC)" ""
    COPY_SRC := .
endif

ifeq "$(COPY_DEST_FILES)" ""
    COPY_DEST_FILES := $(addprefix $(COPY_DEST)/, $(COPY_SOURCES))
endif

# Rules.

prebuild:: $(COPY_DEST_FILES)

# Strip the doxygen documentation if we are coping user header files

$(TARGET_DEST)/$(ARCH_NAME)/unison/ltx/include/%.h: $(COPY_SRC)/%.h
	$(TEST) -d $(TARGET_DEST)
	$(MKDIR) -p $(dir $@)
	$(RM) -f $@
	$(PERL) $(VOBS)/sys/api_doc/bin/Doxy_clean -f $< -o $@

# Otherwise, just do a normal file copy for all other files.

$(COPY_DEST)/%: $(COPY_SRC)/%
	$(copy-file-or-link)

clean::
	$(RM) -rf $(COPY_DEST_FILES)

