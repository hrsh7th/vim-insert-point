let s:save_cpo = &cpo
set cpo&vim

function! insert_point#get_next_pos()
  let config = insert_point#config#get(getbufvar('%', '&filetype'))
  for item in config
    if !insert_point#config#is_next(item.direction)
      continue
    endif

    let cur = insert_point#search_next(item.target, item.offset)
    if empty(cur)
      continue
    endif

    if !exists('pos') || cur[0] < pos[0] || (cur[0] == pos[0] && cur[1] < pos[1])
      let pos = cur
    endif
  endfor

  return exists('pos') ? pos : getpos('.')[1:2]
endfunction

function! insert_point#get_prev_pos()
  let config = insert_point#config#get(getbufvar('%', '&filetype'))
  for item in config
    if !insert_point#config#is_prev(item.direction)
      continue
    endif

    let cur = insert_point#search_prev(item.target, item.offset)
    if empty(cur)
      continue
    endif

    if !exists('pos') || cur[0] > pos[0] || (cur[0] == pos[0] && cur[1] > pos[1])
      let pos = cur
    endif
  endfor

  return exists('pos') ? pos : getpos('.')[1:2]
endfunction

function! insert_point#get_next_char(...)
  let offset = (a:0 > 0 ? a:1 : 0) - 1
  return getline('.')[col('.') + offset]
endfunction

function! insert_point#get_prev_char(...)
  let offset = (a:0 > 0 ? -a:1 : 0) - 2
  return getline('.')[col('.') + offset]
endfunction

function! insert_point#search_next(pattern, ...)
  let pos = searchpos(a:pattern, 'nW')
  let cur = getpos('.')[1:2]
  if pos[0] > cur[0] || (pos[0] == cur[0] && pos[1] > cur[1])
    return [pos[0], pos[1] + (a:0 == 1 ? a:1 : 0)]
  endif
  return []
endfunction

function! insert_point#search_prev(pattern, ...)
  let pos = searchpos(a:pattern, 'nbW')
  let cur = getpos('.')[1:2]
  if pos[0] < cur[0] || (pos[0] == cur[0] && pos[1] < cur[1])
    return [pos[0], pos[1] + (a:0 == 1 ? a:1 : 0)]
  endif
  return []
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

