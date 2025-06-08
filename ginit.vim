" Use a ! to supress fixed width metric warning from Qt.
" Nerd Fonts can be found at:
"   https://www.nerdfonts.com/font-downloads
"   https://github.com/ryanoasis/nerd-fonts/
"
" On Linux:
"   1.) Download a Nerd Font
"   2.) Unzip and copy to ~/.fonts
"   3.) Run the command "sudo fc-cache -fv" to manually rebuild the font cache
"
" Old fonts that were not so bad
"Guifont! Roboto Mono Medium:h7
"Guifont! JetBrains Mono:h8:b
"Guifont! Roboto Mono Medium for Powerlin:h7

" When no fonts are downloaded, this is ok on a laptop screen but not a monitor.
"Guifont! Consolas:h8

" Note: In the terminal, nvim just uses the terminal's font.

" Save and allow adjusting of font and font size using a function.
if exists("g:neovide")
  let g:my_guifont = "RobotoMono\\ NF"
  let g:my_guifontsize = 6.5
  exe "set guifont=" . g:my_guifont . ":h" . g:my_guifontsize . ":#e-subpixelantialias:#h-full"
elseif has("Linux")
  let g:my_guifont="JetBrainsMono\\ Nerd\\ Font"
  let g:my_guifontsize = 7
  exe "set guifont=" . g:my_guifont . ":h" . g:my_guifontsize
else
  let g:my_guifont = "RobotoMono\\ NF"
  let g:my_guifontsize = 7
  " TODO: no idea if we can use set guifont here instead...
  Guifont! RobotoMono NF:h7
endif

function! AdjustFontSize(amount)
  let g:my_guifontsize = g:my_guifontsize + a:amount
  if exists("g:neovide")
    " echom "set guifont=" . g:my_guifont . ":h" . g:my_guifontsize . ":#e-subpixelantialias:#h-full"
    exe "set guifont=" . g:my_guifont . ":h" . g:my_guifontsize . ":#e-subpixelantialias:#h-full"
  else
    " echom "set guifont=" . g:my_guifont . ":h" . g:my_guifontsize
    exe "set guifont=" . g:my_guifont . ":h" . g:my_guifontsize
  endif
endfunction

" Map <C-ScrollWheelUp> to increase font size
noremap <C-ScrollWheelUp> :call AdjustFontSize(0.5)<CR>
" Map <C-ScrollWheelDown> to decrease font size
noremap <C-ScrollWheelDown> :call AdjustFontSize(-0.5)<CR>

"" Set a thin cursor for both insert and visual mode
"" This does not seem to work with nvim-qt
"set guicursor=n-c:block-Cursor
"set guicursor+=i:ver100-iCursor
"set guicursor+=v:ver100-iCursor

" Windows related mappings (see windows.txt in help)
"nnoremap <C-j> <C-W>j  " go down one window
"nnoremap <C-k> <C-W>k  " go up one window
nnoremap <C-j> <C-W>j<C-W>_  " go down one window
nnoremap <C-k> <C-W>k<C-W>_  " go up one window
nnoremap <C-h> <C-W>h  " go left one window
nnoremap <C-l> <C-W>l  " go right one window
nnoremap <C-y> <C-W>=  " make all windows equal/balanced

"nnoremap <C-u> <C-W>c  " close current window
"inoremap <C-j> <Down>

" No annoying sound or flash on errors.
set vb t_vb=

" Allow selecting text with the mouse.
set mouse=a

" Paste with middle mouse click
vmap <LeftRelease> "*ygv

" Paste with <Shift> + <Insert>
imap <S-Insert> <C-R>*

set selection=inclusive " make the cursor select what is under it
set showtabline=1  " Show tabs only when there is more than one tab
set guioptions-=e  " Don't use GUI tabline
