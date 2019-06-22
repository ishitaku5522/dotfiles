scriptencoding utf-8

if &compatible
  set nocompatible
endif

if mymisc#plug_tap('TweetVim')
  " 1ページに表示する最大数
  " let g:tweetvim_tweet_per_page = 100
  " F6と,uvでTweetVimのtimeline選択

  " fork original option
  let g:tweetvim_say_insert_account = 1
  let g:tweetvim_expand_t_co = 1
  let g:tweetvim_display_source = 1
  let g:tweetvim_display_username = 1
  let g:tweetvim_display_icon = 1
  let g:tweetvim_display_separator = 1
  let g:tweetvim_async_post = 1

  " let g:tweetvim_updatetime = 10
  " nnoremap <Leader>Tl :<C-u>Unite tweetvim<CR>
  nnoremap <Leader>Tm :<C-u>TweetVimMentions<CR>
  nnoremap <Leader>Tu :<C-u>TweetVimUserStream<CR>
  nnoremap <Leader>Ts :<C-u>TweetVimSay<CR>
  nnoremap <Leader>Tc :<C-u>TweetVimCommandSay<CR>
  " "tweetvim用
  " augroup mytweetvim
  "   autocmd FileType tweetvim nnoremap <buffer> j gj
  "   autocmd FileType tweetvim nnoremap <buffer> k gk
  " augroup END
endif

if mymisc#plug_tap('YouCompleteMe')
  let g:ycm_global_ycm_extra_conf = $MYDOTFILES . '/vim/scripts/.ycm_extra_conf.py'
  let g:ycm_min_num_of_chars_for_completion = 3
  let g:ycm_complete_in_comments = 1
  let g:ycm_collect_identifiers_from_comments_and_strings = 1
  let g:ycm_collect_identifiers_from_tags_files = 1
  let g:ycm_seed_identifiers_with_syntax = 1
  let g:ycm_add_preview_to_completeopt = 1
  let g:ycm_autoclose_preview_window_after_insertion = 1
  let g:ycm_python_binary_path = 'python'

  let g:ycm_error_symbol = 'E'
  let g:ycm_warning_symbol = 'W'

  let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
  let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
  " autocmd VIMRCCUSTOM FileType python nnoremap <buffer> K :<C-u>YcmCompleter GetDoc<CR>
  nnoremap <leader><c-]> :<C-u>YcmCompleter GoTo<CR>
  nnoremap <leader>} :<C-u>YcmCompleter GoToDefinition<CR>
  nnoremap <leader>{ :<C-u>YcmCompleter GoToDeclaration<CR>
  augroup vimrc_ycm
    autocmd!
    autocmd FileType c,cpp,h,hpp,python nnoremap <buffer> <c-]> :<C-u>YcmCompleter GoTo<CR>
  augroup END
endif

