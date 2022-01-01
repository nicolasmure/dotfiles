let g:polyglot_disabled = ['markdown']
"
" BEGIN vim-plug (vim plugins manager)
"
set nocompatible              " be iMproved, required
filetype off                  " required
call plug#begin('~/.local/share/nvim/plugged')
" let Vundle manage Vundle, required
Plug 'joshdick/onedark.vim' " onedark theme (atom like)
Plug 'sheerun/vim-polyglot' " syntax plugin
Plug 'ekalinin/Dockerfile.vim' " syntax plugin for Dockerfiles (used by vim-polyglot)
Plug 'smerrill/vcl-vim-plugin' " syntax plugin fot vtc (varnish) (used by vim-polyglot)
Plug 'airblade/vim-gitgutter' " show added / edited / removed lines near the line number
Plug 'Yggdroot/indentLine' " indentation guide
Plug 'junegunn/fzf.vim' " fuzzy finder vim plugin (requires bin install too)
Plug 'ntpeters/vim-better-whitespace' " eol and eof whitespace removal
Plug 'jiangmiao/auto-pairs' " autoclose parenthesis and brackets, auto indent in curly braces
Plug 'travisjeffery/vim-auto-mkdir' " auto mkdir when saving a file in an unexistant dir
Plug 'tpope/vim-eunuch' " helpers for unix commands (rm, mv, mkdir, chmod, etc...)
Plug 'tpope/vim-fugitive' " git commands
Plug 'tpope/vim-commentary' " to comment blocks of code
Plug 'tpope/vim-surround' " to change surrounding chunks (eg simple quotes to double quotes)
Plug 'tpope/vim-repeat' " to repeat some plugings map with '.'
" Language Server Protocol support for neovim
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }
Plug 'ncm2/ncm2' " completion integration
Plug 'roxma/nvim-yarp' " required for 'ncm2/ncm2'
" completion sources https://github.com/ncm2/ncm2/wiki
Plug 'ncm2/ncm2-bufword'
Plug 'ncm2/ncm2-path'
Plug 'vim-airline/vim-airline' " powerline like for neovim
Plug 'godlygeek/tabular' " align text (such as markdown tables)
Plug 'sgur/vim-editorconfig' " .editorconfig support
" Initialize plugin system
call plug#end()
" END vim-plug

" completion
" don't give |ins-completion-menu| messages.  For example,
" '-- XXX completion (YYY)', 'match 1 of 2', 'The only match',
set shortmess+=c
" enable ncm2 for all buffers
autocmd BufEnter * call ncm2#enable_for_buffer()
set completeopt=noinsert,menuone,noselect
" use <Tab> to select the popup menu
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
" start new line when pressing enter when popup menu is visible
inoremap <expr> <CR> pumvisible() ? "\<C-y>\<CR>" : "\<CR>"

" Automatically start language servers.
let g:LanguageClient_autoStart = 1
let g:LanguageClient_serverCommands = {
    \ 'php': ['php', '~/.config/composer/vendor/felixfbecker/language-server/bin/php-language-server.php'],
    \ 'javascript': ['javascript-typescript-stdio'],
    \ 'javascript.jsx': ['javascript-typescript-stdio'],
    \ 'typescript': ['javascript-typescript-stdio'],
    \ 'python': ['/usr/local/bin/pyls'],
    \ 'rust': ['rustup', 'run', 'stable', 'rls'],
    \ }
let g:LanguageClient_selectionUI = 'fzf'
nnoremap <silent> K :call LanguageClient_textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>
nnoremap <silent> ref :call LanguageClient_textDocument_references()<CR>
nnoremap <silent> <F2> :call LanguageClient_textDocument_rename()<CR>
nnoremap <silent> <c-t> :call LanguageClient_textDocument_documentSymbol()<CR>
nnoremap <silent> <c-y> :call LanguageClient_workspace_symbol()<CR>

set rtp+=~/.fzf " fuzzyfinder plugin to bin

