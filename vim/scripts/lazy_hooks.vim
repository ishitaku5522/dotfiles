
fun g:plugin_mgr._lazy_CamelCaseMotion()
  call camelcasemotion#CreateMotionMappings(',')
endf

fun g:plugin_mgr._lazy_lexima()
  " call lexima#add_rule({'char': '<', 'input_after': '>'})
  call lexima#add_rule({'char': '>', 'at': '\%#>', 'leave': 1})
  call lexima#add_rule({'char': '<BS>', 'at': '<\%#>', 'input': '<BS>', 'delete' : 1})

  for [begin, end] in [['(', ')'], ['{','}'], ['[',']']]
    call lexima#add_rule({'at': '\%#.*[-0-9a-zA-Z_,:]', 'char': begin, 'input': begin})
    call lexima#add_rule({'at': '\%#\n\s*'.end , 'char': end, 'input': '<CR>'.end, 'delete': end})
  endfor

  for mark in ['"', "'"]
    call lexima#add_rule({'at': '\%#.*[-0-9a-zA-Z_,:]', 'char': mark, 'input': mark})
  endfor

  call lexima#init()
  " <BS>,<CR>が文字列ではなく展開されてしまうためうまくいかないので<lt>を利用
  inoremap <silent><expr> <C-h> lexima#expand('<lt>BS>', 'i')
  imap <silent><expr> <CR> pumvisible() ? '<C-y>' : lexima#expand('<lt>CR>', 'i')
endf

fun g:plugin_mgr._lazy_submode()
  call submode#enter_with('winsize', 'n', '', '<C-w>>', '<C-w>>')
  call submode#enter_with('winsize', 'n', '', '<C-w><', '<C-w><')
  call submode#enter_with('winsize', 'n', '', '<C-w>+', '<C-w>+')
  call submode#enter_with('winsize', 'n', '', '<C-w>-', '<C-w>-')
  call submode#map('winsize', 'n', '', '>', '5<C-w>>')
  call submode#map('winsize', 'n', '', '<', '5<C-w><')
  call submode#map('winsize', 'n', '', '+', '5<C-w>+')
  call submode#map('winsize', 'n', '', '-', '5<C-w>-')
endf

fun g:plugin_mgr._lazy_watchdogs()
  " watchdogs settings
  let g:watchdogs_check_BufWritePost_enable = 1
  let g:watchdogs_check_BufWritePost_enables = {
        \ 'cpp' : 0,
        \ 'java': 0
        \}
  let g:watchdogs_check_CursorHold_enable = 0

  let s:watchdogs_config = {
        \   'watchdogs_checker/_' : {
        \     'runner' : 'vimproc',
        \     'runner/vimproc/updatetime' : 100,
        \     'outputter' : 'quickfix',
        \     'outputter/quickfix/open_cmd' : 'copen 8'
        \   },
        \   'watchdogs_checker/javac' : {
        \   },
        \   'cpp/watchdogs_checker' : {
        \     'type' : 'watchdogs_checker/g++',
        \     'hook/add_include_option/enable' : 1,
        \     'cmdopt' : '-std=c++11 -Wall'
        \   }
        \ }

  if has('job')
    call extend(s:watchdogs_config['watchdogs_checker/_'], {
          \ 'runner' : 'job',
          \ 'runner/job/interval' : 100,
          \ })
  endif
  call extend(g:quickrun_config, s:watchdogs_config)

  let s:watchdogs_config_javac={
        \ 'exec' : '%c %o -d %S:p:h %S:p'
        \ }
  call extend(g:quickrun_config['watchdogs_checker/javac'], s:watchdogs_config_javac)

  unlet s:watchdogs_config
  try
    call watchdogs#setup(g:quickrun_config)
  catch
    echom v:exception
  endtry
endf

let g:plugin_mgr.func_dict = {
      \ 'vim-submode': function(g:plugin_mgr._lazy_submode),
      \ 'vim-watchdogs': function(g:plugin_mgr._lazy_watchdogs),
      \ 'lexima.vim': function(g:plugin_mgr._lazy_lexima),
      \ 'CamelCaseMotion': function(g:plugin_mgr._lazy_CamelCaseMotion),
      \}

fun g:plugin_mgr.posthook(name)
  call self.func_dict[a:name]()
endf
