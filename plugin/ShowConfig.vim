" ============================================================================
" File:        ShowConfig.vim
" Description: Vim global plugin that provides a config explorer, it is
"              a modification of NERDTree.
" Maintainer:  Sam Riesland <sam.riesland at gmail dot com>
" Last Change: 12 February, 2013
" License:     This program is free software. It comes without any warranty,
"              to the extent permitted by applicable law. You can redistribute
"              it and/or modify it under the terms of the Do What The Fuck You
"              Want To Public License, Version 2, as published by Sam Hocevar.
"              See http://sam.zoy.org/wtfpl/COPYING for more details.
"
" ============================================================================
let s:ShowConfigVersion = '1.0.0'

" SECTION: Script init stuff {{{1
"============================================================
if exists("loaded_show_config")
    finish
endif
if v:version < 700
    echoerr "ShowConfig: this plugin requires vim >= 7. DOWNLOAD IT! You'll thank me later!"
    finish
endif
let loaded_show_config = 1

"for line continuation - i.e dont want C in &cpo
let s:old_cpo = &cpo
set cpo&vim

"Function: s:initVariable() function {{{2
"This function is used to initialise a given variable to a given value. The
"variable is only initialised if it does not exist prior
"
"Args:
"var: the name of the var to be initialised
"value: the value to initialise var to
"
"Returns:
"1 if the var is set, 0 otherwise
function! s:initVariable(var, value)
    if !exists(a:var)
        exec 'let ' . a:var . ' = ' . "'" . substitute(a:value, "'", "''", "g") . "'"
        return 1
    endif
    return 0
endfunction

"SECTION: Init variable calls and other random constants {{{2
call s:initVariable("g:ShowConfigMinimalUI", 0)
call s:initVariable("g:ShowConfigHighlightCursorline", 1)
call s:initVariable("g:ShowConfigHijackNetrw", 1)
call s:initVariable("g:ShowConfigShowLineNumbers", 0)
call s:initVariable("g:ShowConfigWinPos", "left")
call s:initVariable("g:ShowConfigWinSize", 31)
call s:initVariable("g:ShowConfigRenderVerbose", 0)
call s:initVariable("g:ShowConfigRenderCommands", 0)

"SECTION: Script level variable declaration{{{2
let s:ShowConfigBufName = 'ShowConfig_'

"the number to add to the show config buffer name to make the buf name unique
let s:next_buffer_number = 1


" SECTION: Commands {{{1
"============================================================
"init the command that users start the nerd tree with
"command! -n=* ShowConfig call s:initShowConfig(<f-args>)
command! -n=0 ShowMappings call s:initShowConfig(0,0)
command! -n=0 ShowMappingsVerbose call s:initShowConfig(1,0)
command! -n=0 ShowCommands call s:initShowConfig(0,1)
command! -n=0 ShowCommandsVerbose call s:initShowConfig(1,)
command! -n=0 ToggleShowMappings call s:toggle(0,0)
command! -n=0 ToggleShowMappingsVerbose call s:toggle(1,)
command! -n=0 ToggleShowCommands call s:toggle(0,1)
command! -n=0 ToggleShowCommandsVerbose call s:toggle(1,1)
command! -n=0 -bar ShowConfigClose call s:closeShowConfigIfOpen()
" SECTION: Auto commands {{{1
"============================================================
augroup ShowConfig
    "Save the cursor position whenever we close the nerd tree
    exec "autocmd BufWinLeave ". s:ShowConfigBufName ."* call <SID>saveScreenState()"

    "disallow insert mode in the ShowConfig
    exec "autocmd BufEnter ". s:ShowConfigBufName ."* stopinsert"
augroup END

if g:ShowConfigHijackNetrw
    augroup ShowConfigHijackNetrw
        autocmd VimEnter * silent! autocmd! FileExplorer
    augroup END
endif

" SECTION: General Functions {{{1
"============================================================

" FUNCTION: s:exec(cmd) {{{2
" same as :exec cmd  but eventignore=all is set for the duration
function! s:exec(cmd)
    let old_ei = &ei
    set ei=all
    exec a:cmd
    let &ei = old_ei
endfunction

