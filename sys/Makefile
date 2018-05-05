
all: install

install: install-hosts

install-hosts:
	cat hosts.template > hosts.tmp
	curl -s https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn/hosts | sed 1,30d >> hosts.tmp
	sudo mv hosts.tmp /etc/hosts
