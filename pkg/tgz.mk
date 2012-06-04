## Rules for building .tgz packages

PKGNAME ?= $(PACKAGE)
PKGVER ?= $(VERSION)-$(RELEASE)
PKGFILE ?= $(POOL)/$(PKGNAME)-$(PKGVER)_$(PKGTARGET).tgz

package: $(PKGFILE)
	$(SUDO)	rm -rf $(STAGE)

$(PKGFILE): stage
	rm -f $(PKGFILE)
	mkdir -p $(POOL)
	cd $(STAGE) && tar zcvf $(PKGFILE) .
