let s:save_cpo = &cpo
set cpo&vim

let g:insert_point_config = get(
      \ g:,
      \ 'insert_point_config',
      \ { 'default': insert_point#config#default#get() })

function! insert_point#config#get(filetype)
  let config = get(g:insert_point_config, 'default', insert_point#config#default#get())
  try
    let config = get(
          \ g:insert_point_config,
          \ a:filetype,
          \ function('insert_point#config#' . a:filetype . '#get')())
  catch
  endtry
  return map(config, "{
        \ 'target': v:val.target,
        \ 'offset': v:val.offset,
        \ 'direction': exists('v:val.direction') ? v:val.direction : 0
        \ }")
endfunction

function! insert_point#config#is_next(direction)
  return a:direction == 0 || a:direction == 1
endfunction

function! insert_point#config#is_prev(direction)
  return a:direction == 0 || a:direction == -1
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

