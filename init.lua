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
--   Packer
--     - cd ~/AppData/Local/nvim-data   # the path returned by :lua print(vim.fn.stdpath('data'))
--     - git clone https://github.com/wbthomason/packer.nvim site/pack/packer/opt/packer.nvim
--     - open nvim and run :PackerInstall, :PackerCompile
--
--   Lua Language Server
--     - cd ${DEV_DIR}
--     - git clone https://github.com/sumneko/lua-language-server
--     - git submodule update --init --recursive
--     - source vcvars64.bat from cmd and build with CMake/Visual Studio
--     - update lua/modules/lsp/init.lua to set "local sumenko_root = ${DEV_DIR}/lua-language-server"
--
--   Python Support
--     - ensure the following executables are in your path:
--        - python3, pip3, python2 and pip2
--     - on windows, ensure python2 exists by copying python.exe to python2.exe.
--     - Run or rerun (to upgrade):
--        % pip2 install --user --upgrade neovim
--        % pip3 install --user --upgrade neovim
--
--   Clangd Language Server
--     - compile for LLVM head, and put clangd in path
--     - ensure compile_commands.json exists (e.g. mklink /H compile_commands.json build_ninja\RelWithDebInfo\compile_commands.json)
--
-- Use :checkhealth to see what is setup successfully.
--
--=====[ Starting Vim ]====={{{1
--
--  With nvim-qt one might want to get a larger window by default:
--    nvim-qt -qwindowgeometry 1200x800
--
--  To profile the startup time:
--    - On command-line run "nvim-qt -- --startup time.log"
--    - From vim run ":StartupTime" (assumes 'dstein64/vim-startuptime' plugin is installed)
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

-- Let impatient cache things, if it is available
local has_impatient, impatient = pcall(require, "impatient")
if not has_impatient then
  print('Unable to load plugin "impatient" -- probably because you need to run :PackerSync or similar.')
end

local global = require('global')
local vim = vim

--=====[ Functions ]====={{{1

-- Create cache dir and subs dir {{{1
local create_cache_dir = function()
  local data_dir = {
    global.cache_dir..'backup',
    global.cache_dir..'session',
    global.cache_dir..'spell',
    global.cache_dir..'swap',
    global.cache_dir..'tags',
    global.cache_dir..'undo',
    global.cache_dir..'view'
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
    for _,v in pairs(data_dir) do
      if vim.fn.isdirectory(v) == 0 then
        os.execute(mkdir_cmd .. v)
      end
    end
  end
end

-- Disable built-in neovim plugins that are unused. {{{1
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
    --"spellfile_plugin",
    "matchit",
    "matchparen"
  }
  for _, plugin in pairs(disabled_built_ins) do
    vim.g["loaded_" .. plugin] = 1
  end
  -- Opt in to new native filtetype.lua support.
  -- To go back to old support, set:
  --   vim.g.do_filetype_lua = 0
  --   vim.g.did_load_filetypes = 1
  vim.g.do_filetype_lua = 1
  vim.g.did_load_filetypes = 0
end

-- Set the map leaders for future key maps. {{{1
local leader_map = function()
  vim.g.mapleader = "\\"
  vim.g.maplocalleader = ";"
  --vim.api.nvim_set_keymap('n','\\','',{noremap = true})
  --vim.api.nvim_set_keymap('x','\\','',{noremap = true})
end

-- Load options, mappings and plugins. {{{1
local load_core = function()
  -- These correspond to .lua files
  local core_modules = {
    "appearances",
    "options",
    "commands",
    "mappings",
    "event",
    "packer_compiled",
  }

  for i = 1, #core_modules, 1 do
    local ok, err = pcall(require, core_modules[i])
    if not ok then print(err) end
  end
end

--=====[ Main ]====={{{1

-- Disable shada file while sourcing.
vim.opt.shadafile = "NONE"

create_cache_dir()
disable_default_neovim_plugins()
leader_map()
load_core()

-- Reenable shada file.
vim.opt.shadafile = ""
