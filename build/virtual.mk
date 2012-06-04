configure: patch
build: configure

stage: build
	$(SUDO) $(INSTALL) -d -m 755 -o root $(STAGE)
