prefix=/usr

PWD=`pwd`
CP=cp
linstall: CP=ln -s

all:

install:
	mkdir -p $(install_root)$(prefix)/bin
	$(CP) $(PWD)/yget $(install_root)$(prefix)/bin/yget
	$(CP) $(PWD)/yplay $(install_root)$(prefix)/bin/yplay

linstall: install
