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

-- Plugins that definitely do not work:
--   plenary, popup, Telescope, lualine
return {
  { "nvim-treesitter/nvim-treesitter",
    branch = 'main',  -- the master branch is frozen; main is a rewrite with a new API
    build = ':TSUpdate',
    config = function()
      -- VSCode does its own highlighting; parsers are only needed for textobjects and similar.
      require('nvim-treesitter').install({ "lua", "vim", "vimdoc", "query", "c", "cpp", "cmake", "python" })
    end,
  },
  { "nvim-treesitter/nvim-treesitter-textobjects",
    branch = 'main',  -- required to work with the nvim-treesitter main branch
    config = function()
      require('nvim-treesitter-textobjects').setup({
        select = { lookahead = true },
        move = { set_jumps = true },
      })
      local select_keymaps = {
        ["a."] = "@class.outer",
        ["i."] = "@class.inner",
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["a?"] = "@conditional.outer",
        ["i?"] = "@conditional.inner",
        ["ao"] = "@loop.outer",
        ["io"] = "@loop.inner",
        ["ac"] = "@comment.outer",
      }
      for lhs, query in pairs(select_keymaps) do
        vim.keymap.set({ "x", "o" }, lhs, function()
          require("nvim-treesitter-textobjects.select").select_textobject(query, "textobjects")
        end)
      end
    end,
  },

  -- Change surrounding characters or select textobjs based on the surrounding characters, such as quotes and parens,
  -- e.g. Typing vi{ in normal mode will select all text inside {}, or typing cs'" will change a surrounding ' to ".
  {
    'machakann/vim-sandwich',
    config = function()
      require(plugin_config .. ".vim_sandwich")
    end,
  },

  { -- I don't use this as much as lightspeed but it's still fun.
    "phaazon/hop.nvim",
    cmd = {
      "HopWord",
      "HopLine",
      "HopChar1",
      "HopChar2",
      "HopPattern",
    },
    name = "hop",
    config = function()
      require("hop").setup()
    end,
  },

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
