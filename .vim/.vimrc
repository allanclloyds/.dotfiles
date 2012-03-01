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
let mapleader = ","

" Reload .vimrc on change
" http://vim.wikia.com/wiki/Change_vimrc_with_auto_reload
if has ('win')
  "autocmd! bufwritepost _vimrc source %
else
  "autocmd! bufwritepost .vimrc source %
endif

" Create ~/.vim.tmp directory if it doesn't already exist
if exists("*mkdir") && ! filereadable(expand("~/.vim.tmp")) && ! isdirectory(expand("~/.vim.tmp"))
  call mkdir(expand("~/.vim.tmp"), "", 0700)
end

" Use UTF-8
if has("multi_byte")
  if &termencoding == ""
    let &termencoding = &encoding
  endif
  set encoding=utf-8
  setglobal fileencoding=utf-8 bomb
  set fileencodings=ucs-bom,utf-8,latin1
  scriptencoding utf-8
endif

" Pathogen plugin for managing Vim plugins:
" http://www.vim.org/scripts/script.php?script_id=2332
" https://github.com/tpope/vim-pathogen
filetype off
silent! call pathogen#runtime_append_all_bundles()
silent! call pathogen#helptags()

if isdirectory(expand("~/.vim/doc"))
  helptags ~/.vim/doc
elseif isdirectory(expand("~/vimfiles/doc"))
  helptags ~/vimfiles/doc
endif

syntax on
filetype on
filetype indent on
filetype plugin on

