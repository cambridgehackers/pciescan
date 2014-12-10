
PREFIX?=/usr/local/bin

all:
	sed -i s_/usr/local/bin_$(DESTDIR)_ pciescanportal.c
	gcc -o pciescanportal pciescanportal.c

install: all
	install -D -o root -g root -m4755 pciescanportal $(DESTDIR)$(PREFIX)
	install -D -o root -g root -m755 pciescan.sh $(DESTDIR)$(PREFIX)
