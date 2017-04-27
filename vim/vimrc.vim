﻿" vim:set foldmethod=marker:
" Initialize {{{
set encoding=utf-8
set langmenu=ja_JP.utf-8

scriptencoding utf-8
if &compatible
  set nocompatible
endif

let s:true = 1
let s:false = 0

if !exists('$MYDOTFILES')
  let $MYDOTFILES = $HOME . '/dotfiles'
endif

let $MYVIMHOME=$MYDOTFILES . '/vim'

if !exists('g:use_plugins')
  let g:use_plugins = s:true
endif
" }}}

" ============================== "
" No Plugin Settings             "
" ============================== "
" Set options {{{
let g:mapleader = "\<space>"

" OSの判定
if has('win32')
  set t_Co=16         " cmd.exeならターミナルで16色を使う
  let g:solarized_termcolors = 16

elseif has('unix')
  set t_Co=256        " ターミナルで256色を使う
  let g:solarized_termcolors = 256

  if v:version >= 800 || has('nvim')
    set termguicolors " ターミナルでTrueColorを使う
  endif

  " 背景をクリア
  set t_ut=

  if !has('nvim')
    set ttymouse=xterm2 " 通常vim用
  endif

  if executable('gsettings') && has('job')
    augroup VIMRC1
      autocmd!
      " カーソルの形をモードによって変更
      let s:curshape_str = 'profile=$(gsettings get org.gnome.Terminal.ProfilesList default);profile=${profile:1:-1};gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/" cursor-shape '
      autocmd InsertEnter * silent call job_start(['/bin/bash', '-c', s:curshape_str . 'ibeam'])
      autocmd InsertLeave * silent call job_start(['/bin/bash', '-c', s:curshape_str . 'block'])
      autocmd VimLeave * silent call job_start(['/bin/bash', '-c', s:curshape_str . 'block'])
    augroup END
  endif
endif

" ビープ音を鳴らなくする
set visualbell
set t_vb=

set diffopt=filler,iwhite,vertical                    " diffのときの挙動
set cursorline                                        " カーソル行のハイライト
set nocursorcolumn
set backspace=indent,eol,start                        " バックスペース挙動のおまじない
set clipboard=unnamed,unnamedplus                     " コピーした文字列がclipboardに入る(逆も）
" Vimrc_clipboard_syncからの依存に注意
set ignorecase                                        " 大文字小文字無視
set smartcase                                         " 大文字で始まる場合は無視しない
set foldmethod=marker                                 " syntaxに応じて折りたたまれる
set tabstop=4                                         " タブキーの挙動設定。タブをスペース4つ分とする
set shiftwidth=4                                      " インデントでスペース４つ分下げる
set expandtab                                         " タブをスペースに変換
set autoindent
set softtabstop=4                                     " バックスペース等でスペースを消す幅
set list                                              " タブ,行末スペース、改行等の可視化,また,その可視化時のマーク
set listchars=tab:>\ ,trail:-,eol:$,extends:>,precedes:<,nbsp:%
set wildmenu                                          " コマンドの補完設定
set wildmode=longest:full,full                        " コマンドの補完スタイル
set laststatus=2                                      " 下のステータスバーの表示
set display=lastline                                  " 一行が長い場合でも@にせずちゃんと表示
set showcmd                                           " 入力中のコマンドを右下に表示
set cmdheight=2                                       " コマンドラインの高さ
set showtabline=2                                     " タブバーを常に表示
set number                                            " 行番号表示
set norelativenumber
set hlsearch                                          " 文字列検索時にハイライトする
set incsearch                                         " 文字入力中に検索を開始
set ruler                                             " 右下の現在行の表示
set hidden
set noequalalways                                     " splitしたときにウィンドウが同じ大きさになるよう調節する
set tags+=./tags;,./tags-ja;                          " タグファイルを上層に向かって探す
set autoread                                          " 他のソフトで、編集中ファイルが変更されたとき自動Reload
set noautochdir                                       " 今開いてるファイルにカレントディレクトリを移動するか
set scrolloff=5                                       " カーソルが端まで行く前にスクロールし始める行数
set ambiwidth=double                                  " 全角記号（「→」など）の文字幅を半角２つ分にする
set mouse=a                                           " マウスを有効化
set nomousehide                                       " 入力中にポインタを消すかどうか
set lazyredraw                                        " スクロールが間に合わない時などに描画を省略する
set sessionoptions=folds,help,tabpages,buffers
set splitbelow
set splitright
set updatetime=1000
set timeoutlen=1000
set ttimeoutlen=100
set fileencodings=utf-8,sjis,iso-2022-jp,cp932,euc-jp " 文字コード自動判別優先順位の設定
set fileformats=unix,dos,mac                          " 改行コード自動判別優先順位の設定
set complete=.,w,b,u,k,s,t,i,d,t
set completeopt=menuone,preview                       " 補完関係の設定
set omnifunc=syntaxcomplete#Complete
set iminsert=0                                        " IMEの管理
set imsearch=0

