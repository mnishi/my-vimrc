"---------------------
" basic 
"---------------------
set nocompatible
set nobackup
set mouse=
set noswapfile
set clipboard=unnamed,autoselect
set incsearch
set timeoutlen=2000
filetype off
filetype plugin indent off
"---------------------------
" dein
"---------------------------
if &compatible
    set nocompatible
endif

call plug#begin()
Plug 'vim-scripts/grep.vim'
Plug 'Shougo/unite.vim'
Plug 'Shougo/neomru.vim'
Plug 'tomasr/molokai'
Plug 'preservim/tagbar'
Plug 'thinca/vim-qfreplace'
Plug 'vim-denops/denops.vim'
Plug 'Shougo/ddc.vim'
Plug 'Shougo/ddc-ui-native'
Plug 'Shougo/ddc-around'
Plug 'Shougo/ddc-matcher_head'
Plug 'Shougo/ddc-sorter_rank'
call plug#end()

"---------------------
" view
"---------------------
set number
set ruler
set nowrap  

set term=xterm-256color
set ttytype=xterm-256color
set background=dark
colorscheme molokai

syntax on
set t_Co=256
set ts=2 sw=2 sts=2
set title
set hlsearch

"------------------------
" status line
"------------------------
set showcmd
set laststatus=2
set statusline=[%n]											
set statusline+=%m											
set statusline+=%r											
set statusline+=%h											
set statusline+=%w											
set statusline+=%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']'}	
set statusline+=%y											
set statusline+=\ 											
set statusline+=%F											
set statusline+=%=											
set statusline+=%ll											
set statusline+=/
set statusline+=%L											
set statusline+=,
set statusline+=%c											
set statusline+=%p											

"------------------------
" cursor line
"------------------------
setlocal cursorline
autocmd WinEnter *.* setlocal cursorline
autocmd WinLeave *.* setlocal nocursorline
highlight Cursorline cterm=underline ctermfg=none ctermbg=none gui=underline guifg=NONE guibg=NONE

"------------------------
" editor
"------------------------
set ignorecase
set smartcase
set tabstop=2
set shiftwidth=4
set expandtab
set autoindent
set cinoptions+=:0
set backspace=indent,eol,start
set wrapscan
set showmatch
set wildmenu

"------------------------
" encoding
"------------------------
set encoding=utf-8
set fileencodings=utf-8,iso-2022-jp,euc-jp,sjis
set fileformats=unix,dos,mac

"------------------------
" include path
"------------------------
if has("unix")
	set path+=/usr/include
	set path+=/usr/local/include
	set path+=./**/include
endif

"------------------------
" tag file path
"------------------------
set tags=./tags;

"------------------------
" for python 
"------------------------
autocmd FileType python setl autoindent
autocmd FileType python setl smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
autocmd FileType python setl tabstop=2 expandtab shiftwidth=2 softtabstop=2

"------------------------
" for ruby 
"------------------------
autocmd FileType ruby setl tabstop=2 expandtab shiftwidth=2

"------------------------
" search 
"------------------------
nnoremap <silent> gt /<C-R><C-W><CR>

"------------------------
" filer 
"------------------------
nmap <F10> :sp %:h<CR> 

"---------------------------
" vimgrep
"---------------------------
autocmd QuickFixCmdPost *vimgrep* cwindow

"------------------------------------
" unite.vim
"------------------------------------
let g:unite_enable_start_insert=0
noremap <C-U><C-B> :Unite buffer<CR>
noremap <C-U><C-F> :UniteWithBufferDir -buffer-name=files file<CR>
noremap <C-U><C-R> :Unite file_mru<CR>
noremap <C-U><C-Y> :Unite -buffer-name=register register<CR>
noremap <C-U><C-U> :Unite buffer file_mru<CR>
noremap <C-U><C-A> :Unite UniteWithBufferDir -buffer-name=files buffer file_mru bookmark file<CR>

"------------------------------------
" grep.vim
"------------------------------------
nnoremap <silent> gr :<C-u>Rgrep<CR><C-R><C-W>
nnoremap <silent> gl :<C-u>vimgrep /<C-R><C-W>/ %<CR>

"------------------------------------
" Tagbar
"------------------------------------
nmap <F8> :let g:tagbar_position='topleft vertical'<CR> :TagbarToggle<CR> 
nmap <F9> :let g:tagbar_position='botright vertical'<CR> :TagbarToggle<CR>
let g:tagbar_width = 46

"---------------------
" filetype 
"---------------------
filetype on
filetype plugin indent on

"------------------------------------
" ddc
"------------------------------------
let g:denops#deno=expand('~/.deno/bin/deno')
call ddc#custom#patch_global('ui', 'native')
call ddc#custom#patch_global('sources', ['around'])
call ddc#custom#patch_global('sourceOptions', #{
      \   _: #{
      \     matchers: ['matcher_head'],
      \     sorters: ['sorter_rank']},
      \   },
      \ )
call ddc#custom#patch_global('sourceOptions', #{
      \   around: #{ mark: 'A' },
      \ })
call ddc#custom#patch_global('sourceParams', #{
      \   around: #{ maxSize: 500 },
      \ })
call ddc#custom#patch_filetype(
    \   ['c', 'cpp'], 'sources', ['around', 'clangd']
    \ )
call ddc#custom#patch_filetype(['c', 'cpp'], 'sourceOptions', #{
    \   clangd: #{ mark: 'C' },
    \ })
call ddc#custom#patch_filetype('markdown', 'sourceParams', #{
    \   around: #{ maxSize: 100 },
    \ })
inoremap <expr> <TAB>
\ pumvisible() ? '<C-n>' :
\ (col('.') <= 1 <Bar><Bar> getline('.')[col('.') - 2] =~# '\s') ?
\ '<TAB>' : ddc#map#manual_complete()
inoremap <expr> <S-TAB>  pumvisible() ? '<C-p>' : '<C-h>'
call ddc#enable()
