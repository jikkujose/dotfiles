local home = os.getenv("HOME")
vim.g.mapleader = " "

vim.g.lightline = {colorscheme = 'jiks'}

vim.o.encoding = "utf-8"
vim.o.incsearch = true
vim.o.compatible = false
vim.o.laststatus = 2
vim.o.tabstop = 2
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.relativenumber = true
vim.o.smartcase = true
vim.o.cursorline = true
vim.o.colorcolumn = "+1"
vim.o.dictionary = vim.o.dictionary .. ",/usr/share/dict/words"
vim.o.hlsearch = true
vim.o.ignorecase = true
vim.o.backup = false
vim.o.writebackup = false
vim.o.spell = true
vim.o.spelllang = "en_gb"

vim.api.nvim_set_keymap('n', 'gn', ':%s///gn<cr>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', 'gr', ':%s///g<cr>', {noremap = true, silent = true})

vim.api.nvim_set_keymap('n', '<leader><leader>', '<C-^>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', 'U', '<c-r>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('', '<leader>c', ':TComment<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>w', ':w<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', ',', ':set hlsearch! hlsearch?<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>p', ':set paste<CR>:put *<CR>:set nopaste<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>f', ':e %:h/', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>t', ':StripWhitespace<cr>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<C-b>', ':CtrlPBuffer<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', 'K', 'i<CR><Esc>', {noremap = true, silent = true})

vim.api.nvim_set_keymap('', '<leader><up>', '<c-w><up>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('', '<leader><down>', '<c-w><down>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('', '<leader><left>', '<c-w><left>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('', '<leader><right>', '<c-w><right>', {noremap = true, silent = true})

vim.g.python_host_prog = '/usr/bin/python2'
vim.g.python2_host_prog = '/usr/bin/python'
vim.g.python3_host_prog = home .. "/.asdf/shims/python3"


vim.g.ctrlp_user_command = {
  '.git',
  'cd %s && git ls-files . -co --exclude-standard',
  'find %s -type f'
}

vim.g.ctrlp_working_path_mode = '0'

vim.g.vimwiki_list = {{syntax = 'markdown', ext = '.md'}}

vim.g.vimwiki_key_mappings = {
  all_maps = 1,
  global = 1,
  headers = 1,
  text_objs = 1,
  table_format = 1,
  table_mappings = 0,
  lists = 1,
  links = 1,
  html = 1,
  mouse = 0
}

vim.g.loaded_perl_provider = 0

function _G.RenameFile()
  local old_name = vim.fn.expand('%')
  local new_name = vim.fn.input('New file name: ', vim.fn.expand('%'), 'file')
  if new_name ~= '' and new_name ~= old_name then
    vim.cmd(':saveas ' .. new_name)
    vim.cmd(':silent !rm ' .. old_name)
    vim.cmd('redraw!')
  end
end

vim.api.nvim_set_keymap('n', 'gmv', ':lua RenameFile()<cr>', {noremap = true, silent = true})

if vim.fn.executable('volta') == 1 then
  vim.g.node_host_prog = vim.fn.system("volta which neovim-node-host"):gsub("^%s*(.-)%s*$", "%1")
end

local Plug = vim.fn['plug#']
vim.call('plug#begin', '~/.fresh/plugged')
  Plug 'dstein64/vim-startuptime'
  Plug 'vimwiki/vimwiki'
  Plug 'JikkuJose/lightline.vim'
  Plug 'kien/ctrlp.vim'
  Plug 'tomtom/tcomment_vim'
  Plug 'tommcdo/vim-exchange'
  Plug 'godlygeek/tabular'
  Plug 'tpope/vim-surround'
  Plug 'dockyard/vim-easydir'
  Plug 'ntpeters/vim-better-whitespace'
  Plug 'HerringtonDarkholme/yats.vim'
  Plug 'tpope/vim-endwise'
  Plug 'pangloss/vim-javascript'
  Plug 'tpope/vim-markdown'
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-treesitter/nvim-treesitter'
  Plug 'sbdchd/neoformat'
  Plug('neoclide/coc.nvim', {['branch'] = 'release'})
vim.call('plug#end')

vim.cmd[[
command! W w

colorscheme Tomorrow-Night-Bright

autocmd BufWritePre,InsertLeave *.js,*.mjs,*.jsx,*.ts,*.tsx,*.css,*.json,*.rb,*.md,*.html silent! Neoformat

au BufRead,BufNewFile *.md setlocal textwidth=80

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

autocmd FileType qf nnoremap <buffer> <CR> <CR>:cclose<CR>

highlight CursorLineNr term=bold cterm=bold ctermfg=012 gui=bold
]]

local path = vim.fn.stdpath('config')

if vim.fn.has('mac') == 1 then
  vim.cmd('source ' .. path .. '/init/mac.vim')
else
  vim.cmd('source ' .. path .. '/init/linux.vim')
end