if v:version >= 800 || has('nvim')                    " バージョン検出
  set breakindent                                     " version8以降搭載の便利オプション
  set display=truncate
  set emoji                                           " 絵文字を全角表示
  set completeopt+=noselect
endif

" Statusline settings {{{
set statusline=%F%m%r%h%w%q%=
set statusline+=[%{&fileformat}]
set statusline+=[%{has('multi_byte')&&\&fileencoding!=''?&fileencoding:&encoding}]
set statusline+=%y
set statusline+=%4p%%%5l:%-3c
" }}}

" agがあればgrepの代わりにagを使う
if executable('pt')
  set grepprg=pt\ --nogroup\ --nocolor\ --column\ --follow
elseif executable('ag')
  set grepprg=ag\ --nogroup\ --nocolor\ --column\ --follow
elseif has('unix')
  set grepprg=grep\ -rinIH\ --exclude-dir='.*'\ $*
endif

" set undofileでアンドゥデータをファイルを閉じても残しておく
" 該当フォルダがなければ作成
if !isdirectory($HOME . '/.vim/undofiles')
  call mkdir($HOME . '/.vim/undofiles','p')
endif

set undodir=$HOME/.vim/undofiles
set undofile

"  set backupでスワップファイルを保存する
" 該当フォルダがなければ作成
if !isdirectory($HOME . '/.vim/backupfiles')
  call mkdir($HOME . '/.vim/backupfiles','p')
endif

set backupdir=$HOME/.vim/backupfiles
set backup
" }}}

" Mapping {{{
" 折り返しがあっても真下に移動できるようになる
nnoremap j gj
nnoremap k gk
nnoremap <Down> gj
nnoremap <Up> gk

vnoremap j gj
vnoremap k gk
vnoremap <Down> gj
vnoremap <Up> gk

noremap <C-j> <ESC>
noremap! <C-j> <ESC>
nnoremap <C-Tab> gt
nnoremap <C-S-TAB> gT


" !マークは挿入モードとコマンドラインモードへのマッピング
" インサートモードとコマンドモードで一部emacsキーバインド
noremap! <C-f> <Right>
noremap! <C-b> <Left>
cnoremap <C-a> <C-b>
cnoremap <C-@> <C-a>
cnoremap <C-p> <up>
cnoremap <C-n> <down>
cnoremap <C-u> <C-e><C-u>

" エスケープ２回でハイライトキャンセル
nnoremap <silent> <ESC><ESC> :noh<CR>
nnoremap <C-g> 2<C-g>
" ビジュアルモードでも*検索が使えるようにする
vnoremap * "zy:let @/ = @z <CR>n
nnoremap <Leader>. <ESC>:<C-u>edit $MYVIMHOME/vimrc.vim<CR>
nnoremap <C-]> g<C-]>

