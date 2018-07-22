# vim: filetype=zsh

export CODE=$HOME/Code

export CONF=$CODE/dotfiles
export ZSH=$CONF/zsh

export CVS_RSH="ssh"
export CVSROOT="salazar@cvs.NetBSD.org:/cvsroot"
export ANONCVS="anoncvs@anoncvs.NetBSD.org:/cvsroot"

export CLICOLOR="YES"
export VISUAL=vim
export EDITOR=vim
export LESS="-RMIKC +Gg"
export PAGER=less

if [[ "$(uname -s)" == "Darwin" ]]; then
  eval $(/usr/libexec/path_helper)
  export PATH="$PATH:/usr/local/bin:/usr/local/sbin"
fi

if [[ "$(uname -s)" == "NetBSD" ]]; then
  export PATH="$PATH:/usr/pkg/bin:/usr/pkg/sbin:/usr/X11R7/bin"
fi

export PATH="$PATH:$HOME/.bin:$HOME/.local/bin"

export WIKIS=$CODE/wikis

# Go
export GOPATH="$CODE/go"
export PATH="$PATH:$GOPATH/bin"

# Rust
export PATH="$PATH:$HOME/.cargo/bin"

# Ruby
if which rbenv &> /dev/null; then
  eval "$(rbenv init -)"
fi

# OpenResty
if [[ "$OSTYPE" = "darwin"* ]]; then
  export RESTY_PATH="/usr/local/opt/openresty"
else
  export RESTY_PATH="/usr/local/openresty"
fi
export PATH="$PATH:$RESTY_PATH/bin"
export PATH="$PATH:$RESTY_PATH/luajit/bin"

# Kong paths
export KONG="$CODE/kong"
export KONG_PLUGINS="$KONG/kong-plugins"
export KONG_VAGRANT="$KONG/kong-vagrant"
export KONG_COMPOSE="$KONG/kong-tests-compose"

# Kong config
export KONG_ANONYMOUS_REPORTS=false
export KONG_LOG_LEVEL="notice"
export KONG_NGINX_WORKER_PROCESSES="$(nproc 2>/dev/null || gnproc)"
export KONG_PREFIX="./servroot_dev"

# Kong vagrant
export KONG_UTILITIES=yes

# Homebrew
export HOMEBREW_NO_AUTO_UPDATE=true
export HOMEBREW_MAKE_JOBS=$(( $(nproc 2> /dev/null || gnproc) + 1 ))

export LANG="en_US.UTF-8" export LC_CTYPE="en_US.UTF-8" export LC_ALL=""
