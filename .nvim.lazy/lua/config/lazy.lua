local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  -- bootstrap lazy.nvim
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

local global = require("global")

-- Create cache dir and subs dir, these are assigned in options.lua {{{1
local create_cache_dir = function()
  local data_dir = {
    global.cache_dir .. "backup",
    global.cache_dir .. "session",
    global.cache_dir .. "spell",
    global.cache_dir .. "swap",
    global.cache_dir .. "tags",
    global.cache_dir .. "undo",
    global.cache_dir .. "view",
  }
  local mkdir_cmd = "mkdir -p "
  if global.is_windows then
    mkdir_cmd = "mkdir "
  end

  -- Only check once whether cache_dir exists. If it does not then make it and
  -- the sub dirs.
  if vim.fn.isdirectory(global.cache_dir) == 0 then
    print(mkdir_cmd .. global.cache_dir)
    os.execute(mkdir_cmd .. global.cache_dir)
    for _, v in pairs(data_dir) do
      if vim.fn.isdirectory(v) == 0 then
        os.execute(mkdir_cmd .. v)
      end
    end
  end
end
create_cache_dir()

-- Disable shada file while sourcing.
vim.opt.shadafile = "NONE"

-- Load lazy.nvim and configure it to pick up plugins from the plugins directory.
require("lazy").setup({
  spec = {
    -- add LazyVim and import its plugins
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    -- import any extras modules here
    -- { import = "lazyvim.plugins.extras.lang.typescript" },
    -- { import = "lazyvim.plugins.extras.lang.json" },
    -- { import = "lazyvim.plugins.extras.ui.mini-animate" },
    -- import/override with your plugins
    { import = "plugins" },
  },
  defaults = {
    -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
    -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
    lazy = false,
    -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
    -- have outdated releases, which may break your Neovim install.
    version = false, -- always use the latest git commit
    -- version = "*", -- try installing the latest stable version for plugins that support semver
  },
  install = { colorscheme = { "tokyonight", "habamax" } },
  checker = { enabled = false }, -- automatically check for plugin updates
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "2html_plugin",
        "getscriptPlugin",
        "getscript",
        "gzip",
        "logipat",
        "netrwFileHandlers",
        "netrwSettings",
        "netrw",
        "rrhelper",
        "tarPlugin",
        "tar",
        "vimballPlugin",
        "vimball",
        "zipPlugin",
        "zip",
        --"netrwPlugin",
        --"spellfile_plugin",
        --"matchit",
        --"matchparen",
      },
    },
  },
})

-- Reenable shada file.
vim.opt.shadafile = ""
