-- Define global variables that are useful in subsequently sourced lua scripts.
local global   = {}

-- Local module variables
local os_name  = vim.uv.os_uname().sysname
local path_sep = string.find(os_name, 'Windows') and '\\' or '/'
-- Resolves via USERPROFILE on Windows and HOME on unix, so it works even when
-- nvim is launched outside a shell (e.g. Explorer) where HOME/USER are unset.
local home     = vim.uv.os_homedir()

function global:load_variables()
  self.config_module = nil
  self.is_mac        = string.find(os_name, 'Darwin')
  self.is_linux      = string.find(os_name, 'Linux')
  self.is_windows    = string.find(os_name, 'Windows')
  self.vim_path      = vim.fn.stdpath('config')  -- path to nvim config, e.g. ~/.config/nvim
  self.lua_dir       = self.vim_path .. path_sep .. 'lua'
  self.modules_dir   = self.vim_path .. path_sep .. 'modules'
  self.cache_dir     = home .. path_sep ..'.cache'.. path_sep ..'nvim'.. path_sep
  self.path_sep      = path_sep
  self.home          = home
  self.data_dir      = string.format('%s/site/',vim.fn.stdpath('data'))

  -- Function to check whether the cfg_name exists in the current working directory.
  -- returns 1 if it's not present and 0 if it's present
  -- we need to compare it with 1 because both 0 and 1 is `true` in lua
  self.is_cfg_present = function(cfg_name)
    return vim.fn.empty(vim.fn.glob(vim.uv.cwd() .. path_sep .. cfg_name)) ~= 1
  end
end

-- Populate the global.* variables/functions that are returned by this module.
global:load_variables()

-- Add a put() function that supports ":lua put(foo)" instead of ":lua print(vim.inspect(foo))"
-- Recommended in the old lua guide (the new guide is in :he lua-guide)
--    https://github.com/nanotee/nvim-lua-guide/blob/master/OLD_README.md#tips-3
function _G.put(...)
  local objects = {}
  for i = 1, select('#', ...) do
    local v = select(i, ...)
    table.insert(objects, vim.inspect(v))
  end

  print(table.concat(objects, '\n'))
  return ...
end

return global
