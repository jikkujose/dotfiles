local home = os.getenv("HOME")
vim.g.mapleader = " "

-- Disable unused providers
vim.g.loaded_ruby_provider = 0

-- Disable all persistent state
vim.o.shada = ""
vim.o.swapfile = false
vim.o.undofile = false

vim.g.lightline = {colorscheme = 'powerline'}

vim.o.encoding = "utf-8"
vim.o.incsearch = true
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

vim.g.python3_host_prog = home .. "/.local/share/mise/shims/python3"

vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
  pattern = "*.gemspec",
  command = "set filetype=ruby",
})

vim.g.ctrlp_user_command = {
  '.git',
  'cd %s && git ls-files . -co --exclude-standard',
  'find %s -type f'
}
vim.g.ctrlp_working_path_mode = '0'

vim.g.markdown_fenced_languages = {'html', 'python', 'javascript', 'bash=sh', 'ruby', 'sql'}

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

local Plug = vim.fn['plug#']
vim.call('plug#begin', '~/.local/share/nvim/plugged')
  Plug 'dstein64/vim-startuptime'
  Plug 'itchyny/lightline.vim'
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
  Plug 'stevearc/dressing.nvim'
  Plug 'MunifTanjim/nui.nvim'
  Plug('nvim-treesitter/nvim-treesitter', {['do'] = ':TSUpdate'})
  Plug 'sbdchd/neoformat'
  Plug('neoclide/coc.nvim', {['branch'] = 'release'})
vim.call('plug#end')

require('plugins.xml_tag_wrapper')

vim.g.neoformat_javascript_prettier = {
  exe = "prettier",
  args = {"--config", vim.fn.expand("~/.prettierrc"), '--stdin-filepath', '"%:p"'},
  stdin = 1,
  try_node_exe = 1
}
vim.g.neoformat_enabled_javascript = {"prettier"}

vim.g.neoformat_javascriptreact_prettier = {
  exe = "prettier",
  args = {"--config", vim.fn.expand("~/.prettierrc"), '--stdin-filepath', '"%:p"'},
  stdin = 1,
  try_node_exe = 1
}
vim.g.neoformat_enabled_javascriptreact = {"prettier"}

vim.g.neoformat_enabled_eruby = { "erbformat", "htmlbeautifier" }
vim.g.neoformat_eruby_erbformat = { exe = "erb-format", args = { "--stdin" }, stdin = 1 }
vim.g.neoformat_eruby_htmlbeautifier = { exe = "htmlbeautifier", args = { "--keep-blank-lines", '1' }, stdin = 1 }

vim.cmd[[
command! W w
colorscheme Tomorrow-Night-Bright
autocmd BufWritePre,InsertLeave *.js,*.mjs,*.jsx,*.ts,*.tsx,*.css,*.json,*.rb,*.py,*.md,*.html,*.gemspec,*.erb silent! Neoformat
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
nnoremap <leader>x :%!tidy -xml -q --show-errors 0 --show-warnings 0 --indent-attributes 1<CR>
highlight CursorLineNr term=bold cterm=bold ctermfg=012 gui=bold
]]

local path = vim.fn.stdpath('config')
if vim.fn.has('mac') == 1 then
  vim.cmd('source ' .. path .. '/init/mac.vim')
else
  vim.cmd('source ' .. path .. '/init/linux.vim')
end
