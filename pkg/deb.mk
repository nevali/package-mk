PKGNAME ?= $(PACKAGE)
PKGVER ?= $(VERSION)-$(RELEASE)
PKGFILE ?= $(POOL)/$(PKGNAME)-$(PKGVER)_$(PKGTARGET).deb
PRIORITY ?= optional
SECTION ?= extra
SHORTDESC ?= $(PACKAGE) $(PKGVER)

export PKGNAME
export PKGVER
export PKGTARGET
export PRIORITY
export SECTION
export SHORTDESC
export DESC
export DEPENDS
export BUILD_DEPENDS
export HOMEPAGE

REL_DEBIAN = debian
DEBIAN = $(PKGDIR)/$(REL_DEBIAN)

REL_DEBWORK = $(REL_WORK)/debian
DEBWORK = $(WORK)/debian

REL_DEBSTAMP = $(REL_WORK)/debian-binary
DEBSTAMP = $(WORK)/debian-binary

REL_CONTROLTAR = $(REL_WORK)/control.tar.gz
CONTROLTAR = $(WORK)/control.tar.gz

REL_DATATAR = $(REL_WORK)/data.tar.gz
DATATAR = $(WORK)/data.tar.gz

CONTROL-IN = $(DEBIAN)/control
CONFFILES-IN = $(DEBIAN)/conffiles

REL_CONTROL = $(REL_DEBWORK)/control
CONTROL = $(DEBWORK)/control

REL_CONFFILES = $(REL_DEBWORK)/conffiles
CONFFILES = $(DEBWORK)/conffiles

REL_MD5SUMS = $(REL_DEBWORK)/md5sums
MD5SUMS = $(DEBWORK)/md5sums

package: stage poststage debprep $(PKGFILE)
	$(SUDO)	rm -rf $(STAGE)

debprep:
	@rm -rf $(DEBWORK)
	mkdir -p $(DEBWORK)

pkgfile: $(PKGFILE)

$(PKGFILE): $(REL_DEBSTAMP) $(REL_CONTROLTAR) $(REL_DATATAR)
	rm -f $(PKGFILE)
	mkdir -p $(POOL)
	cd $(WORK) && $(AR) -r -c $(PKGFILE) debian-binary control.tar.gz data.tar.gz

$(REL_DATATAR):
	$(SUDO) rm -f $(STAGE)$(prefix)/share/info/dir
	rm -f $(DATATAR)
	cd $(STAGE) && gtar cf $(WORK)/data.tar .
	cd $(WORK) && gzip -9 data.tar

$(REL_DEBSTAMP):
	echo '2.0' > $(DEBSTAMP)

debscripts:
	for i in preinst postinst prerm postrm ; do \
		if test -r $(DEBIAN)/$$i ; then \
			cat $(DEBIAN)/$$i | sed \
				-e 's!%package%!$(PKGNAME)!g' \
				-e 's!%version%!$(PKGVER)!g' \
				-e 's!%arch%!$(PKGTARGET)!g' \
				-e 's!%prefix%!$(prefix)!g' \
			> $(DEBWORK)/$$i ; \
			chmod 755 $(DEBWORK)/$$i ; \
		fi ; \
	done

$(REL_CONTROLTAR): $(REL_CONTROL) $(REL_CONFFILES) debscripts $(REL_MD5SUMS)
	cd $(DEBWORK) && tar zcf $(CONTROLTAR) .

$(REL_DEBWORK):
	mkdir -p $(REL_DEBWORK)

$(REL_CONFFILES): $(REL_DEBWORK)
	if test -r "$(CONFFILES-IN)" ; then \
		cat $(CONFFILES-IN) | sed \
			-e 's!%prefix%!$(prefix)!g' \
		> $(CONFFILES) ; \
	else \
		touch $(CONFFILES) ; \
	fi

control: $(REL_CONTROL)

$(REL_CONTROL): $(REL_DEBWORK) $(firstword $(MAKEFILE_LIST))
	src="" ; test -r "$(CONTROL-IN)" && src="$(CONTROL-IN)" ; $(SHELL) $(MK)/pkg/gen-deb-control.sh "$(src)" "$(CONTROL)"

$(REL_MD5SUMS): $(REL_DEBWORK)
	( cd $(STAGE) && find . -type f -exec $(MD5) -r '{}' ';' | sed -e 's! ./! !' ) > $(MD5SUMS)

.PHONY: debprep debscripts pkgfile control

