# ~/.zshrc: Allan C. Lloyds <acl@acl.im>
# vim: set et ff=unix ft=zsh fdm=marker ts=2 sw=2 sts=2 tw=0: 
# see ~/.profile for ksh/bash/zsh startup file loading order

limit    core 0
unsetopt flow_control
unsetopt beep

# autoloading functions
# http://zsh.sourceforge.net/Doc/Release/zsh_8.html
fpath=( ~/.zsh/functions $fpath )
autoload -U ~/.zsh/functions/*(:t)

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
setopt histignorespace  # ignore lines starting with a space
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

# ANSI color codes:
# To enter escape sequence do Ctrl-v [Esc] (Vim)
#
# Effects ######################################
# 00  Reset/Normal/Default                     #
# 01  Bold                                     #
# 04  Underlined                               #
# 05  Blink/Flashing                           #
# 07  Inverse                                  #
# 08  Concealed                                #
# Colours & Backgrounds ########################
# 30  Black        40  Black background        #
# 31  Red          41  Red background          #
# 32  Green        42  Green background        #
# 33  Orange       43  Orange background       #
# 34  Blue         44  Blue background         #
# 35  Purple       45  Purple background       #
# 36  Cyan         46  Cyan background         #
# 37  Grey         47  Grey background         #
# 90  Dark grey    100 Dark grey background    #
# 91  Light red    101 Light red background    #
# 92  Light green  102 Light green background  #
# 93  Yellow       103 Yellow background       #
# 94  Light blue   104 Light blue background   #
# 95  Light purple 105 Light purple background #
# 96  Turquoise    106 Turquoise background    #
# 97  White        107 White background        #
################################################

# prompt and terminal title
PS1_LONG='
%{$fg[yellow]%}%n@${${TTY#/dev/}//\//-}.%m%{${reset_color}%}:%{$fg_bold[red]%}%~%{${reset_color}%} %# '
PS1_SHORT='
%{$fg[yellow]%}%#%{$reset_color%} '

export PS1=${PS1_LONG}

case ${TERM} in
  screen*)
    # Keep the prompt short and sweet for screen
    export PS1=${PS1_SHORT}
    # XXX Unsure where the extra space is coming from but moving the cursor forward then back deals with it
    #     Github users: This line contains control characters you can't see: eg. '{%^[[1C...'
    # %D{} strftime formats: http://www.kernel.org/doc/man-pages/online/pages/man3/strftime.3.html
    export RPROMPT='%{[1C[90m%}%D{%Y-%m-%d %a} %{[0m%}%{[100;30m%}%D{%H:%M}%{[00;90m%}%D{:%S}%{[0m[1D%}'
    # Current working directory goes into the window title, ruby version and git branch into the hardstatus
    # See http://www.nesono.com/node/322 for another way to get git branch into screen
    precmd  () { print -Pn "\033k\033\134\033k%~\033\134\e]0;${${RUBY_VERSION:-system}#ruby-}, ${$(parse_git_branch):-none}\a" }
    preexec () { print -Pn "\033k\033\134\033k$1\033\134" }
    ;;
  xterm*|rxvt)
    precmd  () { print -Pn "\e]0;%n@${${TTY#/dev/}//\//-}.%m (zsh:%~)\a" }
    preexec () { print -Pn "\e]0;%n@${${TTY#/dev/}//\//-}.%m ($1)\a" }
    ;;
esac

# setup aliases, suffix aliases and default programs
if [[ -e ~/.aliases ]]; then
  . ~/.aliases
fi

if [[ -e ~/.zsh/aliases ]]; then
  . ~/.zsh/aliases
fi

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
