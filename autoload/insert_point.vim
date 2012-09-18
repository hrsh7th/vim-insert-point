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

    if !exists('pos') || insert_point#compare_pos(cur, pos)
      let pos = cur
    endif
  endfor

  return exists('pos') ? pos : insert_point#get_current_pos()
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

    if !exists('pos') || !insert_point#compare_pos(cur, pos)
      let pos = cur
    endif
  endfor

  return exists('pos') ? pos : insert_point#get_current_pos()
endfunction

function! insert_point#search_next(pattern, ...)
  let pos = searchpos(a:pattern, 'nW', line('w$'))
  let cur = insert_point#get_current_pos()
  if insert_point#compare_pos(cur, pos)
    return [pos[0], pos[1] + (a:0 == 1 ? a:1 : 0)]
  endif
  return []
endfunction

function! insert_point#search_prev(pattern, ...)
  let pos = searchpos(a:pattern, 'nbW', line('w0'))
  let cur = insert_point#get_current_pos()
  if !insert_point#compare_pos(cur, pos)
    return [pos[0], pos[1] + (a:0 == 1 ? a:1 : 0)]
  endif
  return []
endfunction

function! insert_point#compare_pos(pos1, pos2)
  return a:pos1[0] < a:pos2[0] || (a:pos1[0] == a:pos2[0] && a:pos1[1] < a:pos2[1])
endfunction

function! insert_point#get_current_pos()
  let cur = getpos('.')[1:2]
  return [cur[0], cur[1]]
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

