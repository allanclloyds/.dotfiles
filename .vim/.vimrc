" ~/.vimrc: Allan C. Lloyds <acl@acl.im>
" vim: set et ff=unix ft=vim fdm=marker ts=2 sw=2 sts=2 tw=0:

" Some vim screencasts/resources:
" http://peepcode.com/products/smash-into-vim-i
" http://peepcode.com/products/smash-into-vim-ii
" http://www.codeulatescreencasts.com/products/vim-for-rails-developers
" http://vimcasts.org/episodes/archive
"
" http://vim.wikia.com/wiki/Vim_Tips_Wiki
" http://vimdoc.sourceforge.net/htmldoc/vimfaq.html
" http://vimdoc.sourceforge.net/htmldoc/usr_toc.html
" http://www.oualline.com/vim-cook.html

set nocompatible

if exists(':let')
  nnoremap ,; ,
  let mapleader = ","
end

" Reload .vimrc on change
" http://vim.wikia.com/wiki/Change_vimrc_with_auto_reload

if has('win32')
  autocmd! bufwritepost _vimrc source $MYVIMRC
else
  autocmd! bufwritepost .vimrc source $MYVIMRC
endif

" Use UTF-8

if has('multi_byte')
  if &termencoding == ""
    let &termencoding = &encoding
  endif

  set  encoding=utf-8
  setg fileencoding=utf-8 bomb
  set  fileencodings=ucs-bom,utf-8,latin1

  scriptencoding utf-8
endif

" Create ~/.vim.tmp directory if it doesn't already exist

if !has('win32')
  if exists('*mkdir')
    if !filereadable(expand('~/.vim.tmp')) && !isdirectory(expand('~/.vim.tmp'))
      call mkdir(expand('~/.vim.tmp'), '', 0700)
    end
  end

  " Double slash makes temp file unique
  set backupdir=~/.vim.tmp//
  set directory=~/.vim.tmp//
end

" Pathogen plugin for managing Vim plugins:
" http://www.vim.org/scripts/script.php?script_id=2332
" https://github.com/tpope/vim-pathogen

silent! filetype off
silent! call pathogen#runtime_append_all_bundles()
silent! call pathogen#helptags()

if isdirectory(expand("~/.vim/doc"))
  helptags ~/.vim/doc
elseif isdirectory(expand("~/vimfiles/doc"))
  helptags ~/vimfiles/doc
endif

" Order of the following lines is significant:
"
"   Using autocmd before the first colorscheme command will ensure the
"   highlight group will not be cleared by future colorscheme commands.

if has('autocmd') && exists(':function')

  au! ColorScheme * call ColorSchemeOverRides()

  function! ColorSchemeOverRides()

    if has('gui_running')
      hi Search          guifg=NONE    guibg=NONE   gui=reverse
      hi IncSearch       guifg=NONE    guibg=NONE   gui=reverse
      hi Todo            guifg=196     guibg=NONE   gui=underline
      hi NonText         guifg=238     guibg=NONE   gui=NONE
      hi ExtraWhitespace guifg=black   guibg=33     gui=NONE
      hi OverLength      guifg=NONE    guibg=236    gui=NONE
    else
      hi Search          ctermfg=NONE  ctermbg=NONE cterm=reverse
      hi IncSearch       ctermfg=NONE  ctermbg=NONE cterm=reverse
      hi Todo            ctermfg=196   ctermbg=NONE cterm=underline
      hi NonText         ctermfg=238   ctermbg=NONE cterm=NONE
      hi ExtraWhitespace ctermfg=black ctermbg=33   cterm=NONE
      hi OverLength      ctermfg=NONE  ctermbg=236  cterm=NONE
    end

    hi clear CursorLine
    hi clear CursorColumn
    hi clear ColorColumn

    hi CursorLine        ctermbg=232   guibg=233
    hi CursorColumn      ctermbg=232   guibg=233
    hi ColorColumn       ctermbg=232   guibg=233

    hi PmenuSel          ctermfg=black
    hi Pmenu             ctermbg=58    gui=bold

  endfunction

  if exists('*matchadd') && exists(':let')

    au! FileType *    call MatchOn()
    au! FileType help call MatchNo() | set number

    " Show matches: Extra Whitespace & Over Length, Current Line, Current Col

    nnoremap <silent> <Leader>mm :call MatchOn()<CR>
    nnoremap <silent> <Leader>ml :call MatchOnL()<CR>
    nnoremap <silent> <Leader>mc :call MatchOnC()<CR>

    " Clear matches: Extra Whitespace & Over Length, Current Line & Col, Search

    nnoremap <silent> <Leader>\m :call MatchNo()<CR>
    nnoremap <silent> <Leader>\l :call MatchRm('b:m3')<CR>
    nnoremap <silent> <Leader>\c :call MatchRm('b:m4')<CR>
    nnoremap <silent> <Leader>\\ :call MatchRm('b:m3')<CR>:call MatchRm('b:m4')<CR>
    nnoremap \ :noh<CR>

    fu! MatchOn()
      if !exists('b:m1') && !exists('b:m2')
        let b:m1 = matchadd("ExtraWhitespace", '\v(\t|\s+$)')
        let b:m2 = matchadd("OverLength",      '\v(%>79v.+)')
      endi
    endf

    fu! MatchOnL()
      call MatchRm('b:m3')
      let b:m3 = matchadd("Search", '\%'.line('.').'l')
      mark l
    endf

    fu! MatchOnC()
      call MatchRm('b:m4')
      let b:m4 = matchadd("Search", '\%'.virtcol('.').'v')
    endf

    fu! MatchNo()
      call MatchRm('b:m1') | call MatchRm('b:m2')
    endf

    fu! MatchRm(matchvar)
      if exists(a:matchvar)
        exe "call matchdelete(".a:matchvar.") | unlet ".a:matchvar
      endi
    endf
  endi
