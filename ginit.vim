" Use a ! to supress fixed width metric warning from Qt.
" Nerd Fonts can be found at https://github.com/ryanoasis/nerd-fonts/

" Old fonts that were not so bad
"Guifont! Roboto Mono Medium:h7
"Guifont! JetBrains Mono:h8:b
"Guifont! Roboto Mono Medium for Powerlin:h7

" When no fonts are downloaded, this is ok on a laptop screen but not a monitor.
"Guifont! Consolas:h8

" This is the Medium version (~ same as Powerline). Some icons still cause alignment issues.
if exists("g:neovide")
  "set guifont=RobotoMono\ NF:h7
  set guifont=RobotoMono\ NF:h6.5:#e-subpixelantialias:#h-full
else
  Guifont! RobotoMono NF:h7
endif

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
