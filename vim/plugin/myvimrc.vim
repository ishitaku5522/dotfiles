if exists('g:loaded_myvimrc')
  finish
endif
let g:loaded_myvimrc = 1

let s:save_cpo = &cpo
set cpo&vim

let &cpo = s:save_cpo
unlet s:save_cpo
