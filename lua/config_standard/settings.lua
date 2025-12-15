-- Fold Commands
--   (this is first in case file opens with folds folded)

--   :set foldmethod=marker  (or <F11> currently)
--   zo/zc open/close one fold
--   zr increment foldlevel
--   zm decrement foldlevel
--   zR open all folds
--   zM close all folds
--
--=====[ Initialization ]====={{{1

local global = require('global')

-------[ Global settings ]-----{{{2

-- git
vim.g.author = "sriesland"
vim.g.author_short = "sriesland"

if global.is_windows then
  -- Set python and node provider path to make startup faster
  vim.g.python_host_prog = 'C:/Python27/python.exe'
  vim.g.python3_host_prog = 'C:/Python38/python.exe'

  -- Set the clipboard program used by the clipboard option explicitly for windows so that clipboard.vim loads faster.
  vim.g.clipboard = {
    name = 'win32yank',
    copy = {
       ['+'] = {'win32yank.exe', '-i', '--crlf'},
       ['*'] = {'win32yank.exe', '-i', '--crlf'}
    },
    paste = {
       ['+'] = {'win32yank.exe', '-o', '--lf'},
       ['*'] = {'win32yank.exe', '-o', '--lf'}
    },
    cache_enabled = 1
  }
end

-------[ Gui settings ]-----{{{2

if vim.g.neovide then
  -- Speed everything up
  vim.g.neovide_cursor_animation_length = 0.04  -- default 0.13
  vim.g.neovide_cursor_trail_size = 0.4  -- default 0.8
  vim.g.neovide_scroll_animation_length = 0.1 -- default 0.3

  -- Map the option key to the alt key on mac keyboards
  vim.g.neovide_input_macos_option_key_is_meta = 'only_left'

  if global.is_mac then
    -- Allow clipboard copy paste in neovim
    -- see https://github.com/neovide/neovide/issues/1263
    vim.g.neovide_input_use_logo = 1
  end
end

-------[ Bugs ]-----{{{2

-- Flickering when same file is open in multiple windows at different scroll positions
-- https://github.com/neovim/neovim/issues/32660
-- Disabled for now as it tends to slow things down quite a bit...
-- vim.g._ts_force_sync_parsing = true 

-------[ Assorted plugin settings ]-----{{{2

-- Auto start the coq nvim plugin, but quietly
vim.g.coq_settings = { auto_start = 'shut-up' }

-- disable git messenger default mappings
vim.g.git_messenger_no_default_mappings = true

vim.g.vimsyn_embed = "lPr" -- allow embedded syntax highlighting for lua, python, ruby

vim.g.neovide_cursor_vfx_mode = "pixiedust" -- neovide trail

-- In millisecond, used for both CursorHold and CursorHoldI, use updatetime instead if not defined
vim.g.cursorhold_updatetime = 100

-- Don't implicitly change to the directory of the opened file with vim-startify.
vim.g.startify_change_to_dir = 0

vim.g.NERDSpaceDelims = 1 -- Add a space after comment delim and before line in question.
vim.g.NERDCommentEmptyLines = 1 -- Ensure empty lines also get a comment.

-------[ airline ]-----{{{2
-- See airline faq for the rendering tradeoffs:
-- https://github.com/vim-airline/vim-airline/wiki/FAQ#the-powerline-font-symbols-are-not-showing-up
vim.g.airline_powerline_fonts = 1 -- use the nice powerline fonts
--vim.g.airline_highlighting_cache = 1 -- if you see weirdness, use :AirlineRefresh

-------[ indentline ]-----{{{2

-- Set indentline characters
vim.g.indentLine_first_char = '▏'
vim.g.indentLine_char = '▏'
vim.g.indentLine_faster = 1
vim.g.indentLine_leadingSpaceChar = '˽'

-- Set indentline ignored list
vim.g.indentLine_bufTypeExclude = {'help'}
vim.g.indentLine_bufNameExclude = {'startify', 'NERD_tree_*', 'fern'}
vim.g.indentLine_fileTypeExclude = {'markdown', 'defx', ''}

-- Enable indentation at first level
vim.g.indentLine_showFirstIndentLevel = 1

-- svelte
vim.g.vim_svelte_plugin_has_init_indent = 0

-- highlight yanked text for 250ms
--vim.cmd("au TextYankPost * silent! lua vim.highlight.on_yank{ timeout = 250 }")

-- Disable until https://github.com/vim-airline/vim-airline/issues/2324 is resolved.
-- vim.g["airline#extensions#nvimlsp#enabled"] = 0

-- To choose a theme look at the wiki:
-- https://github.com/vim-airline/vim-airline/wiki/Screenshots
vim.g.airline_theme = "deus"
