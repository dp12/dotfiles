" Chen Bin's vimrc
" shameless copied from Tsung-Hsiang (Sean) Chang <vgod@vgod.tw>
" Fork me on GITHUB git://github.com/redguardtoo/vimrc.git

" For pathogen.vim: auto load all plugins in .vim/bundle

" Map ESC to kj keychord
:imap kj <Esc>
" Allow saving of files as sudo when vim is started w/o sudo.
cmap w!! w !sudo tee > /dev/null %

let g:pathogen_disabled = []

call pathogen#runtime_append_all_bundles()
call pathogen#helptags()

" General Settings

set nocompatible	" not compatible with the old-fashion vi mode
set bs=2		" allow backspacing over everything in insert mode
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set autoread		" auto read when file is changed from outside
set number              " show line numbers
set ignorecase          " ignore case when searching

filetype on           " Enable filetype detection
filetype indent on    " Enable filetype-specific indenting
filetype plugin on    " Enable filetype-specific plugins

set hlsearch		" search highlighting

if has("gui_running")	" GUI color and font settings
  set background=dark
  set t_Co=256          " 256 color mode
  " NO menu,toolbar ...
  set guioptions-=m
  set guioptions-=T
  set guioptions-=l
  set guioptions-=L
  set guioptions-=r
  set guioptions-=R

  if has("win32")
    "start gvim maximized
    if has("autocmd")
      au GUIEnter * simalt ~x
    endif
  endif
  colorscheme desert 
else
  " terminal color settings
  colorscheme desert 
endif


set clipboard=unnamed	" yank to the system register (*) by default
set showmatch		" Cursor shows matching ) and }
set showmode		" Show current mode
set wildchar=<TAB>	" start wild expansion in the command line using <TAB>
set wildmenu            " wild char completion menu

" ignore these files while expanding wild chars
set wildignore=*.o,*.class,*.pyc

set autoindent		" auto indentation
set incsearch		" incremental search
set nobackup		" no *~ backup files
set copyindent		" copy the previous indentation on autoindenting
set ignorecase		" ignore case when searching
set smartcase		" ignore case if search pattern is all lowercase,case-sensitive otherwise
set smarttab		" insert tabs on the start of a line according to context

" disable sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" TAB setting{
set expandtab        "replace <TAB> with spaces
set softtabstop=4
set shiftwidth=4
au FileType Makefile set noexpandtab
"}

" status line {
set laststatus=2
set statusline=%-10.3n  "buffer number
set statusline+=%t       "tail of the filename
set statusline+=[%{strlen(&fenc)?&fenc:'none'}, "file encoding
set statusline+=%{&ff}] "file format
set statusline+=%h      "help file flag
set statusline+=%m      "modified flag
set statusline+=%r      "read only flag
set statusline+=%y      "filetype
set statusline+=%=      "left/right separator
set statusline+=%c      "cursor column
set statusline+=\ %P    "percent through file

function! HasPaste()
  if &paste
    return '[PASTE]'
  else
    return ''
  endif
endfunction
"}

if has("autocmd")
  autocmd BufNewFile,BufRead *.vb set ft=vbnet
  autocmd BufNewFile,BufRead *.{ps1,psm1,psd1} set ft=ps1
  autocmd BufNewFile,BufRead *.{md,markdown} set ft=markdown
  autocmd BufNewFile,BufRead *.json set ft=javascript
  autocmd BufNewFile,BufRead *.{ftl,jsp} set ft=html

  autocmd BufNewFile,BufRead *.build set ft=xml
  " C/C++ specific settings
  autocmd FileType c,cpp,cc  set cindent comments=sr:/*,mb:*,el:*/,:// cino=>s,e0,n0,f0,{0,}0,^-1s,:0,=s,g0,h1s,p2,t0,+2,(2,)20,*30

  " auto reload vimrc when editing it
  autocmd! bufwritepost .vimrc source ~/.vimrc
endif

"Restore cursor to file position in previous editing session
set viminfo='10,\"100,:20,%,n~/.viminfo

if has("autocmd")
  au BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif

  " @see https://www.antagonism.org/privacy/gpg-vi.shtml
  " Transparent editing of GnuPG-encrypted files
  " Based on a solution by Wouter Hanegraaff
  augroup encrypted
    au!
    " First make sure nothing is written to ~/.viminfo while editing
    " an encrypted file.
    autocmd BufReadPre,FileReadPre *.gpg,*.asc set viminfo=
    " We don't want a swap file, as it writes unencrypted data to disk.
    autocmd BufReadPre,FileReadPre *.gpg,*.asc set noswapfile
    " Switch to binary mode to read the encrypted file.
    autocmd BufReadPre,FileReadPre *.gpg set bin
    autocmd BufReadPre,FileReadPre *.gpg,*.asc let ch_save = &ch|set ch=2
    autocmd BufReadPost,FileReadPost *.gpg,*.asc
          \ '[,']!sh -c 'gpg --decrypt 2> /dev/null'
    " Switch to normal mode for editing
    autocmd BufReadPost,FileReadPost *.gpg set nobin
    autocmd BufReadPost,FileReadPost *.gpg,*.asc let &ch = ch_save|unlet ch_save
    autocmd BufReadPost,FileReadPost *.gpg,*.asc
          \ execute ":doautocmd BufReadPost " . expand("%:r")

    " Convert all text to encrypted text before writing
    autocmd BufWritePre,FileWritePre *.gpg set bin
    autocmd BufWritePre,FileWritePre *.gpg
          \ '[,']!sh -c 'gpg --default-recipient-self -e 2>/dev/null'
    autocmd BufWritePre,FileWritePre *.asc
          \ '[,']!sh -c 'gpg --default-recipient-self -e -a 2>/dev/null'
    " Undo the encryption so we are back in the normal text, directly
    " after the file has been written.
    autocmd BufWritePost,FileWritePost *.gpg,*.asc u
  augroup END
