# vim: filetype=zsh

export CODE=$HOME/Code

export CONF=$CODE/conf
export ZSH=$CONF/zsh

export CVS_RSH="ssh"
export CVSROOT="salazar@cvs.NetBSD.org:/cvsroot"
export ANONCVS="anoncvs@anoncvs.NetBSD.org:/cvsroot"

export CLICOLOR="YES"
export VISUAL=vim
export EDITOR=vim
export LESS="-RMIKC +Gg"
export PAGER=less

eval $(/usr/libexec/path_helper)
export PATH="$PATH:$HOME/.bin:$HOME/.local/bin:/usr/local/sbin"

export WIKI=$CODE/wiki

# RVM
if [[ -d $HOME/.rvm ]]; then
  export PATH="$PATH:$HOME/.rvm/bin"
  source /Users/$USER/.rvm/scripts/rvm
fi

# Go
export GOPATH="$CODE/go"
export PATH="$PATH:$GOPATH/bin"

# Rust
export PATH="$PATH:$HOME/.cargo/bin"

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
