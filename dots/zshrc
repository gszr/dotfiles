zstyle ':completion:*' completer _expand _expand_alias _complete _ignored _correct
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' '+l:|=* r:|=*'
zstyle ':completion:*:complete:*make:*:variables' hidden yes
zstyle ':completion:*' rehash true
zstyle ':completion:*' menu select
zstyle ':completion:*' keep-prefix true

fpath=($ZSH/completions $fpath)

autoload -Uz compinit && compinit
autoload -Uz colors && colors
autoload -Uz select-word-style && select-word-style bash
autoload -U history-search-end

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

# Dir stack
DIRSTACKSIZE=10
setopt AUTO_PUSHD

# Aliases

## shell

# MacOS
if [[ "$(uname -s)" = "Darwin" ]]; then
  alias ls='gls --color'
fi

# NetBSD - pkgsrc/misc/colorls
if [[ "$(uname -s)" = "NetBSD" ]]; then
  alias ls='colorls -G'
fi

# Linux
if [[ "$(uname -s)" = "Linux" ]]; then
  alias ls='ls --color'
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
alias gR='git reset'
alias grc='git rebase --continue'
alias grm='git rebase -i master'
alias gl='git log --oneline'

## Vagrant
alias vd='vagrant destroy'
alias vd!='vagrant destroy -f'
alias vu='vagrant up'
alias vh='vagrant halt'
alias vr='vagrant reload'
alias vs='vagrant ssh'
alias vst='vagrant status'

## misc
alias cvs='cvs -z9 -q'
alias svu='svn update'
alias grep='grep --color'
alias clipin='xclip -in -selection clipboard'
alias clipout='xclip -out -selection clipboard'
alias coqtop='rlwrap coqtop'
alias luajit='rlwrap luajit'
alias https='http --default-scheme=https'
alias dm='docker machine'
alias dc='docker compose'
alias lr='luarocks'
alias m='mbsync -a'
alias kong='bin/kong'
alias kr="kong migrations reset --yes; kong migrations bootstrap; kong restart"
alias vi="vim"
alias screen_on="xrandr --output DP1 --right-of eDP1 --auto --mode 3840x2160"
alias screen_off="xrandr --output DP1 --off"
alias today='date "+%-Y-%m-%d"'

zle -A backward-kill-word vi-backward-kill-word
zle -A backward-delete-char vi-backward-delete-char
zle -A backward-kill-line vi-kill-line
zle -N history-beginning-search-backward-end history-search-end

# Key bindings behavior
bindkey -v
bindkey -a "k" history-beginning-search-backward
bindkey -a "j" history-beginning-search-forward

# autoload some functions
for f ($(find $ZSH/functions/ -type f)); do
  source $f
done

PROMPT='$(ssh_get_info)%c%{$fg[blue]%} $ %{$reset_color%}'
RPROMPT='$(zsh_get_rprompt)'

if hash dircolors &> /dev/null; then
  eval `dircolors -b`
  zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
fi

if hash gdircolors &> /dev/null; then
  eval `gdircolors -b`
  zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
fi

