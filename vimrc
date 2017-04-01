let mapleader="\<Space>"

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

" REQUIRED!
filetype off

" Remove delays in exiting insert mode
augroup FastEscape
  autocmd!
  au InsertEnter * set timeoutlen=0
  au InsertLeave * set timeoutlen=1000
augroup END

autocmd InsertEnter * :set number
autocmd InsertLeave * :set relativenumber

function! RenameFile()
  let old_name = expand('%')
  let new_name = input('New file name: ', expand('%'), 'file')
  if new_name != '' && new_name != old_name
    exec ':saveas ' . new_name
    exec ':silent !rm ' . old_name
    redraw!
  endif
endfunction

function! BuildYCM(info)
  if a:info.status == 'installed' || a:info.force
    !./install.sh
  endif
endfunction

" Auto handling of paste modes :)
function! WrapForTmux(s)
  if !exists('$TMUX')
    return a:s
  endif

  let tmux_start = "\<Esc>Ptmux;"
  let tmux_end = "\<Esc>\\"

  return tmux_start . substitute(a:s, "\<Esc>", "\<Esc>\<Esc>", 'g') . tmux_end
endfunction

let &t_SI .= WrapForTmux("\<Esc>[?2004h")
let &t_EI .= WrapForTmux("\<Esc>[?2004l")

