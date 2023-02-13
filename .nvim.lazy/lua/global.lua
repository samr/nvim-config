local global   = {}
local os_name  = vim.loop.os_uname().sysname
local path_sep = string.find(os_name, 'Windows') and '\\' or '/'
local home     = os.getenv("HOME")

if not home then
  if string.find(os_name, 'Windows') then
    home = "C:\\Users\\sriesland"
  else
    home = "~"
  end
end

function global:load_variables()
  self.is_mac       = string.find(os_name, 'Darwin')
  self.is_linux     = string.find(os_name, 'Linux')
  self.is_windows   = string.find(os_name, 'Windows')
  self.vim_path     = vim.fn.stdpath('config')  -- path to nvim config, e.g. ~/.config/nvim
  self.lua_dir      = self.vim_path .. path_sep .. 'lua'
  self.modules_dir  = self.vim_path .. path_sep .. 'modules'
  self.cache_dir    = home .. path_sep ..'.cache'.. path_sep ..'nvim'.. path_sep
  self.path_sep     = path_sep
  self.home         = home
  self.data_dir     = string.format('%s/site/',vim.fn.stdpath('data'))
  self.is_cfg_present = function(cfg_name)
    -- this returns 1 if it's not present and 0 if it's present
    -- we need to compare it with 1 because both 0 and 1 is `true` in lua
    return vim.fn.empty(vim.fn.glob(vim.loop.cwd()..cfg_name)) ~= 1
  end
end

global:load_variables()

-- Allow ":lua put(foo)" instead of ":lua print(vim.inspect(foo))"
-- Recommended in https://github.com/nanotee/nvim-lua-guide#the-vim-namespace
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
