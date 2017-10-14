scriptencoding utf-8

if &compatible
  set nocompatible
endif

if myvimrc#plug_tap('TweetVim')
  " 1ページに表示する最大数
  " let g:tweetvim_tweet_per_page = 100
  " F6と,uvでTweetVimのtimeline選択


  " fork original option
  let g:tweetvim_panewidth = 40
  let g:tweetvim_say_insert_account = 1
  let g:tweetvim_expand_t_co = 1
  let g:tweetvim_open_buffer_cmd = g:tweetvim_panewidth . 'vsplit!'
  let g:tweetvim_display_source = 1
  let g:tweetvim_display_username = 1
  let g:tweetvim_display_icon = 1
  let g:tweetvim_display_separator = 1
  let g:tweetvim_async_post = 1
  let g:tweetvim_buffer_name = 'TweetVimBuffer'
  let g:tweetvim_default_account = 'NUSH06'


  " let g:tweetvim_updatetime = 10
  " nnoremap <Leader>Tl :<C-u>Unite tweetvim<CR>
  nnoremap <Leader>Tm :<C-u>TweetVimMentions<CR>
  nnoremap <Leader>Tu :<C-u>TweetVimUserStream<CR>
  nnoremap <Leader>Ts :<C-u>TweetVimSay<CR>
  nnoremap <Leader>Tc :<C-u>TweetVimCommandSay<CR>
  " "tweetvim用
  " augroup mytweetvim
  " 	autocmd FileType tweetvim nnoremap <buffer> j gj
  " 	autocmd FileType tweetvim nnoremap <buffer> k gk
  " augroup END
endif

