# ~/.kshrc: Allan C. Lloyds <acl@acl.im>
# vim: set et ff=unix ft=sh fdm=marker ts=2 sw=2 sts=2 tw=0: 
# see ~/.profile for ksh/bash/zsh startup file loading order

# OpenBSD global initialization for ksh
if [ -f "/etc/ksh.kshrc" ]; then
  . "/etc/ksh.kshrc"
fi

# Note that this script is run for both interactive and
# non-interactive shells unlike bash/zsh.
