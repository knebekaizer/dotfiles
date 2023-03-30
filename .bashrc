# git prompt
# deprecated, use git symbolic-ref --short HEAD 2>/dev/null # Upd: does not work for "detached HEAD"
# Format: "* master" OR "* (HEAD detached at 8cfc577)"
function parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d; s/^\* *//'
}

function isRemoteSession {
	if [[ -f /.dockerenv ]] || [[ -n $DOCKER_RUNNING ]]; then
		return 0
	fi
	if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
		return 0
	fi
	return 1
}

RED="\[\033[0;31m\]"
RED_BOLD="\[\033[1;31m\]"
GREEN="\[\033[0;32m\]"
YELLOW="\[\033[0;33m\]"
BLUE="\[\033[0;34m\]"
MAGENTA="\[\033[0;35m\]"
CYAN="\[\033[0;36m\]"
NO_COLOUR="\[\033[0m\]"
# if [[ -z $DOCKER ]]; then
if isRemoteSession; then
	export PS1="$RED_BOLD\u$NO_COLOUR@$RED_BOLD\h: $BLUE\w $RED\$(parse_git_branch)$NO_COLOUR\n$ "
else
	export PS1="$CYAN\h: $BLUE\w $RED\$(parse_git_branch)$NO_COLOUR\n$ "
fi

export PATH="~/bin:$PATH"

export GEM_HOME=$HOME/.gem
export PATH="$GEM_HOME/bin:$PATH"

export PATH="/home/vdi/.local/bin:$PATH"

export EDITOR="emacs -nw"
export VISUAL="emacs -nw"

# sh / bash / terminal hacks
shopt -s histappend
#PROMPT_COMMAND='history -a; history -n'
PROMPT_COMMAND='history -a'
export HISTCONTROL="ignorespace:ignoredups"    # ignore duplicate and lines started with space
export HISTSIZE=9999
#export HISTIGNORE="&:ls:[bf]g:exit"
shopt -s cmdhist                   # multiple line commands
# Use failure status when piping, eg `cat blabla.txt | grep` when `cat` fails
set -o pipefail
# Disable Ctrl-S and Ctrl-Q in tty which I always confused by (and keep it free for tmux/screen control)
stty stop ''; stty start '';

# export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_COLLATE=C

[ -x /usr/libexec/java_home ] && export JAVA_HOME=`/usr/libexec/java_home 2>/dev/null`

# Render markdown
function rmd () {
	pandoc $1 | lynx -stdin
}

# ssh-agent
#. ~/bin/ssh_prime
#SSH_INFO=~/.ssh-agent-info-`hostname`
#[ -f $SSH_INFO ] && source $SSH_INFO

#if brew command command-not-found-init >&/dev/null; then eval "$(brew command-not-found-init)"; fi
#if [ -f $(brew --prefix)/etc/bash_completion ]; then . $(brew --prefix)/etc/bash_completion; fi

[ -f ~/.git-completion.bash ] && source ~/.git-completion.bash
[ -f ~/.ssh-completion.bash ] && source ~/.ssh-completion.bash

# zstd settings
[[ -r ~/.zstdrc ]] && source ~/.zstdrc

# HOME_BREW package manager
# which brew >&/dev/null
# BREW_INSTALLED=$?
# if [[ BREW_INSTALLED ]]; then
if [[ -x /opt/homebrew/bin/brew ]]; then
	eval "$(/opt/homebrew/bin/brew shellenv)"
	export HOMEBREW_EDITOR=mate
	# Override BSD utilities with GNU alternative (GNU binutils)
	GNUPATH="$BREW_PREFIX/opt/coreutils/libexec/gnubin:$PATH"
	PATH="$PATH:/opt/homebrew/opt/binutils/bin"
fi

# Linuxbrew
if [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
	eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

[[ -r ~/.alias ]] && source ~/.alias

# ssh-agent
type ssh_prime && source ssh_prime
