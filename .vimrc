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

"map <F11>    :!make<cr>
"map <C-F11>  :!make<cr>
"map <F1>     :call append(line("."),"% ============================== %")<cr>:call append(line(".")+1,"% ")<cr>:call append(line(".")+2,"% ============================== %")<cr>V3j=:.m+3<cr>2k$a
"map <F2>     :call append(line("."),"# ============================== #")<cr>:call append(line(".")+1,"# ")<cr>:call append(line(".")+2,"# ============================== #")<cr>V3j=:.m+3<cr>2k$a
"map <F3>    :%s/\s\+$//e
"map <F4>    :!pdflatex --output-directory=./ %:r && bibtex %:r && pdflatex --output-directory=./ %:r<cr><cr>
"map <F5>    :!pdflatex --output-directory=./ %:r <cr><cr>
"map <F6>    :!python3 %<cr>

syn on
colorscheme default
"colorscheme blue
"colorscheme darkblue
"colorscheme default.vim
"colorscheme desert.vim
"colorscheme elflord.vim
"colorscheme evening.vim
"colorscheme koehler.vim
"colorscheme morning.vim
"colorscheme murphy.vim
"colorscheme pablo.vim
"colorscheme peachpuff.vim
"colorscheme ron.vim
"colorscheme shine.vim
"colorscheme slate.vim
"colorscheme torte.vim
"colorscheme zellner.vim

set fileencodings=ucs-bom,utf-8,latin1
