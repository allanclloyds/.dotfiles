# ~/.bash_logout: Allan C. Lloyds <acl@acl.im>
# vim: set et ff=unix ft=sh fdm=marker ts=2 sw=2 sts=2 tw=0: 
# see ~/.profile for ksh/bash/zsh startup file loading order

# this script is executed by bash(1) when login shell exits

# when leaving the console clear screen to increase privacy
if [ "$SHLVL" = 1 ]; then
    [ -x /usr/bin/clear_console ] && /usr/bin/clear_console -q
fi
