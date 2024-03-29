-- Fold Commands
--   (this is first in case file opens with folds folded)

--   :set foldmethod=marker  (or <F11> currently)
--   zo/zc open/close one fold
--   zr increment foldlevel
--   zm decrement foldlevel
--   zR open all folds
--   zM close all folds
--
local present, packer_init = pcall(require, "packer_init")
if not present then
  print("Could not load packer_init")
  return false
end

local packer_present, packer = pcall(require, "packer")
if not packer_present then
  print("Could not load packer")
  return false
end

--local use = packer.use

return packer.startup(function(use)
  --=====[ Packer ]====={{{1
  --
  use {
    "wbthomason/packer.nvim",
    event = "VimEnter", -- manages itself
  }

  --=====[ Core ]====={{{1
  -- Often required by others
  --
  use {'nvim-lua/plenary.nvim', opt = false}  -- async coroutines
  use {'nvim-lua/popup.nvim', opt = false}
  use {'MunifTanjim/nui.nvim', opt = false} -- general UI component library
  use {'kyazdani42/nvim-web-devicons', opt = false} -- collection of icons
  use {'rafamadriz/friendly-snippets', opt = false} -- collection of snippets

  --=====[ Startup ]====={{{1
  --
  use {'lewis6991/impatient.nvim', opt = false} -- faster loading of lua modules
  -- use {'nathom/filetype.nvim', opt = false}  -- faster filetype support

  use {  -- start with "nvim-qt -- --startuptime time.log", then use :StartupTime
    'dstein64/vim-startuptime',
    cmd = "StartupTime",
  }

  --=====[ Appearances ]====={{{1
  --
  use {
    'nvim-lualine/lualine.nvim',
    config = function()
      require("plugins.others").lualine()
    end,
  }

  --=====[ Themes ]====={{{1
  -- Onedark is pretty good, but liking dark_devel3 better currently.
  -- use {'navarasu/onedark.nvim'}
  -- use {'EdenEast/nightfox.nvim'}
  -- use {'marko-cerovac/material.nvim'}
  -- use {'aktersnurra/no-clown-fiesta.nvim'}
  -- use {'Mofiqul/vscode.nvim'}

  --=====[ Treesitter ]====={{{1
  --
  use {
    "nvim-treesitter/nvim-treesitter",
    requires = {
      {'nvim-treesitter/nvim-treesitter-textobjects'}, -- language aware text objects
    },
    -- run = ':TSUpdate', -- auto-update disabled due to file locking issues on windows
    config = function()
       require("plugins.treesitter")
    end,
  }

  use {'nvim-treesitter/nvim-treesitter-refactor'} -- Highlight definition of current symbol, current scope
  use {'David-Kunz/treesitter-unit'}
  use {'mfussenegger/nvim-treehopper'}

  use {
    "nvim-treesitter/playground",
    cmd = "TSPlayground",
  }

  -- use {  -- show indentation guides
  --   "lukas-reineke/indent-blankline.nvim",
  --   config = function()
  --     require("plugins.others").blankline()
  --   end,
  -- }

  -- syntax aware indentation (requires treesitter)
  use({ "yioneko/nvim-yati", tag = "*", requires = "nvim-treesitter/nvim-treesitter" })

  -- C++ specific stuff: TSCppDefineClassFunc, TSCppMakeConcreteClass, TSCppRuleOf5 (config in treesitter)
  -- TODO: Figure out why it fails in some cases
  use {"Badhi/nvim-treesitter-cpp-tools"}

  --=====[ Language Server Protocol ]====={{{1
  --
  use {
    "neovim/nvim-lspconfig",
    config = function()
      require("plugins.lspconfig")
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
      require("plugins.others").lsp_signature()
    end,
  }

  -- use {
  --   "stevearc/aerial.nvim",
  --   opt = false,  -- so we can use it with lualine
  --   after = "nvim-lspconfig",
  --   config = function()
  --     require("plugins.aerial")
  --   end,
  -- }

  use {
    'j-hui/fidget.nvim',
    opt = false,
    config = function()
      require("fidget").setup()
    end,
  }

  --=====[ Snippets ]====={{{1
  --
  use {
    "L3MON4D3/LuaSnip",
    wants = "friendly-snippets",
    after = "nvim-cmp",
    config = function()
      require("plugins.others").luasnip()
    end,
  }

  --=====[ Code Completion ]====={{{1
  --
  use {
    "hrsh7th/nvim-cmp",
    wants = "friendly-snippets",
    config = function()
       require("plugins.cmp")
    end,
  }

  use {
    "saadparwaiz1/cmp_luasnip",
    after = "LuaSnip",
  }
  use {
    "hrsh7th/cmp-nvim-lua",
    after = "nvim-cmp",
  }
  use {
    "hrsh7th/cmp-nvim-lsp",
    after = "nvim-cmp",
  }
  use {
    "lukas-reineke/cmp-rg",
    after = "nvim-cmp",
  }
  use {
    "ray-x/cmp-treesitter",
    after = "nvim-cmp",
  }
  use {
    "hrsh7th/cmp-path",
    after = "nvim-cmp",
  }

  --=====[ Telescope ]====={{{1
  --
  use {'nvim-telescope/telescope-fzf-native.nvim', branch = 'main', run = 'make'}

  use {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    opt = false,
    config = function()
      require("plugins.telescope")
    end,
  }

  use { -- allow searching all previous copy/pastes with :Telescope neoclip (requires telescope obviously)
    "AckslD/nvim-neoclip.lua",
    config = function()
      require("plugins.others").neoclip()
    end,
  }

  --=====[ File and Buffer Navigation ]====={{{1
  --
  use {'tpope/vim-projectionist', opt = false} -- allow for project files
  use {'jlanzarotta/bufexplorer', cmd = "BufExplorer"}
  use {'famiu/bufdelete.nvim', cmd = "Bdelete"}

  use {'lambdalisue/fern.vim', branch = 'main'}
  use {'hrsh7th/fern-mapping-collapse-or-leave.vim'}

  -- TODO: Create some key mappings for this.
  use {'ThePrimeagen/harpoon'} -- requires "nvim-lua/plenary.nvim"

  use {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v1.x",
    cmd = "NeoTreeReveal", -- lazy load when F2 is pressed
    config = function()
      require("plugins.others").neo_tree()
    end,
    -- we explicitly include these dependencies, so this is just documentation
    -- requires = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim", "kyazdani42/nvim-web-devicons", },
  }

  use { -- I don't use this as much as lightpseed but it's still fun.
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
  use {'lewis6991/gitsigns.nvim'} -- look at lines added/modified/taken away, all at a glance.

  use {
    "TimUntersberger/neogit",
    cmd = {
      "Neogit",
      "Neogit commit",
    },
    config = function()
      require("plugins.neogit")
    end,
  }

  use {
    "sindrets/diffview.nvim",
    after = "neogit",
  }

  --=====[ Text Modification and Formatting ]====={{{1
  --
  use {"gennaro-tedesco/nvim-peekup"} -- vim registers made easy, type ""
  use {'kana/vim-textobj-user', opt = false} -- define custom text objects (though many don't work or are unneeded)
  use {'kana/vim-textobj-line', opt = false} -- il and al for selecting the current line
  use {'kana/vim-textobj-indent', opt = false} -- ii and ai for things at same indent
  use {'kana/vim-textobj-entire', opt = false} -- ie selects the entire file
  use {'deathlyfrantic/vim-textobj-blanklines', opt = false} -- use vi<Space> and va<Space> to select blank lines

  -- Text objects based on syntax trees (e.g. ]] goes to next parameter of a function, and vif selects the function)
  -- See https://github.com/nvim-treesitter/nvim-treesitter-textobjects#built-in-textobjects
  use {'nvim-treesitter/nvim-treesitter-textobjects'}

  use { -- in visual mode + and - expand or shrink selection
    'terryma/vim-expand-region',
    opt = false,
    config = function()
       require("plugins.others").vim_expand_region()
    end,
  }

  -- Change surrounding characters or select textobjs based on the surrounding characters, such as quotes and parens,
  -- e.g. Typing vi{ in normal mode will select all text inside {}, or typing cs'" will change a surrounding ' to ".
  use {
    'machakann/vim-sandwich',
    config = function()
      require("plugins.vim_sandwich")
    end,
  }

  use { -- auto format stuff easier, e.g. clang-format
    'mhartington/formatter.nvim',
    opt = false,
    config = function()
      require("plugins.formatter")
    end,
  }

  use { -- (un)comment toggle with gc and gb in visual mode, or gc(motion) in normal mode (e.g. gcip)
    "numToStr/Comment.nvim",
    opt = false,
    config = function()
       require("plugins.others").comment()
    end,
  }

  use { -- autodetect tabs or spaces and to what degree of indent
    "Darazaki/indent-o-matic",
    cmd = "IndentOMatic",
    config = function()
      require("plugins.others").indentomatic()
    end,
  }

  --=====[ Quickfix and Location List ]====={{{1
  --
  use {'mhinz/vim-grepper', cmd = {'Grepper', '<plug>(GrepperOperator)'}}

  use { -- Makes quickfix and location list window editable (not a lua plugin)
    'stefandtw/quickfix-reflector.vim',
    config = function()
      vim.g.qf_modifiable = 0  -- Require manually making the window editable.
    end,
  }

  --=====[ Miscellaneous Plugins ]====={{{1
  --
  use {'vim-scripts/stlrefvim'} --  C++ STL docs
  use {'antoinemadec/FixCursorHold.nvim'}
  use {'simnalamburt/vim-mundo'} -- a tree of undo
  use {'plasticboy/vim-markdown',  ft = { 'markdown' }}
  use {'dhruvasagar/vim-table-mode', ft = { 'markdown'}}

  --=====[ Debugging ]====={{{1
  --
  -- use {'mfussenegger/nvim-dap'}
  -- use {
  --   "rcarriga/nvim-dap-ui",
  --   after = {"mfussenegger/nvim-dap"}
  -- }
  -- use {'theHamsta/nvim-dap-virtual-text'}
  -- use {'jbyuki/one-small-step-for-vimkind'}

  -- use {  -- use https://godbolt.org by way of curl
  --   'p00f/godbolt.nvim',
  --   cmd = {
  --     "Godbolt",
  --     "GodboltCompiler",
  --   },
  --   config = function()
  --      require("godbolt").setup({})
  --   end,
  -- }

  --=====[ Disabled (to try) ]====={{{1
  --
  -- use {'fern-bookmark.vim'}
  -- use {'fern-git-status.vim'}
  -- use {'fern-mapping-project-top.vim'}

  -- consider using lir instead of neo-tree and fern.
  -- use {'tamago324/lir.nvim'}
  -- use {'tamago324/lir-git-status.nvim'}
  -- use {'tamago324/lir-bookmark.nvim'}
  -- use {'tamago324/lir-mmv.nvim'}

  -- TODO: Maybe add this, it requires wrapping all key mappings and not sure it plays well with which key.
  -- use {  -- fuzzy find key mappings
  --   "lazytanuki/nvim-mapper",
  --   before = "telescope.nvim"
  --   config = function()
  --     require("plugins.others").nvim_mapper()
  --   end,
  -- }

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
  -- Maybe try this as well for finding references and definitions, though it looks frenetic
  -- use {'ray-x/navigator.lua', requires = {'ray-x/guihua.lua', run = 'cd lua/fzy && make'}}

  -- TODO: Explore using this
  -- use({
  --   "narutoxy/themer.lua",
  --   branch = "dev", -- I recommend dev branch because it has more plugin support currently
  --   module = "themer", -- load it as fast as possible
  --   config = function()
  --     -- vim.cmd("colorscheme dark_cpt") -- you can also do this
  --     require("themer").load("dark_cpt")
  --   end,
  -- })

  -- TODO: Try these... possibly instead of lsp_signature
  --
  -- use {
  --   'glepnir/lspsaga.nvim',
  --   requires = "nvim-lspconfig",
  --   config = function()
  --     require("plugins.others").lspsaga()
  --   end,
  -- }
  --
  -- use {
  --   "folke/trouble.nvim",
  --   requires = "kyazdani42/nvim-web-devicons",
  --   after = { "nvim-lspconfig", "telescope", },
  --   config = function()
  --     require("plugins.others").trouble()
  --   end,
  -- }

  -- TODO: Try this to browse call and symbol trees
  --
  -- use {
  --   'ldelossa/litee.nvim',
  --   config = function()
  --     require('litee.lib').setup({
  --         tree = {
  --             icon_set = "codicons"
  --         },
  --         panel = {
  --             orientation = "left",
  --             panel_size  = 30
  --         }
  --     })
  --   end,
  -- }
  -- use {'ldelossa/litee-calltree.nvim'} -- more set up required
  -- use {'ldelossa/litee-symboltree.nvim'} -- more set up required

  -- use {'zsugabubus/crazy8.nvim'} -- Autodetect tabs/spaces and to what degree
  -- use {'Shatur/neovim-session-manager'} -- Save sessions by directory
  -- use {'hkupty/iron.nvim'} -- Spin up a repl in a neovim terminal and send text to it
  -- use {'famiu/nvim-reload'} -- Adds :Reload and :Restart to make reloading lua easier
  -- use {'kosayoda/nvim-lightbulb'}
  -- use {'kevinhwang91/nvim-bqf'} -- better quick fix
  -- use {'tjdevries/colorbuddy.nvim', opt = false} -- inheritance based colorschemes
  -- use {'RishabhRD/nvim-lsputils', opt = false} -- lsp popups and ease of use
  -- use { 'tpope/vim-rhubarb' } -- git related
  -- use {'vim-airline/vim-airline'}
  -- use {'vim-airline/vim-airline-themes'}
  -- use {'folke/zen-mode.nvim',  branch = 'main'}
  -- use {'nvim-lua/lsp_extensions.nvim'} -- TODO: Setup inlay hints for rust, or just fix rust-tools.nvim's inlay hints
  -- use {'folke/lua-dev.nvim'} -- Provides type annotations for neovim's Lua interface.
  -- use {'christoomey/vim-tmux-navigator'}
  -- use {'chriskempson/base16-vim'}
  -- use {"lukas-reineke/indent-blankline.nvim", ft = { 'html', 'htmldjango', 'python' }}
  -- use {'sedm0784/vim-resize-mode'} -- After doing <C-w>,  be able to type consecutive +,-,<,>
  -- use { 'RRethy/nvim-treesitter-textsubjects', }  -- wish this worked, unfortunately it does not seem to, especially for C++. Seems like an alternative to vim-expand-region.

  -- Git fun...
  -- use {'tpope/vim-fugitive', requires = { 'nvim-lua/plenary.nvim' } } -- And I quote tpope, "A git plugin so awesome, it should be illegal."
  -- use {'tpope/vim-rhubarb' }
  -- use {'pwntester/octo.nvim', requires = { 'kyazdani42/nvim-web-devicons' } } -- Who needs web interfaces when you have neovim interfaces (for Github)?

  -- Kotlin
  -- use {'udalov/kotlin-vim'}

  -- -- Rust
  -- use {'simrat39/rust-tools.nvim'}

  --=====[ Disabled (indefinitely) ]====={{{1
  --
  -- use {'nvim-lua/completion-nvim', opt = false} -- no longer maintained.
  -- use {'ggandor/lightspeed.nvim'} -- The s/S mapping drives me crazy, and hop.nvim works
  -- use {'Julian/vim-textobj-brace', opt = false} -- ij and aj for inside [], (), {} (works but don't need it with vim-sandwich)
  -- use {'Julian/vim-textobj-variable-segment'} -- iv and av text objects for variable names (does not work)

  -- Maybe use this in the future. While VERY fast, I am not entirely sold on the snippet support and the constant
  -- suggestions were a bit too frenetic without being what I really want completed in many contexts.
  -- use {
  --   'ms-jpq/coq_nvim',
  --   branch = 'coq',
  --   opt = false,
  --   config = function()
  --     require "plugins.coq"
  --   end,
  -- }

  -- use {  -- 9000+ Snippets
  --   'ms-jpq/coq.artifacts',
  --   branch = 'artifacts',
  -- }

  -- use { -- projectionist alternative (does not seem to work)
  --   "Everduin94/nvim-quick-switcher",
  --   keys = "<leader>oc",
  -- }
  -- -- remap('n', '<leader>oc', ":lua require('nvim-quick-switcher').toggle('cpp', 'h')<CR>", {noremap = true, silent = true})
  -- use { "github/copilot.vim", event = "InsertEnter", } -- a bit creepy/privacy violating

  -- TODO: Good but need to solve the colorscheme issues.
  -- use {
  --   'windwp/windline.nvim',
  --    config = function()
  --      require("plugins.others").windline()
  --    end,
  -- }

  -- TODO: Does not appear to work out of the box.
  -- use {
  --   'rebelot/heirline.nvim',
  --   opt = false,
  --   config = function()
  --     require("plugins.heirline").setup()
  --   end,
  -- }

  -- TODO: Lots of the examples did not work or were old
  -- use {
  --   'feline-nvim/feline.nvim',
  --   requires = { 'kyazdani42/nvim-web-devicons', opt = true },
  --   config = function()
  --     require("plugins.others").feline()
  --   end,
  -- }

end)
