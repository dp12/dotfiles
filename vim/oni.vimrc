" Map jk to enter normal mode
imap kj <Esc>

let mapleader = " "
nnoremap <silent> <leader> :<c-u>LeaderGuide '<Space>'<CR>
vnoremap <silent> <leader> :<c-u>LeaderGuideVisual '<Space>'<CR>

nnoremap <Leader>r :CtrlPMRUFiles()<CR>

call plug#begin('C:\Users\dting\AppData\Roaming\Oni\plugged')
Plug 'https://github.com/jceb/vim-orgmode.git'
Plug 'https://github.com/hecal3/vim-leader-guide'
call plug#end()
