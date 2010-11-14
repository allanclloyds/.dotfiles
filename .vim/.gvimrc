" ~/.gvimrc: Allan C. Lloyds <acl@acl.im>
" vim: set et ff=unix ft=vim fdm=marker ts=2 sw=2 sts=2 tw=0: 

" Reload .gvimrc on change
" http://vim.wikia.com/wiki/Change_vimrc_with_auto_reload
if has ('win')
  autocmd! bufwritepost _vimrc source %
  autocmd! bufwritepost _gvimrc source %
else
  autocmd! bufwritepost .vimrc source %
  autocmd! bufwritepost .gvimrc source %
endif

set guioptions-=T
