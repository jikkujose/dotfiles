vim.cmd[[
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

call plug#begin('~/.fresh/plugged')
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
call plug#end()

]]
