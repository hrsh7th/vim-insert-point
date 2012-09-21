let s:save_cpo = &cpo
set cpo&vim

function! insert_point#config#default#get()
  let config = []
  call add(config, {
        \ 'target': '$',
        \ 'offset': 0,
        \ 'direction': 0 })
  call add(config, {
        \ 'target': ')',
        \ 'offset': 0,
        \ 'direction': 0 })
  call add(config, {
        \ 'target': ']',
        \ 'offset': 0,
        \ 'direction': 0 })
  call add(config, {
        \ 'target': '}',
        \ 'offset': 0,
        \ 'direction': 0 })
  call add(config, {
        \ 'target': "'". '\(\\'. "'". '\|[^'. "'". ']\)\{-}'. "'",
        \ 'select': '\(\\'. "'". '\|[^'. "'". ']\)*',
        \ 'offset': 1,
        \ 'direction': 0 })
  call add(config, {
        \ 'target': '"\(\\"\|[^"]\)\{-}"',
        \ 'select': '\(\\"\|[^"]\)*',
        \ 'offset': 1,
        \ 'direction': 0 })
  call add(config, {
        \ 'target': ')',
        \ 'offset': 1,
        \ 'direction': 0 })
  call add(config, {
        \ 'target': ']',
        \ 'offset': 1,
        \ 'direction': 0 })
  call add(config, {
        \ 'target': '}',
        \ 'offset': 1,
        \ 'direction': 0 })
  return config
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