" FUNCTION: s:nextBufferName() {{{2
" returns the buffer name for the next nerd tree
function! s:nextBufferName()
    let name = s:ShowConfigBufName . s:next_buffer_number
    let s:next_buffer_number += 1
    return name
endfunction

"FUNCTION: s:putCursorInShowConfigWin(){{{2
"Places the cursor in the nerd tree window
function! s:putCursorInShowConfigWin()
    if !s:isShowConfigOpen()
        throw "ShowConfig.InvalidOperationError: cant put cursor in ShowConfig window, no window exists"
    endif

    call s:exec(s:getShowConfigWinNum() . "wincmd w")
endfunction

"FUNCTION: s:saveScreenState() {{{2
"Saves the current cursor position in the current buffer and the window
"scroll position
function! s:saveScreenState()
    let win = winnr()
    try
        call s:putCursorInShowConfigWin()
        let b:ShowConfigOldPos = getpos(".")
        let b:ShowConfigOldTopLine = line("w0")
        let b:ShowConfigOldWindowSize = winwidth("")
        call s:exec(win . "wincmd w")
    catch /^ShowConfig.InvalidOperationError/
    endtry
endfunction

"FUNCTION: s:setCommonBufOptions() {{{2
function! s:setCommonBufOptions()
    "throwaway buffer options
    setlocal noswapfile
    setlocal buftype=nofile
    setlocal bufhidden=hide
    setlocal nowrap
    setlocal foldcolumn=0
    setlocal foldmethod=manual
    setlocal nofoldenable
    setlocal nobuflisted
    setlocal nospell
    if g:ShowConfigShowLineNumbers
        setlocal nu
    else
        setlocal nonu
        if v:version >= 703
            setlocal nornu
        endif
    endif

    iabc <buffer>

    if g:ShowConfigHighlightCursorline
        setlocal cursorline
    endif

    let b:treeShowHelp = 0
    setfiletype showconfig
endfunction

" Function: s:showConfigExistsForTab()   {{{2
" Returns 1 if a nerd tree root exists in the current tab
function! s:showConfigExistsForTab()
    return exists("t:ShowConfigBufName")
endfunction

"FUNCTION: s:isShowConfigOpen() {{{2
function! s:isShowConfigOpen()
    return s:getShowConfigWinNum() != -1
endfunction

"FUNCTION: s:getShowConfigWinNum() {{{2
"gets the nerd tree window number for this tab
function! s:getShowConfigWinNum()
    if exists("t:ShowConfigBufName")
        return bufwinnr(t:ShowConfigBufName)
    else
        return -1
    endif
endfunction

"FUNCTION: s:toggle(dir) {{{2
"Toggles the ShowConfig. I.e the ShowConfig is open, it is closed, if it
"is closed it is restored or initialized (if it doesnt exist)
"
"Args:
"do_verbose: whether to show a verbose listing.
function! s:toggle(do_verbose, show_commands)
  if s:showConfigExistsForTab() && g:ShowConfigRenderVerbose == a:do_verbose && g:ShowConfigRenderCommands == a:show_commands
        if !s:isShowConfigOpen()
            call s:createShowConfigWin()
            if !&hidden
                call s:renderView(a:do_verbose, a:show_commands)
            endif
            call s:restoreScreenState()
        else
            call s:closeShowConfig()
        endif
    else
        call s:initShowConfig(a:do_verbose, a:show_commands)
    endif
endfunction

"FUNCTION: s:restoreScreenState() {{{2
"
"Sets the screen state back to what it was when s:saveScreenState was last
"called.
"
"Assumes the cursor is in the ShowConfig window
function! s:restoreScreenState()
    if !exists("b:ShowConfigOldTopLine") || !exists("b:ShowConfigOldPos") || !exists("b:ShowConfigOldWindowSize")
        return
    endif
    exec("silent vertical resize ".b:ShowConfigOldWindowSize)

    let old_scrolloff=&scrolloff
    let &scrolloff=0
    call cursor(b:ShowConfigOldTopLine, 0)
    normal! zt
    call setpos(".", b:ShowConfigOldPos)
    let &scrolloff=old_scrolloff
endfunction

