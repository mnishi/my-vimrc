"---------------------
" basic 
"---------------------
set nocompatible
set nobackup
set mouse=a
set noswapfile
if has('clipboard')
  set clipboard=unnamedplus
endif
set incsearch
set timeoutlen=2000

augroup CheckExternalChanges
  autocmd!
  autocmd FocusGained * checktime
augroup END

if has('win32')
  if executable('pwsh.exe')
    set shell=pwsh.exe
    let &shellcmdflag='-NoLogo -Command "[Console]::OutputEncoding = [System.Text.UTF8Encoding]::new($false);"'
    set shellquote=
    set shellxquote=
  elseif executable('powershell.exe')
    set shell=powershell.exe
    let &shellcmdflag='-NoLogo -Command "[Console]::OutputEncoding = [System.Text.UTF8Encoding]::new($false);"'
    set shellquote=
    set shellxquote=
  endif
endif

let &shellpipe = '>%s 2>&1'

"---------------------------
" vim-plug
"---------------------------
if !empty(globpath(&runtimepath, 'autoload/plug.vim', 1))
  call plug#begin()
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim'
  Plug 'nvim-treesitter/nvim-treesitter'
  Plug 'loctvl842/monokai-pro.nvim'
  Plug 'preservim/tagbar'
  Plug 'vim-denops/denops.vim'
  Plug 'Shougo/ddc.vim'
  Plug 'Shougo/ddc-ui-native'
  Plug 'Shougo/ddc-around'
  Plug 'Shougo/ddc-matcher_head'
  Plug 'Shougo/ddc-sorter_rank'
  call plug#end()
endif

"---------------------
" view
"---------------------
set number
set ruler
set nowrap  

set background=dark
if !empty(globpath(&runtimepath, 'colors/monokai-pro.lua', 1))
  colorscheme monokai-pro
endif

syntax on
set ts=2 sw=2 sts=2
set title
set hlsearch

"------------------------
" status line
"------------------------
set showcmd
set laststatus=2
highlight StatusLine guifg=#FFFFFF guibg=#285CC4 gui=bold ctermfg=231 ctermbg=26 cterm=bold
highlight StatusLineNC guifg=#FCFCFA guibg=#58535C gui=NONE ctermfg=255 ctermbg=240 cterm=NONE
highlight WinSeparator guifg=#FFD866 guibg=NONE gui=NONE ctermfg=221 ctermbg=NONE cterm=NONE
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
highlight Visual ctermfg=white ctermbg=blue guifg=white guibg=blue

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
set makeencoding=utf-8
set fileencodings=utf-8,iso-2022-jp,euc-jp,sjis
set fileformats=unix,dos,mac

"------------------------
" include path
"------------------------
if has("unix")
	set path+=/usr/include
	set path+=/usr/local/include
endif
set path+=./**/include

"------------------------
" tag file path
"------------------------
set tags=./tags;

filetype plugin indent on

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
nnoremap <silent> gl :<C-u>vimgrep /<C-R><C-W>/ %<CR>
set grepprg=rg\ --vimgrep\ --no-heading\ --line-number\ --color\ never\ --glob=!tags\ --glob=!build/**
set grepformat=%f:%l:%c:%m
function! GrepWordInDir()
  let l:default_word = expand('<cword>')
  let l:word = input('Search word: ', l:default_word)
  if empty(l:word)
    echo "Canceled"
    return
  endif
  let l:dir = input('Search in directory: ', getcwd(), 'dir')
  if empty(l:dir)
    echo "Canceled"
    return
  endif
  execute 'grep! ' . shellescape(l:word) . ' ' . shellescape(l:dir)
  copen
endfunction
nnoremap <silent> gr :call GrepWordInDir()<CR>

"------------------------------------
" Tagbar
"------------------------------------
nmap <F8> :let g:tagbar_position='topleft vertical'<CR> :TagbarToggle<CR> 
nmap <F9> :let g:tagbar_position='botright vertical'<CR> :TagbarToggle<CR>
let g:tagbar_width = 46

"------------------------------------
" ddc
"------------------------------------
if !(has('nvim-0.10') || has('patch-9.1.0448'))
      \ || empty(globpath(&runtimepath, 'autoload/ddc/custom.vim', 1))
      \ || empty(globpath(&runtimepath, 'plugin/denops.vim', 1))
  finish
endif

if !exists('g:denops#deno')
  let s:deno = exepath('deno')
  if empty(s:deno)
    let s:deno = expand('~/.deno/bin/') . (has('win32') ? 'deno.exe' : 'deno')
  endif
  if !executable(s:deno)
    finish
  endif
  let g:denops#deno = s:deno
elseif !executable(g:denops#deno)
  finish
endif
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
if !empty(globpath(&runtimepath, 'denops/ddc-sources/clangd.ts', 1))
  call ddc#custom#patch_filetype(['c', 'cpp'], 'sources', ['around', 'clangd'])
  call ddc#custom#patch_filetype(['c', 'cpp'], 'sourceOptions', #{
        \   clangd: #{ mark: 'C' },
        \ })
endif
call ddc#custom#patch_filetype('markdown', 'sourceParams', #{
    \   around: #{ maxSize: 100 },
    \ })
inoremap <expr> <TAB>
\ pumvisible() ? '<C-n>' :
\ (col('.') <= 1 <Bar><Bar> getline('.')[col('.') - 2] =~# '\s') ?
\ '<TAB>' : ddc#map#manual_complete()
inoremap <expr> <S-TAB>  pumvisible() ? '<C-p>' : '<C-h>'
call ddc#enable()

"---------------------
" telescope
"---------------------
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
