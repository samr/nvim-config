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
  -- Set python provider path to make startup faster (the python2 provider no longer exists)
  vim.g.python3_host_prog = 'C:/Users/samri/AppData/Local/Microsoft/WindowsApps/python.exe'

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

vim.g.vimsyn_embed = "lPr" -- allow embedded syntax highlighting for lua, python, ruby

vim.g.neovide_cursor_vfx_mode = "pixiedust" -- neovide trail
