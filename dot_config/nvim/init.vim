" {{{ vim-plug
call plug#begin(stdpath('data') . '/plugged')

" Airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Colors
Plug 'nanotech/jellybeans.vim'
Plug 'NLKNguyen/papercolor-theme'
Plug 'rakr/vim-one'
Plug 'joshdick/onedark.vim'
Plug 'sonph/onehalf', {'rtp': 'vim/'}
Plug 'ayu-theme/ayu-vim'
Plug 'drewtempelmeyer/palenight.vim'

" Navigation
Plug 'airblade/vim-gitgutter'
Plug 'jamessan/vim-gnupg'
Plug 'scrooloose/nerdtree'
Plug 'mileszs/ack.vim'
Plug 'junegunn/fzf.vim'

" Editing
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'jiangmiao/auto-pairs'
Plug 'majutsushi/tagbar'
Plug 'scrooloose/syntastic'
Plug 'docunext/closetag.vim'
Plug 'tpope/vim-surround'
Plug 'vim-scripts/indentpython.vim'
set rtp+=/usr/local/opt/fzf
Plug 'elzr/vim-json'
Plug 'jtratner/vim-flavored-markdown'
Plug 'tpope/vim-sleuth'
Plug 'fatih/vim-go'
Plug 'vimwiki/vimwiki'

call plug#end()
" END Vundle }}}
" {{{ Colors
let $NVIM_TUI_ENABLE_TRUE_COLOR=1
let $NVIM_TUI_ENABLE_CURSOR_SHAPE = 1
set termguicolors

set background=dark
colorscheme jellybeans
" END Colors }}}
" {{{ General
syntax on
let g:python3_host_prog = $HOME."/.virtualenvs/neovim3/bin/python"	
let g:python_host_prog = $HOME."/.virtualenvs/neovim2/bin/python"	
let mapleader = "\<space>"
set mouse=

" Encoding
set encoding=utf-8

" Search
set incsearch
set ignorecase
set smartcase
set hlsearch

" Visuals
set number
set cursorline
set wildmenu
set completeopt-=preview
set laststatus=2

" Trailing chars, max length
exec "set listchars=trail:\uB7"
highlight ColorColumn ctermbg=235
set colorcolumn=80

" Indentation
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set shiftround

" Folding
set foldmethod=marker
set foldnestmax=2
set foldenable!

" Undo
set undofile
set undodir=$HOME/.local/share/nvim/undo
set undolevels=1000
set undoreload=10000

" Other
set timeoutlen=1000 ttimeoutlen=0
" END General }}}
" {{{ Airline
let g:airline_powerline_fonts = 1
" END Airline }}}
" {{{ Relative numbering
function! NumberToggle()
  if(&relativenumber == 1)
    set relativenumber!
  else
    set relativenumber
  endif
endfunc

set relativenumber

nnoremap <leader>n :call NumberToggle()<CR>
" END Relative numbering }}}
" {{{ Splits
set splitbelow
set splitright
" END Splits }}}
" {{{ Mappings

" Movement
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

nnoremap <Left> <C-w>h
nnoremap <Down> <C-w>j
nnoremap <Up> <C-w>k
nnoremap <Right> <C-w>l

nmap k gk
nmap j gj

nnoremap B ^
nnoremap E $
nnoremap $ <nop>
nnoremap ^ <nop>

" Yank to clipboard
nmap <leader>y "+y_
nmap <leader>Y "+y

" Modes
nmap <leader>q :nohlsearch<CR>

" Buffers, tabs
nmap <C-e> :e#<CR>
nmap <C-p> :bprev<CR>
nmap <C-n> :bnext<CR>
nmap <leader>w :w<CR>
nmap <leader>t :tabedit<CR>
nmap <C-Left> :tabn<CR>
nmap <C-Right> :tabp<CR>

" Folding
nmap <leader>f za

" Plugins
nmap <F12> :TagbarToggle<CR>
nmap <leader><space> :Buffers<CR>
nmap <leader>e :NERDTreeToggle<CR>

" Go
nmap <leader>gf :GoFmt<CR>

" Whitespace
:nnoremap <silent> <F7> :let _s=@/ <Bar> :%s/\s\+$//e <Bar> :let @/=_s <Bar> :nohl <Bar> :unlet _s <CR>

" Spelling
map <F5> :set spell! spelllang=sl<CR>
map <F6> :set spell! spelllang=en<CR>

" Make
set autowrite
map <leader>m :make<CR>

" .vimrc
map <F2> :source $MYVIMRC<CR>

" FZF
nmap <leader>; :Files<CR>
" END Mappings }}}
" Search {{{
let g:ackprg = 'ag --nogroup --nocolor --column'
nnoremap <Leader>s :Ack!<Space>
nnoremap <Leader>S :Ag<CR>
" END Search }}}
" {{{ Markdown
let g:tagbar_type_markdown = {
    \ 'ctagstype': 'markdown',
    \ 'ctagsbin' : '/usr/bin/markdown2ctags',
    \ 'ctagsargs' : '-f - --sort=yes',
    \ 'kinds' : [
        \ 's:sections',
        \ 'i:images'
    \ ],
    \ 'sro' : '|',
    \ 'kind2scope' : {
        \ 's' : 'section',
    \ },
    \ 'sort': 0,
\ }
" END Markdown }}}
" {{{ Syntax specific

" Make
autocmd FileType make set noexpandtab

" Markdown
augroup markdown
  au!
  au BufNewFile,BufRead *.md,*.markdown setlocal filetype=ghmarkdown 
  au BufNewFile,BufRead *.md,*.markdown setlocal foldmethod=marker foldenable
  au BufNewFile,BufRead *.md,*.markdown setlocal textwidth=79
augroup END

" TeX
augroup plaintex
  au!
  au BufNewFile,BufRead *.tex setlocal textwidth=79
augroup END

" Python
let g:syntastic_python_flake8_args = "--ignore=E501"

" Go
let g:go_fmt_autosave = 0
" END Syntax specific }}}
" {{{ Vim-coc
" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
if has('patch8.1.1068')
  " Use `complete_info` if your (Neo)Vim version supports it.
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  imap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Introduce function text object
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Mappings using CoCList:
" Show all diagnostics.
nnoremap <silent> <space>cd  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent> <space>ce  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent> <space>cc  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent> <space>co  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent> <space>cs  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>
" }}}
" {{{ vimwiki
let g:vimwiki_list = [{'path': '~/Notes/',
                      \ 'syntax': 'markdown', 'ext': '.md'}]
nmap <leader>ne <Plug>VimwikiIndex
nmap <leader>nt <Plug>VimwikiTabIndex
nmap <leader>ns <Plug>VimwikiUISelect
nmap <leader>ni <Plug>VimwikiDiaryIndex
nmap <leader>n<leader>n <Plug>VimwikiMakeDiaryNote
nmap <leader>n<leader>t <Plug>VimwikiTabMakeDiaryNote
nmap <leader>n<leader>y <Plug>VimwikiMakeYesterdayDiaryNote
nmap <leader>n<leader>m <Plug>VimwikiMakeTomorrowDiaryNote
nmap <leader>n<leader>i <Plug>VimwikiDiaryGenerateLinks
" }}}
" vim: foldmethod=marker foldenable:
