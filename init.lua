-- Fold Commands
--   (this is first in case file opens with folds folded)

--   :set foldmethod=marker  (or <F11> currently)
--   zo/zc open/close one fold
--   zr increment foldlevel
--   zm decrement foldlevel
--   zR open all folds
--   zM close all folds
--
--=====[ Installation ]====={{{1
--
-- Windows:
--   Lazy.nvim
--     - Should be done automatically by this script, otherwise see https://lazy.folke.io/installation
--     - Note that one can update the plugins with :Lazy sync
--
--   Lua Language Server
--     - Install Lua5.1 on the path, probably from https://luabinaries.sourceforge.net/download.html
--     - Install luarocks, from https://luarocks.org/#quick-start
--     - cd ${DEV_DIR}
--     - git clone https://github.com/sumneko/lua-language-server
--     - git submodule update --init --recursive
--     - Source vcvars64.bat from cmd and build with CMake/Visual Studio
--     - Update lua/modules/lsp/init.lua to set "local sumenko_root = ${DEV_DIR}/lua-language-server"
--
--   Python Support
--     - Ensure the following executables are in your path:
--        - python3, pip3, python2 and pip2
--     - On windows, ensure python2 exists by copying python.exe to python2.exe.
--     - Run or rerun (to upgrade):
--        % pip2 install --user --upgrade neovim
--        % pip3 install --user --upgrade neovim
--
--   Clangd Language Server
--     - Compile for LLVM head, and put clangd in path
--     - Ensure compile_commands.json exists (e.g. mklink /H compile_commands.json build_ninja\RelWithDebInfo\compile_commands.json)
--
-- Use :checkhealth to see what is setup successfully.
--
--=====[ Starting Vim ]====={{{1
--
--  With nvim-qt one might want to get a larger window by default:
--    nvim-qt -qwindowgeometry 1200x800
--
--  For Windows Cmder and similar, may need to add the following to the .bashrc:
--     function nv() {
--       # This unsetting and restoring of TERM is necessary so that fzf works.
--       # See https://github.com/junegunn/fzf/issues/963.
--       TERM_OLD=$TERM
--       export TERM=
--       nvim-qt "$@" &
--       export TERM=$TERM_OLD
--     }
--
--=====[ Profiling Vim ]====={{{1
--
--  To profile the startup time:
--    - On command-line run "nvim-qt -- --startup time.log"
--    - From vim run ":StartupTime" (assumes 'dstein64/vim-startuptime' plugin is installed)
--    - nvim --startuptime startuptime.log -c "call timer_start(0, { -> execute('qall') })"
--
--  To profile something while running:
--    - Use :profile
--       :profile start /tmp/nvim-profile.log | profile func * | profile file *
--       " (do some jobs or source some scripts)
--       :profile pause | dump
--    - Use plenary:
--       require('plenary.profile').start("/tmp/plenary-profile.log")
--         (do some jobs or source some scripts)
--       require('plenary.profile').stop()
--
--=====[ Debugging Vim ]====={{{1
--
--  Nvim keeps a general log file for internal debugging, plugins and RPC clients.
--    :echo $NVIM_LOG_FILE
--
--  If nvim-qt keeps crashing then look for error messages when starting neovim
--  in a terminal (e.g. type ":mess" once in nvim).
--
--  Crashing on exit is likely an issue with ~\AppData\Local\nvim-data\shada
--  being full of temporary files. Delete them.
--
--  Ambiguous command? Try ":verb command XXX" to see if it is even defined, which it may not be.
--
--  To start minimally:
--    nvim-qt -- -u NONE --clean --noplugin
--    nvim -u NORC
--
--=====[ Various Notes ]====={{{1
--
-- Text objects (e.g. viw)
--   [If there are strange characters below then utf8 might not be supported.]
--   iw …inner word
--   aw …a word
--   iW …inner WORD
--   aW …a WORD
--   is …inner sentence
--   as …a sentence
--   ip …inner paragraph
--   ap …a paragraph
--   i( or i) …inner block
--   a( or a) …a block
--   i< or i> …inner block
--   a< or i> …a block
--   i{ or i} …inner block
--   a{ or a} …a block
--   i" …inner block
--   a" …a block
--   i` …inner block
--   a` …a block
--
-- Marks
--   {0-9} are the last 10 positions of closed files (0 the last, 1 the last but
--   one)
--   < and > are the left and right position of marked texts
--   ( and ) are the start or end of the current sentence
--   { and } are the start or end of the current paragraph
--   [ and ] are the first or last character of the last yanked or changed text
--   . position of the last change
--   ' or ` position before the last jump
--   " position before the last exit of the file (local to a file)
--   ^ position of the last insert-stop
--
-- URLs
--   gx will open the URL under the cursor
--
-- Runtime path ordering
--   Look at runtime path with:
--       :echom &rtp
--   Ensure that the "before" directories comes first in the runtime path.
--   (Necessary for things like UltiSnips, where overrides need to come first.)
--   And ensure the "after" directories comes last.
--
--=====[ Credit ]====={{{1
--
-- Influenced by the following configs.
--   https://github.com/shaunsingh/nyoom.nvim
--   https://github.com/davidatbu
--   https://github.com/glepnir/nvim
--   https://github.com/elianiva/dotfiles/tree/master/nvim/.config/nvim
--   https://gitlab.com/Iron_E/dotfiles/-/tree/master/.config/nvim
--   https://github.com/beauwilliams/Dotfiles/blob/master/Vim/nvim
--
-- }}}

local global = require('global')
local vim = vim

--=====[ Functions ]====={{{1

-- Create cache dir and the subdirectories needed by common nvim options {{{1
local create_cache_dir = function()
  -- Look at lua/global.lua to see how cache_dir and other global variables are defined.
  local data_dir = {
    global.cache_dir .. 'backup',
    global.cache_dir .. 'session',
    global.cache_dir .. 'spell',
    global.cache_dir .. 'swap',
    global.cache_dir .. 'tags',
    global.cache_dir .. 'undo',
    global.cache_dir .. 'view'
  }

  -- Only check once whether root cache_dir exists. If it does not then make it and all the sub dirs.
  if vim.fn.isdirectory(global.cache_dir) == 0 then
    local mkdir_cmd
    if global.is_windows then
      mkdir_cmd = "mkdir "
    else
      mkdir_cmd = "mkdir -p "
    end

    print(mkdir_cmd .. global.cache_dir)
    os.execute(mkdir_cmd .. global.cache_dir)
    for _,v in pairs(data_dir) do
      if vim.fn.isdirectory(v) == 0 then
        os.execute(mkdir_cmd .. v)
      end
    end
  end
end

-- Disable built-in neovim plugins that are unused in order to speed up loading. {{{1
local disable_default_neovim_plugins = function()
  local disabled_built_ins = {
    "netrw",
    "netrwPlugin",
    "netrwSettings",
    "netrwFileHandlers",
    "gzip",
    "zip",
    "zipPlugin",
    "tar",
    "tarPlugin",
    "getscript",
    "getscriptPlugin",
    "vimball",
    "vimballPlugin",
    "2html_plugin",
    "logipat",
    "rrhelper",
    "matchit",
    --"spellfile_plugin",
    --"matchparen",
  }
  for _, plugin in pairs(disabled_built_ins) do
    vim.g["loaded_" .. plugin] = 1
  end
end

-- Set the map leaders for future key maps. {{{1
local map_leaders = function()
  vim.g.mapleader = "\\"
  vim.g.maplocalleader = ";"
  --vim.api.nvim_set_keymap('n','\\','',{noremap = true})
  --vim.api.nvim_set_keymap('x','\\','',{noremap = true})
end

-- Set configuartion. {{{1
local set_config = function()
  -- These module strings correspond to directories under the lua directory where .lua files exist
  -- The config_* directories are for easily allowing testing of different configurations of nvim.
  --
  -- No need to specify plugins as a submodule, that is loaded separately by the plugin manager.

  -- Configuartion definitions. {{{1

  local config_standard = {
    config_module = "config_standard",
    sub_modules = {
      "appearances",
      "options",
      "settings",
      "commands",
      "mappings",
      "event",
    }
  }

  local config_vscode = {
    config_module = "config_vscode",
    sub_modules = {
      "appearances",
      "options",
      "settings",
      "commands",
      "mappings",
      "event",
    }
  }

  -- Set the desired configuration. {{{1
  local config
  if vim.g.vscode then
    config = config_vscode
  else
    config = config_standard
  end

  global.config_module = config.config_module
  return config
end

-- Load configuration. {{{1
local load_config = function(config)
  -- Load all the submodules for the config
  for i = 1, #config.sub_modules, 1 do
    if config.config_module ~= "plugins" then
      local ok, err = pcall(require, config.config_module .. "." .. config.sub_modules[i])
      if not ok then print(err) end
    end
  end
end

-- Load plugin manager. {{{1
local load_plugin_manager = function()
  -- https://github.com/folke/lazy.nvim
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
      "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git",
      "--branch=stable", -- latest stable release
      lazypath,
    })
  end
  vim.opt.rtp:prepend(lazypath)

  require("lazy").setup({
    spec = {
      -- Loads the plugins module in the current config_module.
      { import = global.config_module .. '.plugins' },
    },
    performance = {
      rtp = {
        -- Disable some rtp plugins
        disabled_plugins = {
          "gzip",
          "matchit",
          "netrwPlugin",
          "tarPlugin",
          "tohtml",
          "tutor",
          "zipPlugin",
          -- "matchparen",
        },
      },
    },
  })
end

--=====[ Main ]====={{{1

-- Disable shada file while sourcing.
vim.opt.shadafile = "NONE"

create_cache_dir()
disable_default_neovim_plugins()
map_leaders()
local config = set_config()
load_config(config)
load_plugin_manager()

-- Reenable shada file.
vim.opt.shadafile = ""