" }}}

" Commands {{{
" Sudoで強制保存
if has('unix')
  command! Wsudo execute("w !sudo tee % > /dev/null")
endif

" :CdCurrent で現在のファイルのディレクトリに移動できる(Kaoriyaに入ってて便利なので実装)
command! CdCurrent cd\ %:h
command! CopyPath call myvimrc#copypath()
command! Ctags call myvimrc#ctags_project()
command! DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis | wincmd p | diffthis
" }}}

" Autocmds {{{
augroup VIMRC2
  autocmd!
  " タグを</で自動で閉じる。completeoptに依存している
  autocmd Filetype xml,html,eruby inoremap <buffer> </ </<C-x><C-o><C-n><Esc>F<i

  " タグ系のファイルならインデントを浅くする
  autocmd Filetype html,xml setl expandtab softtabstop=2 shiftwidth=2
  autocmd Filetype html,xml setl foldmethod=indent
  autocmd Filetype css setl foldmethod=syntax

  " python関係の設定
  let g:python_highlight_all = 1
  " autocmd FileType python setl autoindent nosmartindent
  autocmd FileType python setl foldmethod=indent
  " autocmd FileType python setl cinwords=if,elif,else,for,while,try,except,finally,def,class
  autocmd FileType python inoremap <buffer> # X#
  autocmd FileType python nnoremap <buffer> >> i<C-t><ESC>^

  " cpp関係の設定
  autocmd FileType c,cpp setl foldmethod=syntax

  autocmd FileType vim setl expandtab softtabstop=2 shiftwidth=2

  let g:vimsyn_folding = 'aflmpPrt'
  autocmd BufRead *.vim setl foldmethod=syntax

  " QuickFixを自動で開く
  autocmd QuickFixCmdPost * cwindow
  autocmd FileType qf nnoremap <silent><buffer> q :quit<CR>
  " pでプレビューができるようにする
  autocmd FileType qf noremap <silent><buffer> p  <CR>zz<C-w>p

  " ヘルプをqで閉じれるようにする
  autocmd FileType help nnoremap <silent><buffer>q :quit<CR>
  autocmd FileType mail call s:add_signature()
  fun! s:add_signature()
    let l:file = $HOME . '/localrcs/vim-local-signature.vim'
    if filereadable(l:file)
      let l:signature = []
      for line in readfile(l:file)
        call add(l:signature,line)
      endfor
      if !exists('b:mailsignature')
        let b:mailsignature = 1
        silent call append(0,l:signature)
        normal! gg
      endif
    else
      echomsg 'There is no signature file'
    endif
  endf

  " misc
  if has('unix')
    " linux用（fcitxでしか使えない）
    autocmd InsertLeave * call myvimrc#ImInActivate()
  endif
  autocmd VimEnter * call myvimrc#git_auto_updating()

  " クリップボードが無名レジスタと違ったら
  " (他のソフトでコピーしてきたということなので)
  " 他のレジスタに保存しておく
  if has('job')
    fun! Vimrc_clipboard_sync(timer)
      if @* != @"
        " let @" = @*
        let @0 = @*
      endif
    endf
    call timer_start(500,'Vimrc_clipboard_sync',{'repeat':-1})
  else
    autocmd CursorHold,CursorHoldI
          \ * if @* != @" | let @" = @* | let @0 = @* | endif
  endif

  autocmd FilterWritePre * if &diff | setlocal wrap< | endif
augroup END
"}}}

" Build in plugins {{{
set runtimepath+=$VIMRUNTIME/pack/dist/opt/editexisting
set runtimepath+=$VIMRUNTIME/pack/dist/opt/matchit
" }}}

