-- Key Mappings
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
--
--
-- helper function for clean mappings
local remap = vim.api.nvim_set_keymap
local eval = vim.api.nvim_eval

local function map(mode, lhs, rhs, opts)
	local options = { noremap = true, silent = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- Toggle telescope.nvim
-- remap('n', ',ff', '<CMD>lua require("telescope.builtin").find_files()<CR>', { noremap = true })
remap("n", ",ff", "<CMD>Telescope find_files<CR>", { noremap = true })
remap("n", ",fh", "<cmd>Telescope oldfiles<CR>", { noremap = true }) --fuzzy
remap("n", ",fc", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { noremap = true })
remap("n", ",fb", "<cmd>Telescope buffers<CR>", { noremap = true })
remap("n", ",fs", '<CMD>lua require("telescope.builtin").live_grep()<CR>', { noremap = true })
remap("n", ",fg", '<CMD>lua require("plugins.telescope").grep_prompt()<CR>', { noremap = true, silent = true })
-- remap('n', ',ft', '<CMD>lua require("telescope.builtin").helptags()<CR>', { noremap = true })
-- TODO: Enable once sql.nvim has windows support...
--remap('n', ',fe', "<CMD>lua require('telescope').extensions.frecency.frecency()<CR>", {noremap = true, silent = true})
--remap('n', ',fh', '<CMD>lua require("plugins.telescope").oldfiles_buffers()<CR>', { noremap = true })
--remap('n', ',fb', '<CMD>lua require("telescope.builtin").buffers()<CR>', { noremap = true })
--map("n", "<leader>.", "<cmd>Telescope find_files<CR>")
--map("n", "<leader>f", "<cmd>Telescope current_buffer_fuzzy_find<CR>")
--map("n", "<leader>:", "<cmd>Telescope commands<CR>")
--map("n", "<leader>bb", "<cmd>Telescope buffers<CR>")

map("n", "<leader>ww", "<cmd>HopWord<CR>") --easymotion/hop
map("n", "<leader>l", "<cmd>HopLine<CR>")
map("n", "<leader>tz", "<cmd>TZAtaraxis<CR>") --ataraxis
map("n", "<leader>op", "<cmd>NvimTreeToggle<CR>") --nvimtree
-- map("n", "<leader>tw", "<cmd>set wrap!<CR>") --nvimtree

if vim.g.neovide then
  -- neovide needs these defined here instead of ginit.vim
  map("n", "<c-k>", "<cmd>wincmd k<CR><cmd>wincmd _<CR>") --ctrlhjkl to navigate splits
  map("n", "<c-j>", "<cmd>wincmd j<CR><cmd>wincmd _<CR>")
else
  map("n", "<c-k>", "<cmd>wincmd k<CR>") --ctrlhjkl to navigate splits
  map("n", "<c-j>", "<cmd>wincmd j<CR>")
end
map("n", "<c-h>", "<cmd>wincmd h<CR>")
map("n", "<c-l>", "<cmd>wincmd l<CR>")

-- prevent typo when pressing `wq` or `q`
vim.cmd([[
  cnoreabbrev <expr> W ((getcmdtype() is# ':' && getcmdline() is# 'W')?('w'):('W'))
  cnoreabbrev <expr> Q ((getcmdtype() is# ':' && getcmdline() is# 'Q')?('q'):('Q'))
  cnoreabbrev <expr> WQ ((getcmdtype() is# ':' && getcmdline() is# 'WQ')?('wq'):('WQ'))
  cnoreabbrev <expr> Wq ((getcmdtype() is# ':' && getcmdline() is# 'Wq')?('wq'):('Wq'))
]])

-- Fast saving
remap("n", ";w", ":w!<CR>", { noremap = false })
remap("n", ";s", ":w!<CR>", { noremap = false })

-- Move cursor up/down a page using ALT+[ui]
remap("n", "<A-i>", "<C-B>", { noremap = true, silent = true })
remap("n", "<A-u>", "<C-F>", { noremap = true, silent = true })

-- Move cursor up/down many lines using ALT+[jk]
remap("n", "<A-k>", "10k", { noremap = true })
remap("n", "<A-j>", "10j", { noremap = true })

-- Move a line of text using ALT+[jk] in visual mode
remap("v", "<A-k>", ":m'<-2<cr>`>my`<mzgv`yo`z", { noremap = true })
remap("v", "<A-j>", ":m'>+<cr>`<my`>mzgv`yo`z", { noremap = true })

-- Use Shift-[jklh] to move around paragraphs and big words
remap("n", "K", "{", { noremap = true })
remap("n", "J", "}", { noremap = true })
remap("n", "L", "W", { noremap = true })
remap("n", "H", "B", { noremap = true })

-- Easy toggle between .h/.cpp/.hpp filetypes using plugin: tpope/vim-projectionist
remap("n", ";e", ":A<CR>", { noremap = true })
remap("n", ";E", ":AD<CR>", { noremap = true })

-- cd/lcd to the directory of the current file
remap("n", ";cd", ':exe ":cd " . expand("%:p:h")<CR>', { noremap = true })
remap("n", ";lcd", ':exe ":lcd " . expand("%:p:h")<CR>', { noremap = true })

-- Toggle mundo
remap("n", "<F4>", "<CMD>MundoToggle<CR>", { noremap = true })

-- Show mappings
remap("n", ",m", ":ToggleShowMappings<CR>", { noremap = true, silent = true })
remap("n", ",com", ":ToggleShowCommands<CR>", { noremap = true, silent = true })
--remap('n', ',', ':<C-u>WhichKey ","<CR>', { noremap = true, silent = true })
remap("n", ";", ':<C-u>WhichKey ";"<CR>', { noremap = true, silent = true })
remap("n", "\\", ':<C-u>WhichKey "\\\\"<CR>', { noremap = true, silent = true })

-- Show buffers & buffer movements
remap("n", ",B", "<CMD>BufExplorer<CR>", { noremap = true, silent = true, script = true })
--remap('i', ',B', '<C-o><CMD>BufExplorer<CR>', { noremap = true, silent = true, script = true })
remap("n", "<A-]>", ":Swbn<CR>", { noremap = true })
remap("n", "<A-[>", ":Swbp<CR>", { noremap = true })
--remap('', '<A-j>', '<CMD>Sayonara!<CR>', { noremap = true })
--remap('', '<A-k>', '<CMD>Sayonara<CR>', { noremap = true })
--remap('', '<A-h>', '<CMD>bp<CR>', { noremap = true })
--remap('', '<A-l>', '<CMD>bn<CR>', { noremap = true })

-- Use jj instead of Esc
-- 4 mappings to prevent typos :p
remap("i", "jj", "<Esc><Esc>", { noremap = true })
remap("i", "Jj", "<Esc><Esc>", { noremap = true })
remap("i", "jJ", "<Esc><Esc>", { noremap = true })
remap("i", "JJ", "<Esc><Esc>", { noremap = true })

-- Better movement between windows
if vim.g.neovide then
  -- neovide needs these defined here instead of ginit.vim
  remap("n", "<C-j>", "<C-w><C-j><C-w>_", { noremap = true })
  remap("n", "<C-k>", "<C-w><C-k><C-w>_", { noremap = true })
else
  remap("n", "<C-j>", "<C-w><C-j>", { noremap = true })
  remap("n", "<C-k>", "<C-w><C-k>", { noremap = true })
end
remap("n", "<C-h>", "<C-w><C-h>", { noremap = true })
remap("n", "<C-l>", "<C-w><C-l>", { noremap = true })

-- Resize buffer easier
remap("n", "<Left>", "<CMD>vertical resize +2<CR>", { noremap = true })
remap("n", "<Right>", "<CMD>vertical resize -2<CR>", { noremap = true })
remap("n", "<Up>", "<CMD>resize +2<CR>", { noremap = true })
remap("n", "<Down>", "<CMD>resize -2<CR>", { noremap = true })

-- Move vertically by visual line on wrapped lines
remap("n", "j", "gj", { noremap = true })
remap("n", "k", "gk", { noremap = true })

-- Move vertically by visual line on wrapped lines
remap("n", "j", "gj", { noremap = true })
remap("n", "k", "gk", { noremap = true })

-- Better yank behaviour
remap("n", "Y", "y$", { noremap = true })

-- Remove annoying exmode
remap("n", "Q", "<Nop>", { noremap = true })
remap("n", "q:", "<Nop>", { noremap = true })

-- Copy to system clipboard
remap("v", "<A-y>", '"+y', { noremap = true })

-- Yank and paste (requires set clipboard=unnamedplus)
remap("x", "<Leader>y", '"+y', { noremap = true })
remap("x", "<Leader>d", '"+d', { noremap = true })
remap("x", "<Leader>p", '"+p', { noremap = true })
remap("x", "<Leader>P", '"+P', { noremap = true })
remap("n", "<Leader>p", '"+p', { noremap = true })
remap("n", "<Leader>P", '"+P', { noremap = true })

-- Run luafile on current file
remap("n", "<Leader>r", "<CMD>luafile %<CR>", { noremap = true })

-- Toggle colorizer
remap("n", "<Leader>c", "<CMD>ColorizerToggle<CR>", { noremap = true })

-- Better indenting experience
remap("v", "<", "<gv", { noremap = true })
remap("v", ">", ">gv", { noremap = true })

-- Commenting
remap("", ",cc", "<Plug>NERDCommenterAlignLeft", {})
remap("", ",cu", "<Plug>NERDCommenterUncomment", {})

-- Clang format
-- TODO: Set these up somewhere
-- let g:clang_format_path = 'C:/Applications/LLVM10/bin/clang-format.exe'
-- function! ClangFormatWholeFile()
--   let l:lines="all"
--   py3file C:\Applications\LLVM10\share\clang\clang-format.py
-- endfunction
--remap('v', ',cf', ':ClangFormat<CR>', { noremap = true })
--remap('n', ',cf', ':ClangFormatWholeFile()<CR>', { noremap = true })
remap("v", ",cf", "<CMD>FormatWrite<CR>", { noremap = true })
remap("n", ",cf", "<CMD>FormatWrite<CR>", { noremap = true })

remap("n", "gf", "<CMD>Format<CR>", { silent = true, noremap = true })
remap("n", ",cf", "<CMD>Format<CR>", { silent = true, noremap = true })

-- Return the syntax highlighting group that the current "thing" under the cursor belongs to.
-- nmap <silent> ,qq :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<' . synIDattr(synID(line("."),col("."),0),"name") . "> lo<" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

-- ===[ Quickfix and Location Lists ]=== {{{1
--
-- TODO: Port these... or use something else.
-- function! GetBufferList()
--   redir =>buflist
--   silent! ls
--   redir END
--   return buflist
-- endfunction
--
-- " For toggling quickfix and location lists
-- function! ToggleList(bufname, pfx)
--   let buflist = GetBufferList()
--   for bufnum in map(filter(split(buflist, '\n'), 'v:val =~ "'.a:bufname.'"'), 'str2nr(matchstr(v:val, "\\d\\+"))')
--     if bufwinnr(bufnum) != -1
--       exec('botright '.a:pfx.'close')
--       return
--     endif
--   endfor
--   if a:pfx == 'l' && len(getloclist(0)) == 0
--       echohl ErrorMsg
--       echo "Location List is Empty."
--       return
--   endif
--   let winnr = winnr()
--   exec('botright '.a:pfx.'open')
--   if winnr() != winnr
--     wincmd p
--   endif
-- endfunction
--
-- nmap <silent> ;t :call ToggleList("Quickfix List", 'c')<CR>
-- nmap <silent> ;lt :call ToggleList("Location List", 'l')<CR>

remap("n", ";ln", ":lnext<CR>", { noremap = true, silent = true })
remap("n", ";lp", ":lprevious<CR>", { noremap = true, silent = true })

remap("n", ";n", ":cnext<CR>", { noremap = true, silent = true })
remap("n", ";p", ":cprevious<CR>", { noremap = true, silent = true })
remap("n", ";o", ":botright copen<CR>", { noremap = true, silent = true })
remap("n", ";O", ":botright cclose<CR>", { noremap = true, silent = true })
remap("n", ";N", ":cnfile<CR>", { noremap = true, silent = true })
remap("n", ";P", ":cpfile<CR>", { noremap = true, silent = true })

-- ===[ LSP Mappings ]=== {{{1
--
-- These are mostly determined here but some are optionally added depending on the LSP's capabilities in
-- lua\plugins\lspconfig.lua.
remap("n", "gK", "<cmd>lua vim.lsp.buf.hover()<CR>", { noremap = true, silent = true })
remap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { noremap = true, silent = true })
remap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", { noremap = true, silent = true })
remap("n", "gD", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", { noremap = true, silent = true })
remap("n", "gr", '<cmd>lua require"telescope.builtin".lsp_references()<CR>', { noremap = true, silent = true })
remap("n", "gR", "<cmd>lua vim.lsp.buf.rename()<CR>", { noremap = true, silent = true })
remap("n", "gw", "<cmd>lua vim.lsp.buf.document_symbol()<CR>", { noremap = true, silent = true })
remap("n", "ga", "<cmd>lua vim.lsp.buf.code_action()<CR>", { noremap = true, silent = true })
remap(
	"n",
	"go",
	"<cmd>lua vim.lsp.buf.code_action({source = {organizeImports = true}})<CR>",
	{ noremap = true, silent = true }
)
remap("n", "gt", ":call v:lua.toggle_diagnostics()<CR>", { silent = true, noremap = true })

-- I don't like input mode mappings that collide with words like "length"
--remap('i', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<CR>', { noremap = true, silent = true })
--remap('i', 'gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', { noremap = true, silent = true })

-- Few language severs support these three
remap("n", "<leader>ff", "<cmd>lua vim.lsp.buf.formatting()<CR>", { noremap = true, silent = true })
remap("n", "<leader>ai", "<cmd>lua vim.lsp.buf.incoming_calls()<CR>", { noremap = true, silent = true })
remap("n", "<leader>ao", "<cmd>lua vim.lsp.buf.outgoing_calls()<CR>", { noremap = true, silent = true })

-- if diagnostic plugin is installed
remap("n", "<leader>ep", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", { noremap = true, silent = true })
remap("n", "<leader>en", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", { noremap = true, silent = true })
remap("n", "<leader>eo", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", { noremap = true, silent = true })

-- Text objects for plugin 'David-Kunz/treesitter-unit'
remap("x", "iu", ':lua require"treesitter-unit".select()<CR>', { noremap = true })
remap("x", "au", ':lua require"treesitter-unit".select(true)<CR>', { noremap = true })
remap("o", "iu", ':<c-u>lua require"treesitter-unit".select()<CR>', { noremap = true })
remap("o", "au", ':<c-u>lua require"treesitter-unit".select(true)<CR>', { noremap = true })

-- Mapping for plugin 'mfussenegger/nvim-treehopper'
remap("o", "m", ':<c-u>lua require"tsht".nodes()<CR>', { noremap = false })
remap("v", "m", ':lua require"tsht".nodes()<CR>', { noremap = true })

-- Mapping for plugin "stevearc/aerial.nvim",
remap("n", "<leader>a", "<cmd>AerialToggle!<CR>", {})

-- Toggle marker based folds
remap("n", "<F11>", "&foldmethod == 'marker' ? ':set foldmethod=manual<CR>zE<CR>' : ':set foldmethod=marker<CR>zM<CR>'", { noremap = true, expr = true })

-- ===[ Platform Specific Mappings ]=== {{{1

-- =[ Windows ]= --
if vim.fn.has("win32") == 1 then
	-- remap('n', '<A-/>', ':set hlsearch! hlsearch?<CR>', {noremap = true, silent = true}) -- toggle search highlighting
	remap("n", "<A-/>", ":nohl<CR>", { noremap = true, silent = true }) -- toggle search highlighting (usually off)

	remap("n", "<F10>", "<CMD>Guifont! JetBrains Mono:h8:b<CR>", { noremap = true })
	remap("n", "<F9>", "<CMD>Guifont! Roboto Mono Medium for Powerlin:h7<CR>", { noremap = true })

	-- Toggle filesystem viewer
	remap("n", "<F2>", "<CMD>NeoTreeRevealToggle<CR>", { noremap = true })
	remap("n", "<F3>", "<CMD>Fern . -reveal=%<CR>", { noremap = true })

-- =[ MacOS ]= --
elseif vim.fn.has("mac") == 1 then
	-- Toggle filesystem viewer
	remap("n", "<F3>", "<CMD>NeoTreeRevealToggle<CR>", { noremap = true })

-- =[ Linux (or other) ]= --
else
	-- Toggle filesystem viewer
	remap("n", "<F3>", "<CMD>NeoTreeRevealToggle<CR>", { noremap = true })

	-- Preview things in their native app
	-- vim.cmd('command! -nargs=0 PreviewFile lua require"modules.util".xdg_open()') -- alternative way
	-- remap('n', 'gx', 'call v:lua.Util.xdg_open()<CR>', { noremap = true, silent = true })
end
