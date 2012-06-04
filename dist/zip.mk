DISTFILENAME ?= $(DISTNAME).zip

extract: prepare $(DISTFILE)
	cd $(WORK) && unzip $(DISTFILE)