"FUNCTION: s:createShowConfigWin() {{{2
"Inits the ShowConfig window. ie. opens it, sizes it, sets all the local
"options etc
function! s:createShowConfigWin()
    "create the nerd tree window
    let splitLocation = g:ShowConfigWinPos ==# "left" ? "topleft " : "botright "
    let splitSize = g:ShowConfigWinSize

    if !exists('t:ShowConfigBufName')
        let t:ShowConfigBufName = s:nextBufferName()
        silent! exec splitLocation . splitSize . ' new'
        silent! exec "edit " . t:ShowConfigBufName
    else
        silent! exec splitLocation . splitSize . ' split'
        silent! exec "buffer " . t:ShowConfigBufName
    endif

    setlocal winfixwidth
    call s:setCommonBufOptions()
endfunction

"FUNCTION: s:closeShowConfig() {{{2
"Closes the primary NERD tree window for this tab
function! s:closeShowConfig()
    if !s:isShowConfigOpen()
        throw "ShowConfig.NoShowConfigFoundError: no ShowConfig is open"
    endif

    if winnr("$") != 1
        if winnr() == s:getShowConfigWinNum()
            call s:exec("wincmd p")
            let bufnr = bufnr("")
            call s:exec("wincmd p")
        else
            let bufnr = bufnr("")
        endif

        call s:exec(s:getShowConfigWinNum() . " wincmd w")
        close
        call s:exec(bufwinnr(bufnr) . " wincmd w")
    else
        close
    endif
endfunction

"FUNCTION: s:closeShowConfigIfOpen() {{{2
"Closes the NERD tree window if it is open
function! s:closeShowConfigIfOpen()
   if s:isShowConfigOpen()
      call s:closeShowConfig()
   endif
endfunction

"FUNCTION: s:initShowConfig(do_verbose, show_commands) {{{2
"Initialise the ShowConfig for this tab.
"
function! s:initShowConfig(do_verbose, show_commands)
    if s:showConfigExistsForTab()
        if s:isShowConfigOpen()
            call s:closeShowConfig()
        endif
        unlet t:ShowConfigBufName
    endif

    call s:createShowConfigWin()
    call s:renderView(a:do_verbose, a:show_commands)

    silent doautocmd User ShowConfigInit
endfunction

"FUNCTION: s:renderView {{{2
"The entry function for rendering the tree
function! s:renderView(do_verbose, show_commands)
    let g:ShowConfigRenderVerbose = a:do_verbose
    let g:ShowConfigRenderCommands = a:show_commands

    setlocal modifiable

    "remember the top line of the buffer and the current line so we can
    "restore the view exactly how it was
    let curLine = line(".")
    let curCol = col(".")
    let topLine = line("w0")

    "delete all lines in the buffer (being careful not to clobber a register)
    silent 1,$delete _

    "delete the blank line before the help and add one after it
    if g:ShowConfigMinimalUI == 0
        call setline(line(".")+1, "")
        call cursor(line(".")+1, col("."))
    endif

    "add header line
    call setline(line(".")+1, "All Mappings:")
    call cursor(line(".")+1, col("."))

    let all_mappings = ""
    if a:show_commands
      if a:do_verbose
        redir =>> all_mappings
        silent verbose com
        redir END
      else
        redir =>> all_mappings
        silent com
        redir END
      endif
    else
      if a:do_verbose
        redir =>> all_mappings
        silent verbose map
        silent verbose map!
        redir END
      else
        redir =>> all_mappings
        silent map
        silent map!
        redir END
      endif
    endif
    "redir =>> all_commands
    "if a:do_verbose
    "  silent verbose com
    "else
    "  silent com
    "endif
    "redir END

    "draw the tree
    let old_o = @o
    let @o = all_mappings
    silent put o
    let @o = old_o

    "delete the blank line at the top of the buffer
    silent 1,1delete _

    "restore the view
    let old_scrolloff=&scrolloff
    let &scrolloff=0
    call cursor(topLine, 1)
    normal! zt
    call cursor(curLine, curCol)
    let &scrolloff = old_scrolloff

    setlocal nomodifiable
endfunction

amenu P&lugin.S&how.Commands :ToggleShowCommands<CR>
amenu P&lugin.S&how.Mappings :ToggleShowMappings<CR>
