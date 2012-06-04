CONFIGURE_SHELL ?= /bin/sh
CONFIGURE_CMD ?= $(CONFIGURE_SHELL) ./configure
COMMON_CONFIGURE_ARGS ?= --prefix=$(prefix)
PHPIZE ?= phpize

pre-configure:
	cd $(DISTDIR) && $(PHPIZE)

configure: patch pre-configure
	cd $(DISTDIR) && $(CONFIGURE_CMD) $(COMMON_CONFIGURE_ARGS) $(CONFIGURE_ARGS)

build: configure
	cd $(DISTDIR) && $(MAKE)

stage: build
	if test -d $(STAGE) ; then $(SUDO) rm -rf $(STAGE) ; fi
	cd $(DISTDIR) && $(SUDO) $(MAKE) install INSTALL_ROOT=$(STAGE)
