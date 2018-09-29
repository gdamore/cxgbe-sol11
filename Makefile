#
# Makefile
#

TOP		=	.

include  Makefile.common
DISTNAME	=	cxgbe-sol11

all		:=	TARGET=all
install		:=	TARGET=install
lint		:=	TARGET=lint
ddict		:=	TARGET=ddict
clean		:=	TARGET=clean
clobber		:=	TARGET=clobber
distsrcs	:=	TARGET=distsrcs

sparc_ARCHS	=	sparcv9
i386_ARCHS	=	amd64
ARCH		=	$(HOST_ARCH:-%=%)
ARCHS_LIST	=	$(HOST_ARCH:-%=%_ARCHS)
ARCHS		=	${${ARCHS_LIST}}

SUBDIRS		=	drv cmd pkg man doc

DISTSRCS	=	Makefile Makefile.common Makefile.targ \
			README LICENSE

DISTLIST	=	$(MAKE) RELDIR=$(DISTNAME)-$(VER) distlist

HASH		:sh=	echo "\043"

distdebug :=	DEBUG=-DDEBUG
distbin :=	DEBUG=

#all:		drv cmd man
all:		drv
#install:	all .WAIT drv cmd man
lint:		drv cmd
clean:		drv cmd man pkg doc
distsrcs:	drv cmd man pkg doc
docs:		doc

clobber:	drv cmd man pkg doc
		$(RM) -f $(DISTNAME)*.zip

include Makefile.targ

dist:	distbin

distbin distdebug:	$(DISTNAME)-$(VER)-$(ARCH).zip

distclean:	clean
	$(RM) $(DISTNAME)-$(VER)-sparc.zip $(DISTNAME)-$(VER)-i386.zip

$(DISTNAME)-$(VER)-$(ARCH).zip:	all .WAIT package docs
	@$(RM) $(DISTNAME)-$(VER)
	mkdir $(DISTNAME)-$(VER)
	mkdir $(DISTNAME)-$(VER)/Packages
	mkdir $(DISTNAME)-$(VER)/Packages/$(ARCH)
	cp README $(DISTNAME)-$(VER)
	cp LICENSE $(DISTNAME)-$(VER)
	zip -r $@ $(DISTNAME)-$(VER)
	@$(RM) -r $(DISTNAME)-$(VER)

$(SUBDIRS):	FRC
	@for ISA in $(ARCHS); do	\
		echo "## Making $(TARGET) for $$ISA in $@"; \
		test -d obj.$$ISA || $(MKDIR) obj.$$ISA;		\
		( cd $@; $(MAKE) DEBUG=$(DEBUG) ISA=$$ISA $(TARGET));\
	done

package:	all
	cd pkg; $(MAKE) ISA=$$ISA all

FRC:
