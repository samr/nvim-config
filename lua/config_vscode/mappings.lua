--
local global = require('global')

local vscode = require('vscode')

local remap = vim.api.nvim_set_keymap
local eval = vim.api.nvim_eval

local function map(mode, lhs, rhs, opts)
	local options = { noremap = true, silent = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- === [ Code Navigation ]== {{{1
--
--   https://github.com/vscode-neovim/vscode-neovim#code-navigation-bindings
--   https://github.com/vscode-neovim/vscode-neovim/blob/master/runtime/vscode/overrides/vscode-code-actions.vim
--
-- gd / C-]  editor.action.revealDefinition -- Also works in vim help.
-- gf        editor.action.revealDeclaration
-- C-w gd    editor.action.revealDefinitionAside
-- C-w gf    editor.action.revealDeclarationAside
-- gD        editor.action.peekDefinition
-- gF        editor.action.peekDeclaration
-- gh / K    editor.action.showHover
-- gH        editor.action.referenceSearch.trigger
-- gO        workbench.action.gotoSymbol
-- C-p       fuzzy find file
-- C-p       Navigate lists, parameter hints, suggestions, quick-open, cmdline history, peek reference list
-- C-S-p     fuzzy find any installed action by description  (note to reload config type this and search "reload window")
-- C-S-e     show the current file in the left sidebar
-- C-S-m     toggle the bottom tray problems (works as a universal way to show/hide the bottom)
-- C-b       toggle the left sidebar (in whatever context it was last in)
-- C-0       move context/focus to the left sidebar
-- C-1       move context/focus to the editor
-- C-2       move context/focus to the right editor (or open an editor split, if not yet split)
-- gt        next tab (within a window)
-- gT        previous tab (within a windows)
-- C-PgUp    next tab (across all windows)
-- C-PgDn    previous tab (across all windows)
-- A-o       switch between header and source
-- z=        quickfix

-- https://github.com/vscode-neovim/vscode-neovim/blob/master/runtime/vscode/overrides/vscode-window-commands.vim
-- C-hjkl to navigate splits
map("n", "<c-j>", "<cmd>call VSCodeNotify('workbench.action.navigateDown')<CR><cmd>call VSCodeNotify('workbench.action.toggleEditorWidths')<CR>")
map("n", "<c-k>", "<cmd>call VSCodeNotify('workbench.action.navigateUp')<CR><cmd>call VSCodeNotify('workbench.action.toggleEditorWidths')<CR>")
map("n", "<c-h>", "<cmd>call VSCodeNotify('workbench.action.navigateLeft')<CR>")
map("n", "<c-l>", "<cmd>call VSCodeNotify('workbench.action.navigateRight')<CR>")

-- Note that to get the Alt key to work in a mapping requires a VSCode keybinding passthrough.
--     Goto Preferences -> Keyboard Shortcuts (click icont to open keyboard shortcuts JSON).
-- The file itself is probably found in:
--     C:\Users\$USER\AppData\Roaming\Code\User\keybindings.json
--
-- Add the following entry to keybindings.json:
--    {
--        "command": "vscode-neovim.send",
--        "key": "alt+/",
--        "when": "editorTextFocus && neovim.mode != insert",
--        "args": "<A-/>",
--    },
--
remap("n", "<A-/>", ":nohl<CR>", { noremap = true, silent = true }) -- toggle search highlighting (usually off)

-- Move cursor up/down a page using ALT+[ui]. This is mapped in keybindings.json instead of here with:
--    {
--      "command": "vscode-neovim.ctrl-b",
--      "key": "alt+i",
--      "when": "editorTextFocus && neovim.ctrlKeysNormal.f && neovim.init && neovim.mode != 'insert' && editorLangId not in 'neovim.editorLangIdExclusions'"
--    },
--
--remap("n", "<A-i>", "<C-b>", { noremap = true, silent = true })
--remap("n", "<A-u>", "<C-f>", { noremap = true, silent = true })

-- Move cursor up/down many lines using ALT+[jk]   (note, add entries similar to A-/)
remap("n", "<A-k>", "10k", { noremap = true })
remap("n", "<A-j>", "10j", { noremap = true })

-- Move a line of text using ALT+[jk] in visual mode
remap("v", "<A-k>", ":m'<-2<cr>`>my`<mzgv`yo`z", { noremap = true })
remap("v", "<A-j>", ":m'>+<cr>`<my`>mzgv`yo`z", { noremap = true })

-- === [ Code Modification ]== {{{1
--
-- gq / =    editor.action.formatSelection (applied to block)
-- gqq / ==  editor.action.formatSelection (applied to line)
-- gc / C-/  comment block
-- gcc / C-/ comment line

-- Format code (probably clang-format.
local code_format = vscode.to_op(function(ctx)
  vscode.action("editor.action.formatSelection", { range = ctx.range, callback = esc })
end)
vim.keymap.set({"n", "x"}, ",cf", code_format, { expr = true })

-- Open refactor menu while something is highlighted,
--   https://github.com/vscode-neovim/vscode-neovim?tab=readme-ov-file#vscodewith_insertcallback
vim.keymap.set({ "n", "x" }, ",r", function()
  vscode.with_insert(function()
    vscode.action("editor.action.refactor")
  end)
end)

-- -- Find the current word in files.
-- local find_in_files = vscode.to_op(function(ctx)
--   vscode.action("workbench.action.findInFiles", { args = { query = vim.fn.expand('<cword>') } })
-- end)
-- vim.keymap.set({"n", "x"}, "?", find_in_files, { noremap = true })

-- Better indenting experience
remap("v", "<", "<gv", { noremap = true })
remap("v", ">", ">gv", { noremap = true })

