-- To update plugins, run :Lazy sync
-- More info at https://lazy.folke.io/usage
--
-- For luarocks see https://luarocks.org/#quick-start
-- For Lua5.1, download at https://luabinaries.sourceforge.net/download.html
--
-- Fold Commands
--   (this is first in case file opens with folds folded)

--   :set foldmethod=marker  (or <F11> currently)
--   zo/zc open/close one fold
--   zr increment foldlevel
--   zm decrement foldlevel
--   zR open all folds
--   zM close all folds
--
--=====[ Initialization ]====={{{1

local global = require('global')

local plugin_config = global.config_module .. ".plugin_config"

return {
  --=====[ LazyExtras ]====={{{1
  -- The ones loaded by :LazyExtras
  -- See https://www.lazyvim.org/extras/vscode
  --{ "dial.nvim", },
  --{ "flit.nvim", },
  --{ "lazy.nvim", },
  --{ "leap.nvim", },
  --{ "mini.ai", },
  --{ "mini.comment", },
  --{ "mini.move", },
  --{ "mini.pairs", },
  --{ "mini.surround", },
  --{ "nvim-treesitter", },
  --{ "nvim-treesitter-textobjects", },
  --{ "nvim-ts-context-commentstring", },
  --{ "vim-repeat", },
  --{ "yanky.nvim", },
}