if mymisc#plug_tap('vim-dirvish')
  nnoremap <silent> <Leader>e :call <SID>mydirvish_start('.',0)<CR>
  nnoremap <silent> <Leader>E :call <SID>mydirvish_start('%:p:h',1)<CR>

  let g:mydirvish_hidden = 1
  let g:mydirvish_sort = 1

  fun! s:mydirvish_start(path, force_change_path)
    let path = expand(a:path)

    if exists('t:mydirvish_winid') && win_gotoid(t:mydirvish_winid)
      let w:mydirvish_before = [expand("%:p")]

      if a:force_change_path
        exe 'Dirvish ' . path
      endif

      return
    endif

    40vsplit
    set winfixwidth
    normal =

    let w:mydirvish_by_split = 1
    let w:mydirvish_before = [expand("%:p")]

    if a:force_change_path
      exe 'Dirvish ' . path
    elseif exists('g:mydirvish_last_dir')
      exe 'Dirvish ' . g:mydirvish_last_dir
    else
      exe 'Dirvish ' . path
    endif

    let t:mydirvish_winid = win_getid(winnr())
  endf

  fun! s:mydirvish_open()
    if len(w:mydirvish_before) > 1
      call remove(w:mydirvish_before,0,1)
    elseif len(w:mydirvish_before) == 1
      call remove(w:mydirvish_before,0)
    endif

    if exists("w:mydirvish_by_split")
      if match(getline("."),"[\\/]$") >= 0
        call dirvish#open('edit', 0)
      else
        let g:mydirvish_tmp = getline('.')
        wincmd p
        exe "drop " . g:mydirvish_tmp
        unlet g:mydirvish_tmp
      endif
    else
      call dirvish#open('edit', 0)
    endif
  endf

  fun s:mydirvish_init_buffer()
    if !exists('w:mydirvish_before')
      let w:mydirvish_before = []
    endif
    
    let g:mydirvish_last_dir = expand('%:p:h')

    augroup mydirvish
      autocmd!
      if exists('##TextChanged') && has('conceal')
        autocmd TextChanged,TextChangedI <buffer> exe 'setlocal conceallevel=2'
      endif
    augroup END

    " hとlによる移動
    nnoremap <buffer> l    :call <SID>mydirvish_open()<CR>
    xnoremap <buffer> l    :call <SID>mydirvish_open()<CR>
    nmap     <buffer> h    <Plug>(dirvish_up)
    xmap     <buffer> h    <Plug>(dirvish_up)
    nnoremap <buffer> <CR> :call <SID>mydirvish_open()<CR>
    xnoremap <buffer> <CR> :call <SID>mydirvish_open()<CR>
    nnoremap <buffer> i    :call <SID>mydirvish_open()<CR>
    xnoremap <buffer> i    :call <SID>mydirvish_open()<CR>
    nnoremap <buffer> o    :call <SID>mydirvish_open()<CR>
    xnoremap <buffer> o    :call <SID>mydirvish_open()<CR>
    nnoremap <buffer> ~    :call <SID>mydirvish_start($HOME)<CR>

    " 独自quitスクリプト
    nnoremap <buffer> q    :call <SID>mydirvish_quit()<cr>

    " .とsに隠しファイルとソートを割り当て
    nnoremap <buffer> .    :call <SID>mydirvish_toggle_hiddenfiles()<CR>
    nnoremap <buffer> s    :call <SID>mydirvish_toggle_sortfiles()<CR>

    " Shell operations
    nnoremap <buffer> dd   :Shdo rm -rf {}<CR>
    vnoremap <buffer> d    :Shdo rm -rf {}<CR>
    nnoremap <buffer> rr   :Shdo mv {}<CR>
    vnoremap <buffer> r    :Shdo mv {}<CR>
    nnoremap <buffer> cc   :Shdo cp {}<CR>
    vnoremap <buffer> c    :Shdo cp {}<CR>

    call <SID>mydirvish_apply_config()

    " 開いていたファイルやDirectory(w:mydirvish_before)にカーソルをあわせる
    call <SID>mydirvish_update_beforelist()
    call <SID>mydirvish_selectprevdir()
  endf

  fun! s:mydirvish_apply_config()
    normal R
    if g:mydirvish_sort
      call s:mydirvish_do_sort()
    endif
    if g:mydirvish_hidden
      call s:mydirvish_do_hide()
    endif
  endf

  fun! s:mydirvish_do_sort()
    sort /.*\([\\\/]\)\@=/
  endf

  fun! s:mydirvish_do_hide()
    keeppatterns g@\v[\/]\.[^\/]+[\/]?$@d _
  endf

  fun! s:mydirvish_toggle_hiddenfiles()
    let g:mydirvish_hidden = !g:mydirvish_hidden
    call s:mydirvish_apply_config()
  endf

  fun! s:mydirvish_toggle_sortfiles()
    let g:mydirvish_sort = !g:mydirvish_sort
    call s:mydirvish_apply_config()
  endf

  fun! s:mydirvish_update_beforelist()
    if len(w:mydirvish_before) == 0 || w:mydirvish_before[0] !=# expand("%:p")
      call insert(w:mydirvish_before,expand("%:p"))
    endif
  endf

  fun! s:mydirvish_selectprevdir()
    if len(w:mydirvish_before) > 1
      call search('\V\^'.escape(w:mydirvish_before[1], '\').'\$', 'cw')
    endif
  endf

  fun! s:mydirvish_clean_on_quit()
    if exists('w:mydirvish_by_split') && exists('t:mydirvish_winid')
      unlet t:mydirvish_winid
    endif

    if exists('w:mydirvish_before')
      unlet w:mydirvish_before
    endif
  endf

  fun! s:mydirvish_quit()
    nmap <buffer> q <plug>(dirvish_quit)
    normal q
    call s:mydirvish_clean_on_quit()
    if exists("w:mydirvish_by_split") && w:mydirvish_by_split && winnr("$") > 1
      unlet w:mydirvish_by_split
      q
      normal =
    endif
  endf

  augroup vimrc_dirvish
    autocmd!
    autocmd FileType dirvish call s:mydirvish_init_buffer()
  augroup END
endif

if mymisc#plug_tap('vim-easymotion')
  let g:EasyMotion_do_mapping = 0
  nmap s <Plug>(easymotion-overwin-f2)
endif

if mymisc#plug_tap('foldCC.vim')
  let g:foldCCtext_enable_autofdc_adjuster = 1
  let g:foldCCtext_head = ''
  let g:foldCCtext_tail = 'printf(" %4d lines Lv%-2d", v:foldend-v:foldstart+1, v:foldlevel)'
  set foldtext=FoldCCtext()
  set fillchars=vert:\|
endif

if mymisc#plug_tap('html5.vim')
  let g:html5_event_handler_attributes_complete = 1
  let g:html5_rdfa_attributes_complete = 1
  let g:html5_microdata_attributes_complete = 1
  let g:html5_aria_attributes_complete = 1
endif

if mymisc#plug_tap('markdown-preview.vim')
  let g:mkdp_auto_close = 1
  let g:mkdp_auto_open = 0
  let g:mkdp_auto_start = 0
  if has('win32')
    let s:google_chrome_path='C:\Program Files\Mozilla Firefox\firefox.exe'
    if executable(s:google_chrome_path)
      let g:mkdp_path_to_chrome=shellescape(s:google_chrome_path)
    endif
    unlet s:google_chrome_path
  else
    let g:mkdp_path_to_chrome = 'xdg-open'
  endif
endif

if mymisc#plug_tap('memolist.vim')
  " let g:memolist_memo_suffix = 'txt'
  " let g:memolist_unite = 1
  " let g:memolist_denite = 1
  " let g:memolist_vimfiler = 1
  " let g:memolist_vimfiler_option = '-force-quit'
  " let g:memolist_ex_cmd = 'Denite file_rec '
  " if mymisc#plug_tap('nerdtree')
  " let g:memolist_ex_cmd = 'e'
  " endif

  nmap <Leader>mn :MemoNew<cr>
  " if mymisc#plug_tap('denite.nvim')
  "   nnoremap <Leader>ml :execute ":Denite" "-path='".g:memolist_path."'" "file_rec"<cr>
  if mymisc#plug_tap('defx.nvim')
    nnoremap <Leader>ml :execute "Defx " . expand(g:memolist_path)<cr>
  else
    nnoremap <Leader>ml :MemoList<cr>
  endif
endif

if mymisc#plug_tap('nerdtree')
  nnoremap <Leader>e :NERDTreeFocus<CR>
  nnoremap <Leader>E :NERDTreeFind<CR>
  nnoremap <Leader><c-e> :NERDTreeCWD<CR>
  nnoremap <Leader>n :NERDTree<space>

  " let g:NERDTreeMapOpenSplit = 's'
  " let g:NERDTreeMapPreviewSplit = 'gs'
  " let g:NERDTreeMapOpenVSplit = 'v'
  " let g:NERDTreeMapPreviewVSplit = 'gv'

  let g:NERDTreeHijackNetrw = 1
  let g:NERDTreeQuitOnOpen = 0
  let g:NERDTreeShowHidden = 0
  let g:NERDTreeWinSize = 35

  let g:NERDTreeMinimalUI = 0
  let g:NERDTreeShowBookmarks = 1
  let g:NERDTreeHighlightCursorline = 0
  let g:NERDTreeIgnore = ['\.meta',
        \ '\.sw[po]',
        \ '\.pyc',
        \ '\.aux',
        \ '\.dvi',
        \ '\.fls',
        \ '\.synctex.gz',
        \ '\.synctex(busy)',
        \ '\.bbl',
        \ '\.blg',
        \ '\.toc',
        \ '\.fdb_latexmk'
        \ ]

  let g:NERDTreeDirArrowExpandable = '+'
  let g:NERDTreeDirArrowCollapsible = '-'
  if executable("trash-put")
    let g:NERDTreeRemoveFileCmd = 'trash-put '
    let g:NERDTreeRemoveDirCmd = 'trash-put '
  endif
endif

if mymisc#plug_tap('open-browser.vim')
  let g:netrw_nogx = 1 " disable netrw's gx mapping.
  nmap gx <Plug>(openbrowser-smart-search)
  vmap gx <Plug>(openbrowser-smart-search)
  nnoremap <Leader>Bh :<C-u>OpenBrowser https://
  nnoremap <Leader>Bs :<C-u>OpenBrowserSearch<Space>
  command! -nargs=1 Weblio OpenBrowser http://ejje.weblio.jp/content/<args>
endif

if mymisc#plug_tap('previm')
  let g:previm_enable_realtime = 1
  " let g:previm_custom_css_path = 
  let g:previm_disable_default_css = 1
  let g:previm_custom_css_path = $MYDOTFILES . "/third-party/github-markdown.css"
  let g:previm_show_header = 0
  function! s:setup_setting()
    command! -buffer -nargs=? -complete=dir PrevimSaveHTML call mymisc#previm_save_html('<args>')
  endfunction

  augroup vimrc_previm
    autocmd!
    autocmd FileType *{mkd,markdown,rst,textile}* call <SID>setup_setting()
  augroup END
endif

if mymisc#plug_tap('restart.vim')
  let g:restart_sessionoptions = &sessionoptions
endif

if mymisc#plug_tap('tagbar')
  nnoremap <silent> <Leader>t :TagbarOpen j<CR>
  let g:tagbar_show_linenumbers = 0
  let g:tagbar_sort = 0
  let g:tagbar_indent = 1
  let g:tagbar_autoshowtag = 1
  let g:tagbar_autopreview = 0
  let g:tagbar_autofocus = 1
  let g:tagbar_autoclose = 0
  " let g:tagbar_width = 30
  augroup vimrc_tagbar
    autocmd!
    autocmd FileType help let b:tagbar_ignore = 1
  augroup END
endif

if mymisc#plug_tap('undotree')
  let g:undotree_WindowLayout = 2
  let g:undotree_SplitWidth = 30
  nnoremap <Leader>gu :<C-u>UndotreeToggle<cr>
endif

if mymisc#plug_tap('vim-searchindex')
  augroup vimrc_searchindex
    autocmd!
    autocmd VimEnter * vnoremap * "9y:<C-u>let @/ = '\<'.@9.'\>\C'<CR>/<CR>:<C-u>SearchIndex<CR>
    autocmd VimEnter * vnoremap g* "9y:<C-u>let @/ = @9.'\C'<CR>/<CR>:<C-u>SearchIndex<CR>
    autocmd VimEnter * vnoremap # "9y:<C-u>let @/ = '\<'.@9.'\>\C'<CR>?<CR>:<C-u>SearchIndex<CR>
    autocmd VimEnter * vnoremap g# "9y:<C-u>let @/ = @9.'\C'<CR>?<CR>:<C-u>SearchIndex<CR>
  augroup END
endif

if mymisc#plug_tap('vim-anzu')
  " mapping
  nmap n <Plug>(anzu-n-with-echo)
  nmap N <Plug>(anzu-N-with-echo)

  " vnoremap * "9y:<C-u>let @/ = '\<'.@9.'\>\C'<CR>/<CR>
  " vnoremap g* "9y:<C-u>let @/ = @9.'\C'<CR>/<CR>
  " vnoremap # "9y:<C-u>let @/ = '\<'.@9.'\>\C'<CR>?<CR>
  " vnoremap g# "9y:<C-u>let @/ = @9.'\C'<CR>?<CR>
  " nmap * <Plug>(anzu-star-with-echo)
  " nmap # <Plug>(anzu-sharp-with-echo)
endif

if mymisc#plug_tap('vim-easy-align')
  " ヴィジュアルモードで選択し，easy-align 呼んで整形．(e.g. vip<Enter>)
  vmap <Enter> <Plug>(LiveEasyAlign)
  " easy-align を呼んだ上で，移動したりテキストオブジェクトを指定して整形．(e.g. gaip)
  " nmap ga <Plug>(EasyAlign)
  " " Start interactive EasyAlign in visual mode (e.g. vipga)
  " xmap ga <Plug>(EasyAlign)
endif

if mymisc#plug_tap('vim-quickrun')
  " quickrun modules
  " quickrun-hook-add-include-option {{{
  let s:hook = {
        \ 'name': 'add_include_option',
        \ 'kind': 'hook',
        \ 'config': {
        \   'enable': 0,
        \   },
        \ }

  function! s:hook.on_module_loaded(session, context)
    let l:clang_complete = findfile(".clang_complete",".;")
    let a:session.config.cmdopt .= ' '.join(readfile(l:clang_complete))

    let paths = filter(split(&path, ','), "len(v:val) && v:val !=#'.' && v:val !~# 'mingw'")
    if len(paths)
      let a:session.config.cmdopt .= ' -I'.join(paths, ' -I')
    endif
  endfunction

  try
    call quickrun#module#register(s:hook, 1)
  catch
    echom v:exception
  endtry
  unlet s:hook
  " }}}

  let g:quickrun_no_default_key_mappings = 1
  let g:quickrun_config = get(g:, 'quickrun_config', {})
  let g:quickrun_config['_'] = {
        \   'hook/close_quickfix/enable_hook_loaded' : 1,
        \   'hook/close_quickfix/enable_success'     : 1,
        \   'hook/close_buffer/enable_hook_loaded'   : 1,
        \   'hook/close_buffer/enable_failure'       : 1,
        \   'hook/inu/enable'                        : 1,
        \   'hook/inu/wait'                          : 1,
        \   'outputter'                              : 'multi:buffer:quickfix',
        \   'outputter/buffer/split'                 : 'botright 20',
        \   'outputter/quickfix/open_cmd'            : 'copen 20',
        \ }

  if has('terminal')
    let g:quickrun_config['runner']                     = 'terminal'
    let g:quickrun_config['runner/terminal/opener']     = 'botright 20split'
    let g:quickrun_config['runner/terminal/into']       = 0
  elseif has('job')
    let g:quickrun_config['runner']                     = 'job'
    let g:quickrun_config['runner/job/interval']        = 100
  else
     let g:quickrun_config['runner']                    = 'vimproc'
     let g:quickrun_config['runner/vimproc/updatetime'] = 100
  endif

  let g:quickrun_config['python'] = {
        \ 'command' : 'python',
        \ 'cmdopt' : '-u',
        \ }
  let g:quickrun_config['markdown'] = {
        \ 'type': 'markdown/pandoc',
        \ 'cmdopt': '-s',
        \ 'outputter' : 'multi:buffer:quickfix:browser'
        \ }
  let g:quickrun_config['cpp'] = {
        \ 'hook/add_include_option/enable' : 1
        \ }

  if has('win32')
    let s:quickrun_win_config = get(g:, 'quickrun_win_config', {})
    let s:quickrun_win_config['cpp'] = {
          \ 'exec' : ['%c %o %s -o %s:p:r' . '.exe', '%s:p:r' . '.exe %a'],
          \ }
    call extend(g:quickrun_config['cpp'], s:quickrun_win_config['cpp'])
    unlet s:quickrun_win_config
  endif

  cabbrev Q QuickRun
  nmap <silent> <Leader>R :QuickRun<CR>
  nnoremap <expr><silent> <C-c> quickrun#is_running() ? <SID>mymisc_quickrun_sweep() : "\<C-c>"

  fun! s:mymisc_quickrun_sweep()
    echo 'Quickrun Sweep'
    call quickrun#sweep_sessions()
  endf
endif

if mymisc#plug_tap('vimshell.vim')
  let g:vimshell_prompt = '% '
  let g:vimshell_secondary_prompt = '> '
  let g:vimshell_user_prompt = 'getcwd()'
endif

if mymisc#plug_tap('vimtex')

  augroup vimrc_vimtex
    autocmd!
    autocmd BufReadPre *.tex let b:vimtex_main = 'main.tex'
  augroup END

  let g:vimtex_compiler_latexmk_engines = { '_' : '-pdfdvi' }
  let g:vimtex_compiler_latexmk = {
        \   'background' : 1,
        \   'build_dir' : '',
        \   'callback' : 1,
        \   'continuous' : 1,
        \   'executable' : 'latexmk',
        \   'options' : [
        \     '-pdfdvi',
        \     '-verbose',
        \     '-file-line-error',
        \     '-synctex=1',
        \     '-interaction=nonstopmode',
        \     '-f',
        \   ],
        \ }

  if has('win32')
    let g:vimtex_view_general_viewer = 'SumatraPDF'
    let g:vimtex_view_general_options
          \ = '-reuse-instance -forward-search @tex @line @pdf'
          \ . ' -inverse-search "gvim --servername ' . v:servername
          \ . ' --remote-send \"^<C-\^>^<C-n^>'
          \ . ':drop \%f^<CR^>:\%l^<CR^>:normal\! zzzv^<CR^>'
          \ . ':execute ''drop '' . fnameescape(''\%f'')^<CR^>'
          \ . ':\%l^<CR^>:normal\! zzzv^<CR^>'
          \ . ':call remote_foreground('''.v:servername.''')^<CR^>^<CR^>\""'
    let g:vimtex_view_general_options_latexmk = '-reuse-instance'
  elseif has('unix')""
    if executable('qpdfview')
      let g:vimtex_view_general_viewer = 'qpdfview'
      let g:vimtex_view_general_options
            \ = '--unique @pdf\#src:@tex:@line:@col'
      let g:vimtex_view_general_options_latexmk = '--unique'
      " qpdfview side: Edit>Settings>Behavior>Source editor
      "   gvim --remote-expr "vimtex#view#reverse_goto(%2, '%1')"
    else
      let g:vimtex_view_general_viewer = 'xdg-open'
    endif
  endif
endif

if mymisc#plug_tap('revimses')
  let g:revimses#sessionoptions = &sessionoptions
endif

if mymisc#plug_tap('vim-indent-guides')
  let g:indent_guides_enable_on_vim_startup = 1
  let g:indent_guides_auto_colors = 1
  let g:indent_guides_color_change_percent = 5
endif

if mymisc#plug_tap('calendar.vim')
  augroup vimrc_calendar
    autocmd!
  augroup END

  if mymisc#plug_tap('vim-indent-guides')
    autocmd vimrc_calendar FileType calendar IndentGuidesDisable
  endif

  if mymisc#plug_tap('indentLine')
    autocmd vimrc_calendar FileType calendar IndentLinesDisable
  endif

  let g:calendar_google_calendar = 1
  let g:calendar_google_task = 1
  let g:calendar_time_zone = '+0900'
  let g:calendar_first_day='sunday'
endif

if mymisc#plug_tap('autofmt')
  set formatexpr=autofmt#japanese#formatexpr()
endif

if mymisc#plug_tap('vimfiler.vim')
  let g:vimfiler_as_default_explorer = 1
  " call vimfiler#custom#profile('default', 'context', {
  "       \   'split' : 1,
  "       \   'horizontal' : 0,
  "       \   'direction' : 'topleft',
  "       \   'winwidth' : 35,
  "       \   'simple' : 1
  "       \ })
  " let g:vimfiler_force_overwrite_statusline = 0
  " let g:vimfiler_restore_alternate_file = 0
  nnoremap <silent> <Leader>e :VimFilerBufferDir  -force-quit -split -winwidth=35 -simple -find<CR>
  nnoremap <silent> <Leader>E :VimFilerCurrentDir -force-quit -split -winwidth=35 -simple <CR>
endif

if mymisc#plug_tap('defx.nvim')
  " nnoremap <silent> <Leader>e :call <SID>quit_existing_defx()<CR>:Defx `expand('%:p:h')` -split=vertical -winwidth=40 -direction=topleft -search=`expand('%:p')`<CR>
  " nnoremap <silent> <Leader>E :call <SID>quit_existing_defx()<CR>:Defx -split=vertical -winwidth=40 -direction=topleft .<CR>
  " nnoremap <silent> <Leader>E :Defx `expand('%:p:h')` -split=vertical -search=`expand('%:p')`<CR>
  " nnoremap <silent> <Leader>e :Defx -split=vertical<CR>

  nnoremap <silent> <Leader>E :call defx#util#call_defx('Defx', expand('%:p:h') . ' -split=vertical -search=' . expand('%:p'))<CR>
  nnoremap <silent> <Leader>e :call defx#util#call_defx('Defx', ' -split=vertical')<CR>

  function! s:expand(path) abort
    return s:substitute_path_separator(
          \ (a:path =~# '^\~') ? fnamemodify(a:path, ':p') :
          \ (a:path =~# '^\$\h\w*') ? substitute(a:path,
          \             '^\$\h\w*', '\=eval(submatch(0))', '') :
          \ a:path)
  endfunction

  function! s:substitute_path_separator(path) abort
    return has('win32') ? substitute(a:path, '\\', '/', 'g') : a:path
  endfunction

  let g:indentLine_fileTypeExclude = ['defx']

  let s:defx_custom_columns = 'mark:indent:icon:filename:type:size:time'

  if mymisc#plug_tap('defx-git')
    let s:defx_custom_columns = 'mark:indent:icon:git:filename:type:size:time'
  endif

  call defx#custom#option('_', { 
        \ 'columns': s:defx_custom_columns,
        \ 'winwidth': '35',
        \ 'direction': 'topleft',
        \ })

  augroup vimrc_defx
    autocmd!

    " Remove netrw and NERDTree directory handlers.
    autocmd VimEnter * if exists('#FileExplorer') | exe 'au! FileExplorer *' | endif
    autocmd VimEnter * if exists('#NERDTreeHijackNetrw') | exe 'au! NERDTreeHijackNetrw *' | endif
    autocmd BufEnter * if !exists('b:defx') && isdirectory(expand('%'))
          \ | call defx#util#call_defx('Defx', escape(s:expand(expand('%')), ' '))
          \ | endif

    call defx#custom#option('_', {'ignored_files': '*.meta,*.swp,*.swo,*.pyc,*.aux,*.dvi,*.fls,*.synctex.gz,*.synctex(busy),*.bbl,*.blg,*.toc,*.fdb_latexmk'})

    autocmd FileType defx call s:defx_my_settings()
    function! s:defx_my_settings() abort
      " Define mappings
      nnoremap <silent><buffer><expr> <CR>
            \ defx#do_action('drop')
      nnoremap <silent><buffer><expr> <2-LeftMouse>
            \ defx#do_action('drop')
      nnoremap <silent><buffer><expr> O
            \ defx#do_action('open_tree_recursive')
      nnoremap <silent><buffer><expr> o
            \ defx#is_directory() ?
            \   defx#do_action('open_tree') :
            \   defx#do_action('drop')
      nnoremap <silent><buffer><expr> u
            \ defx#do_action('cd', ['..'])
      nnoremap <silent><buffer><expr> l
            \ defx#do_action('drop')
      nnoremap <silent><buffer><expr> h
            \ defx#do_action('cd', ['..'])
      nnoremap <silent><buffer><expr> t
            \ defx#do_action('open', 'tabedit')
      nnoremap <silent><buffer><expr> ~
            \ defx#do_action('cd')
      nnoremap <silent><buffer><expr> yy
            \ defx#do_action('yank_path')
      nnoremap <buffer><expr> cd
            \ defx#do_action('yank_path').":cd \<C-r>\"\<CR>"
      nnoremap <silent><buffer><expr> .
            \ defx#do_action('toggle_ignored_files')
      nnoremap <silent><buffer><expr> x
            \ defx#do_action('close_tree')
      nnoremap <silent><buffer><expr> s
            \ defx#do_action('open', 'wincmd p \| vsplit')
      nnoremap <silent><buffer><expr> i
            \ defx#do_action('open', 'wincmd p \| split')
      nnoremap <silent><buffer><expr> P
            \ defx#do_action('open', 'topleft pedit')
      nnoremap <silent><buffer><expr> Y
            \ defx#do_action('copy')
      nnoremap <silent><buffer><expr> M
            \ defx#do_action('move')
      nnoremap <silent><buffer><expr> D
            \ defx#do_action('remove')
      nnoremap <silent><buffer><expr> R
            \ defx#do_action('rename')
      nnoremap <silent><buffer><expr> p
            \ defx#do_action('paste')
      nnoremap <silent><buffer><expr> a
            \ defx#do_action('new_file')
      nnoremap <silent><buffer><expr> A
            \ defx#do_action('new_directory')
      nnoremap <silent><buffer><expr> q
            \ defx#do_action('quit')
      nnoremap <silent><buffer><expr> *
            \ defx#do_action('toggle_select') . 'j'
      nnoremap <silent><buffer><expr> g*
            \ defx#do_action('toggle_select_all')
      nnoremap <silent><buffer><expr> <C-l>
            \ defx#do_action('redraw')
      nnoremap <silent><buffer><expr> <C-g>
            \ defx#do_action('print')
    endfunction
  augroup END
endif

if mymisc#plug_tap('ctrlp.vim')
  let g:ctrlp_max_files = 20000
  let g:ctrlp_match_window = 'bottom,order:btt,min:1,max:20,results:100'
  let g:ctrlp_show_hidden = 1
  let g:ctrlp_root_markers = ['.ctrlproot']
  let g:ctrlp_mruf_default_order = 1
  let s:ctrlp_my_match_func = {}

  if mymisc#plug_tap('cpsm') " ========== For cpsm
    " let s:cpsm_path = expand('$HOME') . '/.vim/dein/repos/github.com/nixprime/cpsm'
    let s:cpsm_path = expand('$HOME') . '/.vim/plugged/cpsm'

    if !filereadable(s:cpsm_path . '/bin/cpsm_py.pyd') && !filereadable(s:cpsm_path . '/bin/cpsm_py.so')
      autocmd VimEnter * echomsg "Cpsm has not been built yet."
    else
      let s:ctrlp_my_match_func = { 'match' : 'cpsm#CtrlPMatch' }
    endif
    let g:cpsm_query_inverting_delimiter = ' '

  elseif mymisc#plug_tap('ctrlp-py-matcher') " ========== For pymatcher
    let s:ctrlp_my_match_func = { 'match' : 'pymatcher#PyMatch' }
  endif

  let g:ctrlp_match_func = s:ctrlp_my_match_func

  augroup vimrc_ctrlp
    autocmd!
    autocmd VimEnter * com! -n=? -com=dir CtrlPMRUFiles let g:ctrlp_match_func = {} |
          \ cal ctrlp#init('mru', { 'dir': <q-args> }) |
          \ let g:ctrlp_match_func = s:ctrlp_my_match_func
  augroup END

  nnoremap <Leader><Leader> :CtrlPMixed<CR>
  nnoremap <Leader>T        :CtrlPTag<CR>
  nnoremap <Leader>al       :CtrlPLine<CR>
  nnoremap <Leader>b        :CtrlPBuffer<CR>
  nnoremap <Leader>c        :CtrlPCurWD<CR>
  nnoremap <Leader>f        :CtrlP<CR>
  " gr
  nnoremap <Leader>l        :CtrlPLine %<CR>
  nnoremap <Leader>o        :CtrlPBufTag<CR>
  nnoremap <Leader>r        :CtrlPRegister<CR>
  nnoremap <Leader>u        :CtrlPMRUFiles<CR>
  nnoremap <Leader>`        :CtrlPMark<CR>

  let s:ctrlp_command_options = '--hidden --nocolor --nogroup --follow -g ""'

  " if has('win32')
  if g:mymisc_files_is_available
    let g:ctrlp_user_command = 'files -a -i "(\.git|\.hg|\.svn|_darcs|\.bzr|node_modules)$" %s'
  elseif g:mymisc_pt_is_available
    let g:ctrlp_user_command = 'pt ' . s:ctrlp_command_options . ' %s'
  elseif g:mymisc_ag_is_available
    let g:ctrlp_user_command = 'ag ' . s:ctrlp_command_options . ' %s'
  else
    let g:ctrlp_user_command = ''
  endif
  " else
  "   " Brought from denite
  "   let g:ctrlp_user_command = 'find -L %s -path "*/.git/*" -prune -o  -type l -print -o -type f -print'
  " endif

  unlet s:ctrlp_command_options
endif

if mymisc#plug_tap('fzf.vim')
  if exists("g:ctrlp_user_command") && g:ctrlp_user_command !=# ''
    let $FZF_DEFAULT_COMMAND = substitute(g:ctrlp_user_command,'%s','.','g')
  endif
  nnoremap <Leader><Leader> :execute ":Files " . mymisc#find_project_dir(g:mymisc_projectdir_reference_files)<CR>
  nnoremap <Leader>T        :Tags<CR>
  nnoremap <Leader>al       :Lines<CR>
  nnoremap <Leader>b        :Buffers<CR>
  nnoremap <Leader>c        :Files<CR>
  nnoremap <Leader>f        :execute ":Files " . mymisc#find_project_dir(g:mymisc_projectdir_reference_files)<CR>
  " gr
  nnoremap <Leader>l        :BLines<CR>
  nnoremap <Leader>o        :BTags<CR>
  " r
  nnoremap <Leader>u        :History<CR>
  nnoremap <Leader>`        :Marks<CR>
endif

if mymisc#plug_tap('vim-peekaboo')
  " let g:peekaboo_window = 'vert abo 40new'
  let g:peekaboo_compact = 1
  let g:peekaboo_prefix = '<leader>'
  let g:peekaboo_ins_prefix = '<C-x>'
endif

if mymisc#plug_tap('denite.nvim')
  let g:neomru#file_mru_ignore_pattern = '^vaffle\|^quickrun\|'.
        \ '\~$\|\.\%(o\|exe\|dll\|bak\|zwc\|pyc\|sw[po]\)$'.
        \ '\|\%(^\|/\)\.\%(hg\|git\|bzr\|svn\)\%($\|/\)'.
        \ '\|^\%(\\\\\|/mnt/\|/media/\|/temp/\|/tmp/\|\%(/private\)\=/var/folders/\)'.
        \ '\|\%(^\%(fugitive\)://\)'.
        \ '\|\%(^\%(term\)://\)'

  call denite#custom#option('default', 'auto_resize',             '1')
  call denite#custom#option('default', 'reversed',                '1')
  call denite#custom#option('default', 'highlight_matched_char',  'Special')
  call denite#custom#option('default', 'highlight_matched_range', 'Normal')
  call denite#custom#option('default', 'updatetime',              '10')

  if !exists('g:ctrlp_match_func')
    let g:ctrlp_match_func = {}
  endif

  if g:ctrlp_match_func != {} && g:ctrlp_match_func['match'] ==# 'cpsm#CtrlPMatch'
    let s:denite_matchers = ['matcher_cpsm']
  else
    let s:denite_matchers = ['matcher_fuzzy']
  endif

  call denite#custom#source('file_mru', 'matchers', s:denite_matchers)
  call denite#custom#source('file_rec', 'matchers', s:denite_matchers)
  call denite#custom#source('line',     'matchers', s:denite_matchers)
  call denite#custom#source('file_mru', 'sorters',  [])
  call denite#custom#source('buffer',   'sorters',  [])

  " Change mappings.
  call denite#custom#map('insert', '<C-j>',  '<denite:move_to_next_line>',     'noremap')
  call denite#custom#map('insert', '<C-k>',  '<denite:move_to_previous_line>', 'noremap')
  call denite#custom#map('insert', '<Down>', '<denite:move_to_next_line>',     'noremap')
  call denite#custom#map('insert', '<Up>',   '<denite:move_to_previous_line>', 'noremap')
  call denite#custom#map('insert', '<C-t>',  '<denite:do_action:tabopen>',     'noremap')
  call denite#custom#map('insert', '<C-v>',  '<denite:do_action:vsplit>',      'noremap')
  call denite#custom#map('insert', '<C-s>',  '<denite:do_action:split>',       'noremap')
  call denite#custom#map('insert', '<C-CR>', '<denite:do_action:split>',       'noremap')
  call denite#custom#map('insert', '<C-x>',  '<denite:do_action:split>',       'noremap')
  call denite#custom#map('insert', '<C-g>',  '<denite:leave_mode>',            'noremap')

  if exists("g:ctrlp_user_command") && g:ctrlp_user_command !=# ''
    call denite#custom#var('file_rec', 'command', split(substitute(g:ctrlp_user_command,'%s',':directory','g'),' '))
  endif

  " rg command on grep source
  if g:mymisc_rg_is_available
    call denite#custom#var('grep', 'command',        ['rg'])
    call denite#custom#var('grep', 'default_opts',   ['--vimgrep'])
    call denite#custom#var('grep', 'recursive_opts', [])
    call denite#custom#var('grep', 'pattern_opt',    ['--regexp'])
    call denite#custom#var('grep', 'separator',      ['--'])
    call denite#custom#var('grep', 'final_opts',     [])
  endif

  " Mappings
  nnoremap <silent> <Leader><Leader> :call mymisc#command_at_destdir(expand('%:h'),['DeniteProjectDir file_rec file_mru buffer'])<CR>
  " nnoremap <silent> <Leader>T :<C-u>Denite tag<CR>
  " al
  " nnoremap <silent> <Leader>b :<C-u>Denite buffer<CR>
  nnoremap <silent> <Leader>c :<C-u>Denite file_rec<CR>
  nnoremap <silent> <Leader>f :call mymisc#command_at_destdir(expand('%:h'),['DeniteProjectDir file_rec'])<CR>
  nnoremap <silent> <Leader>gr :<C-u>Denite grep -no-quit<CR>
  " nnoremap <silent> <Leader>l :<C-u>Denite line<CR>
  " nnoremap <silent> <Leader>o :<C-u>Denite outline<CR>
  " nnoremap <silent> <Leader>r :<C-u>Denite register<CR>
  " nnoremap <silent> <Leader>u :<C-u>Denite file_mru<CR>
  " ` Marks
endif

if mymisc#plug_tap('delimitMate')
  let delimitMate_expand_cr = 1
  let delimitMate_expand_space = 1
  let delimitMate_expand_inside_quotes = 1
  let delimitMate_jump_expansion = 1
  let delimitMate_balance_matchpairs = 1
  " imap <silent><expr> <CR> pumvisible() ? "\<C-Y>" : "<Plug>delimitMateCR"
  " augroup vimrc_delimitmate
  "   au FileType html,xhtml,phtml let b:delimitMate_autoclose = 0
  " augroup END
endif

if mymisc#plug_tap('ultisnips')
  " To Manage mappgins by my self
  let g:UltiSnipsExpandTrigger       = '<Plug>(RemapUltiSnipsExpandTrigger)'
  let g:UltiSnipsListSnippets        = '<Plug>(RemapUltiSnipsListSnippets)'
  let g:UltiSnipsJumpForwardTrigger  = '<Plug>(RemapUltiSnipsJumpForwardTrigger)'
  let g:UltiSnipsJumpBackwardTrigger = '<Plug>(RemapUltiSnipsJumpBackwardTrigger)'

  smap <Tab> <Plug>(RemapUltiSnipsJumpForwardTrigger)
  smap <S-Tab> <Plug>(RemapUltiSnipsJumpBackwardTrigger)

  if has('unix')
    if has('python3')
      let g:UltiSnipsUsePythonVersion = 3
    elseif has('python')
      let g:UltiSnipsUsePythonVersion = 2
    endif
  endif

  imap <expr><S-TAB> pumvisible() ?
        \ "\<C-p>" : "\<C-r>=UltiSnips#JumpBackwards()<CR>"
endif

if mymisc#plug_tap('supertab')
  let g:SuperTabDefaultCompletionType = '<c-n>'
endif

if mymisc#plug_tap('deoplete.nvim')

  " For debugging
  " call deoplete#custom#option('profile', v:true)
  " call deoplete#enable_logging('DEBUG', $HOME.'/.vim/deoplete.log')
  " call deoplete#custom#source("_",'is_debug_enabled',1)

  if has('win32') && !exists('g:python3_host_prog')
    let g:python3_host_prog = 'python'
  endif

  let g:deoplete#enable_at_startup = 1

  inoremap <expr><C-Space> deoplete#mappings#manual_complete()

  call deoplete#custom#var('omni', 'input_patterns', {
        \ 'html':       ['\w+'],
        \ 'css':        ['\w+|\w[ \t]*:[ \t]*\w*'],
        \ 'sass':       ['\w+|\w[ \t]*:[ \t]*\w*'],
        \ 'scss':       ['\w+|\w[ \t]*:[ \t]*\w*'],
        \})

  call deoplete#custom#var('omni', 'functions', {
        \ 'html':       ['LanguageClient#complete'],
        \ 'css':        ['csscomplete#CompleteCSS'],
        \ 'sass':       ['csscomplete#CompleteCSS'],
        \ 'scss':       ['csscomplete#CompleteCSS'],
        \})

  call deoplete#custom#source('_','max_menu_width',0)
  call deoplete#custom#source('_','min_pattern_length', 1)

  call deoplete#custom#option({
        \ 'auto_complete_delay': 20,
        \ 'smart_case': v:false,
        \ 'ignore_sources': {
        \   'c':   ['clang_complete'],
        \   'h':   ['clang_complete'],
        \   'cpp': ['clang_complete'],
        \   'hpp': ['clang_complete'],
        \   }
        \ })
endif

if mymisc#plug_tap('ale')
  let g:ale_fixers = {
        \ 'javascript': ['prettier'],
        \ 'vue':        ['prettier'],
        \ }
  let g:ale_fix_on_save = 0
  let g:ale_linters = {
        \ 'cpp':    [''],
        \ 'python': [''],
        \ 'java':   [''],
        \ }
  let g:ale_sign_error = 'E'
  let g:ale_sign_warning = 'W'
  let g:ale_sign_info = 'I'
  let g:ale_sign_style_error = 'e'
  let g:ale_sign_style_warning = 'w'
endif

if mymisc#plug_tap('LanguageClient-neovim')
  " let g:LanguageClient_loggingLevel = 'DEBUG'
  " let g:LanguageClient_loggingFile = $HOME.'/.vim/languageClient.log'
  " let g:LanguageClient_serverStderr = $HOME.'/.vim/languageServer.log'

  let g:LanguageClient_serverCommands = {}
  if has('win32')
    let g:LanguageClient_serverCommands['javascript'] =
          \ [$APPDATA.'/npm/javascript-typescript-stdio.cmd']
    let g:LanguageClient_serverCommands['typescript'] =
          \ [$APPDATA.'/npm/javascript-typescript-stdio.cmd']
    let g:LanguageClient_serverCommands['vue'] =
          \ [$APPDATA.'/npm/vls.cmd']
  else
    let g:LanguageClient_serverCommands['javascript'] =
          \ ['javascript-typescript-stdio']
    let g:LanguageClient_serverCommands['typescript'] =
          \ ['javascript-typescript-stdio']
    let g:LanguageClient_serverCommands['vue'] =
          \ ['vls']
  endif

  let g:LanguageClient_serverCommands['cpp'] =
        \ [$HOME.'/.vim/clangd']
  let g:LanguageClient_serverCommands['hpp'] =
        \ [$HOME.'/.vim/clangd']
  let g:LanguageClient_serverCommands['c'] =
        \ [$HOME.'/.vim/clangd']
  let g:LanguageClient_serverCommands['h'] =
        \ [$HOME.'/.vim/clangd']
  let g:LanguageClient_serverCommands['rust'] =
        \ ['rls']
  let g:LanguageClient_serverCommands['python'] =
        \ ['python', '-m', 'pyls']
  let g:LanguageClient_diagnosticsEnable = 1

  let g:LanguageClient_diagnosticsDisplay =
        \ {
        \   1: {
        \     "name": "Error",
        \     "texthl": "ALEError",
        \     "signText": "E",
        \     "signTexthl": "ALEErrorSign",
        \   },
        \   2: {
        \     "name": "Warning",
        \     "texthl": "ALEWarning",
        \     "signText": "W",
        \     "signTexthl": "ALEWarningSign",
        \   },
        \   3: {
        \     "name": "Information",
        \     "texthl": "ALEInfo",
        \     "signText": "I",
        \     "signTexthl": "ALEInfoSign",
        \   },
        \   4: {
        \     "name": "Hint",
        \     "texthl": "ALEInfo",
        \     "signText": "H",
        \     "signTexthl": "ALEInfoSign",
        \   },
        \ }
  augroup vimrc_langclient
    autocmd!
    autocmd FileType vue setlocal iskeyword+=$ iskeyword+=-
    autocmd FileType c,cpp,h,hpp,python nnoremap <buffer> <C-]> :call LanguageClient#textDocument_definition()<CR>
    autocmd FileType c,cpp,h,hpp,python nnoremap <buffer> K :call <SID>toggle_preview_window()<CR>
  augroup END

  command! LC call LanguageClient_contextMenu()
  command! LCHover call LanguageClient#textDocument_hover()
  command! LCDefinition call LanguageClient#textDocument_definition()
  command! LCTypeDefinition call LanguageClient#textDocument_typeDefinition()
  command! LCImplementation call LanguageClient#textDocument_implementation()
  command! LCRename call LanguageClient#textDocument_rename()
  command! LCDocumentSymbol call LanguageClient#textDocument_documentSymbol()
  command! LCReferences call LanguageClient#textDocument_references()
  command! LCCodeAction call LanguageClient#textDocument_codeAction()
  command! LCCompletion call LanguageClient#textDocument_completion()
  command! LCFormatting call LanguageClient#textDocument_formatting()
  command! -range LCRangeFormatting call LanguageClient#textDocument_rangeFormatting()
  command! -bang LCDocumentHighlight if empty('<bang>')
        \ | call LanguageClient#textDocument_documentHighlight()
        \ | else
          \ | call LanguageClient#clearDocumentHighlight()
          \ | endif

endif

if mymisc#plug_tap('vim-lsp')
  " let g:lsp_log_verbose = 1
  " let g:lsp_log_file = $HOME."/.vim/asyncomplete.log"

  let g:lsp_signs_enabled           = 1
  let g:lsp_signs_error             = {'text': 'E'}
  let g:lsp_signs_warning           = {'text': 'W'}
  let g:lsp_signs_information       = {'text': 'I'}
  let g:lsp_signs_hint              = {'text': 'H'}

  let g:lsp_diagnostics_echo_cursor = 1
  let g:lsp_diagnostics_echo_delay  = 1
  let g:lsp_textprop_enabled = 0

  hi link LspErrorText ALEErrorSign
  hi link LspWarningText ALEWarningSign
  hi link LspInformationText ALEWarningSign
  hi link LspHintText ALEWarningSign

  augroup vimrc_vimlsp
    autocmd!
    if executable($HOME.'/.vim/clangd')
      au User lsp_setup call lsp#register_server({
            \ 'name': 'clangd',
            \ 'cmd': {server_info->[$HOME.'/.vim/clangd']},
            \ 'whitelist': ['cpp','c','hpp','h'],
            \ 'priority': 100
            \ })
    endif

    if executable('pyls')
      au User lsp_setup call lsp#register_server({
            \ 'name': 'pyls',
            \ 'cmd': {server_info->['python', '-m', 'pyls']},
            \ 'whitelist': ['python'],
            \ 'priority': 100
            \ })
    endif

    if executable('typescript-language-server') || executable($APPDATA.'/npm/typescript-language-server')
      au User lsp_setup call lsp#register_server({
            \ 'name': 'tsserver',
            \ 'cmd': {server_info->[&shell, &shellcmdflag, 'typescript-language-server --stdio']},
            \ 'whitelist': ['javascript','typescript'],
            \ 'priority': 100
            \ })
    endif

    if executable('vls') || executable($APPDATA.'/npm/vls.cmd')
      au User lsp_setup call lsp#register_server({
            \ 'name': 'vls',
            \ 'cmd': {server_info->[&shell, &shellcmdflag, 'vls']},
            \ 'whitelist': ['vue'],
            \ 'priority': 100
            \ })
    endif

    if filereadable(fnamemodify("~", ":p") . '/eclipse.jdt.ls/plugins/org.eclipse.equinox.launcher_1.5.400.v20190515-0925.jar')
      if has('mac')
        let s:eclipse_jdt_config = "config_mac"
      elseif has('unix')
        let s:eclipse_jdt_config = "config_linux"
      else
        let s:eclipse_jdt_config = "config_win"
      endif

      au User lsp_setup call lsp#register_server({
            \ 'name': 'eclipse.jdt.ls',
            \ 'cmd': {server_info->[
            \     'java',
            \     '-Declipse.application=org.eclipse.jdt.ls.core.id1',
            \     '-Dosgi.bundles.defaultStartLevel=4',
            \     '-Declipse.product=org.eclipse.jdt.ls.core.product',
            \     '-Dlog.level=ALL',
            \     '-noverify',
            \     '-Dfile.encoding=UTF-8',
            \     '-Xmx1G',
            \     '-jar',
            \     fnamemodify("~", ":p") . '/eclipse.jdt.ls/plugins/org.eclipse.equinox.launcher_1.5.400.v20190515-0925.jar',
            \     '-configuration',
            \     fnamemodify("~", ":p") . '/eclipse.jdt.ls/' . s:eclipse_jdt_config,
            \     '-data',
            \     fnamemodify("~", ":p") . '~/workspace/',
            \ ]},
            \ 'root_uri':{server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), '.project'))},
            \ 'whitelist': ['java'],
            \ })
    endif

    au FileType c,cpp,python,javascript,typescript,vue,java nnoremap <buffer> <leader><c-]> :<C-u>LspDefinition<CR>
    au FileType c,cpp,python,javascript,typescript,vue,java vnoremap <buffer> <leader>= :<C-u>'<,'>LspDocumentRangeFormat<CR>
    au FileType c,cpp,python,javascript,typescript,vue,java setl omnifunc=lsp#complete
  augroup END
endif

if mymisc#plug_tap('asyncomplete.vim')
  " let g:asyncomplete_log_file = $HOME."/.vim/asyncomplete.log"

  " if mymisc#plug_tap('asyncomplete-omni.vim')
  "   au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#omni#get_source_options({
  "         \ 'name': 'omni',
  "         \ 'whitelist': ['*'],
  "         \ 'blacklist': ['c', 'cpp', 'python', 'javascript', 'typescript', 'vue', 'java', 'sql'],
  "         \ 'priority': 100,
  "         \ 'completor': function('asyncomplete#sources#omni#completor')
  "         \  }))
  " endif

  if mymisc#plug_tap('asyncomplete-necovim.vim')
    au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#necovim#get_source_options({
          \ 'name': 'necovim',
          \ 'whitelist': ['vim'],
          \ 'priority': 100,
          \ 'completor': function('asyncomplete#sources#necovim#completor'),
          \ }))
  endif

  if mymisc#plug_tap('asyncomplete-file.vim')
    au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#file#get_source_options({
          \ 'name': 'file',
          \ 'whitelist': ['*'],
          \ 'priority': 50,
          \ 'completor': function('asyncomplete#sources#file#completor')
          \ }))
  endif

  if mymisc#plug_tap('asyncomplete-neosnippet.vim')
    au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#neosnippet#get_source_options({
          \ 'name': 'neosnippet',
          \ 'whitelist': ['*'],
          \ 'priority': 51,
          \ 'completor': function('asyncomplete#sources#neosnippet#completor'),
          \ }))
  endif

  if mymisc#plug_tap('asyncomplete-ultisnips.vim')
    if has('python3') || has('python')
      au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#ultisnips#get_source_options({
            \ 'name': 'ultisnips',
            \ 'whitelist': ['*'],
            \ 'priority': 50,
            \ 'completor': function('asyncomplete#sources#ultisnips#completor'),
            \ }))
    endif
  endif

  if mymisc#plug_tap('asyncomplete-buffer.vim')
    au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#buffer#get_source_options({
          \ 'name': 'buffer',
          \ 'whitelist': ['*'],
          \ 'priority': 0,
          \ 'completor': function('asyncomplete#sources#buffer#completor'),
          \ }))
  endif

  imap <C-x><Space> <Plug>(asyncomplete_force_refresh)

  " function! s:default_preprocessor(options, matches) abort
  "   let g:matches = a:matches
  "   let g:options = a:options

  "   let l:items = []
  "   for [l:source_name, l:matches] in items(a:matches)
  "     for l:item in l:matches['items']
  "       if stridx(l:item['word'], a:options['base']) == 0
  "         call add(l:items, l:item)
  "       endif
  "     endfor
  "   endfor

  "   let g:items = l:items

  "   call asyncomplete#preprocess_complete(a:options, l:items)
  " endfunction

  function! s:preprocess_fuzzy(ctx, matches) abort
    let l:visited = {}
    let l:items = []
    let l:expression = ""

    for char_nr in str2list(a:ctx['base'])
      let char = nr2char(char_nr) 
      let l:expression .= char . '\k*'
    endfor

    for [l:source_name, l:matches] in items(a:matches)
      for l:item in l:matches['items']
        if match(l:item['word'], l:expression) == 0
          call add(l:items, l:item)
        endif
      endfor
    endfor

    call asyncomplete#preprocess_complete(a:ctx, l:items)
  endfunction

  " let g:asyncomplete_preprocessor = [function('s:preprocess_fuzzy')]
  let g:asyncomplete_popup_delay = 200

  augroup vimrc_asyncomplete
    autocmd!
    autocmd InsertLeave * if pumvisible() == 0 | pclose | endif
  augroup END
endif

if mymisc#plug_tap('clang_complete')
  " let g:clang_library_path='/usr/lib/llvm-3.8/lib'
  let g:clang_complete_auto=0
endif

if mymisc#plug_tap('jedi-vim')
  let g:jedi#completions_enabled = 0
  let g:jedi#show_call_signatures = 2
  let g:jedi#auto_initialization = 0
  augroup vimrc_jedi
    autocmd!
    autocmd FileType python nnoremap <buffer> <F2> :call jedi#rename()<CR>
    autocmd FileType python nnoremap <buffer> K :call jedi#show_documentation()<CR>
    autocmd FileType python nnoremap <buffer> <C-]> :call jedi#goto()<CR>
    autocmd FileType python setlocal omnifunc=jedi#completions
  augroup END
endif

if mymisc#plug_tap('omnisharp-vim')
  let g:OmniSharp_selector_ui = 'ctrlp'
  let g:omnicomplete_fetch_full_documentation = 1
  let g:OmniSharp_want_snippet = 0
  let g:OmniSharp_timeout = 5

  if mymisc#plug_tap('deoplete.nvim')
    call deoplete#custom#source('omnisharp','input_pattern','[^. \t0-9]\.\w*')
  endif

  augroup omnisharp_commands
    autocmd!
    autocmd FileType cs setlocal omnifunc=OmniSharp#Complete
    autocmd FileType cs OmniSharpHighlightTypes
    autocmd FileType cs setlocal expandtab
    " autocmd CursorHold,CursorHoldI *.cs call OmniSharp#TypeLookupWithoutDocumentation()
    autocmd FileType cs nnoremap <buffer> <C-]> :OmniSharpGotoDefinition<CR>
    autocmd FileType cs nnoremap <buffer> K :OmniSharpDocumentation<CR>
    autocmd FileType cs nnoremap <buffer> <F2> :OmniSharpRename<CR>
  augroup END
endif

if mymisc#plug_tap('nerdcommenter')
  let g:NERDSpaceDelims = 1
  let g:NERDCustomDelimiters = {
        \ 'python': { 'left': '#', 'leftAlt': '# ' },
        \ }

  xmap gcc <Plug>NERDCommenterComment
  nmap gcc <Plug>NERDCommenterComment
  xmap gcn <Plug>NERDCommenterNested
  nmap gcn <Plug>NERDCommenterNested
  xmap gc<space> <Plug>NERDCommenterToggle
  nmap gc<space> <Plug>NERDCommenterToggle
  xmap gcm <Plug>NERDCommenterMinimal
  nmap gcm <Plug>NERDCommenterMinimal
  xmap gci <Plug>NERDCommenterInvert
  nmap gci <Plug>NERDCommenterInvert
  xmap gcs <Plug>NERDCommenterSexy
  nmap gcs <Plug>NERDCommenterSexy
  xmap gcy <Plug>NERDCommenterYank
  nmap gcy <Plug>NERDCommenterYank
  nmap gc$ <Plug>NERDCommenterToEOL
  nmap gcA <Plug>NERDCommenterAppend
  nmap gca <Plug>NERDCommenterAltDelims
  xmap gcl <Plug>NERDCommenterAlignLeft
  nmap gcl <Plug>NERDCommenterAlignLeft
  xmap gcb <Plug>NERDCommenterAlignBoth
  nmap gcb <Plug>NERDCommenterAlignBoth
  xmap gcu <Plug>NERDCommenterUncomment
  nmap gcu <Plug>NERDCommenterUncomment
endif

if mymisc#plug_tap('vim-javacomplete2')
  augroup vimrc_javacomplete2
    autocmd!
    autocmd Filetype java setlocal omnifunc=javacomplete#Complete
  augroup END
endif

if mymisc#plug_tap('vim-cpp-enhanced-highlight')
  let g:cpp_class_scope_highlight = 1
  let g:cpp_member_variable_highlight = 1
  let g:cpp_class_decl_highlight = 1
  let g:cpp_concepts_highlight = 1
endif

if mymisc#plug_tap('next-alter.vim')
  nmap <F4> <Plug>(next-alter-open)
  augroup vimrc_nextalter
    autocmd!
    autocmd BufEnter * let g:next_alter#search_dir = [ expand('%:h'), '.' , '..', './include', '../include', './src', '../src' ]
  augroup END
endif

if mymisc#plug_tap('auto-pairs')
  let g:AutoPairsMapCR = 0
  let g:AutoPairsFlyMode = 0
  let g:AutoPairsMultilineClose = 1
  let g:AutoPairsShortcutBackInsert = '<C-j>'
endif

if mymisc#plug_tap('lexima.vim')
  let g:lexima_ctrlh_as_backspace = 1

  for [begin, end] in [['(', ')'], ['{','}'], ['[',']']]
    call lexima#add_rule({'char':begin, 'at':'\%#[:alnum:]', 'input':begin})
    call lexima#add_rule({'char':end,   'at':'\%#\n\s*'.end, 'input':'<CR>'.end, 'delete':end})
  endfor

  for mark in ['"', "'"]
    call lexima#add_rule({'at': '\%#[:alnum:]', 'char': mark, 'input': mark})
  endfor
endif

if mymisc#plug_tap('vim-submode')
  let g:submode_timeoutlen = 3000
  call submode#enter_with('winsize',   'n', '', '<C-w>>', '5<C-w>>')
  call submode#enter_with('winsize',   'n', '', '<C-w><', '5<C-w><')
  call submode#enter_with('winsize',   'n', '', '<C-w>+', '5<C-w>+')
  call submode#enter_with('winsize',   'n', '', '<C-w>-', '5<C-w>-')
  call submode#leave_with('winsize',   'n', '', '<Esc>')
  call submode#map('winsize',          'n', '', '>',      '5<C-w>>')
  call submode#map('winsize',          'n', '', '<',      '5<C-w><')
  call submode#map('winsize',          'n', '', '+',      '5<C-w>+')
  call submode#map('winsize',          'n', '', '-',      '5<C-w>-')

  call submode#enter_with('timeundo/redo', 'n', '', 'g-',     'g-')
  call submode#enter_with('timeundo/redo', 'n', '', 'g+',     'g+')
  call submode#leave_with('timeundo/redo', 'n', '', '<Esc>')
  call submode#map('timeundo/redo',        'n', '', '-',      'g-')
  call submode#map('timeundo/redo',        'n', '', '+',      'g+')
endif

if mymisc#plug_tap('indentLine')
  " let g:indentLine_showFirstIndentLevel=1
endif

if mymisc#plug_tap('vim-autoformat')
  let g:autoformat_verbosemode = 1
endif

if mymisc#plug_tap('vim-startify')
  let g:startify_files_number = 20
endif

if mymisc#plug_tap('vim-devicons')
  let g:WebDevIconsNerdTreeAfterGlyphPadding = ''
  let g:WebDevIconsUnicodeDecorateFolderNodes = 1
endif

if mymisc#plug_tap('vim-go')
  let g:go_gocode_propose_builtins = 0
endif

if mymisc#plug_tap('gina.vim')
  cabbrev G Gina
  nnoremap <Leader>gs :<C-u>Gina status --opener=split<CR>
  nnoremap <Leader>gc :<C-u>Gina commit --opener=split<CR>
  " nnoremap <Leader>gp :<C-u>Gina push<CR>
  " nnoremap <Leader>gl :<C-u>Gina pull<CR>
  nnoremap <Leader>gf :<C-u>Gina fetch --all -t<CR>
  nnoremap <Leader>gm :<C-u>Gina merge<CR>

  call gina#custom#mapping#nmap(
        \ 'status', 'q',
        \ ':<C-u>bd<CR><C-w>p',
        \ {'noremap': 1, 'silent': 0},
        \)
  call gina#custom#mapping#nmap(
        \ 'commit', 'q',
        \ ':<C-u>bd<CR><C-w>p',
        \ {'noremap': 1, 'silent': 0},
        \)
  call gina#custom#mapping#nmap(
        \ 'diff', 'q',
        \ ':<C-u>bd<CR><C-w>p',
        \ {'noremap': 1, 'silent': 0},
        \)
endif

if mymisc#plug_tap('vim-gitgutter')
  let g:gitgutter_async = 0
  nnoremap <Leader>gg :GitGutterAll<CR>
  augroup vimrc_gitgutter
    autocmd!
    autocmd User GitGutter call mymisc#set_statusline_vars()
    autocmd CursorHold,CursorHoldI * GitGutterAll
  augroup END
endif

if mymisc#plug_tap('rainbow_parentheses.vim')
  let g:rainbow#pairs = [['(', ')'], ['[', ']'], ['{','}']]
  augroup vimrc-rainbow
    au!
    au VimEnter * RainbowParentheses
  augroup END
  " augroup vimrc-rainbow
  "   au!
  "   au VimEnter * RainbowParenthesesToggle
  "   au Syntax * RainbowParenthesesLoadRound
  "   au Syntax * RainbowParenthesesLoadSquare
  "   au Syntax * RainbowParenthesesLoadBraces
  "   au Syntax * RainbowParenthesesLoadChevrons
  " augroup END
endif

if mymisc#plug_tap('rainbow')
  " let g:rainbow_active = 1
  let g:rainbow_conf = {
        \ 'guifgs': ['#e06c75', '#98c379', '#d19a66', '#61afef', '#c678dd', '#56b6c2'],
        \ 'ctermfgs': [1, 2, 3, 4, 5, 6]
        \ }
endif

if mymisc#plug_tap('vim-nerdtree-syntax-highlight')
  let g:NERDTreeFileExtensionHighlightFullName = 1
  let g:NERDTreeExactMatchHighlightFullName = 1
  let g:NERDTreePatternMatchHighlightFullName = 1
endif

if mymisc#plug_tap('vim-nerdtree-tabs')
  let g:nerdtree_tabs_open_on_gui_startup = 0
endif

if mymisc#plug_tap('vim-vue')
  augroup vimrc-vue
    autocmd!
    autocmd FileType vue syntax sync fromstart
    " autocmd BufRead,BufNewFile *.vue setlocal filetype=vue.html.javascript.css
  augroup END
endif

if mymisc#plug_tap('CamelCaseMotion')
  call camelcasemotion#CreateMotionMappings(',')
endif

if mymisc#plug_tap('sonictemplate-vim')
  let g:sonictemplate_vim_template_dir = [
        \ $MYDOTFILES.'/vim/template',
        \ ]
  let g:sonictemplate_key             = "\<C-g>\<C-y>t"
  let g:sonictemplate_intelligent_key = "\<C-g>\<C-y>T"
  let g:sonictemplate_postfix_key     = "\<C-g>\<C-y>\<C-b>"
endif

if mymisc#plug_tap('nerdtree-git-plugin')
  let g:NERDTreeIndicatorMapCustom = {
        \ 'Modified'  : '!',
        \ 'Staged'    : '+',
        \ 'Untracked' : 'u',
        \ 'Renamed'   : '>',
        \ 'Unmerged'  : '=',
        \ 'Deleted'   : 'x',
        \ 'Dirty'     : '!',
        \ 'Clean'     : '',
        \ 'Ignored'   : 'i',
        \ 'Unknown'   : '?',
        \ }
endif

source $MYDOTFILES/vim/scripts/custom_global.vim
