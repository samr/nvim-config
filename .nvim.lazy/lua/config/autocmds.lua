-- Autocmds
--
-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua

vim.api.nvim_create_augroup("Bufs", {})
vim.api.nvim_create_augroup("Wins", {})
vim.api.nvim_create_augroup("FT", {})

-- Do not save an undo history for these files
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = "Bufs",
  pattern = {
    "/tmp/*",
    "COMMIT_EDITMSG",
    "MERGE_MSG",
    "*.tmp",
    "*.bak",
  },
  callback = function()
    vim.api.nvim_set_option_value("undofile", false, { scope = "local" })
  end,
})

-- Force write shada on leaving nvim
vim.api.nvim_create_autocmd({ "VimLeave" }, {
  group = "Wins",
  callback = function()
    if vim.api.has("nvim") then
      vim.cmd("wshada!")
    else
      vim.cmd("wviminfo!")
    end
  end,
})

-- Update the buffer with any changes more eagerly than 'autoread'
vim.api.nvim_create_autocmd({ "FocusGained" }, {
  group = "Wins",
  callback = function()
    if vim.api.nvim_get_mode() ~= "c" then
      vim.cmd("checktime")
    end
  end,
})

-- Explicitly set some local options for C++ and CUDA files
-- TODO: Try to use a ftplugin or similar for this
vim.api.nvim_create_autocmd({ "FileType" }, {
  group = "FT",
  pattern = {
    "cpp",
    "cuda",
  },
  callback = function()
    local option_pairs = {
      shiftwidth = 4,
      tabstop = 4,
      softtabstop = 4,
      textwidth = 120,
      expandtab = true,
      wrap = true,
      cindent = true,
      cinoptions = "h1,l1,g1,t0,i4,+4,(0,w1,W4",
    }
    for name, value in pairs(option_pairs) do
      vim.api.nvim_set_option_value(name, value, { scope = "local" })
    end
  end,
})
