# vim: filetype=zsh

export CONF=$HOME/.conf
export ZSH=$CONF/zsh
export CVS_RSH="ssh"
export CVSROOT="salazar@cvs.NetBSD.org:/cvsroot"
export ANONCVS="anoncvs@anoncvs.NetBSD.org:/cvsroot"

# Environment
export CLICOLOR="YES"
export VISUAL=vim
export EDITOR=vim
export LESS="-RMIKC +Gg"
export PAGER=less

if [[ -f $HOME/.profile ]]; then
  source $HOME/.profile
fi

PATH="/usr/pkg/bin:$PATH"
PATH="/opt/pkg/bin:$PATH"
PATH="/opt/local/bin:$PATH"
PATH="$PATH:/usr/local/bin"
PATH="$PATH:$HOME/.bin"
PATH="$PATH:$HOME/.local/bin"
export PATH

DEV="$HOME/Code"

export WIKI=$DEV/misc/wiki

# RVM
if [[ -d $HOME/.rvm ]]; then
  export PATH="$PATH:$HOME/.rvm/bin"
  source /Users/$USER/.rvm/scripts/rvm
fi

# Go
export GOPATH="$DEV/go"
export PATH="$PATH:$GOPATH/bin"

# Rust
export PATH="$HOME/.cargo/bin:$PATH"

# OpenResty
if [[ "$OSTYPE" = "darwin"* ]]; then
  export RESTY_PATH="/usr/local/opt/openresty"
else
  export RESTY_PATH="/usr/local/openresty"
fi
export PATH="$PATH:$RESTY_PATH/bin"
export PATH="$PATH:$RESTY_PATH/luajit/bin"

# Kong paths
export KONG="$DEV/kong"
export KONG_PLUGINS="$KONG/kong-plugins"
export KONG_VAGRANT="$KONG/kong-vagrant"
export KONG_COMPOSE="$KONG/kong-tests-compose"

# Kong config
export KONG_ANONYMOUS_REPORTS=false
export KONG_LOG_LEVEL="debug"
export KONG_DNS_HOSTSFILE="/etc/hosts_kong"
export KONG_NGINX_WORKER_PROCESSES="$(nproc 2>/dev/null || gnproc)"

# Kong vagrant
export KONG_UTILITIES=yes

# Homebrew
export HOMEBREW_NO_AUTO_UPDATE=true
export HOMEBREW_MAKE_JOBS=$(( $(nproc 2> /dev/null || gnproc) + 1 ))

# SSH
SSH_ENV="$HOME/.ssh/env"

function start_agent {
  echo -n "Initialising new SSH agent... "
  ssh-agent -t 3600 | sed 's/^echo/#echo/' > "$SSH_ENV"
  echo "succeeded"
  chmod 600 "${SSH_ENV}"
  . "${SSH_ENV}" > /dev/null
}

source $ZSH/functions/ssh # load ssh helpers
if ! is_ssh_session; then
  if [[ -f $SSH_ENV ]]; then
      . "${SSH_ENV}" > /dev/null
      if ! kill -0 $SSH_AGENT_PID &> /dev/null; then
        start_agent;
      fi
  else
      start_agent;
  fi
fi

export LANG="en_US.UTF-8" export LC_CTYPE="en_US.UTF-8" export LC_ALL=""
