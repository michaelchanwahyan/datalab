set cul
set backspace=indent,eol,start
filetype plugin on
set number
set smartindent
set hlsearch
set incsearch
set colorcolumn=80

if !has('diff')
  au BufWinLeave *.sv mkview
  au BufWrite *.sv mkview
  au BufWinEnter *.sv silent loadview
  au BufWinLeave *.c mkview
  au BufWrite *.c mkview
  au BufWinEnter *.c silent loadview
  au BufWinLeave *.cpp mkview
  au BufWrite *.cpp mkview
  au BufWinEnter *.cpp silent loadview
endif

set nocompatible              " be iMproved, required
filetype off                  " required
set expandtab
set tabstop=4
set shiftwidth=4
set autoindent
set nowrap
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
filetype plugin indent on    " required

" My Vim Functions
"  //==============================
"  // Insert Range Block
"  //==============================
func! InsertRange()
  let startIdx = input("Start Index / Item Count (Default 0):")
  let endIdx   = input("Last Index: ")
  let Stride   = input("Stride: ")
  if startIdx == ""
    let startIdx = 0
  endif
  if endIdx == "" 
    let addList=range(startIdx)
  elseif Stride == "" 
    let addList=range(startIdx,endIdx)
  else
    let addList=range(startIdx,endIdx,Stride)
  endif
  call setreg('a', join(addList,"\<C-J>") . "\<C-J>" , "b")
  execute "normal \"ap"
endf

vnoremap <leader>p "_dP

" My Quick Map
map <F2>     :call append(line("."),"# ============================== #")<cr>:call append(line(".")+1,"# ")<cr>:call append(line(".")+2,"# ============================== #")<cr>V3j=:.m+3<cr>2k$a
map <F3>    :%s/\s\+$//e
map <F4>    :!python3 %:r<cr>

syn on
colorscheme elflord
