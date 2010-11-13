" ~/.vimrc: Allan C. Lloyds <acl@acl.im>

set nocompatible
let mapleader = ","
filetype off
call pathogen#runtime_append_all_bundles()

syntax on
filetype on
filetype indent on
filetype plugin on

map  <F1> <Esc>
imap <F1> <Esc>
map  <F9> <C-o>
nmap <F9> <C-o>

set t_Co=256                     " Enable 256 colors
set t_AB=[48;5;%dm
set t_AF=[38;5;%dm

set list
set lcs=tab:>-                   " Show tabs
set lcs+=trail:·                 " Show trailing spaces
set lcs+=eol:$                   " Show end of lines

" Highlight trailing whitespace or ANY tabs (tabs suck!)
highlight ExtraWhitespace ctermbg=darkgreen ctermfg=black
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=darkgreen ctermfg=black
match ExtraWhitespace /\t\|\>\+\s\+$/
autocmd ColorScheme * highlight NonText ctermbg=black ctermfg=236

colorscheme desert256            " Important: set colorscheme after above
highlight PmenuSel ctermfg=black

set guioptions-=T
set et ts=2 sw=2 sts=2 bs=2 tw=0 " Expandtab, tabstop, shiftwidth, backspace (over everything), textwidh
set backupdir=~/.vim.tmp//       " Double slash makes temp file unique
set directory=~/.vim.tmp//
set autoread autowrite           " Save file when changing buffers, auto reload a changed file
set hidden                       " Allow hidden modified buffers
set novisualbell noerrorbells    " No bells, visual or otherwise
set laststatus=2                 " Always show status line
set showmatch incsearch hlsearch " Show matching brackets, start searching as you type, highlight searches
set number ruler showmode        " Show line numbers, ruler, current mode
set so=7 wmh=0                   " Keep 7 lines visible when scrolling, allow window to be 0 lines high
set showcmd                      " Show current command
set nostartofline                " Do not jump to first character with page commands

" Console title ------------------
set title
set titlestring=vim:\ %F

if $TERM == 'screen-256color-bce'
   exe "set title titlestring=vim:%f"
   exe "set title t_ts=\<ESC>k t_fs=\<ESC>\\"
endif

set tags=./tags;                 " Ctags for jumping around source files
set grepprg=ack-grep             " A better grep for use inside vim

" Required for the plugin --------
" http://vim-taglist.sourceforge.net/
let Tlist_Inc_Winwidth = 0
map <leader>t :TlistToggle<CR>

" Required for the plugin ---------
" http://sjl.bitbucket.org/gundo.vim/
"nnoremap <F5> :GundoToggle<CR>
silent! nmap <unique> <silent> <Leader>u :GundoToggle<CR>

" Required for the plugin ---------
" https://wincent.com/products/command-t
silent! nmap <unique> <silent> <Leader>o :CommandT<CR>

" Ruby/Coding stuff
au BufNewFile,BufRead *.rhtml set syn=eruby
au BufNewFile,BufRead *.rjs set syn=ruby

" Save position and folds in .rb files
au BufWinLeave *.rb mkview
au BufWinEnter *.rb silent loadview

" Bind control-l to hashrocket
imap <C-l> <Space>=><Space>

" Convert word into ruby symbol
imap <C-k> <C-o>b:<Esc>Ea
nmap <C-k> lbi:<Esc>E

" Folding
set foldmethod=marker
map <TAB> za
set fillchars=fold:\ " note the whitespace after

" Places the cursor in the last place that it was in the last file
if has("autocmd")
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif
endif

" Append modeline after last line in buffer.
" Use substitute() (not printf()) to handle '%%s' modeline in LaTeX files.
function! AppendModeline()
  let save_cursor = getpos('.')
  let append = ' vim: set et ff=unix ft='.&filetype.' fdm=marker ts=2 sw=2 sts=2 tw=0: '
  $put =substitute(&commentstring, '%s', append, '')
  call setpos('.', save_cursor)
endfunction
nnoremap <silent> <Leader>ml :call AppendModeline()<CR>

" Edit another file in the same directory as the current file
" Uses expression to extract path from current file's path
map <Leader>e :e <C-R>=expand("%:p:h") . '/'<CR>
map <Leader>s :split <C-R>=expand("%:p:h") . '/'<CR>
map <Leader>v :vnew <C-R>=expand("%:p:h") . '/'<CR>

" Lines below from ---------------
" http://biodegradablegeek.com/2007/12/using-vim-as-a-complete-ruby-on-rails-ide/

" Add recently accessed projects menu (project plugin)
set viminfo^=!

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
