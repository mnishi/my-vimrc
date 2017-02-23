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
" NeoBundle
"---------------------------
set runtimepath+=~/.vim/bundle/neobundle.vim/
let g:neobundle#log_filename = $HOME . "/.vim/bundle/.neobundle.log"
call neobundle#begin(expand('~/.vim/bundle/'))
NeoBundleFetch 'Shougo/neobundle.vim'

NeoBundle 'grep.vim'
NeoBundle 'Shougo/neocomplcache'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/neomru.vim'
NeoBundle 'tomasr/molokai'
NeoBundle 'majutsushi/tagbar'
NeoBundle 'thinca/vim-qfreplace'

call neobundle#end()
NeoBundleCheck

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
set ts=4 sw=4 sts=4
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
set tabstop=4
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
autocmd FileType python setl tabstop=8 expandtab shiftwidth=4 softtabstop=4

"------------------------
" for ruby 
"------------------------
autocmd FileType ruby setl tabstop=2 expandtab shiftwidth=2

"------------------------
" search 
"------------------------
nnoremap <silent> gu /<C-R><C-W><CR>

"------------------------
" filer 
"------------------------
nmap <F10> :sp %:h<CR> 

"---------------------------
" vimgrep
"---------------------------
autocmd QuickFixCmdPost *vimgrep* cwindow

"-----------------------------
" neocomplcache
"-----------------------------
let g:neocomplcache_enable_at_startup = 1
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplcache.
let g:neocomplcache_enable_at_startup = 1
" Use smartcase.
let g:neocomplcache_enable_smart_case = 1
" Use camel case completion.
let g:neocomplcache_enable_camel_case_completion = 0
" Use underbar completion.
let g:neocomplcache_enable_underbar_completion = 1
" Set minimum syntax keyword length.
let g:neocomplcache_min_syntax_length = 3
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplcache#undo_completion()
inoremap <expr><C-l>     neocomplcache#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return neocomplcache#smart_close_popup() . "\<CR>"
  " For no inserting <CR> key.
  "return pumvisible() ? neocomplcache#close_popup() : "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplcache#close_popup()
inoremap <expr><C-e>  neocomplcache#cancel_popup()
" Close popup by <Space>.
"inoremap <expr><Space> pumvisible() ? neocomplcache#close_popup() : "\<Space>"

" For cursor moving in insert mode(Not recommended)
"inoremap <expr><Left>  neocomplcache#close_popup() . "\<Left>"
"inoremap <expr><Right> neocomplcache#close_popup() . "\<Right>"
"inoremap <expr><Up>    neocomplcache#close_popup() . "\<Up>"
"inoremap <expr><Down>  neocomplcache#close_popup() . "\<Down>"
" Or set this.
"let g:neocomplcache_enable_cursor_hold_i = 1
" Or set this.
"let g:neocomplcache_enable_insert_char_pre = 1

" AutoComplPop like behavior.
"let g:neocomplcache_enable_auto_select = 1

" Shell like behavior(not recommended).
"set completeopt+=longest
"let g:neocomplcache_enable_auto_select = 1
"let g:neocomplcache_disable_auto_complete = 1
"inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Enable heavy omni completion.
if !exists('g:neocomplcache_omni_patterns')
  let g:neocomplcache_omni_patterns = {}
endif
let g:neocomplcache_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
let g:neocomplcache_omni_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
let g:neocomplcache_omni_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

" For perlomni.vim setting.
" https://github.com/c9s/perlomni.vim
let g:neocomplcache_omni_patterns.perl = '\h\w*->\h\w*\|\h\w*::'

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
"
"------------------------------------
" Tagbar
"------------------------------------
nmap <F8> :let g:tagbar_left=1<CR> :TagbarToggle<CR> 
nmap <F9> :let g:tagbar_left=0<CR> :TagbarToggle<CR>
let g:tagbar_width = 46

"---------------------
" filetype 
"---------------------
filetype on
filetype plugin indent on

