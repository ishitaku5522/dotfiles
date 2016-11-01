" vim:set foldmethod=marker:
scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim

if exists("g:loaded_mysession_plugin")
	finish
endif
let g:loaded_mysession_plugin = 1

let s:true = 1
let s:false = 0

" ==========セッション復帰用自作スクリプト==========
set sessionoptions=curdir,help,slash,tabpages
" MY SESSION FUNCTIONS
" let g:save_session_file = expand('~/.vimsessions/default.vim')

" Init
let s:save_session_flag = s:true
let g:session_loaded = s:false

let g:save_window_file = expand('~/.vimwinpos')
if isdirectory(expand("$HOME")."/.vimsessions") != 1
	call mkdir($HOME."/.vimsessions","p")
endif

augroup NUSHSESSION
	autocmd!
	" autocmd VimEnter * nested execute("LoadLastSession")
	" nestedしないとSyntaxなどの設定が繁栄されない（BufReadとかがたぶん呼ばれない）
	autocmd VimEnter * nested if @% == '' && s:GetBufByte() == 0 | call s:load_session("lastsession.vim") | endif
	autocmd VimLeavePre * call s:save_window()
	autocmd VimLeavePre * if s:save_session_flag == s:true | call s:save_session("lastsession.vim") | endif
	" 新しいWindowを開かずタブで開く
	" 	autocmd VimEnter * call s:open_with_tab()
augroup END

command! TabMerge call s:tab_merge()
" command! LoadLastSession call s:load_session("lastsession.vim")

" command! ClearSession call s:clear_session()
" call s:load_session_on_startup()

function! s:GetBufByte()
	let byte = line2byte(line('$') + 1)
	if byte == -1
		return 0
	else
		return byte - 1
	endif
endfunction

" LOADING SESSION
function! s:load_session(session_name) abort "{{{
	if has("gui_running")
		execute "source" g:save_window_file
	endif
	let g:session_loaded = s:true
	execute "source" "~/.vimsessions/" . a:session_name
endfunction "}}}

" SAVING SESSION 
function! s:save_session(session_name) abort "{{{
	if g:session_loaded == s:true
		execute  "mksession! "  "~/.vimsessions/". a:session_name
	endif
endfunction "}}}

" SAVING WINDOW POSITION
function! s:save_window() abort "{{{
	let options = [
				\ 'set columns=' . &columns,
				\ 'set lines=' . &lines,
				\ 'winpos ' . getwinposx() . ' ' . getwinposy(),
				\ ]
	call writefile(options, g:save_window_file)
endfunction "}}}

" TABMERGING
function! s:tab_merge() abort "{{{
	if len(split(serverlist())) > 1
		tabnew
		tabprevious
		let s:send_file_path = expand("%")
		quit
		call remote_send("GVIM","<ESC><ESC>:tabnew " . s:send_file_path . "<CR>")
		call remote_foreground("GVIM")
		let s:save_session_flag = s:false
		quitall
	else
		echo "ウィンドウがひとつだけのためマージできません"
	endif
endfunction "}}}

" SESSION CREAR (DESABLED)
" function! s:clear_session() abort "{{{
" 	call s:save_session()
" 	call rename(expand($HOME) . '/.vimsessions/default.vim' ,expand($HOME) . '/.vimsessions/backup.vim')
"
" 	let s:save_session_flag = 1
" 	quitall
" endfunction "}}}


" START UP LOADING (DESABLED)
" function! s:load_session_on_startup() abort "{{{
" 	if has("vim_starting")
" 		if filereadable(g:save_session_file)
" 			"ほかにVimが起動していなければ
" 			" if len(split(serverlist())) == 1 || serverlist() == ''
" 			if serverlist() == ""
" 				silent source ~/.vimsessions/default.vim
" 			endif
" 			" デバッグ用
" 			" source ~/.vimsessions/default.vim
" 		endif
" 	endif
" endfunction "}}}


" ==========セッション復帰用自作スクリプトここまで========== "
"
let &cpo = s:save_cpo
unlet s:save_cpo