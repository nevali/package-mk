DISTFILENAME ?= $(DISTNAME).tar.bz2

extract: prepare $(DISTFILE)
	cd $(WORK) && tar jxf $(DISTFILE)