function! XTermPasteBegin()
  set pastetoggle=<Esc>[201~
  set paste
  return ""
endfunction

inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()

let g:hybrid_use_Xresources = 1

set hlsearch

autocmd BufNewFile,BufReadPost *.coffee setl shiftwidth=2 expandtab

" Spell check
autocmd FileType gitcommit setlocal spell
autocmd FileType markdown setlocal spell

nn <leader>s :setlocal spell! spell?<CR>
nmap <leader>n :NERDTreeToggle %<CR>
nmap <leader>g :GundoToggle <CR>

noremap <silent> <PageUp> <c-y>
noremap <silent> <PageDown> <c-e>

nmap <Leader>= mfgg=G`f

nmap <silent> <leader>u :SyntasticCheck rubocop<cr>

nmap gmv :call RenameFile()<cr>
nmap gl :colorscheme solarized<cr>
nmap gd :colorscheme Tomorrow-Night<cr>
nmap gr :%s///g<cr>
nmap gs :Gstatus<cr>
nmap gp :Gpush<cr>
nmap <silent> gq :s/'/"/g<cr>
nmap <silent> gqq :s/"/'/g<cr>
nmap <silent> gh :'<,'>Tab/\w:\z\s/r1l0l0<CR>
vmap <silent> gh :Tab/\w:\z\s/r1l0l0<CR>
vmap <leader>v :norm<space>
nmap gn :%s///gn<cr>

map `<up> <c-w><up>
map `<down> <c-w><down>
map `<left> <c-w><left>
map `<right> <c-w><right>

:nnoremap K i<CR><Esc>

" Switch between files easily
nnoremap <leader><leader> <C-^>

" Format JSON file
nmap =j :%!python -m json.tool<CR>

" Word complete
autocmd FileType markdown set complete+=kspell

let g:vim_markdown_folding_disabled=1
set ignorecase

set rtp+=~/.fzf

call plug#begin('~/.vim/plugged')
  Plug 'JikkuJose/lightline.vim'
  Plug 'tmux-plugins/vim-tmux'
  Plug 'SirVer/ultisnips'
  Plug 'chriskempson/base16-vim'
  Plug 'dockyard/vim-easydir'
  Plug 'elzr/vim-json'
  Plug 'ervandew/supertab'
  Plug 'gregsexton/MatchTag'
  Plug 'honza/vim-snippets'
  Plug 'kien/ctrlp.vim'
  Plug 'othree/eregex.vim'
  Plug 'rking/ag.vim'
  Plug 'scrooloose/nerdtree'
  Plug 'sjl/gundo.vim'
  Plug 't9md/vim-ruby-xmpfilter'
  Plug 'tomtom/tcomment_vim'
  Plug 'tpope/vim-endwise'
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-haml'
  Plug 'tpope/vim-markdown'
  Plug 'tpope/vim-surround'
  Plug 'vim-ruby/vim-ruby'
  Plug 'scrooloose/syntastic'
  Plug 'thinca/vim-visualstar'
  Plug 'godlygeek/tabular'
  Plug 'tmhedberg/matchit'
  Plug 'kana/vim-textobj-user'
  Plug 'nelstrom/vim-textobj-rubyblock'
  Plug 'tommcdo/vim-exchange'
  Plug 'ntpeters/vim-better-whitespace'
  Plug 'AndrewRadev/splitjoin.vim'
  Plug 'altercation/vim-colors-solarized'
  Plug 'ekalinin/Dockerfile.vim'
  Plug 'pangloss/vim-javascript'
  Plug 'mxw/vim-jsx'
  Plug 'editorconfig/editorconfig-vim'
  Plug 'JikkuJose/vim-visincr'
  Plug 'fleischie/vim-styled-components'
  Plug 'othree/yajs.vim'
  Plug 'maralla/completor.vim'
call plug#end()

autocmd FileType ruby nmap <buffer> <leader>e <Plug>(xmpfilter-mark)
autocmd FileType ruby xmap <buffer> <leader>e <Plug>(xmpfilter-mark)
autocmd FileType ruby imap <buffer> <leader>e <Plug>(xmpfilter-mark)

autocmd FileType ruby nmap <buffer> <leader>r <Plug>(xmpfilter-run)
autocmd FileType ruby xmap <buffer> <leader>r <Plug>(xmpfilter-run)
autocmd FileType ruby imap <buffer> <leader>r <Plug>(xmpfilter-run)

" lightline config
if !has('gui_running')
  set t_Co=256
endif

colorscheme Tomorrow-Night

set backspace=indent,eol,start

syntax on

nmap <silent> <leader>x :%s/\v\s#\s\=\>.*//<cr>

nmap <silent> <leader>t :StripWhitespace<cr>

map <silent> <Leader>c :TComment<CR>

nnoremap <Leader>v :source ~/.vimrc<CR>

" macros
let @d='0idv "A"'
nnoremap <Leader>d @d

let @g="0/httpsc2f/git@f/r:A.git"

" nopaste when leaving insert mode
au InsertLeave * set nopaste

let g:python_host_prog = '/usr/local/bin/python'
let g:python3_host_prog = '/usr/local/bin/python3'

nnoremap U <c-r>

function! g:CopyTheTextPlease()
  let old_z = @z
  normal! gv"zy
  call system('pbcopy', @z)
  let @z = old_z
endfunction
vnoremap <leader>y :<c-u>call g:CopyTheTextPlease()<cr>

noremap <leader>p :set paste<CR>:put  *<CR>:set nopaste<CR>

nnoremap <F3> :NERDTreeToggle<cr>

nnoremap <F2> :GundoToggle<CR>

au BufRead,BufNewFile *.md set syntax=markdown
au BufRead,BufNewFile *.sol set syntax=javascript
au BufRead,BufNewFile *.ru set syntax=ruby
au BufRead,BufNewFile Guardfile set syntax=ruby
au BufRead,BufNewFile *autotest set syntax=ruby
au BufRead,BufNewFile Vagrantfile set syntax=ruby

" Heresy
inoremap <c-a> <esc>I
inoremap <c-e> <esc>A
cnoremap <c-a> <home>
cnoremap <c-e> <end>

" persist (g)undo tree between sessions
set undofile
set undodir=~/.vim/undo/
set undolevels=1000
set undoreload=10000
set backupdir=~/.vim/backup/
set directory=~/.vim/backup/

set history=100

vmap <Tab> >gv
vmap <S-Tab> <gv

nmap gw :silent! !pandoc -c 'http://yegor256.github.io/tacit/tacit.min.css' -s % > /tmp/markdown_preview.html ; open /tmp/markdown_preview.html<cr>


set wildmode=longest:full,full

noremap , :set hlsearch! hlsearch?<CR>

map Q @@

noremap <leader>w :w<CR>

let g:lightline = {'colorscheme': 'jiks'}

let g:ycm_key_list_select_completion=[]
let g:ycm_key_list_previous_completion=[]

let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"
let g:UltiSnipsSnippetDirectories = ['~/.vim/UltiSnips', 'UltiSnips']

let g:syntastic_javascript_checkers = ['eslint']
let g:jsx_ext_required = 0

let g:ctrlp_user_command = [
    \ '.git', 'cd %s && git ls-files . -co --exclude-standard',
    \ 'find %s -type f'
    \ ]
nmap <C-l> :CtrlPLine<CR>
nmap <C-b> :CtrlPBuffer<CR>

set guifont=Monaco:h14

let g:EditorConfig_exclude_patterns = ['fugitive://.*']
let g:EditorConfig_exec_path = '/usr/local/bin/editorconfig'

let g:ctrlp_working_path_mode = '0'

let g:SuperTabDefaultCompletionType="context"

let g:ycm_server_keep_logfiles = 1
let g:ycm_server_log_level = 'debug'

let g:used_javascript_libs = 'react'
let g:completor_node_binary = '/usr/local/bin/node'

" Save current view settings on a per-window, per-buffer basis.
function! AutoSaveWinView()
    if !exists("w:SavedBufView")
        let w:SavedBufView = {}
    endif
    let w:SavedBufView[bufnr("%")] = winsaveview()
endfunction

" Restore current view settings.
function! AutoRestoreWinView()
    let buf = bufnr("%")
    if exists("w:SavedBufView") && has_key(w:SavedBufView, buf)
        let v = winsaveview()
        let atStartOfFile = v.lnum == 1 && v.col == 0
        if atStartOfFile && !&diff
            call winrestview(w:SavedBufView[buf])
        endif
        unlet w:SavedBufView[buf]
    endif
endfunction

" When switching buffers, preserve window view.
if v:version >= 700
    autocmd BufLeave * call AutoSaveWinView()
    autocmd BufEnter * call AutoRestoreWinView()
endif
