# ~/.zprofile: Allan C. Lloyds <acl@acl.im>
# vim: set et ff=unix ft=zsh fdm=marker ts=2 sw=2 sts=2 tw=0: 
# see ~/.profile for ksh/bash/zsh startup file loading order

# paths, umask are setup in ~/.profile
if [ -f ~/.profile ]; then
  emulate sh
  . ~/.profile
  emulate zsh
fi
