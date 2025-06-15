#https://www.lazyvim.org/installation!/usr/bin/env bash
#set -x
# .bashrc
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export FONT="Hack"
export LD_LIBRARY_PATH="/usr/lib64/libreadline.so.8.2"

export DISPLAY=$(ip route list default | awk '{print $3}'):0
export LIBGL_ALWAYS_INDIRECT=1

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# If not connected to a terminal, don't do anything
#if ! tty &>/dev/null; then
#return
#fi

# use nvim to open manpages
export MANPAGER='nvim +Man!'
export MANWIDTH=999

# Set color

case "$TERM" in
xterm-color | *-256color) color_prompt=yes ;;
esac

#export TERM=screen-256color
set termguicolors

# start tmux session automatically or attach to existing session
function manage_tmux() {
  if ! command -v tmux >/dev/null 2>&1; then
    echo "tmux not found on this machine"
  else
    if [ -z "$TMUX" ]; then
      if [ -z "$(tmux list-sessions 2>/dev/null)" ]; then
        exec tmux new-session
      else
        exec tmux attach
      fi
      unbind -a
    fi
  fi
}
# Load cheatsheet
. ~/.bash.d/cht.sh

# Change window color to red when connecting to remote
function sshTmuxColor() {
  if [ -n "$TMUX" ]; then
    case "$1" in
    suresh*)
      tmux set-option -g window-status-current-style bg=green
      # tmux selectp -P 'fg=white,bg=colour22' #colour124=darker-green
      ;;
    *)
      tmux set-option -g window-status-current-style bg=red
      tmux selectp -P 'fg=white,bg=colour52' # color28=darker-red
      ;;
    esac
  fi
  ssh "$@"
  tmux selectp -P default
}

alias ssh=sshTmuxColor

# update ssh agent socket
SSHAGENT=/usr/bin/ssh-agent
SSHAGENTARGS="-s"
if [ -z "$SSH_AUTH_SOCK" ] && [ -x "$SSHAGENT" ]; then
  eval "$($SSHAGENT $SSHAGENTARGS)" >/dev/null
  trap 'kill $SSH_AGENT_PID' 0
fi
# load Fuzzy finder if present
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

