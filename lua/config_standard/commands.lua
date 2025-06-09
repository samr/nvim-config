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

vim.api.nvim_create_user_command("OverseerRestartLast", function()
  local present, overseer = pcall(require, "overseer")
  if not present then
    print("overseer is not installed")
    return
  end
  local tasks = overseer.list_tasks({ recent_first = true })
  if vim.tbl_isempty(tasks) then
    vim.notify("No tasks found", vim.log.levels.WARN)
  else
    overseer.run_action(tasks[1], "restart")
  end
end, {})

vim.api.nvim_create_user_command("Grep", function(params)
  local present, overseer = pcall(require, "overseer")
  if not present then
    print("overseer is not installed")
    return
  end
  -- Insert args at the '$*' in the grepprg
  local cmd, num_subs = vim.o.grepprg:gsub("%$%*", params.args)
  if num_subs == 0 then
    cmd = cmd .. " " .. params.args
  end
  local task = overseer.new_task({
    cmd = vim.fn.expandcmd(cmd),
    components = {
      {
        "on_output_quickfix",
        errorformat = vim.o.grepformat,
        open = not params.bang,
        open_height = 8,
        items_only = true,
      },
      -- We don't care to keep this around as long as most tasks
      { "on_complete_dispose", timeout = 30 },
      "default",
    },
  })
  task:start()
end, { nargs = "*", bang = true, complete = "file" })
