
PREFIX?=/usr/bin

all:
	gcc -o pciescanportal pciescanportal.c

install: all
	install -D -m4755 pciescanportal $(DESTDIR)$(PREFIX)/pciescanportal
	install -D -m755 pciescan.sh $(DESTDIR)$(PREFIX)/pciescan.sh

dpkg:
	git clean -fdx
	git buildpackage --git-upstream-branch=master --git-debian-branch=ubuntu/trusty --git-ignore-new -tc -us -uc

spkg:
	git clean -fdx
	git buildpackage --git-upstream-branch=master --git-debian-branch=ubuntu --git-upstream-tag='v%(version)s' --git-ignore-new -tc -S
	sed -i s/trusty/precise/g debian/changelog
	git buildpackage --git-upstream-branch=master --git-debian-branch=ubuntu --git-upstream-tag='v%(version)s' --git-ignore-new -tc -S
	sed -i s/precise/utopic/g debian/changelog
	git buildpackage --git-upstream-branch=master --git-debian-branch=ubuntu --git-upstream-tag='v%(version)s' --git-ignore-new -tc -S
	git clean -fdx
	git checkout debian

upload:
	git push origin v$(VERSION)
	dput ppa:jamey-hicks/connectal ../pciescan_$(VERSION)-*_source.changes
	(cd  ../obs/home:jameyhicks:connectaldeb/pciescan/; osc rm * || true)
	cp -v ../pciescan_$(VERSION)*trusty*.diff.gz ../pciescan_$(VERSION)*trusty*.dsc ../pciescan_$(VERSION)*trusty*.orig.tar.gz ../obs/home:jameyhicks:connectaldeb/pciescan/
	(cd ../obs/home:jameyhicks:connectaldeb/pciescan/; osc add *; osc commit -m $(VERSION) )
	(cd ../obs/home:jameyhicks:connectal/pciescan; sed -i "s/>v.....</>v$(VERSION)</" _service; osc commit -m "v$(VERSION)" )
