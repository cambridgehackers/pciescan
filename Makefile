
PREFIX?=/usr/bin

all:
	sed -i "s|/usr/local/bin|$(PREFIX)|" pciescanportal.c
	gcc -o pciescanportal pciescanportal.c

install: all
	install -D -o root -g root -m4755 pciescanportal $(DESTDIR)$(PREFIX)/pciescanportal
	install -D -o root -g root -m755 pciescan.sh $(DESTDIR)$(PREFIX)/pciescan.sh

dpkg:
	git clean -fdx
	git buildpackage --git-upstream-branch=master --git-debian-branch=ubuntu/trusty --git-ignore-new -tc -us -uc

spkg:
	git clean -fdx
	sed -i s/precise/trusty/g debian/changelog
	git buildpackage --git-upstream-branch=master --git-debian-branch=ubuntu/trusty --git-ignore-new -tc -S
	sed -i s/trusty/precise/g debian/changelog
	git buildpackage --git-upstream-branch=master --git-debian-branch=ubuntu/trusty --git-ignore-new -tc -S
