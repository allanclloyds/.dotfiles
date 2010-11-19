# ~/.profile: Allan C. Lloyds <acl@acl.im>
# vim: set et ff=unix ft=sh fdm=marker ts=2 sw=2 sts=2 tw=0: 

# ksh/bash/zsh startup files loading order:

# Tables below from:
# http://shreevatsa.wordpress.com/2008/03/30/zshbash-startup-files-loading-order-bashrc-zshrc-etc/
# See also: http://meta.ath0.com/2007/10/23/cleaning-up-bash-customizations/

# Read down the appropriate column. Executes A, then B, then C, etc. The B1,
# B2, B3 means it executes only the first of those files found.

# Note this is not entirely correct, as zsh reads ~/.profile as well, if
# ~/.zshrc is not present (?) or if called as sh or ksh.

# ksh uses two startup files: ~/.profile (if one exists) and the
# startup file specified by the ENV environment variable (if set and exported)
# Typically, this is set to ~/.kshrc

# ~/.profile is read once, by a login ksh. The ENV file is read by each
# invocation of ksh, if ENV is defined in the current environment. Typically,
# users define ENV in their .profile file, and then this variable is available
# to all future child shells (unless ENV is unset).

# See /usr/share/doc/bash/examples/startup-files for bash startup examples.

# +----------------+-----------+-----------+------+
# |ksh             |Interactive|Interactive|Script|
# |                |login      |non-login  |      |
# +----------------+-----------+-----------+------+
# |~/.profile      |    A      |           |      |
# +----------------+-----------+-----------+------+
# |ENV             |    B      |    A      |  A   |
# +----------------+-----------+-----------+------+

# +----------------+-----------+-----------+------+
# |bash            |Interactive|Interactive|Script|
# |                |login      |non-login  |      |
# +----------------+-----------+-----------+------+
# |/etc/profile    |   A       |           |      |
# +----------------+-----------+-----------+------+
# |/etc/bash.bashrc|           |    A      |      |
# +----------------+-----------+-----------+------+
# |~/.bashrc       |           |    B      |      |
# +----------------+-----------+-----------+------+
# |~/.bash_profile |   B1      |           |      |
# +----------------+-----------+-----------+------+
# |~/.bash_login   |   B2      |           |      |
# +----------------+-----------+-----------+------+
# |~/.profile      |   B3      |           |      |
# +----------------+-----------+-----------+------+
# |BASH_ENV        |           |           |  A   |
# +----------------+-----------+-----------+------+
# |                |           |           |      |
# +----------------+-----------+-----------+------+
# |                |           |           |      |
# +----------------+-----------+-----------+------+
# |~/.bash_logout  |    C      |           |      |
# +----------------+-----------+-----------+------+

# +----------------+-----------+-----------+------+
# |zsh             |Interactive|Interactive|Script|
# |                |login      |non-login  |      |
# +----------------+-----------+-----------+------+
# |/etc/zshenv     |    A      |    A      |  A   |
# +----------------+-----------+-----------+------+
# |~/.zshenv       |    B      |    B      |  B   |
# +----------------+-----------+-----------+------+
# |/etc/zprofile   |    C      |           |      |
# +----------------+-----------+-----------+------+
# |~/.zprofile     |    D      |           |      |
# +----------------+-----------+-----------+------+
# |/etc/zshrc      |    E      |    C      |      |
# +----------------+-----------+-----------+------+
# |~/.zshrc        |    F      |    D      |      |
# +----------------+-----------+-----------+------+
# |/etc/zlogin     |    G      |           |      |
# +----------------+-----------+-----------+------+
# |~/.zlogin       |    H      |           |      |
# +----------------+-----------+-----------+------+
# |                |           |           |      |
# +----------------+-----------+-----------+------+
# |                |           |           |      |
# +----------------+-----------+-----------+------+
# |~/.zlogout      |    I      |           |      |
# +----------------+-----------+-----------+------+
# |/etc/zlogout    |    J      |           |      |
# +----------------+-----------+-----------+------+

# setup paths
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/games:/usr/local/bin:/usr/local/sbin
HOME_PATH=$HOME/bin
if   [ -d "${HOME}/.gem/ruby/1.9/bin" ] ; then
  HOME_PATH=$HOME_PATH:$HOME/.gem/ruby/1.9/bin
elif [ -d "${HOME}/.gem/ruby/1.8/bin" ] ; then
  HOME_PATH=$HOME_PATH:$HOME/.gem/ruby/1.8/bin
fi
PATH=$HOME_PATH:$PATH
if [ -d /usr/X11R6/bin    ] ; then PATH=$PATH:/usr/X11R6/bin    ; fi # fhs
if [ -d /opt/bin          ] ; then PATH=$PATH:/opt/bin          ; fi # fhs
if [ -d /opt/sbin         ] ; then PATH=$PATH:/opt/sbin         ; fi # fhs
if [ -d /opt/gnome/bin    ] ; then PATH=$PATH:/opt/gnome/bin    ; fi # enu
if [ -d /opt/kde3/bin     ] ; then PATH=$PATH:/opt/kde3/bin     ; fi # enu
if [ -d /usr/lib/mit/bin  ] ; then PATH=$PATH:/usr/lib/mit/bin  ; fi # enu
if [ -d /usr/lib/mit/sbin ] ; then PATH=$PATH:/usr/lib/mit/sbin ; fi # enu

if [ `uname -s` = "OpenBSD" ]; then
  PKG_PATH=ftp://ftp.plig.net/pub/OpenBSD/`uname -r`/packages/`arch -s`
  export PKG_PATH
fi

export ENV=$HOME/.kshrc
export BASH_ENV=$HOME/.bash_env

export PATH HOME TERM
umask  0027

# disable ctrl-s flow control madness
stty ixany
stty ixoff -ixon

# if running zsh:  this file was called from ~/.zprofile
#                  zsh will now run ~/.zshrc automatically
# if running ksh:  this file was called directly
#                  ksh will now run ENV (~/.kshrc) automatically
# if running bash: this file was called from ~/.bash_profile
#                  now call ~/.bashrc

if [ -n "$BASH_VERSION" ]; then
  if [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
  fi
fi
