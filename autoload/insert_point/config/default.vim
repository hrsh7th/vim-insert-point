let s:save_cpo = &cpo
set cpo&vim

function! insert_point#config#default#get()
  let config = []
  " next and prev.
  call add(config, { 'target': "^.",  'offset': 0, 'direction': 0 })
  call add(config, { 'target': ".$",  'offset': 1, 'direction': 0 })
  call add(config, { 'target': '.)',  'offset': 1, 'direction': 0 })
  call add(config, { 'target': '()',  'offset': 1, 'direction': 0 })
  call add(config, { 'target': '{}',  'offset': 1, 'direction': 0 })

  " next only.
  call add(config, { 'target': "'",   'offset': 1, 'direction': 1 })
  call add(config, { 'target': '"',   'offset': 1, 'direction': 1 })
  call add(config, { 'target': ')',   'offset': 1, 'direction': 1 })
  call add(config, { 'target': '}',   'offset': 1, 'direction': 1 })
  return config
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

