let mapleader="\<Space>"
let g:lightline = {'colorscheme': 'jiks'}
colorscheme Tomorrow-Night

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
set rtp+=~/.fzf
nmap gn :%s///gn<cr>
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
vnoremap <leader>y :<c-u>call g:CopyToClipboard()<cr>
noremap <leader>w :w<CR>
noremap , :set hlsearch! hlsearch?<CR>
noremap <leader>p :set paste<CR>:put  *<CR>:set nopaste<CR>
nmap <leader>f :e %:h/
nmap <silent> <leader>t :StripWhitespace<cr>
nmap <C-b> :CtrlPBuffer<CR>
:nnoremap K i<CR><Esc>
map `<up> <c-w><up>
map `<down> <c-w><down>
map `<left> <c-w><left>
map `<right> <c-w><right>

call plug#begin('~/.vim/plugged')
  Plug 'JikkuJose/lightline.vim'
  Plug 'kien/ctrlp.vim'
  Plug 'tomtom/tcomment_vim'
  Plug 'tommcdo/vim-exchange'
  Plug 'godlygeek/tabular'
  Plug 'tpope/vim-surround'
  Plug 'dockyard/vim-easydir'
  Plug 'ntpeters/vim-better-whitespace'
  Plug 'prettier/vim-prettier', {
        \ 'do': 'yarn install',
        \ 'for': [
        \ 'javascript',
        \ 'tsx',
        \ 'ruby',
        \ 'typescript.tsx',
        \ 'typescript',
        \ 'css',
        \ 'json',
        \ 'html' ] }
  Plug 'neoclide/coc.nvim', {'branch': 'release', 'do': { -> coc#util#install()}}
  Plug 'HerringtonDarkholme/yats.vim'
  Plug 'tpope/vim-endwise'
call plug#end()

autocmd BufWritePre *.js,*.json,*.css,*.ts,*.tsx PrettierAsync

" Configs

let g:coc_global_extensions = ['coc-tsserver']
let g:python_host_prog = '/usr/local/bin/python2'
let g:python2_host_prog = '/usr/local/bin/python'
let g:python3_host_prog = '/usr/local/bin/python3'

let g:prettier#config#print_width = 80
let g:prettier#config#tab_width = 2
let g:prettier#config#use_tabs = 'false'
let g:prettier#config#semi = 'false'
let g:prettier#config#single_quote = 'false'
let g:prettier#config#bracket_spacing = 'true'
let g:prettier#config#jsx_bracket_same_line = 'false'
let g:prettier#config#trailing_comma = 'es5'
let g:prettier#config#parser = 'babylon'
let g:prettier#config#config_precedence = 'prefer-file'

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
