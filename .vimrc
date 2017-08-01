"
" BEGIN Vundle (vim plugins manager)
"
set nocompatible              " be iMproved, required
filetype off                  " required
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" let Vundle manage Vundle, required
Plugin 'airblade/vim-gitgutter'
Plugin 'arnaud-lb/vim-php-namespace'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'joshdick/onedark.vim'
Plugin 'ntpeters/vim-better-whitespace'
Plugin 'Quramy/tsuquyomi'
Plugin 'scrooloose/nerdtree'
Plugin 'sheerun/vim-polyglot'
Plugin 'sjbach/lusty'
Plugin 'Townk/vim-autoclose'
Plugin 'VundleVim/Vundle.vim'
Plugin 'w0rp/ale'
" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" END Vundle

au FileType php set tags=tags_php-src.tags,tags_php-vendor.tags
au FileType behat set tags=tags_gherkin.tags
au FileType javascript set tags=tags_js-lib.tags,tags_js-src.tags,tags_js-modules.tags
au FileType typescript set tags=tags_ts-lib.tags,tags_ts-typings.tags,tags_ts-modules.tags,tags_ts-src.tags
au FileType python set tags=tags_python.tags

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
" Search options
set incsearch
set hlsearch
set ignorecase
set hidden          " be able to open new buffer w/o saving changes to the current one
set wildmenu        " display autocomplete possibilities in vim commands
" remove trailing whitespaces ntpeters/vim-better-whitespace
autocmd BufEnter * EnableStripWhitespaceOnSave

"
" Tabs & Indentation
"
set expandtab     " converts tabs to spaces
" indents with tab = 4 spaces
set tabstop=4
set shiftwidth=4
set softtabstop=4

"
" Mouse scrolling and copying
"
set ttymouse=xterm2
set clipboard=unnamed

set updatetime=200 " git gutter update time (in ms)

" map ctrl+w ctrl+w to tab to switch vim window
nnoremap <tab> <c-w><c-w>
" map autocomplete
inoremap <c-space> <c-x><c-o>
inoremap <c-@> <c-x><c-o>

"BEGIN Powerline (sudo dnf install vim-powerline)
python3 from powerline.vim import setup as powerline_setup
python3 powerline_setup()
python3 del powerline_setup
set laststatus=2 " Always display the statusline in all windows
set showtabline=2 " Always display the tabline, even if there is only one tab
set noshowmode " Hide the default mode text (e.g. -- INSERT -- below the statusline)
set t_Co=256
"END Powerline


" BEGIN one-dark theme https://github.com/joshdick/onedark.vim
"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (empty($TMUX))
  if (has("nvim"))
    "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
  if (has("termguicolors"))
    set termguicolors
  endif
endif

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

"
" Syntastic
"
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*
"
"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
"let g:syntastic_check_on_open = 1
"let g:syntastic_check_on_wq = 0
"let g:syntastic_php_checkers = ['php', 'phpcs', 'phpmd']

" dnf install vim-enhanced
" echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p
