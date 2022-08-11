
# ssh-agent
#. ~/bin/ssh_prime
#SSH_INFO=~/.ssh-agent-info-`hostname`
#[ -f $SSH_INFO ] && source $SSH_INFO

#if brew command command-not-found-init >&/dev/null; then eval "$(brew command-not-found-init)"; fi
#if [ -f $(brew --prefix)/etc/bash_completion ]; then . $(brew --prefix)/etc/bash_completion; fi

[ -f ~/.git-completion.bash ] && source ~/.git-completion.bash
[ -f ~/.ssh-completion.bash ] && source ~/.ssh-completion.bash

# Override BSD utilities with GNU alternative (GNU binutils)
GNUPATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"

. ~/.alias