endif

"---------------------------------------------------------------------------
" USEFUL SHORTCUTS
"---------------------------------------------------------------------------
"work with clipbord in vim-console
" C-c is same as ESC which is good if you switch CAP and Ctrl key
if has("unix")
  " two clipboards in X
  vmap <C-y> y:call system("xclip -i -selection clipboard", getreg("\""))<CR>:call system("xclip -i", getreg("\""))<CR>
elseif has("win32unix")
  vmap <C-y> y:call system("putclip", getreg("\""))<CR>
endif

" set leader to ,
let mapleader=","
let g:mapleader=","

" for merge tool
map <silent> <leader>1 :diffget 1<CR> :diffupdate<CR>
map <silent> <leader>2 :diffget 2<CR> :diffupdate<CR>
map <silent> <leader>3 :diffget 3<CR> :diffupdate<CR>
map <silent> <leader>4 :diffget 4<CR> :diffupdate<CR>

map <silent> <leader>xvp :Gblame<CR>

" grep result window operation alias
" " Do :help cope if you are unsure what cope is. It's super useful!
map <leader>co :botright copen<cr>
"<leader>cc is reserved for nerd comment
map <leader>nn :cn<cr>
map <leader>pp :cp<cr>
map <leader>as :w!<CR>:!aspell check %<CR>:e! %<CR>

