ifeq ($(DISTURLS),)

ifeq ($(DISTGROUP),gnu)
DISTURL ?= http://ftp.gnu.org/gnu/$(PACKAGE)/
endif

endif

fetch:
	if test -d $(DISTFILES)/$(DISTGROUP) ; then true ; else mkdir -p $(DISTFILES)/$(DISTGROUP) || exit $? ; fi
ifeq ($(DISTURLS),)
	CURL="$(CURL)" $(SHELL) $(MK)/fetch.sh "$(DISTFILE)" "$(DISTFILENAME)" "$(DISTURL)"
else
	CURL="$(CURL)" $(SHELL) $(MK)/fetch.sh "$(DISTFILES)/$(DISTGROUP)" "-" $(foreach disturl,$(DISTURLS),"$(disturl)")
endif
