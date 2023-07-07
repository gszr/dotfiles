
# dotfiles
CFG  = bin
CFG += vim
CFG += docker
CFG += zshrc
CFG += zshenv
CFG += zprofile
CFG += gitconfig
CFG += dircolors
CFG += urlview
CFG += mutt
CFG += msmtprc
CFG += mbsyncrc
CFG += xbindkeysrc
CFG += offlineimaprc
CFG += offlineimap.py
CFG += gitignore_global
CFG += config/nvim
CFG += tmux.conf
CFG += config/alacritty
CFG += config/redshift.conf
CFG += config/user-dirs.dirs
CFG += gnupg/gpg.conf
CFG += gnupg/gpg-agent.conf

# those are **disabled** under Mac
OS != uname -s
.if ${OS} != "Darwin"

CFG += i3
CFG += xinitrc
CFG += Xresources
CFG += imwheelrc

.endif


# vim plugins
# environment variable takes precedence
.if !defined(VIM)

VIM  = https://github.com/altercation/vim-colors-solarized
VIM += https://github.com/vimwiki/vimwiki
VIM += https://github.com/mhinz/vim-rfc
VIM += https://github.com/ruanyl/vim-gh-line.git

.endif


# list existing plugins
VIM_DIR = vim/pack/plugins/start
.if exists(${VIM_DIR})

PLUGINS != ls ${VIM_DIR}

.endif


all:
	@echo "clean, prepare or install?"

install: prepare link

prepare: \
	prepare-dynamic-colors \
	prepare-vim-plugins \
	prepare-urxvt \
	prepare-docker \
	prepare-dircolors \
	prepare-zsh \
	prepare-bin

prepare-self:

prepare-vim-plugins: prepare-vim
	@echo "Preparing VIM plugins"
.for plg in ${VIM}
.if ! exists(${VIM_DIR}/${plg})
	git -C ${VIM_DIR} clone ${plg}
.endif
.endfor

prepare-vim:
	@echo "Preparing VIM..."
	mkdir -p ${VIM_DIR}
	mkdir -p vim/swap

prepare-dynamic-colors:
	@echo "Preparing dynamic colors"
	git clone https://github.com/sos4nt/dynamic-colors.git ~/.dynamic-colors

prepare-urxvt:
	@echo "Preparing urxvt..."
	mkdir -p ~/.urxvt

prepare-docker:
	@echo "Preparing Docker..."
	cp docker/config.json.template docker/config.json

prepare-zsh:
	@echo "Preparing ZSH..."
	curl https://raw.githubusercontent.com/docker/cli/master/contrib/completion/zsh/_docker > zsh/completions/_docker
	curl https://raw.githubusercontent.com/docker/compose/master/contrib/completion/zsh/_docker-compose > zsh/completions/_docker-compose
	curl https://raw.githubusercontent.com/docker/machine/master/contrib/completion/zsh/_docker-machine > zsh/completions/_docker-machine
	curl https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/plugins/vagrant/_vagrant > zsh/completions/_vagrant

prepare-dircolors:
	@echo "Preparing dircolors..."
	curl https://raw.githubusercontent.com/seebi/dircolors-solarized/master/dircolors.ansi-dark > dircolors

prepare-bin:
	@echo "Preparing bin..."
	git clone https://github.com/gszr/bin.git

update: update-vim-plugins

update-vim-plugins:
	@echo "Updating VIM plugins..."
.for plg in ${PLUGINS}
.if exists(${VIM_DIR}/${plg}/.git)
	@echo "Updating ${plg}..."
	git -C ${VIM_DIR}/${plg} pull
.endif
.endfor

link:
	@echo "Creating symlinks..."
.for cfg in $(CFG)
	ln -sfn $(PWD)/$(cfg) ~/.$(cfg)
.endfor
	ln -sfn $(PWD)/bin/urxvt-perl ~/.urxvt/ext
	ln -sfn ${PWD} ~/.conf

clean: clean-links clean-vim clean-misc

clean-links:
	@echo "Cleaning symlinks..."
.for cfg in $(CFG)
	rm -f ~/.$(cfg)
.endfor
	rm -f ~/.conf

clean-vim:
	@echo "Cleaning VIM stuff..."
	rm -rf vim/pack
	rm -rf vim/swap

clean-misc:
	@echo "Cleaning urxvt"
	rm -f ~/.urxvt/ext
	rm -rf bin
	rm -rf ~/.dynamic-colors