" General Netrw settings {{{
" let g:netrw_winsize = 30 " 起動時用の初期化。起動中には使われない
" let g:netrw_browse_split = 4
let g:netrw_banner = 1
let g:netrw_list_hide = '\(^\|\s\s\)\zs\.\S\+'
let g:netrw_liststyle = 0
let g:netrw_alto = 1
let g:netrw_altv = 1
" カレントディレクトリを変える
let g:netrw_keepdir = 0
highlight! link netrwMarkFile Search

augroup CustomNetrw
  autocmd!
  " for toggle
  " autocmd FileType netrw nnoremap <buffer><Leader>e :call <SID>NiceLexplore(0)<CR>
  " autocmd FileType netrw nnoremap <silent><buffer>q :quit<CR>
  autocmd FileType netrw nmap <silent><buffer>. gh
  autocmd FileType netrw nmap <silent><buffer>h -
  autocmd FileType netrw nmap <silent><buffer>l <CR>
  autocmd FileType netrw nmap <silent><buffer>q <C-o>
  " autocmd FileType netrw unmap <silent><buffer>qf
  " autocmd FileType netrw unmap <silent><buffer>qF
  " autocmd FileType netrw unmap <silent><buffer>qL
  " autocmd FileType netrw unmap <silent><buffer>qb
  " autocmd FileType netrw nnoremap <silent><buffer>qq :quit<CR>
augroup END
" }}}

