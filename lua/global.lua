local global   = {}
local home     = os.getenv("HOME")
local os_name  = vim.loop.os_uname().sysname
local path_sep = string.find(os_name, 'Windows') and '\\' or '/'

function global:load_variables()
  self.is_mac      = string.find(os_name, 'Darwin')
  self.is_linux    = string.find(os_name, 'Linux')
  self.is_windows  = string.find(os_name, 'Windows')
  self.vim_path    = vim.fn.stdpath('config')
  self.cache_dir   = home .. path_sep ..'.cache'.. path_sep ..'nvim'.. path_sep
  self.modules_dir = self.vim_path .. path_sep..'modules'
  self.path_sep    = path_sep
  self.home        = home
  self.data_dir    = string.format('%s/site/',vim.fn.stdpath('data'))
  self.is_cfg_present = function(cfg_name)
    -- this returns 1 if it's not present and 0 if it's present
    -- we need to compare it with 1 because both 0 and 1 is `true` in lua
    return vim.fn.empty(vim.fn.glob(vim.loop.cwd()..cfg_name)) ~= 1
  end
end

global:load_variables()

return global