if myvimrc#plug_tap('YouCompleteMe')
  let g:ycm_global_ycm_extra_conf = $MYDOTFILES . '/vim/scripts/.ycm_extra_conf.py'
  "       \'~/.vim/dein/repos/github.com/Valloric/YouCompleteMe
  "       \/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'
  let g:ycm_min_num_of_chars_for_completion = 1
  let g:ycm_cache_omnifunc = 0
  let g:ycm_complete_in_comments = 1
  let g:ycm_collect_identifiers_from_comments_and_strings = 1
  let g:ycm_collect_identifiers_from_tags_files = 1
  let g:ycm_seed_identifiers_with_syntax = 1
  let g:ycm_add_preview_to_completeopt = 1
  let g:ycm_autoclose_preview_window_after_insertion = 1


  " setting of the which python is used
  if has('unix')
    " let g:ycm_python_binary_path = 'python' . g:myvimrc_python_version
    let g:ycm_python_binary_path = 'python'
  endif

  let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
  let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
  " autocmd VIMRCCUSTOM FileType python nnoremap <buffer> K :<C-u>YcmCompleter GetDoc<CR>
  nnoremap <leader><c-]> :<C-u>YcmCompleter GoTo<CR>
  nnoremap <leader>} :<C-u>YcmCompleter GoToDefinition<CR>
  nnoremap <leader>{ :<C-u>YcmCompleter GoToDeclaration<CR>
  augroup vimrc_ycm
    autocmd filetype python nnoremap <buffer> K :<C-u>YcmCompleter GetDoc<CR><C-w>P:<C-u>set ft=rst<CR>
  augroup END
endif

if myvimrc#plug_tap('ctrlp-filer')
  nnoremap <Leader>f :<C-u>CtrlPFiler<cr>
endif

if myvimrc#plug_tap('ctrlp.vim')
  " let g:ctrlp_cmd = 'CtrlPMRUFiles'
  " yankroundのところでマッピングし直している
  " let g:ctrlp_map = ''
  " let g:ctrlp_extensions = ['mixed']
  let g:ctrlp_max_files = 50000
  " let g:ctrlp_match_window = 'bottom,order:btt,min:1,max:10,results:10'
  let g:ctrlp_show_hidden = 1
  let g:ctrlp_root_markers = ['.ctrlproot']
  let g:ctrlp_mruf_default_order = 1
  " if has('unix')
  " let s:ctrlp_my_match_func = {}
  let s:ctrlp_my_match_func = {}
  if !filereadable(expand('$HOME') . '/.vim/dein/repos/github.com/nixprime/cpsm/bin/cpsm_py.pyd' )
    augroup vimrc_cpsm
      autocmd VimEnter * call s:cpsm_build()
    augroup END

    fun! s:cpsm_build()
      if has('win32')
        let s:cpsm_install_confirm = confirm('Build cpsm now?',"&yes\n&no",2)
        if s:cpsm_install_confirm == 1
          exe '!' . $MYDOTFILES . '/tools/cpsm_winmake.bat'
          if v:shell_error == 0
            let s:ctrlp_my_match_func = { 'match' : 'cpsm#CtrlPMatch' }
          else
            echomsg 'Couldn''t build cpsm correctly'
          endif
        endif
      else
        " call system($HOME . '/.vim/dein/repos/github.com/nixprime/cpsm/install.sh')
        " if v:shell_error == 0
        " let s:ctrlp_my_match_func = { 'match' : 'cpsm#CtrlPMatch' }
        " else
        echomsg 'Please build cpsm with install.sh'
        " endif
      endif
      " code
    endf

  else
    if has('python3')
      let s:ctrlp_my_match_func = { 'match' : 'cpsm#CtrlPMatch' }
    endif
  endif
  let g:cpsm_query_inverting_delimiter = ' '

  let g:ctrlp_match_func = s:ctrlp_my_match_func
  " elseif has('win32')
  " endif

  augroup vimrc_ctrlp
    autocmd VimEnter * com! -n=? -com=dir CtrlPMRUFiles let g:ctrlp_match_func = {} |
          \ cal ctrlp#init('mru', { 'dir': <q-args> }) |
          \ let g:ctrlp_match_func = s:ctrlp_my_match_func
  augroup END

  nnoremap <Leader>mr       :CtrlPMRUFiles<CR>
  nnoremap <Leader>r        :CtrlPRegister<CR>
  nnoremap <Leader>c        :CtrlPCurWD<CR>
  nnoremap <Leader>T        :CtrlPBufTag<CR>
  nnoremap <Leader>b        :CtrlPBuffer<CR>
  nnoremap <Leader>l        :CtrlPLine %<CR>
  nnoremap <Leader>al       :CtrlPLine<CR>
  nnoremap <Leader><Leader> :CtrlP<CR>

  " let s:ctrlp_command_options = '--hidden --nocolor --nogroup --follow -g ""'
  " " if g:myvimrc_files_isAvalable
    " " let g:ctrlp_user_command = 'files -a -i "^$" %s'
  " if g:myvimrc_pt_isAvalable
    " let g:ctrlp_user_command = 'pt ' . s:ctrlp_command_options . ' %s'
  " elseif g:myvimrc_ag_isAvalable
    " let g:ctrlp_user_command = 'ag ' . s:ctrlp_command_options . ' %s'
  " else
    " if has('unix')
      " let g:ctrlp_user_command = 'find %s -type f'
    " else
      " let g:ctrlp_user_command = 'dir %s /-n /b /s /a-d'
    " endif
  " endif
  " unlet s:ctrlp_command_options

  " let g:ctrlp_user_command = 'chcp 65001| dir %s /-n /b /s /a-d | findstr /v /l ".jpg \\tmp\\ .git\\ .svn\\ .hg\\"' " Windows
  " else
  "   let g:ctrlp_use_caching=1
  " let g:ctrlp_user_command = 'ag %s ' . s:ctrlp_ag_options
  " let g:ctrlp_user_command = 'find %s -type f | grep -v -P "\.git/|\.svn/|\.hg/|\.jpg$|/tmp/"'          " MacOSX/Linux
  " endif
  " endif
endif

if myvimrc#plug_tap('foldCC.vim')
  let g:foldCCtext_enable_autofdc_adjuster = 1
  let g:foldCCtext_head = ''
  let g:foldCCtext_tail = 'printf(" %4d lines Lv%-2d", v:foldend-v:foldstart+1, v:foldlevel)'
  set foldtext=FoldCCtext()
  set fillchars=vert:\|
  " augroup FoldCC "{{{
  "	 hi Folded gui=bold guibg=Grey28 guifg=gray80
  "	 hi FoldColumn guibg=Grey14 guifg=gray80
  "
  "	 " hi Folded gui=bold term=standout ctermbg=Grey ctermfg=DarkBlue guibg=Grey50 guifg=Grey80
  "	 " hi FoldColumn gui=bold term=standout ctermbg=Grey ctermfg=DarkBlue guibg=Grey guifg=DarkBlue
  " augroup END "}}}
endif

if myvimrc#plug_tap('html5.vim')
  let g:html5_event_handler_attributes_complete = 1
  let g:html5_rdfa_attributes_complete = 1
  let g:html5_microdata_attributes_complete = 1
  let g:html5_aria_attributes_complete = 1
endif

if myvimrc#plug_tap('markdown-preview.vim')
  let g:mkdp_auto_close = 0
  let g:mkdp_auto_open = 0
  let g:mkdp_auto_start = 0
  if has('win32')
    let s:google_chrome_path='C:/Program Files (x86)/Google/Chrome/Application/chrome.exe'
    if executable(s:google_chrome_path)
      let g:mkdp_path_to_chrome=shellescape(s:google_chrome_path)
    endif
    unlet s:google_chrome_path
  else
    let g:mkdp_path_to_chrome = 'firefox'
  endif
endif

if myvimrc#plug_tap('memolist.vim')
  " let g:memolist_memo_suffix = 'txt'
  " let g:memolist_unite = 1
  " let g:memolist_denite = 1
  " let g:memolist_ex_cmd = 'Denite file_rec '
  " if myvimrc#plug_tap('nerdtree')
  " let g:memolist_ex_cmd = 'e'
  " endif

  nmap <Leader>mn :MemoNew<cr>
  nmap <Leader>ml :MemoList<cr>
  " nmap <Leader>ml :execute "Denite file_rec -path=" . g:memolist_path<cr>
endif

if myvimrc#plug_tap('nerdtree')
  nnoremap <Leader>e :NERDTreeFind<CR>
  nnoremap <Leader>E :NERDTreeCWD<CR>

  let g:NERDTreeQuitOnOpen = 1
  let g:NERDTreeHijackNetrw = 1
  let g:NERDTreeShowHidden = 1

  " let g:NERDTreeMapActivateNode = 'l'
  " let g:NERDTreeMapOpenSplit = 's'
  " let g:NERDTreeMapOpenVSplit = 'v'
  " let g:NERDTreeMapOpenRecursively = 'L'

  let NERDTreeMinimalUI = 1
endif

if myvimrc#plug_tap('open-browser.vim')
  let g:netrw_nogx = 1 " disable netrw's gx mapping.
  nmap gx <Plug>(openbrowser-smart-search)
  vmap gx <Plug>(openbrowser-smart-search)
  nnoremap <Leader>oh :<C-u>OpenBrowser https://
  nnoremap <Leader>os :<C-u>OpenBrowserSearch<Space>
endif

if myvimrc#plug_tap('previm')
  let g:previm_enable_realtime = 1
  " let g:previm_custom_css_path = $HOME . '/.vim/dein/repos/github.com/jasonm23/markdown-css-themes/markdown.css'
  let g:previm_show_header = 0
  function! s:setup_setting()
    command! -buffer -nargs=? -complete=dir PrevimSaveHTML call myvimrc#previm_save_html('<args>')
  endfunction

  augroup vimrc_previm
    autocmd!
    autocmd FileType *{mkd,markdown,rst,textile}* call <SID>setup_setting()
  augroup END
endif

if myvimrc#plug_tap('restart.vim')
  let g:restart_sessionoptions = &sessionoptions
endif

if myvimrc#plug_tap('supertab')
  let g:SuperTabDefaultCompletionType = '<c-n>'
endif

if myvimrc#plug_tap('tagbar')
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

if myvimrc#plug_tap('ultisnips')
  " better key bindings for UltiSnipsExpandTrigger
  let g:UltiSnipsExpandTrigger = '<Tab>'
  let g:UltiSnipsJumpForwardTrigger = '<Tab>'
  let g:UltiSnipsJumpBackwardTrigger = '<S-Tab>'

  if has('unix')
    if has('python3')
      let g:UltiSnipsUsePythonVersion = 3
    elseif has('python')
      let g:UltiSnipsUsePythonVersion = 2
    endif
  endif
endif

if myvimrc#plug_tap('undotree')
  let g:undotree_WindowLayout = 2
  let g:undotree_SplitWidth = 30
  nnoremap <Leader>gu :<C-u>UndotreeToggle<cr>
endif

if myvimrc#plug_tap('unite.vim')
  nnoremap <silent> <Leader>ub :<C-u>Unite buffer<CR>
  " if has('win32')
  nnoremap <silent> <Leader>uf :call myvimrc#command_at_destdir(expand('%:h'),['UniteWithProjectDir file_rec'])<CR>
  " else
  " nnoremap <silent> <Leader>uf :call myvimrc#command_at_destdir(expand('%:h'),['UniteWithProjectDir file_rec/async'])<CR>
  " endif
  nnoremap <silent> <Leader>uc :<C-u>Unite file_rec<CR>
  nnoremap <silent> <Leader>ul :<C-u>Unite line<CR>
  nnoremap <silent> <Leader>ug :<C-u>UniteWithProjectDir grep<CR>
  nnoremap <silent> <Leader>ur :<C-u>Unite register<CR>
  nnoremap <silent> <Leader>um :<C-u>Unite file_mru<CR>
  " UniteOutLine
  nnoremap <silent> <Leader>uo :<C-u>Unite -vertical -no-quit -winwidth=40 outline -direction=botright<CR>
  let g:unite_force_overwrite_statusline = 0
  " call unite#filters#sorter_default#use(['sorter_length'])
  " call unite#custom#profile('default', 'context', {
  " \	'start_insert': 1,
  " \	'winheight': 10,
  " \	'direction': 'botright'
  " \ })
  " ウィンドウを分割して開く
  augroup vimrc_unite
    autocmd!
    " autocmd FileType unite nnoremap <silent> <buffer> <expr> <C-j> unite#do_action('split')
    " autocmd FileType unite inoremap <silent> <buffer> <expr> <C-j> unite#do_action('split')
    " " ウィンドウを縦に分割して開く
    " autocmd FileType unite nnoremap <silent> <buffer> <expr> <C-l> unite#do_action('vsplit')
    " autocmd FileType unite inoremap <silent> <buffer> <expr> <C-l> unite#do_action('vsplit')
    " " タブで開く
    " autocmd FileType unite nnoremap <silent> <buffer> <expr> <C-t> unite#do_action('tabopen')
    " autocmd FileType unite inoremap <silent> <buffer> <expr> <C-t> unite#do_action('tabopen')
    " ESCキーを2回押すと終了する
    autocmd FileType unite nmap <silent> <buffer> <ESC><ESC> <Plug>(unite_exit)
    autocmd FileType unite imap <silent> <buffer> <ESC><ESC> <Plug>(unite_exit)
    autocmd FileType unite imap <silent> <buffer> <C-j> <Plug>(unite_select_next_line)
    autocmd FileType unite imap <silent> <buffer> <C-k> <Plug>(unite_select_previous_line)
    autocmd FileType unite imap <silent> <buffer> <Tab> <Plug>(unite_complete)
    autocmd FileType unite imap <silent> <buffer> <C-Tab> <Plug>(unite_choose_action)
    autocmd FileType unite call unite#filters#matcher_default#use(['matcher_fuzzy'])
  augroup END
  let g:unite_source_history_yank_enable = 1
  " if has('win32')
  " 	let g:unite_source_rec_async_command =
  " 				\ ['dir', '/-n /b /s /a-d | findstr /v /l ".jpg \\tmp\\ .git\\ .svn\\ .hg\\"']
  " else
  " 	let g:unite_source_rec_async_command =
  " 				\ ['find', '-type f | grep -v -P "\.git/|\.svn/|\.hg/|\.jpg$|/tmp/"']
  " endif
  "nice unite and ag
  " let g:unite_source_rec_async_command =
  " 			\ ['ag', '--follow', '--nocolor', '--nogroup',
  " 			\  '--hidden', '-g', '']
  let g:unite_source_rec_max_cache_files = 20000
  let g:unite_source_rec_min_cache_files = 10
  " search a file in the filetree
  " nnoremap <space><space> :<C-u>Unite -start-insert file_rec/async<cr>
  " reset not it is <C-l> normally
  " nnoremap <space>r <Plug>(unite_restart)
endif

if myvimrc#plug_tap('vim-airline')
  let g:airline#extensions#tagbar#enabled            = 0
  let g:airline#extensions#branch#enabled            = 1
  let g:airline#extensions#branch#empty_message      = ''
  " let g:airline#extensions#whitespace#checks	 = [ 'indent',  'mixed-indent-file' ]
  let g:airline#extensions#syntastic#enabled         = 0
  let g:airline#extensions#tabline#enabled           = 1 "{{{
  " right side show mode
  let g:airline#extensions#tabline#show_tab_type     = 0
  " プレビューウィンドウのステータスライン(Airline優先:0か,他のプラグイン優先:1)
  let g:airline#extensions#tabline#exclude_preview   = 0

  let g:airline#extensions#tabline#show_tabs         = 1
  let g:airline#extensions#tabline#show_splits       = 0
  let g:airline#extensions#tabline#show_buffers      = 0
  let g:airline#extensions#tabline#tab_nr_type       = 2 " splits and tab number
  let g:airline#extensions#tabline#show_close_button = 0 "}}}

  let g:airline#extensions#tabline#buffer_idx_mode = 1
  nmap <leader>1 <Plug>AirlineSelectTab1
  nmap <leader>2 <Plug>AirlineSelectTab2
  nmap <leader>3 <Plug>AirlineSelectTab3
  nmap <leader>4 <Plug>AirlineSelectTab4
  nmap <leader>5 <Plug>AirlineSelectTab5
  nmap <leader>6 <Plug>AirlineSelectTab6
  nmap <leader>7 <Plug>AirlineSelectTab7
  nmap <leader>8 <Plug>AirlineSelectTab8
  nmap <leader>9 <Plug>AirlineSelectTab9

  " let g:airline_powerline_fonts=1
  if !exists('g:airline_symbols')
    let g:airline_symbols = {}
  endif
  " powerline symbols" {{{
  " if has('win32') && (!has('gui_running'))
    let g:airline_left_sep                         = ''
    let g:airline_left_alt_sep                     = ''
    let g:airline_right_sep                        = ''
    let g:airline_right_alt_sep                    = ''
    let g:airline_symbols.branch                   = ''
  " else
    " let g:airline#extensions#tabline#left_sep      = '⮀'
    " let g:airline#extensions#tabline#left_alt_sep  = '⮁'
    " let g:airline#extensions#tabline#right_sep     = '⮂'
    " let g:airline#extensions#tabline#right_alt_sep = '⮃'
    " let g:airline_left_sep                         = '⮀'
    " let g:airline_left_alt_sep                     = '⮁'
    " let g:airline_right_sep                        = '⮂'
    " let g:airline_right_alt_sep                    = '⮃'

    " let g:airline_symbols.branch                   = '⭠'
    " let g:airline_symbols.readonly                 = '⭤'
    " let g:airline_symbols.linenr                   = '⭡'
  " endif " }}}
  let g:airline_symbols.maxlinenr                  = ''
  let g:airline_symbols.linenr                     = ''

  " disable warning " {{{
  " let g:airline#extensions#default#layout = [
  "			 \ [ 'a', 'b', 'c' ],
  "			 \ [ 'x', 'y', 'z' ]
  "			 \ ] " }}}
endif

if myvimrc#plug_tap('lightline.vim')
  let g:lightline = {
        \ 'colorscheme': 'jellybeans',
        \ 'active': {
        \   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename'], [ 'ctrlpmark' ] ],
        \   'right': [ [ 'syntastic', 'lineinfo' ], ['percent'], [ 'fileformat', 'fileencoding', 'filetype' ] ]
        \ },
        \ 'inactive': {
        \   'left': [ [ 'fugitive', 'filename' ] ],
        \   'right': [ [ 'lineinfo' ], [ 'percent' ], ['fileformat', 'fileencoding', 'filetype' ] ]
        \ },
        \ 'tab': {
        \   'active': [ 'tabnum', 'filename', 'readonly', 'modified' ],
        \   'inactive': [ 'tabnum', 'filename', 'readonly', 'modified' ],
        \ },
        \ 'tab_component_function': {
        \   'filename': 'LightlineTabFilename',
        \   'modified': 'lightline#tab#modified',
        \   'readonly': 'lightline#tab#readonly',
        \   'tabnum':   'lightline#tab#tabnum'
        \ },
        \ 'component': {
        \   'concatenate': '%<',
        \ },
        \ 'component_function': {
        \   'fugitive': 'LightlineFugitive',
        \   'filename': 'LightlineFilename',
        \   'fileformat': 'LightlineFileformat',
        \   'filetype': 'LightlineFiletype',
        \   'fileencoding': 'LightlineFileencoding',
        \   'mode': 'LightlineMode',
        \   'ctrlpmark': 'CtrlPMark',
        \ },
        \ 'component_expand': {
        \   'syntastic': 'SyntasticStatuslineFlag',
        \ },
        \ 'component_type': {
        \   'syntastic': 'error',
        \ },
        \ 'separator': { 'left': '', 'right': '' },
        \ 'subseparator': { 'left': '|', 'right': '|' }
        \ }

  function! LightlineModified()
    return &ft =~# 'help' ? '' : &modified ? '+' : &modifiable ? '' : '-'
  endfunction

  function! LightlineReadonly()
    return &ft !~? 'help' && &readonly ? '⭤' : ''
  endfunction

  function! LightlineFilename()
    let fname = expand('%:t')
    " return fname ==# 'ControlP' && has_key(g:lightline, 'ctrlp_item') ? g:lightline.ctrlp_item :
    return fname ==# 'ControlP' && has_key(g:lightline, 'ctrlp_item') ? '' :
          \ fname =~# '__Tagbar__' ? g:lightline.fname :
          \ fname =~# '__Gundo\|NERD_tree' ? '' :
          \ &ft ==# 'denite' ? denite#get_status_path() :
          \ &ft ==# 'vimfiler' ? vimfiler#get_status_string() :
          \ &ft ==# 'unite' ? unite#get_status_string() :
          \ &ft ==# 'vimshell' ? vimshell#get_status_string() :
          \ ('' !=# LightlineReadonly() ? LightlineReadonly() . ' ' : '') .
          \ ('' !=# fname ? fname : '[No Name]') .
          \ ('' !=# LightlineModified() ? ' ' . LightlineModified() : '')
  endfunction

  function! LightlineTabFilename(n) abort
    let buflist = tabpagebuflist(a:n)
    let winnr = tabpagewinnr(a:n)
    let name = expand('#'.buflist[winnr - 1].':p')
    let fmod = ':~:.'
    let _ = ''

    if empty(name)
      let _ .= '[No Name]'
    else
      let _ .= substitute(fnamemodify(name, fmod), '\v\w\zs.{-}\ze(\\|/)', '', 'g')
    endif

    let _ = substitute(_, '\\', '/', 'g')
    return _
  endfunction

  function! LightlineFugitive()
    try
      if expand('%:t') !~? 'Tagbar\|Gundo\|NERD' && &ft !~? 'vimfiler' && exists('*fugitive#head')
        let mark = '⭠ '  " edit here for cool mark
        let branch = fugitive#head()
        return branch !=# '' ? mark.branch : ''
      endif
    catch
    endtry
    return ''
  endfunction

  function! LightlineFileformat()
    return winwidth(0) > 70 ? &fileformat : ''
  endfunction

  function! LightlineFiletype()
    return winwidth(0) > 70 ? (&filetype !=# '' ? &filetype : 'no ft') : ''
  endfunction

  function! LightlineFileencoding()
    return winwidth(0) > 70 ? (&fenc !=# '' ? &fenc : &enc) : ''
  endfunction

  function! LightlineMode()
    if &ft ==# 'denite'
      let mode_str = substitute(denite#get_status_mode(), '-\| ', '', 'g')
      " call lightline#link(tolower(mode_str[0]))
      return mode_str
    else
      let fname = expand('%:t')
      return fname =~# '__Tagbar__' ? 'Tagbar' :
            \ fname ==# 'ControlP' ? 'CtrlP' :
            \ fname ==# '__Gundo__' ? 'Gundo' :
            \ fname ==# '__Gundo_Preview__' ? 'Gundo Preview' :
            \ fname =~# 'NERD_tree' ? 'NERDTree' :
            \ &ft ==# 'unite' ? 'Unite' :
            \ &ft ==# 'vimfiler' ? 'VimFiler' :
            \ &ft ==# 'vimshell' ? 'VimShell' :
            \ winwidth(0) > 60 ? lightline#mode() : ''
    endif
  endfunction

  function! CtrlPMark()
    if expand('%:t') =~# 'ControlP' && has_key(g:lightline, 'ctrlp_item')
      call lightline#link('iR'[g:lightline.ctrlp_regex])
      return lightline#concatenate([g:lightline.ctrlp_prev, g:lightline.ctrlp_item
            \ , g:lightline.ctrlp_next], 0)
    else
      return ''
    endif
  endfunction

  let g:ctrlp_status_func = {
        \ 'main': 'CtrlPStatusFunc_1',
        \ 'prog': 'CtrlPStatusFunc_2',
        \ }

  function! CtrlPStatusFunc_1(focus, byfname, regex, prev, item, next, marked)
    let g:lightline.ctrlp_regex = a:regex
    let g:lightline.ctrlp_prev = a:prev
    let g:lightline.ctrlp_item = a:item
    let g:lightline.ctrlp_next = a:next
    return lightline#statusline(0)
  endfunction

  function! CtrlPStatusFunc_2(str)
    return lightline#statusline(0)
  endfunction

  let g:tagbar_status_func = 'TagbarStatusFunc'

  function! TagbarStatusFunc(current, sort, fname, ...) abort
    let g:lightline.fname = a:fname
    return lightline#statusline(0)
  endfunction

  let g:unite_force_overwrite_statusline = 0
  let g:vimfiler_force_overwrite_statusline = 0
  let g:vimshell_force_overwrite_statusline = 0

  " lightline.vim側で描画するのでdeniteでstatuslineを描画しないようにする
  call denite#custom#option('default', 'statusline', v:false)
endif

if myvimrc#plug_tap('vim-anzu')
  " mapping
  nmap n <Plug>(anzu-n-with-echo)
  nmap N <Plug>(anzu-N-with-echo)
  nmap * <Plug>(anzu-star-with-echo)
  nmap # <Plug>(anzu-sharp-with-echo)
endif

if myvimrc#plug_tap('vim-brightest')
  let g:brightest#highlight = {
        \   'group' : 'BrightestUnderline'
        \}
endif

if myvimrc#plug_tap('vim-clang-format')
  let g:clang_format#auto_format = 0
  let g:clang_format#command = 'clang-format'
  if has('unix')
    if !executable('clang-format')
      for majorversion in range(4, 3, -1)
        for minorversion in range(9, 1, -1)
          if executable('clang-format-' . majorversion . '.' . minorversion)
            let g:clang_format#command = 'clang-format-' . majorversion . '.' . minorversion
          endif
        endfor
      endfor
    endif
  endif
  let g:clang_format#style_options = {
        \ 'AllowShortIfStatementsOnASingleLine':'true',
        \ 'AllowShortBlocksOnASingleLine'      :'true',
        \ 'AllowShortCaseLabelsOnASingleLine'  :'true',
        \ 'AllowShortFunctionsOnASingleLine'   :'true',
        \ 'AllowShortLoopsOnASingleLine'       :'true',
        \ 'AlignAfterOpenBracket'              :'AlwaysBreak',
        \ 'AlignConsecutiveAssignments'        :'true',
        \ 'AlignConsecutiveDeclarations'       :'true',
        \ 'AlignTrailingComments'              :'true',
        \ 'TabWidth'                           :'4',
        \ 'UseTab'                             :'Never',
        \ 'ColumnLimit'                        :'120'
        \ }
  " function! s:safeundo()
  " let s:pos = getpos( '. ')
  " let s:view = winsaveview()
  " undo
  " call setpos( '.', s:pos )
  " call winrestview( s:view )
  " endfunc

  " function! s:saferedo()
  " let s:pos = getpos( '.' )
  " let s:view = winsaveview()
  " redo
  " call setpos( '.', s:pos )
  " call winrestview( s:view )
  " endfunc

  " nnoremap u :call <SID>safeundo()<CR>
  " nnoremap <C-r> :call <SID>saferedo()<CR>
endif

if myvimrc#plug_tap('clang_complete')
    let g:clang_library_path='/usr/lib/llvm-3.8/lib'
endif

if myvimrc#plug_tap('vim-dirvish')
  nnoremap <silent> <Leader>e :exe ":" . <SID>open_mydirvish()<CR>
  nnoremap <silent> <Leader>E :Dirvish .<cr>
  " nnoremap <silent> <Leader>e :Dirvish %:p:h<CR>
  " nnoremap <silent> <Leader>E :Dirvish .<CR>

  fun! s:open_mydirvish()
    let savepre = 'let w:dirvish_before = [expand("%:p")]'
    " if len(tabpagebuflist()) > 1
    let w:dirvish_splited = 0
    let w:dirvish_start_cd = getcwd()
    return savepre . '| Dirvish %:p:h'
    " else
    " return 'leftabove vsplit|' . savepre .'| let w:dirvish_splited = 1 | Dirvish %:p:h'
    " endif
  endf

  fun! s:quit_mydirvish()
    if !exists('w:dirvish_splited')
      let w:dirvish_splited = 0
    endif
    if w:dirvish_splited == 1 && len(tabpagebuflist()) > 1
      quit
    else
      nmap <buffer> q <plug>(dirvish_quit)
      exe 'normal q'
      unlet w:dirvish_before
    endif
    if(exists('w:dirvish_start_cd'))
      exe 'cd ' . w:dirvish_start_cd
      unlet w:dirvish_start_cd
    endif
  endf

  fun! s:mydirvish_selectprevdir()
    if !exists('w:dirvish_before')
      let w:dirvish_before = []
    endif
    if len(w:dirvish_before) > 0
      call search('\V\^'.escape(w:dirvish_before[0], '\').'\$', 'cw')
    endif
  endf

  fun! s:mydirvish_open()

    if len(w:dirvish_before) > 1
      call remove(w:dirvish_before,0,1)
    elseif len(w:dirvish_before) == 1
      call remove(w:dirvish_before,0)
    endif

    call dirvish#open('edit', 0)

  endf

  augroup vimrc_dirvish
    autocmd!
    " hとlによる移動
    autocmd FileType dirvish nnoremap <silent><buffer> l :call <SID>mydirvish_open()<CR>
    autocmd FileType dirvish xnoremap <silent><buffer> l :call <SID>mydirvish_open()<CR>
    autocmd FileType dirvish nmap <silent><buffer> h <Plug>(dirvish_up)
    autocmd FileType dirvish xmap <silent><buffer> h <Plug>(dirvish_up)
    " 独自quitスクリプト
    autocmd FileType dirvish nmap <silent><buffer> q :call <SID>quit_mydirvish()<cr>
    " 起動時にソート.行末記号を入れないことで全行ソートする(共通部はソートしない)
    autocmd FileType dirvish silent sort /.*\([\\\/]\)\@=/
    " autocmd FileType dirvish silent keeppatterns g@\v[\/]\.[^\/]+[\/]?$@d
    " .とsに隠しファイルとソートを割り当て
    autocmd FileType dirvish nnoremap <silent><buffer> . :keeppatterns g@\v[\/]\.[^\/]+[\/]?$@d<cr>
    autocmd FileType dirvish nnoremap <silent><buffer> s :sort /.*\([\\\/]\)\@=/<cr>

    autocmd FileType dirvish nnoremap <silent><buffer> ~ :Dirvish ~/<CR>

    autocmd FileType dirvish nnoremap <silent><buffer> dd :Shdo rm -rf {}<CR>
    autocmd FileType dirvish vnoremap <silent><buffer> d :Shdo rm -rf {}<CR>
    autocmd FileType dirvish nnoremap <silent><buffer> rr :Shdo mv {}<CR>
    autocmd FileType dirvish vnoremap <silent><buffer> r :Shdo mv {}<CR>
    autocmd FileType dirvish nnoremap <silent><buffer> cc :Shdo cp {}<CR>
    autocmd FileType dirvish vnoremap <silent><buffer> c :Shdo cp {}<CR>

    " 開いていたファイルやDirectory(w:dirvish_before)にカーソルをあわせる
    autocmd FileType dirvish call <SID>mydirvish_selectprevdir()
    autocmd FileType dirvish call insert(w:dirvish_before,expand("%:p"))
    autocmd FileType dirvish CdCurrent
  augroup END
endif

if myvimrc#plug_tap('vim-easy-align')
  " ヴィジュアルモードで選択し，easy-align 呼んで整形．(e.g. vip<Enter>)
  vmap <Enter> <Plug>(LiveEasyAlign)
  " easy-align を呼んだ上で，移動したりテキストオブジェクトを指定して整形．(e.g. gaip)
  " nmap ga <Plug>(EasyAlign)
  " " Start interactive EasyAlign in visual mode (e.g. vipga)
  " xmap ga <Plug>(EasyAlign)
endif

if myvimrc#plug_tap('vim-easymotion')
  let g:EasyMotion_do_mapping = 0
  nmap <Leader>s <Plug>(easymotion-overwin-f2)
endif

if myvimrc#plug_tap('vim-indent-guides')
  let g:indent_guides_guide_size = 0
  let g:indent_guides_color_change_percent = 5
  let g:indent_guides_start_level = 1
  let g:indent_guides_enable_on_vim_startup = 1
endif

if myvimrc#plug_tap('vim-multiple-cursors')
  let g:multi_cursor_use_default_mapping = 0
  " Default mapping
  let g:multi_cursor_start_key = 'g<C-n>'
  let g:multi_cursor_next_key = '<C-n>'
  let g:multi_cursor_prev_key = '<C-p>'
  let g:multi_cursor_skip_key = '<C-x>'
  let g:multi_cursor_quit_key = '<Esc>'
endif

if myvimrc#plug_tap('vim-precious')
  " let g:context_filetype#search_offset = 300
  let g:precious_enable_switch_CursorMoved = {
        \   '*' : 0,
        \}
  let g:precious_enable_switch_CursorMoved_i = {
        \   '*' : 0,
        \}
  let g:precious_enable_switch_CursorHold = {
        \	'*' : 0,
        \   'toml' : 1,
        \   'help' : 1,
        \}
  " INSERTモードのON／OFFに合わせてトグル
  augroup vimrc_precious
    autocmd!
    " autocmd InsertEnter * :PreciousSwitch
    " autocmd InsertLeave * :PreciousSwitch
    autocmd FileType toml :syntax sync fromstart
  augroup END


  " setfiletype を無効
  " let g:precious_enable_switchers = {
  " \	"*" : {
  " \		"setfiletype" : 0,
  " \	},
  " \}
  " augroup test
  "	 autocmd!
  "	 autocmd User PreciousFileType let &l:syntax = precious#context_filetype()
  " augroup END
endif

if myvimrc#plug_tap('vim-quickrun')
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
        \ 'hook/close_quickfix/enable_hook_loaded' : 0,
        \ 'hook/close_quickfix/enable_success' : 1,
        \ 'hook/close_buffer/enable_failure' : 1,
        \ 'hook/close_buffer/enable_empty_data' : 1,
        \ 'outputter' : 'multi:buffer:quickfix',
        \ 'outputter/quickfix/open_cmd' : 'copen 8',
        \ 'hook/inu/enable' : 1,
        \ 'hook/inu/wait' : 1,
        \ 'outputter/buffer/split' : ':botright 8',
        \ 'runner' : 'vimproc',
        \ 'runner/vimproc/updatetime' : 100,
        \ }

  if has('job')
    call extend(g:quickrun_config['_'], {
          \ 'runner' : 'job',
          \ 'runner/job/interval' : 100,
          \ })

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

  nmap <silent> <Leader>R :CdCurrent<CR><Plug>(quickrun)
  nnoremap <expr><silent> <C-c> quickrun#is_running() ? <SID>myvimrc_quickrun_sweep() : "\<C-c>"

  fun! s:myvimrc_quickrun_sweep()
    echo 'Quickrun Sweep'
    call quickrun#sweep_sessions()
  endf
endif

if myvimrc#plug_tap('vimshell.vim')
  let g:vimshell_prompt = '% '
  let g:vimshell_secondary_prompt = '> '
  let g:vimshell_user_prompt = 'getcwd()'
endif

if myvimrc#plug_tap('vimtex')
  if has('win32')
    let g:vimtex_latexmk_continuous = 1
    let g:vimtex_latexmk_background = 1
    "let g:vimtex_latexmk_options = '-pdf'
    let g:vimtex_latexmk_options = '-pdfdvi'
    "let g:vimtex_latexmk_options = '-pdfps'
    let g:vimtex_view_general_viewer = 'SumatraPDF.exe'
    let g:vimtex_view_general_options =
          \ '-reuse-instance -inverse-search "\"' . $VIM . '\gvim.exe\" -n --remote-silent +\%l \"\%f\"" -forward-search @tex @line @pdf'
    let g:vimtex_view_general_options_latexmk = '-reuse-instance'
    "let g:vimtex_view_general_viewer = 'texworks'
  elseif has('unix')""
    let g:vimtex_latexmk_continuous = 1
    let g:vimtex_latexmk_background = 1
    "let g:vimtex_latexmk_options = '-pdf'
    let g:vimtex_latexmk_options = '-pdfdvi'
    "let g:vimtex_latexmk_options = '-pdfps'
    let g:vimtex_view_general_viewer = 'xdg-open'
    "let g:vimtex_view_general_viewer = 'okular'
    "let g:vimtex_view_general_options = '--unique @pdf\#src:@line@tex'
    "let g:vimtex_view_general_options_latexmk = '--unique'
    "let g:vimtex_view_general_viewer = 'qpdfview'
    "let g:vimtex_view_general_options = '--unique @pdf\#src:@tex:@line:@col'
    "let g:vimtex_view_general_options_latexmk = '--unique'
  endif
endif

if myvimrc#plug_tap('yankround.vim')
  nmap p <Plug>(yankround-p)
  xmap p <Plug>(yankround-p)
  nmap P <Plug>(yankround-P)
  nmap gp <Plug>(yankround-gp)
  xmap gp <Plug>(yankround-gp)
  nmap gP <Plug>(yankround-gP)
  nnoremap <silent><SID>(ctrlp) :<C-u>CtrlP<CR>
  nmap <expr><C-p> yankround#is_active() ?
        \ "\<Plug>(yankround-prev)" :
        \ ":CtrlP<CR>"
  nmap <C-n> <Plug>(yankround-next)
endif

if myvimrc#plug_tap('vaffle.vim')
  nnoremap <silent> <Leader>e :Vaffle %:p:h<CR>
  nnoremap <silent> <Leader>E :Vaffle .<CR>
  function! s:customize_vaffle_mappings() abort
    " Customize key mappings here
    nmap <buffer> <tab> <Plug>(vaffle-toggle-current)
  endfunction
  augroup vimrc_vaffle
    autocmd FileType vaffle call s:customize_vaffle_mappings()
    autocmd FileType vaffle command! -buffer CdCurrent execute printf('cd %s', vaffle#buffer#get_env().dir)
  augroup END
endif

if myvimrc#plug_tap('vimfiler.vim')
  " let g:vimfiler_force_overwrite_statusline = 0
  let g:vimfiler_enable_auto_cd = 1
  let g:vimfiler_as_default_explorer = 1
  call vimfiler#custom#profile('default', 'context' , { 'simple' : 1 })
  " let g:vimfiler_restore_alternate_file = 0
  nnoremap <silent> <Leader>v :VimFilerBufferDir -split -winwidth=35 -simple -toggle -find -force-quit -split-action=below<CR>
  nnoremap <silent> <Leader>V :VimFilerCurrentDir -split -winwidth=35 -simple -toggle -force-quit -split-action=below<CR>
  nnoremap <silent> <Leader>e :VimFilerBufferDir -split -winwidth=35 -simple -toggle -find -force-quit -split-action=below<CR>
  nnoremap <silent> <Leader>E :VimFilerCurrentDir -split -winwidth=35 -simple -toggle -force-quit -split-action=below<CR>
  " nnoremap <silent> <Leader>e :VimFilerBufferDir -toggle -find -force-quit -split  -status -winwidth=35 -simple -split-action=below<CR>
  " nnoremap <silent> <Leader>E :VimFilerCurrentDir -split -toggle -force-quit -status -winwidth=35 -simple -split-action=below<CR>
endif

if myvimrc#plug_tap('revimses')
  let g:revimses#sessionoptions = &sessionoptions
endif

if myvimrc#plug_tap('jedi-vim')
  " let g:jedi#completions_enabled = 0
  let g:jedi#show_call_signatures = 2
endif

if myvimrc#plug_tap('calendar.vim')
  augroup vimrc_calendar
    autocmd!
    autocmd FileType calendar IndentGuidesDisable
  augroup END
  let g:calendar_google_calendar = 1
  let g:calendar_google_task = 1
  let g:calendar_time_zone = '+0900'

endif

if myvimrc#plug_tap('thumbnail.vim')
  augroup vimrc_thumbnail
    autocmd!
    autocmd FileType thumbnail IndentGuidesDisable
  augroup END
endif

if myvimrc#plug_tap('autofmt')
  set formatexpr=autofmt#japanese#formatexpr()
endif

if myvimrc#plug_tap('denite.nvim')
  if has('job')
    call timer_start(100, 'async_custom#denite',{'repeat':1})
  else
    call async_custom#denite()
  endif
  " Change file_rec command.
  " if g:myvimrc_files_isAvalable
    " call denite#custom#var('file_rec', 'command', ['files', '-a', '-i', '^$'])
  if g:myvimrc_pt_isAvalable
    " if has("win32")
    call denite#custom#var('file_rec', 'command',
          \ ['pt', '--follow', '--nocolor', '--nogroup', '--hidden', '-g', ''])
    " else
    "   call denite#custom#var('file_rec', 'command',
    "         \ ['pt', '--follow', '--nocolor', '--nogroup', '-g', ''])
    " endif
  elseif g:myvimrc_ag_isAvalable
    call denite#custom#var('file_rec', 'command',
          \ ['ag', '--follow', '--nocolor', '--nogroup', '--hidden', '-g',''])
  endif

  call denite#custom#source(
        \ 'file_mru', 'matchers', ['matcher_fuzzy'])

  if g:ctrlp_match_func != {} && g:ctrlp_match_func['match'] ==# 'cpsm#CtrlPMatch'
    call denite#custom#source(
          \ 'file_mru', 'matchers', ['matcher_fuzzy', 'matcher_cpsm'])
    call denite#custom#source(
          \ 'line', 'matchers', ['matcher_fuzzy', 'matcher_cpsm'])
    call denite#custom#source(
          \ 'file_rec', 'matchers', ['matcher_fuzzy', 'matcher_cpsm'])
  endif

  " Change mappings.
  call denite#custom#map(
        \ 'insert',
        \ '<C-j>',
        \ '<denite:move_to_next_line>',
        \ 'noremap'
        \)
  call denite#custom#map(
        \ 'insert',
        \ '<C-k>',
        \ '<denite:move_to_previous_line>',
        \ 'noremap'
        \)
  " pt command on grep source
  call denite#custom#var('grep', 'command', ['pt'])
  call denite#custom#var('grep', 'default_opts',
        \ ['--nogroup', '--nocolor', '--follow', '--smart-case'])
  call denite#custom#var('grep', 'recursive_opts', [])
  call denite#custom#var('grep', 'pattern_opt', [])
  call denite#custom#var('grep', 'separator', ['--'])
  call denite#custom#var('grep', 'final_opts', [])

  nnoremap <silent> <leader>d<Leader> :call myvimrc#command_at_destdir(expand('%:h'),['DeniteProjectDir file_rec'])<CR>
  nnoremap <silent> <Leader>db :<C-u>Denite buffer<CR>
  nnoremap <silent> <Leader>dc :<C-u>Denite file_rec<CR>
  nnoremap <silent> <Leader>dl :<C-u>Denite line<CR>
  nnoremap <silent> <Leader>dg :<C-u>Denite grep -no-quit<CR>
  nnoremap <silent> <Leader>dr :<C-u>Denite register<CR>
  nnoremap <silent> <Leader>dm :<C-u>Denite file_mru<CR>
  nnoremap <silent> <Leader>do :<C-u>Denite outline<CR>
  exe 'nnoremap <silent> <Leader>ml :<C-u>Denite file_rec -path='. g:memolist_path. '<CR>'
endif

if myvimrc#plug_tap('deoplete.nvim')
  call deoplete#enable()
endif

if myvimrc#plug_tap('nerdcommenter')
  let g:NERDSpaceDelims = 1
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

if myvimrc#plug_tap('vim-javacomplete2')
  autocmd Filetype java setlocal omnifunc=javacomplete#Complete
endif

if myvimrc#plug_tap('vim-cpp-enhanced-highlight')
  let g:cpp_class_scope_highlight = 1
  let g:cpp_member_variable_highlight = 1
  let g:cpp_class_decl_highlight = 1
  let g:cpp_concepts_highlight = 1
endif

if myvimrc#plug_tap('next-alter.vim')
  nmap <F4> <Plug>(next-alter-open)
endif

if myvimrc#plug_tap('vim-submode')
  augroup mysubmode
    autocmd VimEnter * call g:plugin_mgr.lazy_hook('vim-submode')
  augroup END
endif