" Self constructed plugins {{{
let s:myplugins = $MYDOTFILES . '/vim'
exe 'set runtimepath+=' . escape(s:myplugins, ' \')
set runtimepath+=$HOME/.fzf/
nnoremap <silent><expr><Leader><C-f> myvimrc#command_at_destdir(myvimrc#find_project_dir(['.git','tags']),['FZF'])
"}}}

" Confirm whether or not install dein if not exists {{{
let s:plugin_dir = $HOME . '/.vim/dein'
let s:dein_dir = s:plugin_dir . '/repos/github.com/Shougo/dein.vim'

if !isdirectory(s:dein_dir) && g:use_plugins == s:true
  " deinがインストールされてない場合そのままではプラグインは使わない
  let g:use_plugins = s:false

  let s:install_dein_diag_mes = 'Dein is not installed yet.Install now?'
  if confirm(s:install_dein_diag_mes,"&yes\n&no",2) == 1
    call mkdir(s:dein_dir, 'p')
    exe printf('!git clone %s %s', 'https://github.com/Shougo/dein.vim', '"' . s:dein_dir . '"')
    " インストールが完了したらフラグを立てる
    let g:use_plugins = s:true
  endif
endif
"}}}

" ============================== "
" Plugin Settings START          "
" ============================== "
if g:use_plugins == s:true
  " Load local settings"{{{
  if filereadable($HOME . '/localrcs/vim-local.vim')
    source $HOME/localrcs/vim-local.vim
  endif
  "}}}

  " Plugin pre settings {{{
  " vimprocが呼ばれる前に設定
  let g:vimproc#download_windows_dll = 1
  " プラグインで使われるpythonのバージョンを決定
  if !exists('g:myvimrc_python_version')
    let g:myvimrc_python_version = '3'
  endif
  " }}}

  " Dein main settings {{{
  exe 'set runtimepath+=' . escape(s:dein_dir, ' \')

  let s:plugins_toml = '$MYVIMHOME/tomlfiles/dein.toml'
  let s:plugins_lazy_toml = '$MYVIMHOME/tomlfiles/dein_lazy.toml'

  if dein#load_state(s:plugin_dir)
    call dein#begin(s:plugin_dir)
    call dein#add('Shougo/dein.vim')

    call dein#load_toml(s:plugins_toml,{'lazy' : 0})
    call dein#load_toml(s:plugins_lazy_toml,{'lazy' : 1})

    call dein#end()
    call dein#save_state()
  endif

  filetype plugin indent on
  syntax enable

  if dein#check_install()
    " インストールされていないプラグインがあれば確認
    if has('vim_starting')
      augroup vimrc_dein_install_plugs
        autocmd!
        autocmd VimEnter * call myvimrc#confirm_do_dein_install()
      augroup END
    else
      call myvimrc#confirm_do_dein_install()
    endif
  endif

  " load settings of plugins
  source $MYVIMHOME/scripts/custom.vim
  " Dein end
  if filereadable($HOME . '/localrcs/vim-localafter.vim')
    source $HOME/localrcs/vim-localafter.vim'
  endif
  " }}}

  " Color settings {{{
  " ターミナルでの色設定
  if has('win32') && !has('gui_running')
    colorscheme elflord
  else
    try
      set background=light
      " let g:airline_theme="molokai"
      " colorscheme molokai
      " colorscheme summerfruit256
      colorscheme onedark
      let g:airline_theme='onedark'
      " highlight! IncSearch term=none cterm=none gui=none ctermbg=114 guibg=#98C379
      highlight! Folded ctermbg=235 ctermfg=none guibg=#282C34 guifg=#abb2bf
      highlight! FoldColumn ctermbg=233 guibg=#0e1013
      highlight! Normal ctermbg=233 guifg=#abb2bf guibg=#0e1013
      highlight! Vertsplit term=reverse ctermfg=235 ctermbg=235 guifg=#282C34 guibg=#282C34
      " highlight! MatchParen gui=none cterm=none term=none

      " for YCM's warning area
      highlight! SpellCap cterm=underline gui=underline
      " transparent
      " highlight! Folded cterm=underline ctermbg=none
      " highlight! FoldColumn ctermbg=none
      " highlight! Normal ctermbg=none
      " highlight! Vertsplit term=reverse ctermfg=145 ctermbg=none guifg=#282C34 guibg=#282C34

      " highlight! StatusLine ctermbg=235 guibg=#282C34
      " highlight! StatusLineNC ctermbg=235 guibg=#282C34

      if has('gui_running')
        let g:indent_guides_auto_colors = 1
      else
        let g:indent_guides_auto_colors = 0
        " solarized(light)
        augroup VIMRC4
          autocmd!
          " solarized
          " autcmd VimEnter,Colorscheme * :hi IndentGuidesEven guifg=#0C3540 guibg=#183F49
          " autcmd VimEnter,Colorscheme * :hi IndentGuidesOdd guifg=#183F49 guibg=#0C3540
          " autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd ctermbg=230
          " autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=223
          " summerfruit
          " autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd ctermbg=255
          " autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=254
          " one(light)
          " autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd ctermbg=254 guifg=#E1E1E1 guibg=#EDEDED
          " autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=253 guifg=#EDEDED guibg=#E1E1E1
          " onedark
          " autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd ctermfg=59 ctermbg=234 guifg=#252629 guibg=#1A1B1E
          " autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermfg=59 ctermbg=235 guifg=#1A1B1E guibg=#252629
          " transparent
          autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  ctermbg=none guifg=#252629 guibg=#1A1B1E
          autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=none guifg=#1A1B1E guibg=#252629
        augroup END

      endif
    catch
      colorscheme default
      set background=light
    endtry
  endif
  " }}}

  " Netrw Mapping {{{
  " バッファファイルのディレクトリで開く
  nnoremap <Leader>n :call myvimrc#NiceLexplore(1)<CR>
  " カレントディレクトリで開く
  nnoremap <Leader>N :call myvimrc#NiceLexplore(0)<CR>
  " }}}
else
  " Without plugins settings {{{
  colorscheme default
  set background=light

  " Netrw settings {{{
  " バッファファイルのディレクトリで開く
  nnoremap <Leader>e :call myvimrc#NiceLexplore(1)<CR>
  " カレントディレクトリで開く
  nnoremap <Leader>E :call myvimrc#NiceLexplore(0)<CR>
  " }}}

  " }}}
endif
if getcwd() ==# $VIM
  cd $HOME
endif
