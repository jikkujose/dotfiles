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
set dictionary+=/usr/share/dict/words
set hlsearch
set ignorecase
set nobackup nowritebackup
set rtp+=~/.fzf
nmap gn :%s///gn<cr>
nmap gt :Telescope<cr>
nmap gr :%s///g<cr>

function! g:CopyToClipboard()
  let old_z = @z
  normal! gv"zy
  call system('pbcopy', @z)
  let @z = old_z
endfunction

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
map <silent> <Leader>a :PrettierAsync<CR>
" vnoremap <leader>y :<c-u>call g:CopyToClipboard()<cr>
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
  Plug 'JikkuJose/lightline.vim'
  Plug 'kien/ctrlp.vim'
  Plug 'tomtom/tcomment_vim'
  Plug 'tommcdo/vim-exchange'
  Plug 'godlygeek/tabular'
  Plug 'tpope/vim-surround'
  Plug 'dockyard/vim-easydir'
  Plug 'ntpeters/vim-better-whitespace'
  " Plug 'prettier/vim-prettier', {
  "       \ 'do': 'yarn install',
  "       \ 'for': [
  "       \ 'javascript',
  "       \ 'tsx',
  "       \ 'ruby',
  "       \ 'typescript.tsx',
  "       \ 'typescript',
  "       \ 'css',
  "       \ 'json',
  "       \ 'html' ] }
  Plug 'neoclide/coc.nvim', {'branch': 'release', 'do': { -> coc#util#install()}}
  Plug 'HerringtonDarkholme/yats.vim'
  Plug 'tpope/vim-endwise'
  Plug 'ruby-formatter/rufo-vim'
  Plug 'jremmen/vim-ripgrep'
  Plug 'TovarishFin/vim-solidity'
  Plug 'jonsmithers/vim-html-template-literals'
  Plug 'pangloss/vim-javascript'
  " Plug 'Quramy/vim-js-pretty-template'
  Plug 'tpope/vim-markdown'
  Plug 'mustache/vim-mustache-handlebars'
  Plug 'dart-lang/dart-vim-plugin'
  " Plug 'chriskempson/base16-vim'
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.x' }
  Plug 'morhetz/gruvbox'
  Plug 'psf/black', { 'branch': 'stable' }
  " Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  Plug 'tikhomirov/vim-glsl'
call plug#end()

colorscheme Tomorrow-Night-Bright

" autocmd BufWritePre *.js,*.json,*.css,*.ts,*.tsx,*.rb,*.html PrettierAsync
au BufRead,BufNewFile *.md setlocal textwidth=80

" Configs
"
let g:rufo_auto_formatting = 1

let g:coc_global_extensions = ['coc-tsserver']
let g:python_host_prog = '/usr/bin/python2'
let g:python2_host_prog = '/usr/bin/python'
let g:python3_host_prog = '/usr/bin/python3'
" let g:htl_all_templates

" let g:prettier#config#print_width = 80
" let g:prettier#config#tab_width = 2
" let g:prettier#config#use_tabs = 'false'
" let g:prettier#config#semi = 'false'
" let g:prettier#config#single_quote = 'false'
" let g:prettier#config#bracket_spacing = 'true'
" let g:prettier#config#jsx_bracket_same_line = 'false'
" let g:prettier#config#trailing_comma = 'es5'
" let g:prettier#config#config_precedence = 'prefer-file'

let g:ctrlp_user_command = [
    \ '.git', 'cd %s && git ls-files . -co --exclude-standard',
    \ 'find %s -type f'
    \ ]
let g:ctrlp_working_path_mode = '0'

inoremap <silent><expr> <TAB>
      \ pumvisible() ? coc#_select_confirm() :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

let g:coc_snippet_next = '<tab>'
let g:loaded_perl_provider = 0

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

autocmd FileType qf nnoremap <buffer> <CR> <CR>:cclose<CR>

func! GetSelectedText()
  normal gv"xy
  let result = getreg("x")
  return result
endfunc

if !has("gui_running") && executable("clip.exe")
  vnoremap <leader>y :call system('clip.exe', GetSelectedText())<CR>
  nnoremap YY ^"xyg$:call system('clip.exe', GetSelectedText())<CR>
endif
