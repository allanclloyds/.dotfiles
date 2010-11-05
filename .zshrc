# ~/.zshrc: Allan C. Lloyds <acl@acl.im>

# setup paths
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/games:/usr/local/bin:/usr/local/sbin
HOME_PATH=$HOME/bin
if [[ -d $HOME/.gem/ruby/1.8/bin ]] ; then
  HOME_PATH=$HOME_PATH:$HOME/.gem/ruby/1.8/bin
fi
PATH=$HOME_PATH:$PATH
if [[ -d /usr/X11R6/bin    ]] ; then PATH=$PATH:/usr/X11R6/bin    ; fi # fhs
if [[ -d /opt/bin          ]] ; then PATH=$PATH:/opt/bin          ; fi # fhs
if [[ -d /opt/sbin         ]] ; then PATH=$PATH:/opt/sbin         ; fi # fhs
if [[ -d /opt/gnome/bin    ]] ; then PATH=$PATH:/opt/gnome/bin    ; fi # enu
if [[ -d /opt/kde3/bin     ]] ; then PATH=$PATH:/opt/kde3/bin     ; fi # enu
if [[ -d /usr/lib/mit/bin  ]] ; then PATH=$PATH:/usr/lib/mit/bin  ; fi # enu
if [[ -d /usr/lib/mit/sbin ]] ; then PATH=$PATH:/usr/lib/mit/sbin ; fi # enu
export PATH

# setup completion
autoload -Uz compinit
compinit
zstyle :compinstall filename '/home/allan/.zshrc'

autoload -U colors
colors
autoload -Uz vcs_info

# setup history
if [ -e "$HOME/.histfile" ]; then
  chmod 600 $HOME/.histfile 2>/dev/null
fi
export HISTFILE=~/.histfile
export HISTSIZE=1000
export SAVEHIST=1000

# setup aliases
if [ -e "$HOME/.aliases" ]; then
  source "$HOME/.aliases"
fi

# setup options
setopt histignoredups # ignore duplicate history entries
setopt prompt_subst   # expand functions in the prompt
setopt notify         # notify immediately on job status change
unsetopt autocd beep
bindkey -v

# generic profile options
export PS1='%{$fg_bold[yellow]%}%n@%m%{${reset_color}%}:%{$fg_bold[red]%}%~%{${reset_color}%} %# '
if [[ ${TERM} == "screen-256color-bce" ]]; then
  precmd  () { print -Pn "\033k\033\134\033kzsh:%~\033\134" }
  preexec () { print -Pn "\033k\033\134\033k$1\033\134" }
fi
export HOME TERM
export EDITOR=/usr/bin/vim

# openbsd stuff
if [ `uname -s` = "OpenBSD" ]; then
  PKG_PATH=ftp://ftp.plig.net/pub/OpenBSD/`uname -r`/packages/`arch -s`
  export PKG_PATH
fi


# development stuff
export PYTHONSTARTUP=~/.pythonstartup
if [[ -s $HOME/.rvm/scripts/rvm ]] ; then . $HOME/.rvm/scripts/rvm ; fi