scriptencoding utf-8
set encoding=utf-8
"
" General behavior
"
set nocompatible                " Use vim defaults (not vi ones)
let mapleader=","               " Use the comma as leader
set history=1000                " Increase history
set nobackup                    " Do not backup files on overwrite
set noswapfile
set autoread                    " Reload buffer automatically on external file change
set lazyredraw
" higlight the cursor line
set cursorline
set cursorcolumn
set number          " display line number
set relativenumber  " display relative line number
set colorcolumn=80  " display a column at 80 chars
let g:indentLine_char = '▏' " indentation guide char
" Search options
set incsearch
set hlsearch
set ignorecase
set hidden          " be able to open new buffer w/o saving changes to the current one
set wildmenu        " display autocomplete possibilities in vim commands
" remove trailing whitespaces ntpeters/vim-better-whitespace
let g:better_whitespace_enabled=1
let g:strip_whitespace_on_save=1
let g:strip_whitelines_at_eof=1
" easy navigation between words
nmap <C-l> w
nmap <C-h> b
nmap <C-j> 4j
nmap <C-k> 4k
vmap <C-l> w
vmap <C-h> b
vmap <C-j> 4j
vmap <C-k> 4k
" force to never use arrow for navigation !
nmap <Up> <nop>
nmap <Down> <nop>
nmap <Left> <nop>
nmap <Right> <nop>
" remove shift+j original mapping (originally concat the next line to the current one)
nmap <S-j> <nop>
vmap <S-j> <nop>
" show next matched string at the center of screen
nnoremap n nzz
nnoremap N Nzz

"
" Tabs & Indentation
"
set expandtab     " converts tabs to spaces
" indents with tab = 4 spaces
set tabstop=4
set shiftwidth=4
set softtabstop=4
" editorconfig plugin options
let g:editorconfig_root_chdir = 1 " automatically :lcd if root = true exists in .editorconfig
let g:editorconfig_verbose = 1 " show verbose messages

"
" Tabularize
"
nmap <Leader>= :Tabularize /=<CR>
vmap <Leader>= :Tabularize /=<CR>
nmap <Leader>: :Tabularize /:\zs<CR>
vmap <Leader>: :Tabularize /:\zs<CR>
nmap <Leader>\| :Tabularize /\|<CR>
vmap <Leader>\| :Tabularize /\|<CR>

set updatetime=200 " git gutter update time (in ms)

" Fast split resize
nnoremap <silent> <Leader>+ :exe "resize " . (winheight(0) * 3/2)<CR>
nnoremap <silent> <Leader>- :exe "resize " . (winheight(0) * 2/3)<CR>
nnoremap <silent> <Leader>> :exe "vertical resize " . (winwidth(0) * 3/2)<CR>
nnoremap <silent> <Leader>< :exe "vertical resize " . (winwidth(0) * 2/3)<CR>

" map ctrl+w ctrl+w to tab to switch vim window
nnoremap <tab> <c-w><c-w>
nnoremap <S-tab> <c-w>W
" do a grep search on the selected text
vnoremap <leader>f y:grep -r "<C-r>""
" do a grep search on the word under cursor
nnoremap <leader>f :grep -r "<C-r><C-w>"
" ctrl+p to list files with fzf
nnoremap <c-p> :Files<CR>
" ctrl+b to list MRU buffers with fzf
nnoremap <c-b> :Buffers<CR>
" get back to the previously used buffer
nnoremap <leader>b :b#<CR>
" airline config
let g:airline#extensions#tabline#enabled = 1

" BEGIN one-dark theme https://github.com/joshdick/onedark.vim
if (has("nvim"))
  "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif
"For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
"Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
" < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
if (has("termguicolors"))
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

let g:onedark_terminal_italics=1
syntax on
colorscheme onedark
" Default terminal font is Monospace Regular 12pt
" END one-dark theme

" Customize fzf colors to match your color scheme
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

"
" netrw (split explorer)
" @see https://vi.stackexchange.com/a/17684
" @see https://shapeshed.com/vim-netrw/#nerdtree-like-setup
"
let g:netrw_browse_split = 4 " open selected file in previously focused window
let g:netrw_banner = 0       " hide the comments banner
let g:netrw_liststyle = 3    " tree style listing
let g:netrw_altv = 1
let g:netrw_winsize = 25
let g:NetrwOpened=0

function! ToggleNetrw()
    if g:NetrwOpened
        let i = bufnr("$")
        while (i >= 1)
            if (getbufvar(i, "&filetype") == "netrw")
                silent exe "bwipeout " . i
            endif
            let i-=1
        endwhile
        let g:NetrwOpened=0
    else
        let g:NetrwOpened=1
        silent Lexplore .
    endif
endfunction

noremap <silent> <C-n> :call ToggleNetrw()<CR>
