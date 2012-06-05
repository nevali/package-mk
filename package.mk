TOP ?= ../..
ROOT ?= $(shell cd $(TOP) && pwd)

#### Tunables

include $(ROOT)/config.mk

DISTTYPE ?= targz
BUILDTYPE ?= autotools
PKGTYPE ?= deb
prefix ?= /usr/local

TMPDIR ?= /tmp
PKGDIR ?= $(shell pwd)
STAGE ?= $(TMPDIR)/$(LOGNAME).$(PACKAGE)-$(VERSION)
REL_WORK ?= work
WORK ?= $(PKGDIR)/$(REL_WORK)
MK ?= $(ROOT)/mk
DISTGROUP ?= $(PACKAGE)
DISTFILES ?= $(ROOT)/distfiles
DISTNAME ?= $(PACKAGE)-$(VERSION)
DISTDIRNAME ?= $(DISTNAME)
DISTDIR ?= $(WORK)/$(DISTDIRNAME)
PATCHDIR ?= $(PKGDIR)/patches

ifneq ($(DISTURLS),)
DISTFILE = $(foreach urlpair,$(DISTURLS),$(DISTFILES)/$(DISTGROUP)/$(word 1,$(subst |, ,$(urlpair))))
else
DISTFILE ?= $(DISTFILES)/$(DISTGROUP)/$(DISTFILENAME)
endif

OPSYS ?= $(shell uname -s | tr 'A-Z' 'a-z')

include $(MK)/opsys/$(OPSYS).mk

## Defaults

ARCH ?= $(shell arch)

MD5 ?= md5
SUDO ?= sudo
AR ?= ar
INSTALL ?= install
CURL ?= curl

ifeq ($(ARCH),x86_64)
PKGARCH ?= amd64
endif

PKGARCH ?= $(ARCH)
ifeq ($(ARCH),all)
PKGTARGET ?= all
else
PKGTARGET ?= $(OPSYS)-$(PKGARCH)
endif

POOL ?= $(ROOT)/pool/binary-$(PKGTARGET)

#### Package build rules

all: package

env:
	@env

clean: cleanwork

cleanwork:
	rm -rf $(WORK)

ifneq ($(DISTTYPE),custom)
include $(MK)/dist/$(DISTTYPE).mk
endif

ifneq ($(BUILDTYPE),custom)
include $(MK)/build/$(BUILDTYPE).mk
endif

ifneq ($(DISTTYPE),none)
include $(MK)/fetch.mk
endif

include $(MK)/pkg/$(PKGTYPE).mk

PATCHLIST = $(foreach patch,$(PATCHES) $(PATCHES_$(OPSYS)) $(PATCHES_$(ARCH)) $(PATCHES_$(OPSYS)_$(ARCH)),$(PATCHDIR)/$(patch))

prepare: clean fetch
	mkdir $(WORK)

poststage: stage

patch: extract
	if test x"$(PATCHLIST)" = x"" ; then \
		true ; \
	else \
		for p in $(PATCHLIST) ; do \
			cd $(DISTDIR) && patch -p1 < $$p || exit $? ; \
		done ; \
	fi

.PHONY: clean prepare extract configure build stage package poststage patch


