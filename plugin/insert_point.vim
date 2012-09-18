if exists('g:loaded_insert_point')
  finish
endif
let g:loaded_insert_point = 1

let s:save_cpo = &cpo
set cpo&vim

inoremap <silent> <Plug>(insert_point_next_point) <ESC>:<C-u>call <SID>next_point()<CR>
inoremap <silent> <Plug>(insert_point_prev_point) <ESC>:<C-u>call <SID>prev_point()<CR>

function! s:next_point()
  let pos = insert_point#get_next_pos()
  let key = insert_point#detect_key(pos)
  call cursor(insert_point#fix_pos(pos))
  call feedkeys(key)
endfunction

function! s:prev_point()
  let pos = insert_point#get_prev_pos()
  let key = insert_point#detect_key(pos)
  call cursor(insert_point#fix_pos(pos))
  call feedkeys(key)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

