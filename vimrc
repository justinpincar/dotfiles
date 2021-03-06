" vimrc - Universal customization for Vim
" by David Jacobs

" -----------------------------------------------------------
" Pathogen configuration
" -----------------------------------------------------------

set nocompatible
filetype off
call pathogen#infect()
call pathogen#helptags()
source ~/.vim/autoload/slime.vim
filetype plugin indent on
syntax on

" -----------------------------------------------------------
" General configuration
" -----------------------------------------------------------

set clipboard=unnamed   " Allow anonymous clipboard
set hidden              " Allow unsaved changes in hidden buffers
set hlsearch            " Highlight search results
set visualbell t_vb=    " Get rid of that annoying error beep & flash
set expandtab           " Use soft tabs
set tabstop=2           " Width of soft tabs
set autoindent
set shiftwidth=2        " Width of autoindent
set cindent             " C-style autoindenting
set cinoptions=(0       " Align arguments separated by line breaks inside parens
set cinoptions+=
set smartindent
set smarttab            " Use shiftwidth to tab at line beginning
set wrap                " Wrap text inside screen
set linebreak           " Wrap words, not characters
set linespace=4         " Baseline spacing, measured in pixels
set list                " Do show difference between tabs and spaces
set listchars=tab:>-,trail:·,nbsp:·
set number              " Show line numbers
set incsearch           " Incremental search
set ignorecase          " Ignore search case
set smartcase           " ... unless uppercase letters are explicit
set completeopt-=menu   " Bash-like inline completion
set foldmethod=indent   " Fold using indentation
set tildeop             " Tilde is an operator
set formatprg=par\ -w80 " Format paragraphs using par
set wig+=checkouts/**   " Completion/search blacklist
set wig+=.git
set wig+=tmp/**
set autoread
set autowriteall        " Save when focus is lost
set laststatus=2        " Always show status bar
set statusline=         " Customize status bar
set statusline+=\ %F\ \|\ len:\ \%L\ \|\ type:\ %Y\ \|\ ascii:\ \%03.3b\ \|\ hex:\ %2.2B\ \|\ line:\ \%2l

autocmd FocusLost * silent! wall

color ir_black
color desert

nmap <D-C> :color desert<CR>
nmap <D-I> :color ir_black<CR>
nmap <D-L> :color solarized<CR>

if has('unix') || has('mac')
  set directory=/tmp    " Don't store swap files by the originals!
end

" -----------------------------------------------------------
" Keyboard configuration
" -----------------------------------------------------------

let mapleader=','
let maplocalleader=';'

" Leader/a - the easy way to select all
noremap <Leader>aa ggVG

" Leader/s - the easy way to search
" nmap <Leader>s :%s/
" vmap <Leader>s :s/

" Run == formatting on the entire file and return to original position
noremap <Leader>= gg=G``
noremap <D-M-i> gg=G``

" Sudo - even if you didn't open the file as root
cmap w!! %!sudo tee > /dev/null %

" Easy splits, navigation, search, buffers & tabs
map <F9>        :split<CR>
map <D-j>       :split<CR>
map <F10>       :vsplit<CR>
map <D-k>       :vsplit<CR>
map <C-j>       <C-w>j
map <C-k>       <C-w>k
map <C-h>       <C-w>h
map <C-l>       <C-w>l

map <Leader>y   :nohls<CR>
map Y           y$

map <Leader>bl  :buffers<CR>
map <Leader>bn  :bn<CR>
map <M-D-Left>  :bp<CR>
map <Leader>bp  :bp<CR>
map <M-D-Right> :bn<CR>
map <Leader>b   :b#<CR>

imap <D-CR>     <ESC>o

map <D-<>       :tabedit $MYVIMRC<CR>

" Plugins
map <Leader>a :Ack ""<Left>
map <Leader>rt :!/usr/local/bin/ctags -R --exclude=.git --exclude=log ./* `rvm gemhome`/*<CR>

map <Leader>N :CommandT<CR>
map <D-N>     :CommandT<CR>

map <Leader>e :CommandTBuffer<CR>
map <D-e>     :CommandTBuffer<CR>

map <Leader>t :CommandTFlush<CR>
map <D-t>     :CommandTFlush<CR>

map <D-n>     :NERDTreeToggle<CR>
map <Leader>n :NERDTreeToggle<CR>

map <D-/>     <plug>NERDCommenterToggle
map <Leader>/ <plug>NERDCommenterToggle

map <D-r>     :SweetVimRspecRunFile<CR>
map <D-R>     :SweetVimRspecRunFocused<CR>
map <M-D-r>   :SweetVimRspecRunPrevious<CR>

" -----------------------------------------------------------
" Plugin configuration
" -----------------------------------------------------------

let g:CommandTMaxDepth=8
let g:CommandTMaxHeight=10
let g:CommandTMaxFiles=64000
let g:NERDTreeWinSize=20
let g:NERDTreeChDirMode=2
let g:NERDTreeDirArrows=1
let g:NERDSpaceDelims=1               " Add a space before comments
let g:NERDTreeIgnore=['tags']
let g:NERDTreeMinimalUI=1

let vimclojure#HighlightBuiltins=1
let vimclojure#ParenRainbow=1

" Ack functions, taken from:
" https://github.com/pivotal/vim-config/commit/ddb041154c250e2eefacdc2916e7bbd3c51f42c0#diff-2
function! AckCommand()
  let command = "ack ".expand("<cword>")
  cexpr system(command)
  cw
endfunction

function! AckVisual()
  normal gv"xy
  let command = "ack ".@x
  cexpr system(command)
  cw
endfunction

map <Leader>a :call AckCommand()<CR>
vmap <Leader>a :call AckVisual()<CR>

" -----------------------------------------------------------
" Auto sourcing
" -----------------------------------------------------------

" Source this file after saving it
" autocmd bufwritepost .vimrc source $MYVIMRC

" -----------------------------------------------------------
" Post-init configuration
" -----------------------------------------------------------

if getcwd() == expand('~')
  if isdirectory(expand('~/Projects'))
    cd ~/Projects
  elseif isdirectory(expand('~/workspace'))
    cd ~/workspace
  endif
endif
set foldlevel=20

fun! <SID>StripTrailingWhitespaces()
  let l = line(".")
  let c = col(".")
  %s/\s\+$//e
  call cursor(l, c)
endfun

autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()
