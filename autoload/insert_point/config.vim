let s:save_cpo = &cpo
set cpo&vim

let g:insert_point_config = get(g:, 'insert_point_config',
      \ { 'default': insert_point#config#default#get() })

let g:insert_point_same_filetype_map = {
      \ 'smarty': 'html' }

function! insert_point#config#get(filetype)
  echomsg a:filetype
  let config = get(g:insert_point_config, 'default', insert_point#config#default#get())
  try
    let config = get(g:insert_point_config,a:filetype,
          \ function('insert_point#config#' . a:filetype . '#get')())
  catch
    if exists('g:insert_point_same_filetype_map[a:filetype]')
      return insert_point#config#get(g:insert_point_same_filetype_map[a:filetype])
    endif
  endtry
  return config
endfunction

function! insert_point#config#is_select(item)
  let select = exists('a:item.select') ? a:item.select : ''
  return strlen(select) > 0
endfunction

function! insert_point#config#is_next(item)
  let direction = exists('a:item.direction') ? a:item.direction : 0
  return direction == 0 || direction == 1
endfunction

function! insert_point#config#is_prev(item)
  let direction = exists('a:item.direction') ? a:item.direction : 0
  return direction == 0 || direction == -1
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

