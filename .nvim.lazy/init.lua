-- Fold Commands
--   (this is first in case file opens with folds folded)

--   :set foldmethod=marker  (or <F8> currently)
--   zo/zc open/close one fold
--   zr increment foldlevel
--   zm decrement foldlevel
--   zR open all folds
--   zM close all folds
--
--=====[ Installation ]====={{{1
--
-- Rust (for bob): https://www.rust-lang.org/tools/install
--
-- Bob (stay up-to-date with Neovim builds): https://github.com/MordechaiHadad/bob
--  (run these as admin on Windows)
--   % cargo install bob-nvim
--   % bob use [nightly|stable]
--
-- LSP, DAP, Linters and Formatters are installed with Mason: https://github.com/williamboman/mason.nvim
--   For Unix systems: git(1), curl(1) or wget(1), unzip(1), tar(1), gzip(1)
--   For Windows systems: pwsh or powershell, git, tar, and 7zip or peazip or archiver or winzip or WinRAR
--
-- Windows:
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
--    (note, the args are very limited in nvim-qt
--     https://github.com/equalsraf/neovim-qt/blob/master/src/gui/main.cpp#L43)
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
--=====[ Where next? ]====={{{1
--
-- This config is mostly derived from LazyVim, so everything is generally additions, overrides and disabling of
-- the settings enabled by default in LazyVim: https://www.lazyvim.org/
--
-- For options see lua/config/options.lua
-- For keymaps see lua/config/keymaps.lua
-- For autocmds see lua/config/autocmds.lua
-- For plugins see lua/plugins (all files are loaded by default, though core.lua contains the lions share)
--
-- Also, ginit.vim is used for configuring things uniquely nvim-qt (i.e. gvim) related.

-- Bootstrap lazy.nvim, LazyVim and your plugins (lua/config/lazy.nvim contains mostly optimizations to
-- autoconfigure caching and disable certain rtp plugins for faster starup time)
require("config.lazy")
