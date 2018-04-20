
all: install

install: install-hosts

install-hosts:
	cat hosts.template > hosts.tmp
	curl -s https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling/hosts | sed 1,20d >> hosts.tmp
	sudo mv hosts.tmp /etc/hosts
