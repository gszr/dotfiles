zstyle ':completion:*' completer _expand _expand_alias _complete _ignored _correct
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' '+l:|=* r:|=*'
zstyle ':completion:*:complete:*make:*:variables' hidden yes
zstyle ':completion:*' rehash true
zstyle ':completion:*' menu select

# TODO review this in the future
. ~/.zprofile

autoload -Uz history-search-end
autoload -Uz compinit && compinit
autoload -Uz select-word-style && select-word-style bash
autoload -Uz colors && colors

# History
HISTSIZE=10000
SAVEHIST=$HISTSIZE
HISTFILE=$HOME/.zhistory

setopt APPEND_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_VERIFY
setopt PROMPT_SUBST

# Dir stack -- should I persist those? :)
DIRSTACKSIZE=10
setopt AUTO_PUSHD

# Aliases

## shell

# MacOS
if [[ "$(uname -s)" = "Darwin" ]]; then
  alias ls='ls -G'
fi

# NetBSD - pkgsrc/misc/colorls
if [[ "$(uname -s)" = "NetBSD" ]]; then
  alias ls='colorls -G'
fi

# Linux
if [[ "$(uname -s)" = "Linux" ]]; then
  alias ls=' ls --color'
fi

## Git
alias gs='git status'
alias gS='git stash'
alias gSp='git stash pop'
alias ga='git add'
alias ga!='git add -A'
alias gb='git branch'
alias gc='git commit'
alias gc!='git commit --amend --no-edit'
alias gd='git diff'
alias gdc='git diff --cached'
alias gp='git push'
alias gp!='git push -f'
alias gP='git pull'
alias gk='git checkout'
alias gm='git merge'
alias gf='git fetch'
alias gr='git rebase'
alias gl='git log --oneline'

## httpie
alias h="http"
alias hP="http PUT"
alias hp="http POST"
alias hd="http DELETE"

## Vagrant
alias vd='vagrant destroy'
alias vu='vagrant up'
alias vh='vagrant halt'
alias vr='vagrant reload'
alias vs='vagrant ssh'
alias vst='vagrant status'

## Kong
alias kr="kong migrations reset --yes && kong migrations up && kong restart"

## misc
alias cvs='cvs -z9 -q'
alias svu='svn update'
alias grep='grep --color'
alias clipin='xclip -in -selection clipboard'
alias clipout='xclip -out -selection clipboard'
alias coqtop='rlwrap coqtop'
alias luajit='rlwrap luajit'
alias https='http --default-scheme=https'
alias dm='docker-machine'
alias dc='docker-compose'
alias m='mbsync -a'

# Enable editing the buffer past the point where
# insert mode was activated
zle -A backward-kill-word vi-backward-kill-word
zle -A backward-delete-char vi-backward-delete-char
zle -A backward-kill-line vi-kill-line
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end

# Key bindings behavior
bindkey -v
bindkey -a "k" history-beginning-search-backward-end
bindkey -a "j" history-beginning-search-forward-end

# cannot be in zprofile, since current tty can be different
# from the login shell's
export GPG_TTY=$(tty)

# ZSH customs

# autoload some functions
for f ($(find $ZSH/functions/ -type f)); do
  source $f
done

PROMPT='$(ssh_get_info)%c%{$fg[blue]%} $ %{$reset_color%}'
RPROMPT='$(zsh_get_rprompt)'

if hash gdircolors &> /dev/null; then
  eval `gdircolors ~/.dircolors`
  zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
fi
