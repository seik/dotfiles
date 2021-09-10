set encoding=utf-8

call plug#begin(stdpath('data') . '/plugged')

" Run tests
Plug 'janko-m/vim-test', { 'for': ['python'] }
Plug 'tpope/vim-dispatch' " asynchronous

" File browser
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }

" Airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Class/module browser
Plug 'majutsushi/tagbar'

" Code and files fuzzy finder
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all'}
Plug 'junegunn/fzf.vim'

" Ack code search (requires ack or ag installed in the system)
Plug 'mileszs/ack.vim'

" Override configs by directory.
" Create a .vim.custom file in the directory you want to customize.
Plug 'arielrossanigo/dir-configs-override.vim'

" Intellisense
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-compe'

" Code dark theme
Plug 'tomasiser/vim-code-dark'

call plug#end()

" no vi-compatible
set nocompatible

" allow plugins by file type (required for plugins!)
filetype plugin on
filetype indent on

" always show status bar
set ls=2

" highlighted search results
set hlsearch

" syntax highlight on
syntax on

" autosave buffers
set autowriteall

" autosave
set autowriteall

" theme
colorscheme codedark

" swap, backup and undo files
set noswapfile
set directory=~/.config/nvim/dirs/tmp     " folder for swap files
set backup                        " make backup files
set backupdir=~/.config/nvim/dirs/backups " folder for backup files
set undofile                      " persistent undos - undo after you re-open the file
set undodir=~/.config/nvim/dirs/undos
set viminfo+=n~/.config/nvim/dirs/viminfo " if you exit vim and later start, vim remembers information like, command line history, search history, marks, etc ...

" create needed directories if they don't exist
if !isdirectory(&backupdir)
    call mkdir(&backupdir, "p")
endif
if !isdirectory(&directory)
    call mkdir(&directory, "p")
endif
if !isdirectory(&undodir)
    call mkdir(&undodir, "p")
endif

" tabs and spaces handling
set expandtab " hitting Tab in insert mode will produce the appropriate number of spaces
set tabstop=2 " tell vim how many columns a tab counts for
set softtabstop=2 " control how many columns vim uses when you hit Tab in insert mode
set shiftwidth=2 " control how many columns text is indented with the reindent operations (<< and >>)


" show
set number " precede each line with its line number

" show tabs, eol and spaces
set list
" chars to use to show the tabs, eol and spaces
set listchars=tab:▸\

" how to split windows
set splitbelow
set splitright

au VimResized *:wincmd = " resize splits when windows are reduced

set wildmenu

" when scrolling, keep cursor 5 lines away from screen border
set scrolloff=5

" search
set incsearch " incremental search
set ignorecase " search is case insensitive but you can add \C to make it sensitive
set smartcase " will automatically switch to a case-sensitive search if you use any capital letters

" ============================== 
" mappings
" ============================== 

" :map and :noremap are recursive and non-recursive

let mapleader=","

" quit file
nnoremap <leader>q <esc>:q<cr>

" move between windows
noremap <TAB><TAB> <C-w><C-w>

" tab navigation mappings
nnoremap tn :tabn<CR>
nnoremap tp :tabp<CR>
nnoremap tt :$tabnew<CR>

" override next and previous search to show in the middle of the screen (zz)
" and also open just enough folds (zv) to make the line in which the cursor 
" is located not folded.
nnoremap n nzzzv
nnoremap N Nzzzv

" clear search results
nnoremap <silent><space> :nohl<CR>

" select current line without identation
nnoremap vv ^vg_

" duplicate line
nnoremap dl :t.<CR>

" disable arrow keys
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>
map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>

" clear empty spaces at the end of lines on save of python files
autocmd BufWritePre *.py :%s/\s\+$//e

" ???
set complete=.,w,b,u,t
set completeopt=longest,menuone " Use the popup menu also when there is only one match.
set completeopt-=preview   " Hide the documentation preview window
set omnifunc=syntaxcomplete#Complete


" ============================
" Plugins configuration
" ============================

" NERDTree ------------------------------

" toggle nerdtree display
map <F3> :NERDTreeToggle<CR>
" open nerdtree with the current file selected
nmap <F4> :NERDTreeFind<CR>
" dont show this files
let NERDTreeIgnore = ['\.pyc$', '\.pyo$', '__pycache__']
" show cursor line
let NERDTreeHighlightCursorline = 1

" Autorefresh on tree focus
function! NERDTreeRefresh()
    if &filetype == "nerdtree"
        silent exe substitute(mapcheck("R"), "<CR>", "", "")
    endif
endfunction

autocmd BufEnter * call NERDTreeRefresh()

" Ariline -------------------------------
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_left_sep = ''
let g:airline_right_sep = ''
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.whitespace = 'Ξ'
let g:airline_theme = 'codedark'

" Fuzzy finder -------------------------
nnoremap <C-P> :GFiles<CR>
nnoremap <leader>f :Ag<CR>
nnoremap <leader>l :Lines<CR>
nnoremap <leader>m :History<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>W :Windows<CR>
command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, {'options': ['--preview', '--info=inline']}, <bang>0)

" Tagbar ------------------------------
let g:tagbar_compact = 1
let g:tagbar_sort = 1
let g:tagbar_autoclose = 1
let g:tagbar_foldlevel = 0
let g:tagbar_width = 60
" open Tagbar
nnoremap <leader>t :TagbarToggle<CR>

" Vim tests -----------------------------

" run tests in a vim8 terminal
let g:test#strategy = "neovim"

nmap <silent> <leader>rt :TestNearest<CR>
nmap <silent> <leader>rT :TestFile<CR>
nmap <silent> <leader>ra :TestSuite<CR>
nmap <silent> <leader>rl :TestLast<CR>
nmap <silent> <leader>rg :TestVisit<CR>

" LSP configs
sign define LspDiagnosticsSignError text=🔴
sign define LspDiagnosticsSignWarning text=🟠
sign define LspDiagnosticsSignInformation text=🔵
sign define LspDiagnosticsSignHint text=🟢

lua << EOF
require'lspconfig'.pyright.setup{
  settings = {
    python = {
      analysis = {
        autoImportCompletions = true,
      }
    }
  }
}
EOF

" Compe config
lua << EOF
vim.o.completeopt = "menuone,noselect"

require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = false;

  source = {
    path = true;
    buffer = true;
    calc = true;
    vsnip = true;
    nvim_lsp = true;
    nvim_lua = true;
    spell = true;
    tags = true;
    snippets_nvim = true;
    treesitter = true;
  };
}
local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
    local col = vim.fn.col('.') - 1
    if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        return true
    else
        return false
    end
end

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
_G.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-n>"
  else
    return t "<TAB>"
  end
end
_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-p>"
  else
    return t "<TAB>"
  end
end

vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})

-- Map compe confirm and complete functions
vim.api.nvim_set_keymap('i', '<cr>', 'compe#confirm("<cr>")', { expr = true })
vim.api.nvim_set_keymap('i', '<c-space>', 'compe#complete()', { expr = true })
EOF
nnoremap <silent> gd <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> gD <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> gr <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> gi <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> K <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> <C-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
" nnoremap <silent> <C-n> <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>
" nnoremap <silent> <C-p> <cmd>lua vim.lsp.diagnostic.goto_next()<CR>

