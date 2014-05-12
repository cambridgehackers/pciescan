
all:
	gcc -o pciescanportal pciescanportal.c

install: all
	cp pciescanportal pciescan.sh /usr/local/bin/
	chown root:root /usr/local/bin/pciescanportal
	# setuid on pciescanportal, so that it can exec pciescan.sh
	chmod 7555 /usr/local/bin/pciescanportal
