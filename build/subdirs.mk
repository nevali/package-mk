configure: patch
build: configure
stage: build

package:
	for i in $(SUBDIRS) ; do $(MAKE) -C $$i || exit 255 ; done

clean:
	for i in $(SUBDIRS) ; do $(MAKE) -C $$i clean || exit 255 ; done
