VERSION=18.05.1

PREFIX?=/usr/bin

all:
	gcc -o pciescanportal pciescanportal.c

install: all
	install -D -m4755 pciescanportal $(DESTDIR)$(PREFIX)/pciescanportal
	install -D -m755 pciescan.sh $(DESTDIR)$(PREFIX)/pciescan.sh

dpkg:
	git clean -fdx
	gbp buildpackage --git-upstream-branch=master --git-debian-branch=ubuntu/ --git-upstream-tag='v%(version)s' --git-ignore-new -tc -pgpg2 -us -uc

spkg:
	git clean -fdx
	gbp buildpackage --git-upstream-branch=master --git-debian-branch=ubuntu --git-upstream-tag='v%(version)s' --git-ignore-new -tc -pgpg2 -S
	git checkout debian
	sed -i s/trusty/xenial/g debian/changelog
	gbp buildpackage --git-upstream-branch=master --git-debian-branch=ubuntu --git-upstream-tag='v%(version)s' --git-ignore-new -tc -pgpg2 -S
	git checkout debian
	sed -i s/trusty/bionic/g debian/changelog
	gbp buildpackage --git-upstream-branch=master --git-debian-branch=ubuntu --git-upstream-tag='v%(version)s' --git-ignore-new -tc -pgpg2 -S
	git clean -fdx
	git checkout debian

upload:
	git push origin v$(VERSION)
	ls ../pciescan_$(VERSION)-*_source.changes
	dput ppa:jamey-hicks/connectal ../pciescan_$(VERSION)-*_source.changes
