EXT = zmqext

# The default target
default::

# -----------------------------------------------------------------------------
#
# Customisable build options
#
# -----------------------------------------------------------------------------

# How to call REBOL 3 (required for header generation)
R3 = rebol3

# Path to the R3 Host Kit (the host kit's header files are required for this
# extension)
R3_HOSTKIT = ../../hostkit

# Alternatively to changing those settings here, you can also override them
# in a local build configuration file.
-include build/local.mk

# -----------------------------------------------------------------------------

# Standard hostkit/extension overrides
override CPPFLAGS =
%.so: override CPPFLAGS += -DTO_LINUX
%.dll: override CPPFLAGS += -DTO_WIN32
override CFLAGS += -I $(R3_HOSTKIT)/src/include
override LDFLAGS += -shared

# Library-specific overrides
override LDFLAGS += -lzmq

default::
	@echo "This build currently supports the following primary targets:"
	@echo "   $(EXT).so    Build $(EXT) for Linux"
	@echo "   $(EXT).dll   Build $(EXT) for Win32"

full: $(EXT).so $(EXT).dll

%.h: %.r3
	$(R3) -q make-ext-header.r3 $< > $@

%.so: %.c %.h
	$(CC) $(CPPFLAGS) $(CFLAGS) $(LDFLAGS) -o $@ $<

%.dll: %.c %.h
	$(CC) $(CPPFLAGS) $(CFLAGS) $(LDFLAGS) -o $@ $<

.PHONY: clean
clean:
	-rm -f $(EXT).so $(EXT).dll $(EXT).h
