-- Fold Commands
--   (this is first in case file opens with folds folded)

--   :set foldmethod=marker  (or <F11> currently)
--   zo/zc open/close one fold
--   zr increment foldlevel
--   zm decrement foldlevel
--   zR open all folds
--   zM close all folds
--
local present, packer = pcall(require, "packer_init")

if present then
  packer = require "packer"
else
  return false
end

local use = packer.use
return packer.startup(function()
  --=====[ Packer ]====={{{1
  use {
    "wbthomason/packer.nvim",
    event = "VimEnter", -- manages itself
  }

  --=====[ Startup ]====={{{1
  --
  use { "nathom/filetype.nvim", }
  use { "lewis6991/impatient.nvim", }

  use {  -- start with "nvim-qt -- --startuptime time.log", then use :StartupTime
    'dstein64/vim-startuptime',
    cmd = "StartupTime",
  }

  --=====[ Appearances ]====={{{1
  --
  use {'kyazdani42/nvim-web-devicons'}

  --=====[ Treesitter ]====={{{1
  --
  use {
    "nvim-treesitter/nvim-treesitter",
    requires = {
      {'nvim-treesitter/nvim-treesitter-textobjects'}, -- language aware text objects
    },
    --run = ':TSUpdate'
    config = function()
       require "plugins.treesitter"
    end,
  }

  use {
    "nvim-treesitter/playground",
    cmd = "TSPlayground",
  }

  use {'nvim-treesitter/nvim-treesitter-textobjects'} -- Text objects based on syntax trees!!
  use {'nvim-treesitter/nvim-treesitter-refactor'} -- Highlight definition of current symbol, current scope

  use {
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      require("plugins.others").blankline()
     end,
  }

  use { "lewis6991/gitsigns.nvim", }

  --=====[ Language Server Protocol ]====={{{1
  --
  use {
    "github/copilot.vim",
    event = "InsertEnter",
  }

  use {
    "neovim/nvim-lspconfig",
    config = function()
      require "plugins.lspconfig"
    end,
  }

  use { -- statusline components from lsp
    'nvim-lua/lsp-status.nvim',
    after = "nvim-lspconfig",
  }

  use {
    "williamboman/nvim-lsp-installer",
  }

  use {
    "ray-x/lsp_signature.nvim",
    after = "nvim-lspconfig",
    config = function()
      require("plugins.others").signature()
    end,
  }

  --=====[ Snippets ]====={{{1
  --
  use {
    "rafamadriz/friendly-snippets",
    event = "InsertEnter",
  }

  use {
    "L3MON4D3/LuaSnip",
    wants = "friendly-snippets",
    --after = "nvim-cmp",
    config = function()
      require("plugins.others").luasnip()
    end,
  }

  --=====[ Code Completion ]====={{{1
  --
  use {
    'ms-jpq/coq_nvim',
    branch = 'coq',
    opt = false,
    config = function()
      require("plugins.coq").luasnip()
    end,
  }

  use {  -- 9000+ Snippets
    'ms-jpq/coq.artifacts',
    branch = 'artifacts',
  }

  --=====[ Telescope ]====={{{1
  --
  use {'nvim-lua/"plenary.nvim'}
  use {'nvim-lua/popup.nvim'}
  use {'nvim-telescope/telescope-fzf-native.nvim', branch = 'main', run = 'make'}
  use {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    opt = false,
    requires = {
      {
        "nvim-lua/plenary.nvim",
        'nvim-lua/popup.nvim',
        "nvim-telescope/telescope-fzf-native.nvim",
      },
    },
    config = function()
      require "plugins.telescope"
    end,
  }

  --=====[ File and Buffer Navigation ]====={{{1
  --
  use {'tpope/vim-projectionist', opt = false} -- allow for project files
  use {'jlanzarotta/bufexplorer', cmd = "BufExplorer" }
  use {'lambdalisue/fern.vim'}
  use {'hrsh7th/fern-mapping-collapse-or-leave.vim'}
  use {
    'kyazdani42/nvim-tree.lua',
    opt = true,
    requires = {
      {'kyazdani42/nvim-web-devicons', opt = true}
    },
  } -- super fast file tree viewer (note: currently does not work on Windows)

  use {
    "phaazon/hop.nvim",
    cmd = {
      "HopWord",
      "HopLine",
      "HopChar1",
      "HopChar2",
      "HopPattern",
    },
    as = "hop",
    config = function()
      require("hop").setup()
    end,
  }

  --=====[ Git and Diff ]====={{{1
  --
  use {
    "sindrets/diffview.nvim",
    after = "neogit",
  }

  use {
    "TimUntersberger/neogit",
    cmd = {
      "Neogit",
      "Neogit commit",
    },
    config = function()
      require "plugins.neogit"
    end,
  }

  --=====[ Text Modification and Formatting ]====={{{1
  --
  use {'kana/vim-textobj-user'} -- define custom text objects

  use { -- surround selections with symbols, such as quotes and parens
    'machakann/vim-sandwich',
    config = function()
      require "plugins.vim_sandwich"
     end,
  }

  use { -- auto format stuff easier, e.g. clang-format
    'mhartington/formatter.nvim',
    opt = false,
    --cmd = {
    --  "Format",
    --  "FormatWrite",
    --},
    config = function()
      require "plugins.formatter"
    end,
  }

  use {
    "numToStr/Comment.nvim",
    after = "friendly-snippets",
    config = function()
       require("plugins.others").comment()
    end,
  }

  --=====[ Debugging ]====={{{1
  --
  -- use {'mfussenegger/nvim-dap'}
  -- use {
  --   "rcarriga/nvim-dap-ui",
  --   after = {"mfussenegger/nvim-dap"}
  -- }
  -- use {'theHamsta/nvim-dap-virtual-text'}

  --=====[ Other Plugins ]====={{{1
  --
  use {'vim-scripts/stlrefvim'} --  C++ STL docs
  use {'antoinemadec/FixCursorHold.nvim'}
  use {'simnalamburt/vim-mundo'} -- a tree of undo
  use {'plasticboy/vim-markdown',  ft = { 'markdown' }}
  use {'dhruvasagar/vim-table-mode', ft = { 'markdown'}}

  --=====[ Disabled (to try) ]====={{{1
  --
  -- use {'fern-bookmark.vim'}
  -- use {'fern-git-status.vim'}
  -- use {'fern-mapping-project-top.vim'}
  --
  -- use {
  --    "rcarriga/nvim-notify",
  --    config = function()
  --       vim.notify = require "notify"
  --       require("notify").setup {
  --          stages = "slide",
  --          timeout = 2500,
  --          minimum_width = 50,
  --          icons = {
  --             ERROR = "",
  --             WARN = "",
  --             INFO = "",
  --             DEBUG = "",
  --             TRACE = "✎",
  --          },
  --       }
  --    end,
  -- }
  --
  --
  -- use {'Shatur/neovim-session-manager'} -- Save sessions by directory
  -- use {'hkupty/iron.nvim'} -- Spin up a repl in a neovim terminal and send text to it
  -- use {'famiu/nvim-reload'} -- Adds :Reload and :Restart to make reloading lua easier
  -- use {'kosayoda/nvim-lightbulb'}
  -- use {'stevearc/aerial.nvim'} -- Symbol tree. Better than symbols-outline.nvim because it allows filtering by symbol type.
  -- use {'kevinhwang91/nvim-bqf'} -- better quick fix
  -- use {'tjdevries/colorbuddy.nvim', opt = false} -- inheritance based colorschemes
  -- use {'nvim-lua/completion-nvim', opt = false} -- better completion using lsp
  -- use {'RishabhRD/nvim-lsputils', opt = false} -- lsp popups and ease of use
  -- use { 'tpope/vim-rhubarb' } -- git related
  -- use { 'pwntester/octo.nvim', requires = { 'kyazdani42/nvim-web-devicons' } } -- Who needs web interfaces when you have neovim interfaces (for Github)?
  -- use {'vim-airline/vim-airline'}
  -- use {'vim-airline/vim-airline-themes'}
  -- use {'folke/zen-mode.nvim',  branch = 'main'}
  -- use {'nvim-lua/lsp_extensions.nvim'} -- TODO: Setup inlay hints for rust, or just fix rust-tools.nvim's inlay hints
  -- use {'folke/lua-dev.nvim'} -- Provides type annotations for neovim's Lua interface.
  -- use {'christoomey/vim-tmux-navigator'}
  -- use {'chriskempson/base16-vim'}
  -- use {"lukas-reineke/indent-blankline.nvim", ft = { 'html', 'htmldjango', 'python' }}
  -- use {'sedm0784/vim-resize-mode'} -- After doing <C-w>,  be able to type consecutive +,-,<,>
  --
  -- Git fun...
  -- use {'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' } } -- Look at lines added/modified/taken away, all at a glance.
  -- use {'tpope/vim-fugitive', requires = { 'nvim-lua/plenary.nvim' } } -- And I quote tpope, "A git plugin so awesome, it should be illegal."
  -- use {'tpope/vim-rhubarb' }
  -- use {'pwntester/octo.nvim', requires = { 'kyazdani42/nvim-web-devicons' } } -- Who needs web interfaces when you have neovim interfaces (for Github)?
  -- 
  -- Kotlin
  -- use {'udalov/kotlin-vim'}
  --
  -- -- Rust
  -- use {'simrat39/rust-tools.nvim'}
  --
  --=====[ Disabled (indefinitely) ]====={{{1
  --
  -- Must say, coq is impressive...
  -- use {
  --   "hrsh7th/nvim-cmp",
  --   after = "friendly-snippets",
  --   config = function()
  --      require "plugins.cmp"
  --   end,
  -- }

  -- use {
  --   "saadparwaiz1/cmp_luasnip",
  --   after = "LuaSnip",
  -- }

  -- use {
  --   "hrsh7th/cmp-nvim-lua",
  --   after = "nvim-cmp",
  -- }

  -- use {
  --   "hrsh7th/cmp-nvim-lsp",
  --   after = "nvim-cmp",
  -- }

  -- use {
  --   "lukas-reineke/cmp-rg",
  --   after = "nvim-cmp",
  -- }

  -- use {
  --   "ray-x/cmp-treesitter",
  --   after = "nvim-cmp",
  -- }

  -- use {
  --   "hrsh7th/cmp-path",
  --   after = "nvim-cmp",
  -- }

end)
