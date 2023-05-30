let mapleader="\<Space>"
let g:lightline = {'colorscheme': 'jiks'}

set encoding=utf-8
set incsearch
set nocompatible
set laststatus=2
set tabstop=2
set expandtab
set shiftwidth=2
set relativenumber
set smartcase
set cursorline
set colorcolumn=+1
set dictionary+=/usr/share/dict/words
set hlsearch
set ignorecase
set nobackup nowritebackup

nmap gn :%s///gn<cr>
nmap gr :%s///g<cr>

function! RenameFile()
  let old_name = expand('%')
  let new_name = input('New file name: ', expand('%'), 'file')
  if new_name != '' && new_name != old_name
    exec ':saveas ' . new_name
    exec ':silent !rm ' . old_name
    redraw!
  endif
endfunction

nmap gmv :call RenameFile()<cr>
nnoremap <leader><leader> <C-^>
nnoremap U <c-r>
map <silent> <Leader>c :TComment<CR>
noremap <leader>w :w<CR>
noremap , :set hlsearch! hlsearch?<CR>
noremap <leader>p :set paste<CR>:put  *<CR>:set nopaste<CR>
nmap <leader>f :e %:h/
nmap <silent> <leader>t :StripWhitespace<cr>
nmap <C-b> :CtrlPBuffer<CR>
:nnoremap K i<CR><Esc>

map <leader><up> <c-w><up>
map <leader><down> <c-w><down>
map <leader><left> <c-w><left>
map <leader><right> <c-w><right>

call plug#begin('~/.vim/plugged')
  Plug 'vimwiki/vimwiki'
  Plug 'glench/vim-jinja2-syntax'
  Plug 'JikkuJose/lightline.vim'
  Plug 'kien/ctrlp.vim'
  Plug 'tomtom/tcomment_vim'
  Plug 'tommcdo/vim-exchange'
  Plug 'godlygeek/tabular'
  Plug 'tpope/vim-surround'
  Plug 'dockyard/vim-easydir'
  Plug 'ntpeters/vim-better-whitespace'
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'HerringtonDarkholme/yats.vim'
  Plug 'tpope/vim-endwise'
  Plug 'ruby-formatter/rufo-vim'
  Plug 'pangloss/vim-javascript'
  Plug 'tpope/vim-markdown'
  Plug 'mustache/vim-mustache-handlebars'
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-treesitter/nvim-treesitter'
call plug#end()

colorscheme Tomorrow-Night-Bright

autocmd BufWritePre *.js,*.jsx,*.ts,*.tsx,*.css,*.scss,*.json,*.md,*.html,*.vue silent! CocCommand prettier.formatFile
au BufRead,BufNewFile *.md setlocal textwidth=80

" Configs
"
let g:rufo_auto_formatting = 1

let g:coc_global_extensions = ['coc-prettier']
let g:python_host_prog = '/usr/bin/python2'
let g:python2_host_prog = '/usr/bin/python'
let g:python3_host_prog = '~/miniconda3/bin/python3'

let g:ctrlp_user_command = [
    \ '.git', 'cd %s && git ls-files . -co --exclude-standard',
    \ 'find %s -type f'
    \ ]
let g:ctrlp_working_path_mode = '0'

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <TAB>
      \ pumvisible() ? coc#_select_confirm() :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

let g:coc_snippet_next = '<tab>'

let g:vimwiki_list = [{'syntax': 'markdown', 'ext': '.md'}]
let g:vimwiki_key_mappings = {
            \ 'all_maps': 1,
            \ 'global': 1,
            \ 'headers': 1,
            \ 'text_objs': 1,
            \ 'table_format': 1,
            \ 'table_mappings': 0,
            \ 'lists': 1,
            \ 'links': 1,
            \ 'html': 1,
            \ 'mouse': 0,
            \ }

if executable('volta')
  let g:node_host_prog = trim(system("volta which neovim-node-host"))
endif

let g:loaded_perl_provider = 0

function! CocToggle()
    if g:coc_enabled
        CocDisable
    else
        CocEnable
    endif
endfunction
command! CocToggle :call CocToggle()

autocmd FileType qf nnoremap <buffer> <CR> <CR>:cclose<CR>

function! SortLines() range
    execute a:firstline . "," . a:lastline . 's/^\(.*\)$/\=strdisplaywidth( submatch(0) ) . " " . submatch(0)/'
    execute a:firstline . "," . a:lastline . 'sort n'
    execute a:firstline . "," . a:lastline . 's/^\d\+\s//'
endfunction

highlight CursorLineNr term=bold cterm=bold ctermfg=012 gui=bold

let path = expand("$HOME") . "/.config/" . expand("$NVIM_APPNAME")

if has('mac')
  exec 'source' path . '/init-mac.vim'
else
  exec 'source' path . '/init-linux.vim'
endif