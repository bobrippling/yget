prefix=/usr
manprefix=$(prefix)/share/man

PWD=`pwd`
CP=cp
linstall: CP=ln -s

all:

install:
	mkdir -p $(install_root)$(prefix)/bin
	$(CP) $(PWD)/yget $(install_root)$(prefix)/bin/yget
	$(CP) $(PWD)/yplay $(install_root)$(prefix)/bin/yplay
	$(CP) $(PWD)/ysubfix $(install_root)$(prefix)/bin/ysubfix
	$(CP) $(PWD)/yurl $(install_root)$(prefix)/bin/yurl
	mkdir -p $(install_root)$(manprefix)/man1
	$(CP) $(PWD)/yget.1 $(install_root)$(manprefix)/man1/yget.1
	ln -sf yget.1 $(install_root)$(manprefix)/man1/yplay.1
	ln -sf yget.1 $(install_root)$(manprefix)/man1/yurl.1

linstall: install

deb: FORCE
	fakeroot debian/rules binary

FORCE:
