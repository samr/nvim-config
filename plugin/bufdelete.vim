"=============================================================================
" File:		bufdelete.vim                                           {{{1
" Author:	samr
" Version:	1.0
" Created:	Fri 20 Jan 2006 09:19:52 AM PST
" Last Update:	Fri 20 Jan 2006 09:19:52 AM PST
"------------------------------------------------------------------------
" Description:	Smart deletion of buffers.  If the buffer has been modified
" this do not try to do a :bwipe on the buffer, otherwise delete it while
" keeping the current window layout.
"
"------------------------------------------------------------------------
" Installation:	copy this into the "plugin/" directory
" History:	Initial version
" TODO:		«missing features»
" }}}1
"=============================================================================


"=============================================================================
" Avoid global reinclusion {{{1
if exists("g:DisableBufDelete")
      \ || (exists("s:loaded_bufdelete_vim")
      \ && !exists('g:force_reload_bufdelete_vim'))
  finish
endif
let s:loaded_bufdelete_vim = 1
" Temporarily set "cpo" to its Vim default, to avoid the mappings to be
" misinterpreted.  This makes the file incompatible with Vi, but makes sure it
" can be used with different terminals.
let s:cpo_save=&cpo
set cpo&vim
" Avoid global reinclusion }}}1
"------------------------------------------------------------------------
" Commands {{{1

command Swbd  :call <SID>SmartBufferDelete(0)
command Swbw  :call <SID>SmartBufferDelete(1)
command Swbn  #|bn
command Swbp  #|bp

" Commands }}}1
"------------------------------------------------------------------------
" Functions {{{1

function s:SmartBufferDelete(bang)
    if a:bang
	bw!
    elseif !&modified && bufexists(0)
	bn
	bw #
    elseif !bufexists(0)
	" echo "No more buffers to switch to."
	enew
	bw #
    else
	echo "Buffer has been modified, use :bd!"
    endif
endfunction


" Functions }}}1
"------------------------------------------------------------------------
let &cpo=s:cpo_save
"=============================================================================
" vim600: set fdm=marker:
