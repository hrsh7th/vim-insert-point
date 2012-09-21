let s:save_cpo = &cpo
set cpo&vim

function! insert_point#get_next_item()
  let config = insert_point#config#get(insert_point#get_filetype())
  for value in config
    if !insert_point#config#is_next(value)
      continue
    endif

    let cur = insert_point#search_next(value.target, value.offset)
    if !exists('pos') || insert_point#compare_pos(cur, pos)
      let pos = cur
      let item = value
    endif
  endfor

  return exists('item') ? item : {}
endfunction

function! insert_point#get_prev_item()
  let config = insert_point#config#get(insert_point#get_filetype())
  for value in config
    if !insert_point#config#is_prev(value)
      continue
    endif

    let cur = insert_point#search_prev(value.target, value.offset)
    if !exists('pos') || !insert_point#compare_pos(cur, pos)
      let pos = cur
      let item = value
    endif
  endfor

  return exists('item') ? item : {}
endfunction

function! insert_point#search_next(pattern, ...)
  let pos = searchpos(a:pattern, 'ncW', line('w$'))

  let offset = a:0 == 1 ? a:1 : 0
  if offset < 0
    let offset = strlen(matchstr(getline('.'), a:pattern, pos[1] - 1, 1)) + offset - 1
  endif

  let pos = [pos[0], pos[1] + offset]
  if insert_point#compare_pos(insert_point#get_current_pos(), pos)
    return pos
  endif
  return insert_point#get_last_pos()
endfunction

function! insert_point#search_prev(pattern, ...)
  let offset = a:0 == 1 ? a:1 : 0

  let pos = searchpos(a:pattern, 'nbW' . (offset == 0 ? 'c' : ''))
  if offset < 0
    let offset = strlen(matchstr(getline('.'), a:pattern, pos[1] - 1, 1)) + offset - 1
  endif

  let pos = [pos[0], pos[1] + offset]
  if insert_point#compare_pos(pos, insert_point#get_current_pos())
    return pos
  endif
  return insert_point#get_first_pos()
endfunction

function! insert_point#move_next(item)
  call insert_point#move(insert_point#search_next(a:item.target, a:item.offset))
endfunction

function! insert_point#move_prev(item)
  call insert_point#move(insert_point#search_prev(a:item.target, a:item.offset))
endfunction

function! insert_point#get_current_pos(...)
  let offset = a:0 == 1 ? a:1 : 0

  let cur = getpos('.')[1:2]
  return [cur[0], cur[1] + offset]
endfunction

function! insert_point#get_first_pos()
  return [0, 0]
endfunction

function! insert_point#get_last_pos()
  let l = line('$')
  let c = strlen(getline(l)) + 1
  return [l, c]
endfunction

function! insert_point#compare_pos(pos1, pos2)
  return a:pos1[0] < a:pos2[0] || (a:pos1[0] == a:pos2[0] && a:pos1[1] < a:pos2[1])
endfunction

function! insert_point#move(pos)
  call cursor(insert_point#fix_pos(a:pos))
endfunction

function! insert_point#fix_pos(pos)
  let pos = a:pos
  let len = strlen(getline(pos[0]))
  if pos[1] < 1
    let pos[1] = 1
  elseif pos[1] > len + 1
    let pos[1] = len + 1
  endif
  return pos
endfunction

function! insert_point#get_filetype()
  return exists('g:loaded_neocomplcache') ? neocomplcache#get_context_filetype() : getbufvar('%', '&filetype')
endfunction

function! insert_point#get_select_length(item)
  let str = ''
  if insert_point#config#is_select(a:item)
    let cur = insert_point#get_current_pos()
    let str = matchstr(getline(cur[0]), a:item.select, cur[1] - 1)
  endif
  return strlen(str) - 1
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

