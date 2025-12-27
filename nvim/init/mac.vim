function! g:CopyToClipboard()
  let old_z = @z
  normal! gv"zy
  call system('pbcopy', @z)
  let @z = old_z
endfunction

vnoremap <leader>y :<c-u>call g:CopyToClipboard()<cr>

let g:python3_host_prog = '/usr/local/bin/python3'
