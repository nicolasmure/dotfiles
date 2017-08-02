"
" BEGIN Vundle (vim plugins manager)
"
set nocompatible              " be iMproved, required
filetype off                  " required
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim' " plugin manager
Plugin 'joshdick/onedark.vim' " onedark theme (atom like)
Plugin 'sheerun/vim-polyglot' " syntax plugin
Plugin 'scrooloose/nerdtree'
Plugin 'airblade/vim-gitgutter'
Plugin 'arnaud-lb/vim-php-namespace'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'sjbach/lusty'
Plugin 'ntpeters/vim-better-whitespace' " eol and eof whitespace removal
Plugin 'Townk/vim-autoclose' " autoclose parenthesis and brackets
"Plugin 'Quramy/tsuquyomi' " typescript plugin
Plugin 'autozimu/LanguageClient-neovim' " Language Server Protocol support for neovim
Plugin 'Shougo/denite.nvim' " Multi-entry selection UI.
Plugin 'Shougo/deoplete.nvim' " Completion integration with deoplete
Plugin 'Shougo/echodoc.vim' " Showing function signature and inline doc.
Plugin 'Shougo/vimproc.vim' " asynchronous execution library
Plugin 'vim-airline/vim-airline' " powerline like for neovim
Plugin 'w0rp/ale' " asynchronous lint engine
Plugin 'junegunn/fzf.vim' " fuzzy finder vim plugin (requieres bin install too)
" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" END Vundle

let g:deoplete#enable_at_startup = 1
let g:deoplete#complete_method = 'omnifunc'

" Automatically start language servers.
let g:LanguageClient_autoStart = 1
let g:LanguageClient_serverCommands = {
    \ 'php': ['php', '/home/nicolas/tmp/vendor/felixfbecker/language-server/bin/php-language-server.php'],
    \ 'javascript': ['javascript-typescript-stdio'],
    \ 'typescript': ['javascript-typescript-stdio'],
    \ }
let g:LanguageClient_selectionUI = 'fzf'
nnoremap <silent> K :call LanguageClient_textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>
nnoremap <silent> <F2> :call LanguageClient_textDocument_rename()<CR>
nnoremap <silent> <c-r> :call LanguageClient_textDocument_documentSymbol()<CR>
set omnifunc=LanguageClient#complete

set rtp+=~/.fzf " fuzzyfinder plugin to bin

"au FileType php set tags=tags_php-src.tags,tags_php-vendor.tags
"au FileType behat set tags=tags_gherkin.tags
"au FileType javascript set tags=tags_js-lib.tags,tags_js-src.tags,tags_js-modules.tags
"au FileType typescript set tags=tags_ts-lib.tags,tags_ts-typings.tags,tags_ts-modules.tags,tags_ts-src.tags
"au FileType python set tags=tags_python.tags

scriptencoding utf-8
set encoding=utf-8
"
" General behavior
"
set nocompatible                " Use vim defaults (not vi ones)
let mapleader=","               " Use the comma as leader
set history=1000                " Increase history
set nobackup                    " Do not backup files on overwrite
set directory=~/.vim/tmp        " Directory to put swap file
" higlight the cursor line
set cursorline
set cursorcolumn
set number          " display line number
set relativenumber  " display relative line number
set colorcolumn=80  " display a column at 80 chars
" Search options
set incsearch
set hlsearch
set ignorecase
set hidden          " be able to open new buffer w/o saving changes to the current one
set wildmenu        " display autocomplete possibilities in vim commands
" remove trailing whitespaces ntpeters/vim-better-whitespace
autocmd BufEnter * EnableStripWhitespaceOnSave
" easy navigation between words
nmap <C-l> w
nmap <C-h> b
nmap <C-j> 4j
nmap <C-k> 4k
vmap <C-l> w
vmap <C-h> b
vmap <C-j> 4j
vmap <C-k> 4k

"
" Tabs & Indentation
"
set expandtab     " converts tabs to spaces
" indents with tab = 4 spaces
set tabstop=4
set shiftwidth=4
set softtabstop=4

set updatetime=200 " git gutter update time (in ms)

" map ctrl+w ctrl+w to tab to switch vim window
nnoremap <tab> <c-w><c-w>
" Explore tags list for the word under the cursor
map tt g<C-]>
map TT <C-T>
" map autocomplete
inoremap <c-space> <c-x><c-o>
inoremap <c-@> <c-x><c-o>
" do a grep search on the selected text
vnoremap <leader>f y:grep -r "<C-r>""
" do a grep search on the word under cursor
nnoremap <leader>f :grep -r "<C-r><C-w>"
" lusty open last used buffer
nnoremap <leader>lp :LustyJugglePrevious<cr>
" airline config
let g:airline#extensions#tabline#enabled = 1

" BEGIN one-dark theme https://github.com/joshdick/onedark.vim
"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
"if (empty($TMUX))
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
"endif

let g:onedark_terminal_italics=1
syntax on
colorscheme onedark
" Default terminal font is Monospace Regular 12pt
" END one-dark theme

" BEGIN ctrl+p config
let g:ctrlp_working_path_mode = 0
let g:ctrlp_cache_dir = $HOME . '/.cache/ctrlp'
" let g:ctrlp_cmd = 'CtrlPMRU'
" speep up Ctrl-P
if executable('ag')
  " change the grep program for ag which is faster
  set grepprg=ag\ --nogroup\ --nocolor
  if filereadable('.agignore')
      let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
  else
      let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
  endif
let g:ctrlp_use_caching = 0
endif
" END ctrl+p config

"
" NERDTree
"
noremap <C-n> :NERDTreeToggle<CR>

" edit vimrc file
nnoremap <leader>ev :vsplit $MYVIMRC<cr>

