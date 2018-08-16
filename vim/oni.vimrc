" Map jk to enter normal mode
imap kj <Esc>

let mapleader = " "
nnoremap <silent> <leader> :<c-u>LeaderGuide '<Space>'<CR>
vnoremap <silent> <leader> :<c-u>LeaderGuideVisual '<Space>'<CR>

nnoremap <Leader>r :CtrlPMRUFiles()<CR>
let g:deoplete#enable_at_startup = 1

call plug#begin('C:\Users\dting\AppData\Roaming\Oni\plugged')
Plug 'https://github.com/jceb/vim-orgmode.git'
Plug 'https://github.com/hecal3/vim-leader-guide'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
call plug#end()
