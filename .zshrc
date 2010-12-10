# ~/.zshrc: Allan C. Lloyds <acl@acl.im>
# vim: set et ff=unix ft=zsh fdm=marker ts=2 sw=2 sts=2 tw=0: 
# see ~/.profile for ksh/bash/zsh startup file loading order

limit    core 0
unsetopt flow_control
unsetopt beep

# setup completion and other zsh options
zstyle   :compinstall filename '/home/allan/.zshrc'
zmodload zsh/complist
autoload -U compinit colors vcs_info
compinit; colors

# pick up new commands in $path automatically
# http://zshwiki.org/home/examples/compquickstart
_force_rehash() {
  (( CURRENT == 1 )) && rehash
  return 1
}
zstyle ':completion:::::' completer _force_rehash _complete _approximate

zstyle -e ':completion:*:approximate:*' max-errors 'reply=( $(( ($#PREFIX + $#SUFFIX) / 3 )) )'
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always
zstyle ':completion:*:descriptions' format "- %d -"
zstyle ':completion:*:corrections' format "- %d - (errors %e})"
zstyle ':completion:*:default' list-prompt '%S%M matches%s'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:manuals' separate-sections true
zstyle ':completion:*:manuals.(^1*)' insert-sections true
zstyle ':completion:*' menu select
zstyle ':completion:*' verbose yes

setopt histignoredups   # ignore duplicate history entries
setopt prompt_subst     # expand functions in the prompt
setopt check_jobs       # report job status before exit, 2nd exit will succeed
setopt notify           # notify immediately on job status change
setopt mail_warn        # warn if mail file has been accessed since shell last checked
setopt print_exit_value # show exit code when > 0
setopt autocd           # cd by entering directory as command
bindkey -v              # vi editing mode

export WATCH=all
export LOGCHECK=30
export WATCHFMT="%n from %M has %a tty%l at %T %W"

# setup history
touch $HOME/.histfile
chmod 600 $HOME/.histfile 2>/dev/null
export HISTFILE=~/.histfile
export HISTSIZE=1000
export SAVEHIST=1000

# prompt and terminal title
export PS1='%{$fg_bold[yellow]%}%n@${${TTY#/dev/}//\//-}.%m%{${reset_color}%}:%{$fg_bold[red]%}%~%{${reset_color}%} %# '
case ${TERM} in
  screen*)
    precmd  () { print -Pn "\033k\033\134\033kzsh\033\134\e]0;${STY#*.}\a" }
    preexec () { print -Pn "\033k\033\134\033k$1\033\134" }
    ;;
  xterm*|rxvt)
    precmd  () { print -Pn "\e]0;%n@${${TTY#/dev/}//\//-}.%m (zsh:%~)\a" }
    preexec () { print -Pn "\e]0;%n@${${TTY#/dev/}//\//-}.%m ($1)\a" }
    ;;
esac

# setup aliases, suffix aliases and default programs
if [[ -e "$HOME/.aliases" ]]; then
  source "$HOME/.aliases"
fi

ls --color >/dev/null 2>&1
if [[ "$?" -eq "0" ]]; then
  alias ls="ls --color"
fi
alias ll="ls -lFah"

if [[ -x ~/bin/vim ]]; then
  export EDITOR=~/bin/vim
else
  export EDITOR=/usr/bin/vi
fi

for suffix in "rb" "erb" "haml" "md" "markdown" "textile"; do
  alias -s ${suffix}=${EDITOR}
done

if [[ `which w3m` != 'w3m not found' ]]; then
  export PAGER=`which w3m`
  export BROWSER=${PAGER}
  for suffix in "html" "htm" "uk" "com" "net" "org" "edu"; do
    alias -s ${suffix}=`which w3m`
  done
fi

# quick change directories from zsh-lovers(1) eg cd ..../dir
rationalise-dot() {
  if [[ $LBUFFER = *.. ]]; then
    LBUFFER+=/..
  else
    LBUFFER+=.
  fi
}
zle -N rationalise-dot
bindkey . rationalise-dot

# development stuff
export PYTHONSTARTUP=~/.pythonstartup
if [[ -s $HOME/.rvm/scripts/rvm ]] ; then . $HOME/.rvm/scripts/rvm ; fi
