
PREFIX?=/usr/local/bin

all:
	gcc -o pciescanportal pciescanportal.c

install: all
	install -D -o root -g root -m4755 pciescanportal $(DESTDIR)$(PREFIX)
	install -D -o root -g root -m755 pciescan.sh $(DESTDIR)$(PREFIX)
