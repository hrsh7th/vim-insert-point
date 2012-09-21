if exists('g:loaded_insert_point')
  finish
endif
let g:loaded_insert_point = 1

let s:save_cpo = &cpo
set cpo&vim

inoremap <silent> <Plug>(insert_point_next_point) <C-r>=<SID>next_point()<CR>
inoremap <silent> <Plug>(insert_point_prev_point) <C-r>=<SID>prev_point()<CR>
snoremap <silent> <Plug>(insert_point_next_point_select) <ESC><ESC>i<C-r>=<SID>next_point()<CR>
snoremap <silent> <Plug>(insert_point_prev_point_select) <ESC><ESC>i<C-r>=<SID>prev_point()<CR>

let s:select_length = 0

function! s:next_point()
  call s:reset_select(s:select_length)

  let keys = "\<ESC>"
  let item = insert_point#get_next_item()
  if !empty(item)
    call insert_point#move_next(item)

    if insert_point#get_current_pos()[1] == 0
      let keys .= 'i'
    else
      let keys .= 'a'
    endif

    if insert_point#config#is_select(item)
      let s:select_length = insert_point#get_select_length(item)
      if s:select_length > 0
        let keys .= "\<C-o>v" . repeat('l', s:select_length) . "\<C-g>"
      endif
    endif
  endif
  return keys
endfunction

function! s:prev_point()
  call s:reset_select(s:select_length)

  let keys = "\<ESC>"
  let item = insert_point#get_prev_item()
  if !empty(item)
    call insert_point#move_prev(item)

    if insert_point#get_current_pos()[1] == 0
      let keys .= 'i'
    else
      let keys .= 'a'
    endif

    if insert_point#config#is_select(item)
      let s:select_length = insert_point#get_select_length(item)
      if s:select_length > 0
        let keys .= "\<C-o>v" . repeat('l', s:select_length) . "\<C-g>"
      endif
    endif
  endif
  return keys
endfunction

function! s:reset_select(length)
  if a:length > 0
    call insert_point#move(insert_point#get_current_pos(-a:length))
  endif
  let s:select_length = 0
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

