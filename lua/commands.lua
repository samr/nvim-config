
local global = require('global')

vim.cmd("command! -nargs=0 LspClearLineDiagnostics lua require('mode-diagnostic')()")
vim.cmd('command! -nargs=0 LspLog call v:lua.open_lsp_log()')
vim.cmd('command! -nargs=0 LspRestart call v:lua.reload_lsp()')
