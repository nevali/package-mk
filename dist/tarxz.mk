DISTFILENAME ?= $(DISTNAME).tar.xz
BUILD_DEPENDS += utils/xz

extract: prepare $(DISTFILE)
	cd $(WORK) && xz -dc $(DISTFILE) | tar xf -
