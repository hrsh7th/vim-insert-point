if exists('g:loaded_insert_point')
  finish
endif
let g:loaded_insert_point = 1

let s:save_cpo = &cpo
set cpo&vim

inoremap <silent> <Plug>(insert_point_next_point) <C-r>=<SID>next_point()<CR>
inoremap <silent> <Plug>(insert_point_prev_point) <C-r>=<SID>prev_point()<CR>

function! s:next_point()
  call cursor(insert_point#fix_pos(insert_point#get_next_pos()))
  return ".\<BS>"
endfunction
function! s:prev_point()
  call cursor(insert_point#fix_pos(insert_point#get_prev_pos()))
  return ".\<BS>"
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

