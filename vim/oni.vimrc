" Map jk to enter normal mode
imap kj <Esc>

"Leader Mappings
let mapleader = " "
nnoremap <silent> <leader> :<c-u>LeaderGuide '<Space>'<CR>
vnoremap <silent> <leader> :<c-u>LeaderGuideVisual '<Space>'<CR>

nnoremap <Leader>r :CtrlPMRUFiles()<CR>

" System Config
set grepprg=rg\ --vimgrep

" Plugins
call plug#begin('C:\Users\dting\AppData\Roaming\Oni\plugged')
Plug 'https://github.com/jceb/vim-orgmode.git'
Plug 'https://github.com/hecal3/vim-leader-guide'
Plug 'https://github.com/airblade/vim-gitgutter.git'
Plug 'https://github.com/hecal3/vim-leader-guide.git'
Plug 'https://github.com/jreybert/vimagit.git'
Plug 'https://github.com/kien/ctrlp.vim.git'
Plug 'https://github.com/kshenoy/vim-signature.git'
Plug 'https://github.com/terryma/vim-multiple-cursors.git'
Plug 'https://github.com/tpope/vim-speeddating.git'
Plug 'https://github.com/tpope/vim-surround.git'
Plug 'https://github.com/justinmk/vim-sneak.git'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
call plug#end()

"Plugin Config
let g:deoplete#enable_at_startup = 1
