set cul
filetype plugin on
set number
set smartindent
set hlsearch
set incsearch
set colorcolumn=80
set tw=80

set nocompatible
filetype off
set expandtab
set tabstop=4
set shiftwidth=4
set autoindent
set nowrap

filetype plugin indent on

vnoremap <leader>p "_dP

map <F3>    :%s/\s\+$//e
map <F6>    :!python3 %<cr>

syn on

set fileencodings=ucs-bom,utf-8,latin1
