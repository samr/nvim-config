-- Key Mappings
--
-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add or override any keymaps here
--
-- If E464 is thrown, look at command prefix by using ":verb command <cmd>"
--
-- Fold Commands
--   (this is first in case file opens with folds folded)

--   :set foldmethod=marker  (or <F11> currently)
--   zo/zc open/close one fold
--   zr increment foldlevel
--   zm decrement foldlevel
--   zR open all folds
--   zM close all folds

-- ===[ Definitions and Misc ]=== {{{1

local Util = require("lazyvim.util")

-- Function to map keys using the more modern vim.keymap API
-- This defaults to noremap, to override use remap = true in opts.
local function map(mode, lhs, rhs, opts)
  local keys = require("lazy.core.handler").handlers.keys
  ---@cast keys LazyKeysHandler
  -- do not create the keymap if a lazy keys handler exists
  if not keys.active[keys.parse({ lhs, mode = mode }).id] then
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

-- Prevent typos when pressing `wq` or `q`
vim.cmd([[
  cnoreabbrev <expr> W ((getcmdtype() is# ':' && getcmdline() is# 'W')?('w'):('W'))
  cnoreabbrev <expr> Q ((getcmdtype() is# ':' && getcmdline() is# 'Q')?('q'):('Q'))
  cnoreabbrev <expr> WQ ((getcmdtype() is# ':' && getcmdline() is# 'WQ')?('wq'):('WQ'))
  cnoreabbrev <expr> Wq ((getcmdtype() is# ':' && getcmdline() is# 'Wq')?('wq'):('Wq'))
]])

-- ===[ Primary mappings ]=== {{{1

map("n", "<leader>a", "<CMD>AerialToggle!<CR>", { desc = "Toggle Aerial" })
map("n", "<leader>uz", "<CMD>ColorizerToggle<CR>", { desc = "Toggle Colorizer" })
map("n", "<leader>up", "<CMD>NvimTreeToggle<CR>", { desc = "Toggle NvimTree" })
map("n", "<F4>", "<CMD>MundoToggle<CR>", { desc = "Toggle Mundo" })

-- map("n", "<leader>ww", "<cmd>HopWord<CR>") --easymotion/hop
-- map("n", "<leader>l", "<cmd>HopLine<CR>")
-- map("n", "<leader>tz", "<cmd>TZAtaraxis<CR>") --ataraxis

-- Move to window using the <ctrl> hjkl keys
-- map("n", "<C-h>", "<cmd>wincmd h<CR>", { desc = "Go to left window" })
-- map("n", "<C-j>", "<cmd>wincmd j<CR>", { desc = "Go to lower window" })
-- map("n", "<C-k>", "<cmd>wincmd k<CR>", { desc = "Go to upper window" })
-- map("n", "<C-l>", "<cmd>wincmd l<CR>", { desc = "Go to right window" })

-- Fast saving
map("n", ";w", ":w!<CR>", { desc = "Save file" })
map("n", ";s", ":w!<CR>", { desc = "Save file" })

-- Move cursor up/down a page using ALT+[ui]
map("n", "<A-i>", "<C-B>", { silent = true, desc = "Page up" })
map("n", "<A-u>", "<C-F>", { silent = true, desc = "Page down" })

-- Move cursor up/down many lines using ALT+[jk]
map("n", "<A-k>", "10k", { desc = "Move up +10" })
map("n", "<A-j>", "10j", { desc = "Move down +10" })

map("n", "<A-/>", ":nohl<CR>", { silent = true, desc = "Escape and clear hlsearch" }) -- toggle search highlighting (usually off)

-- cd/lcd to the directory of the current file
map("n", ";cd", ':exe ":cd " . expand("%:p:h")<CR>', { desc = "Change directory" })
map("n", ";lcd", ':exe ":lcd " . expand("%:p:h")<CR>', { desc = "Change local directory" })

-- Easy toggle between .h/.cpp/.hpp filetypes using plugin: tpope/vim-projectionist
map("n", ";e", ":A<CR>", { desc = "Alternate file" })
map("n", ";E", ":AD<CR>", { desc = "Alternate file+" })

-- Show buffers & buffer movements
map("n", ",B", "<CMD>BufExplorer<CR>", { silent = true, script = true, desc = "Open BufExplorer" })

if Util.has("bufferline.nvim") then
  map("n", "<A-[>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev buffer" })
  map("n", "<A-]>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
else
  map("n", "<A-[>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
  map("n", "<A-]>", "<cmd>bnext<cr>", { desc = "Next buffer" })
end

-- Remove annoying exmode
map("n", "Q", "<Nop>", { desc = "Exit exmode" })

-- Yank and paste (requires set clipboard=unnamedplus)
map("x", "<leader>y", '"+y', { desc = "Yank to clipboard" })
map("x", "<leader>d", '"+d', { desc = "Yank to clipboard and delete" })
map({ "x", "n" }, "<leader>p", '"+p', { desc = "Paste from clipboard before cursor" })
map({ "x", "n" }, "<leader>P", '"+P', { desc = "Paste from clipboard after cursor" })

-- Commenting
map({ "n", "v" }, ",cc", "<Plug>NERDCommenterAlignLeft", { desc = "Comment block" })
map({ "n", "v" }, ",cu", "<Plug>NERDCommenterUncomment", { desc = "Uncomment block" })

-- Clang format
map({ "n", "v" }, ",cf", "<CMD>FormatWrite<CR>", { desc = "Clang format and write" })

-- ===[ Quickfix and Location Lists ]=== {{{1

-- nmap <silent> ;t :call ToggleList("Quickfix List", 'c')<CR>
-- nmap <silent> ;lt :call ToggleList("Location List", 'l')<CR>

map("n", ";ln", ":lnext<CR>", { silent = true, desc = "Location next" })
map("n", ";lp", ":lprevious<CR>", { silent = true, desc = "Location previous" })

map("n", ";n", ":cnext<CR>", { silent = true, desc = "QFix next" })
map("n", ";p", ":cprevious<CR>", { silent = true, desc = "QFix previous" })
map("n", ";o", ":botright copen<CR>", { silent = true, desc = "QFix open file" })
map("n", ";O", ":botright cclose<CR>", { silent = true, desc = "QFix close file" })
map("n", ";N", ":cnfile<CR>", { silent = true, desc = "QFix next file" })
map("n", ";P", ":cpfile<CR>", { silent = true, desc = "QFix prev file" })

-- ===[ Platform Specific Mappings ]=== {{{1

-- =[ Windows ]= --
if vim.fn.has("win32") == 1 then
  -- map('n', '<A-/>', ':set hlsearch! hlsearch?<CR>', {silent = true}) -- toggle search highlighting
  map("n", "<A-/>", ":nohl<CR>", { silent = true }) -- toggle search highlighting (usually off)

  map("n", "<F11>", "<CMD>Guifont! Roboto Mono Medium for Powerlin:h8<CR>", { desc = "Bigger font" })
  map("n", "<F10>", "<CMD>Guifont! JetBrains Mono:h8:b<CR>", { desc = "Bigger font #2" })
  map("n", "<F9>", "<CMD>Guifont! Roboto Mono Medium for Powerlin:h7<CR>", { desc = "Smaller font" })

  map("n", "<F8>", ":set foldmethod=marker<CR>", { desc = "Enable folds" })

  -- Toggle filesystem viewer
  map("n", "<F2>", "<CMD>NeoTreeRevealToggle<CR>", { noremap = true })
  map("n", "<F3>", "<CMD>Fern . -reveal=%<CR>", { noremap = true })

-- =[ MacOS ]= --
elseif vim.fn.has("mac") == 1 then
  -- Toggle filesystem viewer
  map("n", "<F3>", "<CMD>NeoTreeRevealToggle<CR>", { noremap = true })

-- =[ Linux (or other) ]= --
else
  -- Toggle filesystem viewer
  map("n", "<F3>", "<CMD>NeoTreeRevealToggle<CR>", { noremap = true })

  -- Preview things in their native app
  -- vim.cmd('command! -nargs=0 PreviewFile lua require"modules.util".xdg_open()') -- alternative way
  -- remap('n', 'gx', 'call v:lua.Util.xdg_open()<CR>', { noremap = true, silent = true })
end
