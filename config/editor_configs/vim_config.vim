" DevEnvSetup - Vim Configuration
" A comprehensive .vimrc configuration for development

" General Settings
set nocompatible              " Be iMproved, required
filetype off                  " Required for Vundle
set encoding=utf-8            " Default encoding
set fileencoding=utf-8        " File encoding
set fileformats=unix,dos,mac  " File format
set autoread                  " Auto-reload files changed outside of Vim
set backspace=indent,eol,start " Backspace behavior
set history=1000              " Command line history
set showcmd                   " Show incomplete commands
set showmode                  " Show current mode
set hidden                    " Allow hidden buffers
set laststatus=2              " Always show status line
set ruler                     " Show cursor position
set number                    " Show line numbers
set relativenumber            " Relative line numbers
set cursorline                " Highlight current line
set wildmenu                  " Better command-line completion
set wildmode=list:longest,full " Completion mode
set scrolloff=3               " Keep 3 lines above/below cursor
set sidescrolloff=5           " Keep 5 columns left/right of cursor
set visualbell                " Use visual bell instead of beeping
set t_vb=                     " Disable visual bell
set mouse=a                   " Enable mouse usage
set lazyredraw                " Don't redraw while executing macros
set ttyfast                   " Fast terminal connection
set showmatch                 " Highlight matching braces
set mat=2                     " How many tenths of a second to blink
set incsearch                 " Searches for strings incrementally
set hlsearch                  " Highlight all search results
set ignorecase                " Ignore case in search patterns
set smartcase                 " Override ignorecase when search contains uppercase
set foldenable                " Enable folding
set foldmethod=indent         " Fold based on indentation
set foldlevelstart=10         " Open most folds by default
set foldnestmax=10            " 10 nested fold max
set splitright                " Split vertical windows right
set splitbelow                " Split horizontal windows below
set autoindent                " Auto-indent new lines
set smartindent               " Enable smart-indent
set smarttab                  " Enable smart-tabs
set shiftwidth=4              " Number of auto-indent spaces
set softtabstop=4             " Number of spaces per tab
set tabstop=4                 " Number of visual spaces per tab
set expandtab                 " Use spaces instead of tabs
set textwidth=0               " Hard-wrap lines (0 = disabled)
set wrap                      " Soft-wrap lines
set linebreak                 " Don't break words when wrapping
set list                      " Display unprintable characters
set listchars=tab:▸\ ,trail:· " Show tabs and trailing spaces
set nojoinspaces              " Prevents double spaces after punctuation on join
set confirm                   " Prompt confirmation for unsaved changes
set undolevels=1000           " Number of undo levels
set background=dark           " Dark background
set timeout timeoutlen=1000 ttimeoutlen=100 " Faster key response
set updatetime=300            " Faster updates

" Map leader key to space
let mapleader = " "
let maplocalleader = " "

" Colors
syntax enable                 " Enable syntax highlighting
set t_Co=256                  " 256 colors

" Try to detect and load colorschemes if installed
try
    colorscheme slate
catch /^Vim\%((\a\+)\)\=:E185/
    " No colorscheme installed, use default
endtry

" Key mappings
" Quick save
nmap <leader>w :w!<cr>

" Quick quit
nmap <leader>q :q<cr>

" Quick save and quit
nmap <leader>wq :wq<cr>

" Quick reload vimrc
nmap <leader>r :source $MYVIMRC<cr>

" Toggle paste mode
nmap <leader>p :set paste!<cr>

" Toggle line numbers
nmap <leader>n :set number!<cr>

" Toggle relative line numbers
nmap <leader>rn :set relativenumber!<cr>

" Clear search highlighting
nmap <leader>/ :nohlsearch<cr>

" Quick navigation between splits
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Buffer navigation
nmap <leader>bn :bnext<cr>
nmap <leader>bp :bprevious<cr>
nmap <leader>bd :bdelete<cr>
nmap <leader>bl :ls<cr>

" Tab navigation
nmap <leader>tn :tabnext<cr>
nmap <leader>tp :tabprevious<cr>
nmap <leader>tc :tabnew<cr>
nmap <leader>td :tabclose<cr>

" Remap Escape key
inoremap jk <Esc>
inoremap kj <Esc>

" Keep visual selection when indenting
vnoremap < <gv
vnoremap > >gv

" Move visual block
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" Center search results
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz

" Automatically create directories when saving
augroup BWCCreateDir
    autocmd!
    autocmd BufWritePre * if expand("<afile>")!~#'^\w\+:/' && !isdirectory(expand("%:h")) | execute "silent! !mkdir -p ".shellescape(expand('%:h'), 1) | redraw! | endif
augroup END

" Remember cursor position between vim sessions
augroup remember_cursor_position
    autocmd!
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
augroup END

" Auto source vimrc on save
augroup reload_vimrc
    autocmd!
    autocmd BufWritePost $MYVIMRC source $MYVIMRC
augroup END

" Strip trailing whitespace on save
augroup strip_whitespace
    autocmd!
    autocmd BufWritePre * :%s/\s\+$//e
augroup END

" File type specific settings
augroup file_types
    autocmd!
    autocmd FileType python setlocal ts=4 sts=4 sw=4 expandtab
    autocmd FileType javascript setlocal ts=2 sts=2 sw=2 expandtab
    autocmd FileType html setlocal ts=2 sts=2 sw=2 expandtab
    autocmd FileType css setlocal ts=2 sts=2 sw=2 expandtab
    autocmd FileType json setlocal ts=2 sts=2 sw=2 expandtab
    autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
    autocmd FileType markdown setlocal ts=2 sts=2 sw=2 expandtab wrap
    autocmd FileType gitcommit setlocal spell textwidth=72
augroup END