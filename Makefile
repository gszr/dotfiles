# config files
CFG  = bin vim docker zshrc gitconfig zprofile dircolors urlview mutt msmtprc mbsyncrc gitignore_global

OS != uname -s
.if ${OS} != "Darwin"
CFG += i3 xinitrc Xresources imwheelrc
.endif

# vim plugins
.if !defined(VIM)
VIM  = https://github.com/salazar/vim-colors-solarized
VIM += https://github.com/vimwiki/vimwiki
.endif

VIM_DIR = vim/pack/plugins/start
.if exists(${VIM_DIR})
PLUGINS != ls ${VIM_DIR}
.endif

all:
	@echo "clean, prepare or install?"

install: prepare link

prepare: prepare-vim-plugins prepare-solarized prepare-urxvt prepare-docker \
	prepare-dircolors prepare-zsh prepare-mbsync prepare-msmtp

prepare-vim-plugins: prepare-vim
	@echo "Preparing VIM plugins"
.for plg in ${VIM}
	git -C ${VIM_DIR} clone ${plg}
.endfor

prepare-vim:
	@echo "Preparing VIM..."
	mkdir -p ${VIM_DIR}
	mkdir -p vim/swap

prepare-solarized:
	@echo "Preparing X Solarized"
	git clone https://github.com/solarized/xresources Xsolarized

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

prepare-mbsync:
	@echo "Preparing mbsync..."
	cp mbsyncrc.template mbsyncrc
	@echo "'mbsynrc' created; EDIT PLACEHOLDERS!"

prepare-msmtp:
	@echo "Preparing msmtp..."
	cp msmtprc.template msmtprc
	@echo "'msmtp' created; EDIT PLACEHOLDERS!"

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

clean: clean-links clean-vim clean-misc

clean-links:
	@echo "Cleaning symlinks..."
.for cfg in $(CFG)
	rm -f ~/.$(cfg)
.endfor

clean-vim:
	@echo "Cleaning VIM stuff..."
	rm -rf vim/pack
	rm -rf vim/swap

clean-misc:
	@echo "Cleaning urxvt, X solarized..."
	rm -f ~/.urxvt/ext
	rm -rf Xsolarized
