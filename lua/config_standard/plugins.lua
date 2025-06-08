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
  --=====[ Core ]====={{{1
  -- Often required by others
  --
  { 'nvim-lua/plenary.nvim', lazy = false },  -- async coroutines
  { 'nvim-lua/popup.nvim', lazy = false },
  { 'MunifTanjim/nui.nvim', lazy = false }, -- general UI component library
  { 'kyazdani42/nvim-web-devicons', lazy = false }, -- collection of icons
  { 'rafamadriz/friendly-snippets', lazy = false }, -- collection of snippets
  { 'nvim-neotest/nvim-nio', lazy = false },  -- async io

  --=====[ Appearances ]====={{{1
  --
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      require(plugin_config .. ".others").lualine()
    end,
  },

  --=====[ Startup ]====={{{1
  --
  {  -- start with "nvim-qt -- --startuptime time.log", then use :StartupTime
    "dstein64/vim-startuptime",
    cmd = "StartupTime",
  },

  --=====[ Treesitter ]====={{{1
  --
  { "nvim-treesitter/nvim-treesitter" },
  { "nvim-treesitter/nvim-treesitter-refactor" }, -- Highlight definition of current symbol, current scope
  { "nvim-treesitter/nvim-treesitter-textobjects", lazy = true},
  { "nvim-treesitter/playground", cmd = "TSPlayground", lazy = true },
  { "David-Kunz/treesitter-unit" },
  { "mfussenegger/nvim-treehopper" },
  -- C++ specific stuff: TSCppDefineClassFunc, TSCppMakeConcreteClass, TSCppRuleOf5 (config in treesitter)
  -- TODO: Figure out why it fails in some cases
  { "Badhi/nvim-treesitter-cpp-tools" },

  --=====[ Language Server Protocol ]====={{{1
  --
  {
    "neovim/nvim-lspconfig",
    config = function()
      require(plugin_config .. ".lspconfig")
    end,
  },

  { 'nvim-lua/lsp-status.nvim', },  -- statusline components from lsp
  { "williamboman/mason.nvim" },

  -- {
  --   "ray-x/lsp_signature.nvim",
  --   config = function()
  --     require(plugin_config .. ".others").lsp_signature()
  --   end,
  -- },

  -- {
  --   "stevearc/aerial.nvim",
  --   lazy = false,  -- so we can use it with lualine
  --   config = function()
  --     require(plugin_config .. ".aerial")
  --   end,
  -- },

  {
    'j-hui/fidget.nvim',
    config = function()
      require(plugin_config .. ".others").fidget()
    end,
  },

  --=====[ Debugging ]====={{{1
  --
  { 'mfussenegger/nvim-dap' },

  {
    "jay-babu/mason-nvim-dap.nvim",
    ---@type MasonNvimDapSettings
    opts = {
      handlers = {},  -- this line is essential to making automatic installation work
      automatic_installation = {
        -- These will be configured by separate plugins.
        exclude = {
          "delve",
          "python",
        },
      },
      -- DAP servers: Mason will be invoked to install these if necessary.
      ensure_installed = {
        "bash",
        "codelldb",
        "php",
        "python",
      },
    },
    dependencies = {
      "mfussenegger/nvim-dap",
      "williamboman/mason.nvim",
    },
  },

  {
    "mfussenegger/nvim-dap-python",
    lazy = true,
    config = function()
      -- mason puts the required "debugpy" package here in this venv
      -- local python = vim.fn.expand("~/.local/share/nvim/mason/packages/debugpy/venv/bin/python")
      local python = "python"  -- hopefully pick up the local venv python (but will neet to pip install debugpy)
      require("dap-python").setup(python)
    end,
    -- Consider the mappings at
    -- https://github.com/mfussenegger/nvim-dap-python?tab=readme-ov-file#mappings
    dependencies = {
      "mfussenegger/nvim-dap",
    },
  },

  {
    "theHamsta/nvim-dap-virtual-text",
    config = true,
    dependencies = {
      "mfussenegger/nvim-dap",
    },
  },

  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",
      "jay-babu/mason-nvim-dap.nvim",
      "mfussenegger/nvim-dap-python",
      "theHamsta/nvim-dap-virtual-text",
    },
    config = function()
      require(plugin_config .. ".others").dapui()
    end,
  },

  --=====[ Snippets ]====={{{1
  --
  -- {  -- TODO: Disabled due to cache related failures.
  --   "L3MON4D3/LuaSnip",
  --   -- follow latest release.
  --   version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
  --   -- install jsregexp (optional!).
  --   -- build = "make install_jsregexp"
  --   config = function()
  --     require(plugin_config .. ".others").luasnip()
  --   end,
  -- },

  --=====[ Code Completion ]====={{{1
  --
  {
    "hrsh7th/nvim-cmp",
    config = function()
       require(plugin_config .. ".cmp")
    end,
  },
  { "hrsh7th/cmp-nvim-lua", },
  { "hrsh7th/cmp-nvim-lsp", },
  { "hrsh7th/cmp-path", },
  { "saadparwaiz1/cmp_luasnip", },
  { "lukas-reineke/cmp-rg", },
  { "ray-x/cmp-treesitter", },

  --=====[ Telescope ]====={{{1
  --
  {'nvim-telescope/telescope-fzf-native.nvim', branch = 'main', build = 'make'},

  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    lazy = false,
    config = function()
      require(plugin_config .. ".telescope")
    end,
  },

  { -- allow searching all previous copy/pastes with :Telescope neoclip (requires telescope obviously)
    "AckslD/nvim-neoclip.lua",
    config = function()
      require(plugin_config .. ".others").neoclip()
    end,
  },

  --=====[ File and Buffer Navigation ]====={{{1
  --
  -- TODO: Appears to be broken in latest neovim
  -- {'tpope/vim-projectionist', lazy = false}, -- allow for project files
  {'jlanzarotta/bufexplorer', cmd = "BufExplorer"},
  {'famiu/bufdelete.nvim', cmd = "Bdelete"},
  {'lambdalisue/fern.vim', branch = 'main'},
  {
    'samr/fileblink.nvim',
    -- dir = "C:/Users/___/fileblink.nvim", -- for plugin development
    lazy = false,
    config = function()
      require("fileblink").setup({
        extension_maps = {
            h = { "cpp", "cc", "c" },
            hpp = { "cpp", "cc" },
            c = { "h" },
            cc = { "hpp", "h" },
            cpp = { "hpp", "h" },

            cu = { "cuh" },
            cuh = { "cu" },

            js = { "ts", "jsx", "tsx" },
            ts = { "js", "jsx", "tsx" },
            jsx = { "js", "ts", "tsx" },
            tsx = { "js", "ts", "jsx" },

            html = { "css", "scss", "sass" },
            css = { "html", "scss", "sass" },
            scss = { "css", "html" },
            sass = { "css", "html" },
        },

        prefix_suffix_maps = {
            ["_test"] = { "" },        -- suffix  (foo_test.cc -> foo.cc)
            ["test_/"] = { "" },       -- prefix  (test_foo.cc -> foo.cc)
            ["_impl"] = { "" },
            [""] = { "_test", "test_/", "_impl" },  -- maps back (foo.cc -> *)
        },

        root_markers = { ".git", ".clang-format", ".dockerignore", "requirements.txt", "package.json", "Cargo.toml" },

        cache_size = 20000,
        autoload_fileblinkrc = false,
      })
    end,
  },


  -- Note: currently disabled because I haven't been using it much.
  -- TODO: Create some key mappings for this.
  -- {
  --   "ThePrimeagen/harpoon",
  --   branch = "harpoon2",
  --   -- requires = { {"nvim-lua/plenary.nvim"} }
  -- }

  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    lazy = false, -- neo-tree lazy loads itself
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
      -- {"3rd/image.nvim", opts = {}}, -- Optional image support in preview window: See `# Preview Mode` for more information
    },
    config = function()
      require(plugin_config .. ".others").neo_tree()
    end,
    -- we explicitly include these dependencies, so this is just documentation
    -- requires = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim", "kyazdani42/nvim-web-devicons", },
  },

  { -- Currently use this rather than lightspeed or leap.nvim.
    "phaazon/hop.nvim",
    cmd = {
      "HopWord",    -- type ;ww
      "HopLine",    -- type ;ll
      "HopChar1",   -- type ;cc
      "HopChar2",
      "HopPattern", -- type ;ss (for search)
    },
    name = "hop",
    config = function()
      require("hop").setup()
    end,
  },

  -- {
  --   "ggandor/leap.nvim",
  --   config = function()
  --     require(plugin_config .. ".others").leap()
  --   end,
  -- },

  --=====[ Git and Diff ]====={{{1
  --
  {
    'lewis6991/gitsigns.nvim', -- look at lines added/modified/taken away, all at a glance.
    -- Currently causes issues similar to https://github.com/LazyVim/LazyVim/discussions/3407 with Lazy, so be super
    -- lazy about loading it. Maybe it will work in a future version.
    lazy = true,
    cmd = "Gitsigns",
  },

  {
    "TimUntersberger/neogit",
    cmd = {
      "Neogit",
      "Neogit commit",
    },
    config = function()
      require(plugin_config .. ".neogit")
    end,
  },

  { "sindrets/diffview.nvim", },

  --=====[ Text Modification and Formatting ]====={{{1
  --
  {"gennaro-tedesco/nvim-peekup"}, -- vim registers made easy, type ""
  {'kana/vim-textobj-user', lazy = false}, -- define custom text objects (though many don't work or are unneeded)
  {'kana/vim-textobj-line', lazy = false, dependencies = {'kana/vim-textobj-user'}}, -- il and al for selecting the current line
  {'kana/vim-textobj-indent', lazy = false, dependencies = {'kana/vim-textobj-user'}}, -- ii and ai for things at same indent
  {'kana/vim-textobj-entire', lazy = false, dependencies = {'kana/vim-textobj-user'}}, -- ie selects the entire file

  -- use vi<Space> and va<Space> to select blank lines
  {'deathlyfrantic/vim-textobj-blanklines', lazy = false, dependencies = {'kana/vim-textobj-user'}},

  -- Text objects based on syntax trees (e.g. ]] goes to next parameter of a function, and vif selects the function)
  -- See https://github.com/nvim-treesitter/nvim-treesitter-textobjects#built-in-textobjects
  {'nvim-treesitter/nvim-treesitter-textobjects'},

  { -- in visual mode + and - expand or shrink selection
    'terryma/vim-expand-region',
    lazy = false,
    config = function()
       require(plugin_config .. ".others").vim_expand_region()
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

  { -- auto format stuff easier, e.g. clang-format
    'mhartington/formatter.nvim',
    lazy = false,
    config = function()
      require(plugin_config .. ".formatter")
    end,
  },

  { -- (un)comment toggle with gc and gb in visual mode, or gc(motion) in normal mode (e.g. gcip)
    "numToStr/Comment.nvim",
    lazy = false,
    config = function()
       require(plugin_config .. ".others").comment()
    end,
  },

  { -- autodetect tabs or spaces and to what degree of indent
    "Darazaki/indent-o-matic",
    cmd = "IndentOMatic",
    config = function()
      require(plugin_config .. ".others").indentomatic()
    end,
  },

  --=====[ Quickfix and Location List ]====={{{1
  --
  { 'mhinz/vim-grepper', cmd='Grepper' },

  { -- Makes quickfix and location list window editable (not a lua plugin)
    'stefandtw/quickfix-reflector.vim',
    config = function()
      vim.g.qf_modifiable = 0  -- Require manually making the window editable.
    end,
  },

  --=====[ Miscellaneous Plugins ]====={{{1
  --
  { 'vim-scripts/stlrefvim' }, --  C++ STL docs
  { 'antoinemadec/FixCursorHold.nvim' },
  { 'simnalamburt/vim-mundo' }, -- a tree of undo
  { 'plasticboy/vim-markdown',  ft = { 'markdown' } },
  { 'dhruvasagar/vim-table-mode', ft = { 'markdown'} },

}