#load rsa key
ssh-add 2>/dev/null
ssh-add ~/.ssh/*rsa 2>/dev/null

# Colorize grep output (good for log files)
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# kill process by name (killbyname)
killbyname() {
  local process_name="$1"
  if [ -z "$process_name" ]; then
    echo "Usage: killbyname <process-name>"
    return 1
  fi

  # List matching processes
  echo "Processes matching '$process_name':"
  ps aux | grep "$process_name" | grep -v grep

  # Ask for confirmation
  read -p "Do you want to kill these processes? (y/N): " confirm
  if [[ "$confirm" =~ ^[Yy]$ ]]; then
    pkill -f "$process_name"
    echo "Killed all processes matching: $process_name"
  else
    echo "Action canceled."
  fi
}

# confirm before overwriting something
alias cp="cp -i"
alias mv='mv -i'
alias rm='rm -i'

alias lsd='eza -lhDF'                #list only directories
alias lsf="ls -lArth | grep -v '^d'" #list only files
alias ll='eza -lhaF -s=modified'     # use exa instead of ls
alias ..='cd ..'
alias refresh='export $(tmux show-environment SSH_AUTH_SOCK)'
alias today='date +%F'
alias yesterday='date --date yesterday +%F'
alias vimdiff='nvim -d'
alias vim='nvim'
alias passwd-generate="python3 -c \"import string,random; print (''.join(random.sample(string.punctuation+string.ascii_lowercase+string.ascii_uppercase+string.digits, 14)))\""
alias ping='ping -c 8' #send only 8 packets for ping

# CD Aliasse
alias sm='cd /home/suresh/trading'
alias smk="cd /home/suresh/git/trading/Screeni-py/src/; python3.10 -W ignore::FutureWarning screenipy.py"
alias gt='cd /home/suresh/git'

# process handling
alias kbn='killbyname'

# Git

#source ~/.git-prompt.sh

# Launch lazygit and toggle tmux color
alias lg='tmux set -g window-active-style "fg=default,bg=black";\
  lazygit;\
  tmux set -g window-active-style "fg=colour40,bg=black";'

# Eazy navigation across directories
function up() {
  local d=""
  local limit="$1"

  # Default to limit of 1
  if [ -z "$limit" ] || [ "$limit" -le 0 ]; then
    limit=1
  fi

  for ((i = 1; i <= limit; i++)); do
    d="../$d"
  done

  # perform cd. Show error if cd fails
  if ! cd "$d"; then
    echo "Couldn't go up $limit dirs."
  fi
}

#Extract a archive file based on its extension
# usage extract <file>
function extract() {
  if [ -f "$1" ]; then
    case "$1" in
    *.tar.bz2) tar xvjf "$1" ;;
    *.tar.gz) tar xvzf "$1" ;;
    *.bz2) bunzip2 "$1" ;;
    *.rar) unrar x "$1" ;;
    *.gz) gunzip "$1" ;;
    *.tar) tar xvf "$1": ;;
    *.tbz2) tar xvjf "$1" ;;
    *.tgz) tar xvzf "$1" ;;
    *.zip) unzip "$1" ;;
    *.Z) uncompress "$1" ;;
    *.7z) 7za x "$1" ;;
    *) echo "Oops.. Don't know how to extract '$1'..." ;;
    esac
  else
    echo "'$1' is not a valid file!"
  fi
}

shopt -s autocd       # change to the directory
shopt -s cdspell      # autorcorrects cd misspellings
shopt -s cmdhist      # save multiline commands in history as a single line
shopt -s checkwinsize # check the window size after each command and, if necessary, update the values of LINES and COLUMNS.
shopt -s expand_aliases
shopt -s direxpand
shopt -s dirspell
shopt -s dotglob
shopt -s histreedit
shopt -s hostcomplete
shopt -s nocaseglob

# Optimize autom completion
bind "set completion-ignore-case on"
set show-all-if-ambiguous on
set completion-prefix-display-length 2
complete -o bashdefault -o default -o nospace -o filenames cd

# History search
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
bind 'set show-all-if-ambiguous on'

# never truncate bash history file
HISTSIZE=100000
HISTFILESIZE=200000
export HISTFILESIZE=
export HISTSIZE=
export HISTTIMEFORMAT="[%F %T] "
# always write a history line
#export PROMPT_COMMAND="history -a; $PROMPT_COMMAND"

# append to the history file, don't overwrite it
shopt -s histappend

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

# local RPM repository maintenance funcions
if [ -f ~/.localrpm ]; then
  . "$HOME/.localrpm"
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f ~/.profile ]; then
  . "$HOME/.profile"
fi

if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

umask 0022
export el7=centos-7-x86_64
#proxy
#pw=""
#ur=""
#export http_proxy="http://$ur:$pw@:8080"
#export https_proxy="$http_proxy"
#export ftp_proxy="$http_proxy"
#export all_proxy="$http_proxy"
#export no_proxy=domain.com
#export RSYNC_PROXY="$ur:$pw@"
#unset pw
#unset ur

# customised PS1 prompt to change color based on exit code of last executed command.
RED="$(tput setaf 1)"
GREEN="$(tput setaf 2)"
YELLOW="$(tput setaf 3)"
BLUE="$(tput setaf 4)"
VIOLET="$(tput setaf 5)"
CYAN="$(tput setaf 6)"
LIGHT_GRAY="$(tput setaf 7)"
RESET="$(tput sgr0)"
BOLD="$(tput bold)"

# git-prompt
#YELLOW="\[\033[01;33m\]"
#BLUE="\[\033[00;34m\]"
#LIGHT_GRAY="\[\033[0;37m\]"
#CYAN="\[\033[01;36m\]"
#GREEN="\[\033[00;32m\]"
#RED="\[\033[0;31m\]"
#VIOLET='\[\033[01;35m\]'
export LS_OPTIONS='--color=auto'
export CLICOLOR='Yes'
export LSCOLORS=gxfxbEaEBxxEhEhBaDaCaD

function color_my_prompt {
  __user_and_host="$GREEN\u@\h" # '\u' => Username '\h' => hostname
  __cur_location="$BLUE\W"      # 'W' => current directory, 'w' => full file path
  __git_branch_color="$GREEN"
  __prompt_tail="$VIOLET$"
  __user_input_color="$GREEN"
  #local __git_branch='`git branch 2> /dev/null | grep -e ^* | sed -E s/^\\\\\*\ \(.+\)$/\(\\\\\1\)\ /`'
  #local __git_branch='$(__git_ps1 " (%s)")';
  __git_branch=$(__git_ps1)

  # colour branch name depending on state
  if [[ "${__git_branch}" = "*" ]]; then # if repository is dirty
    __git_branch_color="$RED"
  elif [[ "${__git_branch}" =~ "$" ]]; then # if there is something stashed
    __git_branch_color="$YELLOW"
  elif [[ "${__git_branch}" =~ "%" ]]; then # if there are only untracked files
    __git_branch_color="$LIGHT_GRAY"
  elif [[ "${__git_branch}" =~ "+" ]]; then # if there are staged files
    __git_branch_color="$CYAN"
  fi

  # build prompt string
  PS1="${__user_and_host} ${__cur_location}${__git_branch_color}${__git_branch} ${__prompt_tail}${__user_input_color} "
}
customised_PS1() {
  #colors
  # Display red bash prompt when previous command's exit code is non zero
  trap 'PREVIOUS_COMMAND=$THIS_COMMAND; THIS_COMMAND=$BASH_COMMAND' DEBUG
  read -r -d '' PROMPT_COMMAND <<'END'
  if [ $? = 0 -o $? == 130 -o "$PREVIOUS_COMMAND" = ": noop" ]; then
    # call PROMPT_COMMAND which is executed before PS1
    color_my_prompt
    # export PROMPT_COMMAND=color_my_prompt
  else
    PS1=$'\u274C ${YELLOW}[$?] ${RED}\u@\h\w ${BOLD}\$ ${RESET}'
  fi
  : noop
END
}

# Uncomment below to use basic git-prompt (without colours)
#export PROMPT_COMMAND='__git_ps1 "\u:\W" "$"'

if [ -f ~/.git-prompt.sh ]; then
  GIT_PS1_SHOWDIRTYSTATE=true
  GIT_PS1_SHOWSTASHSTATE=true
  GIT_PS1_SHOWUNTRACKEDFILES=true
  GIT_PS1_SHOWUPSTREAM="auto"
  GIT_PS1_HIDE_IF_PWD_IGNORED=true
  GIT_PS1_SHOWCOLORHINTS=true
  . ~/.git-prompt.sh
fi

# main
manage_tmux

if [ "$color_prompt" = yes ]; then
  customised_PS1
fi

PROMPT_DIRTRIM=3

# Disable flow control to fix lazy  freeze issue.
# stty -ixon
# exec fish
exec fish
