# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions

## disable terminal flow control (ctrl+s "freezing" terminal) if on an interactive shell
[[ $- == *i* ]] && stty -ixon

## setup my aliases
alias ..='cd ..'
alias ...='cd ../..'
alias l.='ls -dN .* --color=auto'
alias la='ls -alN --color=auto'
alias ll='ls -lN --color=auto'
alias ls='ls -N --color=auto'
alias open='xdg-open'

## setup my paths
#export JAVA_HOME="/usr/java/latest"
#export GOPATH=$HOME/go
#export PATH=$PATH:$GOPATH/bin

## configure pip
### source: Hitchhiker's Guide to Python
### cache frequently used packages locally
#export PIP_DOWNLOAD_CACHE=$HOME/.pip/cache
### keep clean by requiring pip to run only in virtenvs; use gpip to override
#export PIP_REQUIRE_VIRTUALENV=true
#gpip() {
#	PIP_REQUIRE_VIRTUALENV="" pip "$@"
#}

## setup dircolors
#eval `dircolors ~/.config/dotfiles/.dircolors/dircolors.myconfig`

## setup todo.txt
#source ~/.todo/todo_completion
#complete -F _todo t
#alias t='todo.sh'

## setup powerline
command -v powerline-daemon &>/dev/null
if [ $? -eq 0 ]; then
    powerline-daemon -q
    POWERLINE_BASH_CONTINUATION=1
    POWERLINE_BASH_SELECT=1
    . /usr/share/powerline/bash/powerline.sh
#else
#    . /usr/share/git-core/contrib/completion/git-prompt.sh
fi

## kubectl autocompletion
#command -v kubectl &>/dev/null
#if [ $? -eq 0 ]; then
#	source <(kubectl completion bash)
#fi

## setup ssh-agent
### source: Joseph M. Reagle
#SSH_ENV="$HOME/.ssh/environment"
#
#function start_agent {
#     echo "Initialising new SSH agent..."
#     /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
#     echo succeeded
#     chmod 600 "${SSH_ENV}"
#     . "${SSH_ENV}" > /dev/null
##     /usr/bin/ssh-add;
#}

## Source SSH settings, if applicable
#if [ -f "${SSH_ENV}" ]; then
#     . "${SSH_ENV}" > /dev/null
#     #ps ${SSH_AGENT_PID} doesn't work under cywgin
#     ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
#         start_agent;
#     }
#else
#     start_agent;
#fi


## improve bash history behavior
### source: raychi @ stackoverflow.com
### remove duplicates while preserving input order
function dedup {
   #awk '! x[$0]++' $@             # in input order
   tac $@ | awk '! x[$0]++' | tac # in chronological order
}

### removes $HISTIGNORE commands from input
function remove_histignore {
   if [ -n "$HISTIGNORE" ]; then
      # replace : with |, then * with .*
      local IGNORE_PAT=`echo "$HISTIGNORE" | sed s/\:/\|/g | sed s/\*/\.\*/g`
      # negated grep removes matches
      grep -vx "$IGNORE_PAT" $@
   else
      cat $@
   fi
}

### clean up the history file by removing duplicates and commands matching $HISTIGNORE entries
function history_cleanup {
   local HISTFILE_SRC=~/.bash_history
   local HISTFILE_DST=/tmp/.$USER.bash_history.clean
   if [ -f $HISTFILE_SRC ]; then
      \cp $HISTFILE_SRC $HISTFILE_SRC.backup
      dedup $HISTFILE_SRC | remove_histignore >| $HISTFILE_DST
      \mv $HISTFILE_DST $HISTFILE_SRC
      chmod go-r $HISTFILE_SRC
      history -c
      history -r
   fi
}

export HISTCONTROL=ignoredups:erasedups  # no duplicate entries
export HISTSIZE=100000                   # big big history
export HISTFILESIZE=100000               # big big history
shopt -s histappend                      # append to history, don't overwrite it

