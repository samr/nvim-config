local global = require('global')

vim.cmd("command! -nargs=0 LspClearLineDiagnostics lua require('mode-diagnostic')()")
vim.cmd('command! -nargs=0 LspLog call v:lua.open_lsp_log()')
vim.cmd('command! -nargs=0 LspRestart call v:lua.reload_lsp()')

-- since we lazy load packer.nvim, we need to load it when we run packer-related commands
vim.cmd "silent! command PackerCompile lua require 'packer_plugins' require('packer').compile()"
vim.cmd "silent! command PackerInstall lua require 'packer_plugins' require('packer').install()"
vim.cmd "silent! command PackerStatus lua require 'packer_plugins' require('packer').status()"
vim.cmd "silent! command PackerSync lua require 'packer_plugins' require('packer').sync()"
vim.cmd "silent! command PackerUpdate lua require 'packer_plugins' require('packer').update()"
vim.cmd "silent! command PackerClean lua require 'packer_plugins' require('packer').clean()"

-- TODO: Enable this again, once we figure out the textobj error.
-- Add a text object for selecting block C++ comments. Requires code in 'plugin/cpp_block_comment.vim'
-- Note that this creates "ic" as a textobj for block comments that use //, while "ac" uses treesitter to create
-- a textobj for block comments that use /**/.
-- vim.api.nvim_exec([[
-- call textobj#user#plugin('cppblockcomment', {
--     \   '-': {
--     \     '*sfile*': expand('<sfile>:p'),
--     \     'select-i-function': 'GetLinesForBlockComment',
--     \     'select-i': 'ic',
--     \   },
--     \ })
-- 
-- augroup cpp_textobjs
--   autocmd!
--   autocmd FileType cpp call textobj#user#map('cppblockcomment', {
--   \   '-': {
--   \     'select-a': '<buffer> ac',
--   \     'select-i': '<buffer> ic',
--   \   },
--   \ })
-- augroup END
-- ]], false)
