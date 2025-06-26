# for non-interactive sessions stop execution here -- https://serverfault.com/a/805532/67528
[[ $- != *i* ]]  && return

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

export PATH="$HOME/bin:$PATH"

export GEM_HOME=$HOME/.gem
export PATH="$GEM_HOME/bin:$PATH"

export PATH="$HOME/.local/bin:$PATH"

export EDITOR="emacs"
export VISUAL="emacs"

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
if ! isRemoteSession; then
  stty stop ''; stty start '';
fi

# export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# sort
export LC_COLLATE=C

[ -x /usr/libexec/java_home ] && export JAVA_HOME=`/usr/libexec/java_home 2>/dev/null`

# Render markdown
function rmd () {
	pandoc $1 | lynx -stdin
}

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

[[ -r ~/.alias ]] && source ~/.alias

# ssh-agent
if ! [[ -e /.dockerenv ]]; then
	# look for .ssh_prime or ssh_prime
	if [[ -x $HOME/.ssh_prime ]]; then
		source $HOME/.ssh_prime
	else
    	type ssh_prime >&/dev/null && source ssh_prime
	fi
fi
