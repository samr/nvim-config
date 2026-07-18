local autocmd = vim.api.nvim_create_autocmd
local augroup = function(name)
  return vim.api.nvim_create_augroup(name, { clear = true })
end

-- Buffer autocmds.
local bufs = augroup('bufs')
-- Do not keep undo files for temporary or generated files.
autocmd('BufWritePre', {
  group = bufs,
  pattern = { '/tmp/*', 'COMMIT_EDITMSG', 'MERGE_MSG', '*.tmp', '*.bak' },
  command = 'setlocal noundofile',
})
autocmd('BufWritePre', { group = bufs, pattern = '*.tsx', command = 'Format' })

-- Window autocmds.
local wins = augroup('wins')
-- Force write shada on leaving nvim.
autocmd('VimLeave', { group = wins, command = 'wshada!' })
-- Check if file changed when its window is focused, more eager than 'autoread'.
autocmd('FocusGained', { group = wins, command = 'checktime' })

-- Filetype autocmds.
local ft = augroup('ft')
autocmd('FileType', { group = ft, pattern = 'NvimTree', command = 'hi Cursor blend=100' })
autocmd('FileType', {
  group = ft,
  pattern = 'dashboard',
  command = 'set showtabline=0 | autocmd WinLeave <buffer> set showtabline=2',
})
autocmd('FileType', {
  group = ft,
  pattern = 'cpp',
  command = 'setlocal shiftwidth=4 tabstop=4 softtabstop=4 textwidth=120 expandtab wrap cindent'
    .. ' cinoptions=h1,l1,g1,t0,i4,+4,(0,w1,W4',
})
