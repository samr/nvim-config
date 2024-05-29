local global = require('global')

vim.cmd("command! -nargs=0 LspClearLineDiagnostics lua require('mode-diagnostic')()")
vim.cmd('command! -nargs=0 LspLog call v:lua.open_lsp_log()')
vim.cmd('command! -nargs=0 LspRestart call v:lua.reload_lsp()')

-- Add a text object for selecting block C++ comments. Requires code in 'plugin/cpp_block_comment.vim'
-- Note that this creates "ic" as a textobj for block comments that use //, while "ac" uses treesitter to create
-- a textobj for block comments that use /**/.
vim.api.nvim_exec([[
augroup cpp_textobjs
  autocmd!

  autocmd VimEnter call textobj#user#plugin('cppblockcomment', {
  \   '-': {
  \     '*sfile*': expand('<sfile>:p'),
  \     'select-i-function': 'GetLinesForBlockComment',
  \     'select-i': 'ic',
  \   },
  \ })

  autocmd FileType cpp call textobj#user#map('cppblockcomment', {
  \   '-': {
  \     'select-a': '<buffer> ac',
  \     'select-i': '<buffer> ic',
  \   },
  \ })
augroup END
]], false)