endi

if !exists('g:colors_name')
  colorscheme desert256

  silent! syntax on
  silent! filetype on
  silent! filetype indent on
  silent! filetype plugin on

  " Enable 256 colours
  set t_Co=256
  set t_AB=[48;5;%dm
  set t_AF=[38;5;%dm
endi

set et ts=2 sw=2 sts=2 bs=2 tw=0  " Expandtab, tabstop, shiftwidth
                                  " backspace (over everything), textwidth
set nowrap                        " Do not wrap text
set formatoptions+=m              " Add multibyte support
set viminfo^=!,%                  " See :help viminfo
set hidden                        " Allow hidden modified buffers
set autoread                      " Reload changed file
set autowrite                     " Save when changing buffers
set novisualbell noerrorbells     " No bells, visual or otherwise
set showmatch                     " Show matching brackets
set wrapscan                      " Wrap search to start of file
set incsearch                     " Search as you type
set hlsearch                      " Highlight searches
set number ruler                  " Show line numbers, ruler
set showmode showcmd              " Show current mode, current command
set so=7                          " Keep 7 lines visible when scrolling
set wmh=0                         " Allow window to be 0 lines high
set startofline                   " Jump to first character when paging
set wildmenu                      " Enhanced command line completion
set wildmode=list:longest         " Complete files like a shell
set tags=./tags;                  " Ctags for jumping around source files
set grepprg=ack-grep              " A better grep for use inside vim
set fillchars=fold:\              " note the whitespace after

if exists('+foldmethod')
  set foldmethod=marker           " Use predefined markers for folds
end

if exists('+colorcolumn')
  set colorcolumn=79
endif

set list
set lcs=precedes:<,extends:>
set lcs+=tab:>-
set lcs+=trail:~
set lcs+=eol:$
set lcs+=nbsp:%

set title                         " Boolean: set title of terminal
set titlestring=vim:\ %F

if $TERM == 'screen-256color-bce'
   exe "set title titlestring=%F"
   exe "set title t_ts=\<ESC>k t_fs=\<ESC>\\"
endif

if exists(':function')
  function! VarExists(var, val)
    if exists(a:var)
      return a:val
    else
      return ''
    endif
  endfunction
end

set laststatus=2                  " Always show status line

set stl=%-20.(%-5.L\\%5.l,%3.c,%3.v\ %)\|
set stl+=\ l:%p%%\ w:%P\ o:0x%O\ b:0x%B\ %=
set stl+=\ %f\ %r%w%{VarExists('b:gzflag','\ [gz]')}
set stl+=\[%{&ff}\]%y%{SyntasticStatuslineFlag()}%m
set stl+=\ %<%{strftime(\"%Y-%m-%d\ %a\ %H:%M:%S\",getftime(expand(\"%:p\")))}

" Speeddating plugin:
" http://www.vim.org/scripts/script.php?script_id=2120
" https://github.com/tpope/vim-speeddating
"
" Some other mappings here as well: On my netbook <Esc> is tiny, and right next
" to <F1>. <C-a> is special in both Windows + GNU Screen, so don't use that for
" incrementing, and <C-i> and <Tab> share the same mapping, so this will allow
" <Tab> to increment.

map      <F1>  <Esc>
imap     <F1>  <Esc>
noremap  <F8>  <C-o>
noremap  <F9>  <C-i>
nmap     <C-i> <Plug>SpeedDatingUp
nmap     <C-x> <Plug>SpeedDatingDown
xmap     <C-i> <Plug>SpeedDatingUp
xmap     <C-x> <Plug>SpeedDatingDown
nmap    d<C-i> <Plug>SpeedDatingNowUTC
nmap    d<C-x> <Plug>SpeedDatingNowLocal

" Fast buffer switching (,, for alternate buffer, ,. for a menu)
" This works better than Bufexplorer for me
silent! map <leader>, :b#<CR>
silent! map <leader>. :buffers<CR>:buffer<Space>

" Bufexplorer plugin: http://www.vim.org/scripts/script.php?script_id=42
silent! nmap <unique> <silent> <Leader>b :BufExplorer<CR>

" Syntastic plugin: https://github.com/scrooloose/syntastic
silent! let g:syntastic_enable_signs=1

" Vim-Taglist plugin: http://vim-taglist.sourceforge.net/
silent! let Tlist_Inc_Winwidth = 0
silent! map <leader>t :TlistToggle<CR>

" Gundo plugin: http://sjl.bitbucket.org/gundo.vim/
silent! nmap <unique> <silent> <Leader>u :GundoToggle<CR>

" Command-t plugin: https://wincent.com/products/command-t
silent! nmap <unique> <silent> <Leader>o :CommandT<CR>
silent! let g:CommandTMaxHeight = 25

" Gist.vim plugin: http://www.vim.org/scripts/script.php?script_id=2423
silent! let g:gist_detect_filetype = 1
silent! nmap <unique> <silent> <Leader>g :Gist -l<CR><C-w>o

" Scratch.vim plugin: http://www.vim.org/scripts/script.php?script_id=664
silent! nmap <unique> <silent> <Leader>s :Scratch<CR><C-w>o

" Unimpared.vim plugin: http://github.com/tpope/vim-unimpaired
" Text bubbling: http://vimcasts.org/episodes/bubbling-text/

  " Bubble single lines
  nmap <Up> [e
  nmap <Down> ]e

  " Bubble multiple lines
  vmap <Up> [egv
  vmap <Down> ]egv

if has('autocmd')
  aug vimrc_autocmd
    au!

    au BufNewFile,BufRead *.gz let b:gzflag = 1

    " Ruby/Coding stuff
    au BufNewFile,BufRead *.rhtml set syn=eruby
    au BufNewFile,BufRead *.rjs set syn=ruby

    " Save position and folds in .rb files
    au BufWinLeave *.rb mkview
    au BufWinEnter *.rb silent loadview

  " Display cursorline only in active window
    au WinLeave * set nocursorline
    au WinEnter,BufEnter,BufRead,BufWinEnter,BufNewFile * set cursorline

    " Places the cursor in the last place that it was in the last file
    au BufReadPost *
      \ if line("'\"") > 1 && line("'\"") <= line("$") |
      \   exe "normal! g`\"" |
      \ endif

  aug END
end

""" Tweaks from: http://jetpackweb.com/blog/2010/02/15/vim-tips-for-ruby/

  " Bind control-l to hashrocket
  imap <C-l> <Space>=><Space>

  " Convert word into ruby symbol
  imap <C-k> <C-o>b:<Esc>Ea
  nmap <C-k> lbi:<Esc>E

""" Tweaks from: https://github.com/airblade/dotvim/blob/master/vimrc

  " Very magic regexes
  nnoremap / /\v
  vnoremap / /\v

  " Make Y consistent with D and C (instead of yy)
  noremap Y y$

  " Visually select the text that was most recently edited/pasted.
  nmap gV `[v`]

""" Tweaks from: http://news.ycombinator.com/item?id=2082478

  " Repeats the last command for the entire visual selection
  vnoremap . :normal .<CR>

  " Toggle paste mode
  noremap <silent> <leader>p :se invpaste<cr>:echo &paste ? "paste on" : "paste off"<cr>

" Search for selected text, forwards or backwards
" http://vim.wikia.com/wiki/Search_for_visually_selected_text
"
vnoremap <silent> * :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy/<C-R><C-R>=substitute(
  \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>
vnoremap <silent> # :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy?<C-R><C-R>=substitute(
  \escape(@", '?\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>

" Append modeline after last line in buffer.
" Use substitute() (not printf()) to handle '%%s' modeline in LaTeX files.
" http://vim.wikia.com/wiki/Modeline_magic
"
if exists(':function')
  function! AppendModeline()
    let save_cursor = getpos('.')
    let append = ' vim: set et ff=unix ft='.&filetype.' fdm=marker ts=2 sw=2 sts=2 tw=0:'
    $put =substitute(&commentstring, '%s', append, '')
    call setpos('.', save_cursor)
  endfunction
  nnoremap <silent> <Leader>v :call AppendModeline()<CR>
end

" Edit another file in the same directory as the current file
" Uses expression to extract path from current file's path
"
map <Leader>ee :e <C-R>=expand("%:p:h") . '/'<CR>
map <Leader>es :split <C-R>=expand("%:p:h") . '/'<CR>
map <Leader>ev :vnew <C-R>=expand("%:p:h") . '/'<CR>

" Lines below from:
" http://biodegradablegeek.com/2007/12/using-vim-as-a-complete-ruby-on-rails-ide/

  " Minibuffer Explorer Settings
  silent! let g:miniBufExplMapWindowNavVim = 1
  silent! let g:miniBufExplMapWindowNavArrows = 1
  silent! let g:miniBufExplMapCTabSwitchBufs = 1
  silent! let g:miniBufExplModSelTarget = 1

  " alt+n or alt+p to navigate between entries in QuickFix
  map <silent> <m-p> :cp <cr>
  map <silent> <m-n> :cn <cr>

  " Change which file opens after executing :Rails command
  silent! let g:rails_default_file='config/database.yml'