" Spell checking
map <leader>sn ]
map <leader>sp [
map <leader>sa zg
map <leader>s? z=

"Remove the Windows ^M
noremap <leader>rm :%s/\r//g<CR>

"Switch to current dir
map <leader>cd :cd %:p:h<cr>

"Remove indenting on empty line
map <leader>el :%s/s*$//g<cr>:noh<cr>''

" --- Smart way to move window {
"  TIPS:
"  C-W +/- increase/descrease window height
"  C-W _ maxmize window height
"  C-W = restore window size
"  C-W | maxmize window width
set wmw=0                     " set the min width of a window to 0 so we can maximize others
set wmh=0                     " set the min height of a window to 0 so we can maximize others
"}

" --- Faster window resize {
"  TIPS:
"  C-W </ > resize window width
if bufwinnr(1)
  " recommend using scroll pad
  map + <C-W>+
  map - <C-W>-
endif
"  }

" new tab
map <leader>tn :tabnew<CR>
" close tab
map <leader>tc :tabclose<CR>

" ,/ turn off search highlighting
nmap <leader>nh :nohl<CR>

" Bash like keys for the command line
cnoremap <C-A>      <Home>
cnoremap <C-E>      <End>
cnoremap <C-K>      <C-U>

" ,p toggles paste mode
nmap <leader>pp :set paste!<BAR>set paste?<CR>

"---------------------------------------------------------------------------
" PROGRAMMING SHORTCUTS
"---------------------------------------------------------------------------

" Ctrl-[ jump out of the tag stack (undo Ctrl-])
map <C-[> <ESC>:po<CR>

" ,g generates the header guard
map <leader>gg :call IncludeGuard()<CR>
fun! IncludeGuard()
  let basename = substitute(bufname(""), '.*/', '', '')
  let guard = '_' . substitute(toupper(basename), '\.', '_', "H")
  call append(0, "#ifndef " . guard)
  call append(1, "#define " . guard)
  call append( line("$"), "#endif // for #ifndef " . guard)
endfun

if has("autocmd") && exists("+omnifunc")
  " Enable omni completion. (Ctrl-X Ctrl-O)
  autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
  autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
  autocmd FileType css set omnifunc=csscomplete#CompleteCSS

  " use syntax complete if nothing else available
  autocmd Filetype *
        \	if &omnifunc == "" |
        \		setlocal omnifunc=syntaxcomplete#Complete |
        \	endif
endif

set cot-=preview "disable doc preview in omnicomplete

if has("autocmd")
  " make CSS omnicompletion work for SASS and SCSS
  autocmd BufNewFile,BufRead *.scss             set ft=scss.css
  autocmd BufNewFile,BufRead *.sass             set ft=sass.css
endif

"---------------------------------------------------------------------------
" ENCODING SETTINGS
"---------------------------------------------------------------------------
set encoding=utf-8
set termencoding=utf-8
set fileencoding=utf-8
set fileencodings=ucs-bom,utf-8,big5,gb2312,latin1

fun! ViewUTF8()
  set encoding=utf-8
  set termencoding=big5
endfun

fun! UTF8()
  set encoding=utf-8
  set termencoding=big5
  set fileencoding=utf-8
  set fileencodings=ucs-bom,big5,utf-8,latin1
endfun

fun! Big5()
  set encoding=big5
  set fileencoding=big5
endfun


"---------------------------------------------------------------------------
" PLUGIN SETTINGS
"---------------------------------------------------------------------------

" --- AutoClose - Inserts matching bracket, paren, brace or quote
" fixed the arrow key problems caused by AutoClose
if !has("gui_running")
  set term=linux
  imap OA <ESC>ki
  imap OB <ESC>ji
  imap OC <ESC>li
  imap OD <ESC>hi

  nmap OA k
  nmap OB j
  nmap OC l
  nmap OD h
endif

" --- taglist
map <leader>tt :TlistToggle<CR>

" leader hotkeys
map <leader>xs :write<CR>
map <leader>ww :write<CR>
map <leader>s2 :sp<CR>
map <leader>s3 :vs<CR>
map <leader>s1 <C-W>o
map <leader>s0 :close<CR>
" go to SCM conflict marker
map ]] ]n
map [[ [n
map <leader>xf :CtrlP<CR>
map <leader>xb :CtrlPBuffer<CR>
map <leader>hr :CtrlPMRU<CR>
map <leader>gt :CtrlPTag<CR>
map <leader>nm ]n
map <leader>pm [n
map <leader>ni d]n
map <leader>pi d[n
map <leader>nc ]c
map <leader>pc [c
map <leader>tr :%s/ \+$//g<CR>
map <leader>cg :CtrlPRoot<CR>
map <leader>xz :suspend<CR>
map <leader>s0 :quit<CR>
map <leader>s2 :sp<CR>
map <leader>s3 :vs<CR>
map <leader>xc :quitall<CR>
map <leader>n :NERDTreeToggle<CR> " NERDTree

if !hasmapto("<Plug>ZoomWin")
 nmap <unique> <leader>ff  <Plug>ZoomWin
endif

syntax on		" syntax highlight

"====[ Make tabs, trailing whitespace, and non-breaking spaces visible ]======

exec "set listchars=tab:\uBB\uBB,trail:\uB7,nbsp:~"
set list

" Local Variables:
" coding: utf-8
" indent-tabs-mode: nil
" tab-width: 2
" End:
" vim: set fenc=utf-8 et ts=2 sts=2 sw=2 foldmethod=marker :
