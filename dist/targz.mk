DISTFILENAME ?= $(DISTNAME).tar.gz

extract: prepare $(DISTFILE)
	cd $(WORK) && tar zxf $(DISTFILE)