set t_Co=256                      " Enable 256 colors
set t_AB=[48;5;%dm
set t_AF=[38;5;%dm

set list
set lcs=tab:>-                    " Show tabs

set lcs+=trail:~
set lcs+=eol:$

" Highlight trailing whitespace or ANY tabs
highlight   ExtraWhitespace ctermbg=darkgreen ctermfg=black
autocmd     ColorScheme * highlight ExtraWhitespace ctermbg=darkgreen ctermfg=black
match       ExtraWhitespace /\t\|\>\+\s\+$/
autocmd     ColorScheme * highlight NonText ctermbg=black ctermfg=236

" Set colorscheme after above but before the rest
colorscheme desert256

" Popupmenu selected line, cursor line highlight, completion popup
highlight   PmenuSel ctermfg=black
highlight   clear Cursorline
highlight   CursorLine ctermbg=234  guibg=233
highlight   Pmenu ctermbg=58 gui=bold

set et ts=2 sw=2 sts=2 bs=2 tw=0  " Expandtab, tabstop, shiftwidth, backspace (over everything), textwidth
set formatoptions+=m              " Add multibyte support
set backupdir=~/.vim.tmp//        " Double slash makes temp file unique
set directory=~/.vim.tmp//
set viminfo^=!,%                  " See: http://vimdoc.sourceforge.net/htmldoc/options.html#'viminfo'
set hidden autoread autowrite     " Allow hidden modified buffs, save when changing buffs, reload changed file
set novisualbell noerrorbells     " No bells, visual or otherwise
set showmatch                     " Show matching brackets
set wrapscan incsearch hlsearch   " Wrap search to start of file, search as you type, highlight searches
set number ruler showmode showcmd " Show line numbers, ruler, current mode, current command
set so=7 wmh=0                    " Keep 7 lines visible when scrolling, allow window to be 0 lines high
set nostartofline                 " Do not jump to first character with page commands
set wildmenu                      " Enhanced command line completion
set wildmode=list:longest         " Complete files like a shell
set tags=./tags;                  " Ctags for jumping around source files
set grepprg=ack-grep              " A better grep for use inside vim
set foldmethod=marker             " Use predefined markers for folds
set fillchars=fold:\              " note the whitespace after

set title                         " Boolean: set title of terminal
set titlestring=vim:\ %F

if $TERM == 'screen-256color-bce'
   exe "set title titlestring=%F"
   exe "set title t_ts=\<ESC>k t_fs=\<ESC>\\"
endif

au BufNewFile,BufRead *.gz let b:gzflag = 1

function VarExists(var, val)
  if exists(a:var) | return a:val | else | return '' | endif
endfunction

set laststatus=2                  " Always show status line

set statusline=%-20.(%-5.L\\%5.l,%3.c,%3.v\ %)\|
set statusline+=\ l:%p%%\ w:%P\ o:0x%O\ b:0x%B\ %=
set statusline+=\ %f\ %r%w%{VarExists('b:gzflag','\ [gz]')}\[%{&ff}\]%y%{SyntasticStatuslineFlag()}%m
set statusline+=\ %<%{strftime(\"%Y-%m-%d\ %a\ %H:%M:%S\",getftime(expand(\"%:p\")))}

" Speeddating plugin:
" http://www.vim.org/scripts/script.php?script_id=2120
" https://github.com/tpope/vim-speeddating
"
" Some other mappings here as well: On my netbook <Esc> is tiny, and right next to <F1>
" <C-a> is special in both Windows + GNU Screen, so don't use that for incrementing and
" <C-i> and <Tab> share the same mapping, so this will allow <Tab> to increment.
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
map <leader>, :b#<CR>
map <leader>. :buffers<CR>:buffer<Space>

" Bufexplorer plugin: http://www.vim.org/scripts/script.php?script_id=42
silent! nmap <unique> <silent> <Leader>b :BufExplorer<CR>

" Syntastic plugin: https://github.com/scrooloose/syntastic
let g:syntastic_enable_signs=1

" Vim-Taglist plugin: http://vim-taglist.sourceforge.net/
let Tlist_Inc_Winwidth = 0
map <leader>t :TlistToggle<CR>

" Gundo plugin: http://sjl.bitbucket.org/gundo.vim/
silent! nmap <unique> <silent> <Leader>u :GundoToggle<CR>

" Command-t plugin: https://wincent.com/products/command-t
silent! nmap <unique> <silent> <Leader>o :CommandT<CR>
let g:CommandTMaxHeight = 25

" Gist.vim plugin: http://www.vim.org/scripts/script.php?script_id=2423
let g:gist_detect_filetype = 1
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

" Ruby/Coding stuff
au BufNewFile,BufRead *.rhtml set syn=eruby
au BufNewFile,BufRead *.rjs set syn=ruby

" Save position and folds in .rb files
au BufWinLeave *.rb mkview
au BufWinEnter *.rb silent loadview

""" Tweaks from: http://nanabit.net/blog/2007/11/03/vim-cursorline/

  " Display cursorline only in active window
  augroup cch
    autocmd! cch
    autocmd WinLeave * set nocursorline
    autocmd WinEnter,BufRead * set cursorline
  augroup END

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

" Highlight and mark current line or column
" http://vim.wikia.com/wiki/Highlight_current_line
nnoremap <silent> <Leader>hl ml:execute 'match Search /\%'.line('.').'l/'<CR>
nnoremap <silent> <Leader>hc :execute 'match Search /\%'.virtcol('.').'v/'<CR>

" Clear current line/search highlight
nnoremap <silent> <Leader>hh :match
nnoremap \ :noh<CR>

" Search for selected text, forwards or backwards
" http://vim.wikia.com/wiki/Search_for_visually_selected_text
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

" Places the cursor in the last place that it was in the last file
if has("autocmd")
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif
endif

" Append modeline after last line in buffer.
" Use substitute() (not printf()) to handle '%%s' modeline in LaTeX files.
" http://vim.wikia.com/wiki/Modeline_magic
function! AppendModeline()
  let save_cursor = getpos('.')
  let append = ' vim: set et ff=unix ft='.&filetype.' fdm=marker ts=2 sw=2 sts=2 tw=0:'
  $put =substitute(&commentstring, '%s', append, '')
  call setpos('.', save_cursor)
endfunction
nnoremap <silent> <Leader>ml :call AppendModeline()<CR>

" Edit another file in the same directory as the current file
" Uses expression to extract path from current file's path
map <Leader>ee :e <C-R>=expand("%:p:h") . '/'<CR>
map <Leader>es :split <C-R>=expand("%:p:h") . '/'<CR>
map <Leader>ev :vnew <C-R>=expand("%:p:h") . '/'<CR>

" Lines below from:
" http://biodegradablegeek.com/2007/12/using-vim-as-a-complete-ruby-on-rails-ide/

  " Minibuffer Explorer Settings
  let g:miniBufExplMapWindowNavVim = 1
  let g:miniBufExplMapWindowNavArrows = 1
  let g:miniBufExplMapCTabSwitchBufs = 1
  let g:miniBufExplModSelTarget = 1

  " alt+n or alt+p to navigate between entries in QuickFix
  map <silent> <m-p> :cp <cr>
  map <silent> <m-n> :cn <cr>

  " Change which file opens after executing :Rails command
  let g:rails_default_file='config/database.yml'
