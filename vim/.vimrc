" -*- mode: vimrc -*-
"vim: ft=vim

" Personal settings
" Map ESC to kj keychord
:imap kj <Esc>

" Automatically reload file
au CursorHold,CursorHoldI * silent! checktime
" Autosave
augroup autosave
    autocmd!
    autocmd BufRead * if &filetype == "" | setlocal ft=text | endif
    autocmd FileType * autocmd TextChanged,InsertLeave <buffer> if &readonly == 0 | silent write | endif
augroup END

set tabstop     =4
set softtabstop =4
set shiftwidth  =4
set expandtab

set number
set autoindent
set smartindent
set noswapfile
" Set leader to space
nnoremap <SPACE> <Nop>
let mapleader=" "

vnoremap <C-r> "hy:.,$s/<C-r>h//gc<left><left><left>
vnoremap g<C-r> "hy:%s/<C-r>h//gc<left><left><left>
vnoremap <C-w> <esc>`>a)<esc>`<i(<esc>
vnoremap <C-d> <esc>`>a"<esc>`<i"<esc>
vnoremap <C-e> <esc>`>a'<esc>`<i'<esc>

" Reselect pasted text
nnoremap gp `[v`]
" Reselect and dedent/indent
nnoremap <leader>[ `[V`]<
nnoremap <leader>] `[V`]>

" One-key exit
nnoremap Q :wqa<CR>

" Leader mappings
nnoremap <leader>w :w<CR>
nnoremap <leader>q :wqa<CR>
noremap <leader>n :set invnu <CR>

" Multiple cursors lite
nnoremap c* *Ncgn

" Binding for sudo write
cnoremap  w!! w !sudo tee % > /dev/null

" Allow saving of files as sudo when vim is started w/o sudo.
cmap w!! w !sudo tee > /dev/null %

let @x='"yy:r! printf "= 0x\%x" $((y))kJ$'

" dotspacevim/auto-install {{{
" Automatic installation of spacevim.

if empty(glob('~/.vim/autoload/spacevim.vim'))
    silent !curl -sSfLo ~/.vim/autoload/spacevim.vim --create-dirs
          \ https://raw.githubusercontent.com/ctjhoa/spacevim/master/autoload/spacevim.vim
endif

" }}}

" dotspacevim/init {{{
" This code is called at the very startup of Spacevim initialization
" before layers configuration.
" You should not put any user code in there besides modifying the variable
" values."
" IMPORTANT: For the moment, any changes in plugins or layers needs
" a vim restart and :PlugInstall

  let g:dotspacevim_distribution_mode = 1

  let g:dotspacevim_configuration_layers = [
  \  'core/.*',
  \  'git',
  \  'syntax-checking'
  \]

  let g:dotspacevim_additional_plugins = ['morhetz/gruvbox',
                                        \ {'name': 'sonph/onehalf', 'option': {'rtp': 'vim'}},
                                        \ 'vim-airline/vim-airline',
                                        \ 'vim-airline/vim-airline-themes',
                                        \ 'johngrib/vim-game-code-break',
                                        \ 'terryma/vim-multiple-cursors',
                                        \ ]
  " You can also pass vim plug options like this: [{ 'name': 'Valloric/YouCompleteMe', 'option': {'do': './install.py'}}]

  let g:dotspacevim_excluded_plugins = []

  " let g:dotspacevim_escape_key_sequence = 'fd'
  let g:dotspacevim_escape_key_sequence = 'kj'

" }}}

" dotspacevim/user-init {{{
" Initialization for user code.
" It is compute immediately after `dotspacemacs/init', before layer
" configuration executes.
" This function is mostly useful for variables that need to be set
" before plugins are loaded. If you are unsure, you should try in setting
" them in `dotspacevim/user-config' first."

  let mapleader = ' '
  let g:leaderGuide_vertical = 1

" }}}

call spacevim#bootstrap()

" dotspacevim/user-config {{{
" Configuration for user code.
" This is computed at the very end of Spacevim initialization after
" layers configuration.
" This is the place where most of your configurations should be done.
" Unless it is explicitly specified that
" a variable should be set before a plugin is loaded,
" you should place your code here."

  set background=dark
  " colorscheme onehalfdark
  colorscheme desert
  let g:airline_theme='onehalfdark'
  let g:airline_powerline_fonts = 1

  if !exists('g:airline_symbols')
    let g:airline_symbols = {}
  endif
  set laststatus=2
  let g:airline#extensions#tabline#enabled = 1

" }}}
