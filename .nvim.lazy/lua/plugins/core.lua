-- Core plugins and their configuration
--
-- Every spec file under config.plugins will be loaded automatically by lazy.nvim
--
-- Fold Commands
--   (this is first in case file opens with folds folded)

--   :set foldmethod=marker  (or <F8> currently)
--   zo/zc open/close one fold
--   zr increment foldlevel
--   zm decrement foldlevel
--   zR open all folds
--   zM close all folds
--
--=====[ LazyVim Plugins ]====={{{1
-- Many plugins are included by LazyVim by default. They are listed below for convenience.
--
--   -- core.lua
--   'folke/lazy.nvim'
--   'LazyVim/LazyVim'
--
--   -- coding.lua
--   'L3MON4D3/LuaSnip' -- snippets
--   'rafamadriz/friendly-snippets' -- collection of snippets
--   'hrsh7th/nvim-cmp' -- auto completion
--   'hrsh7th/cmp-nvim-lsp'
--   'hrsh7th/cmp-buffer'
--   'hrsh7th/cmp-path'
--   'saadparwaiz1/cmp_luasnip'
--   'echasnovski/mini.pairs' -- auto pairs
--   'echasnovski/mini.surround' -- surround
--   'JoosepAlviste/nvim-ts-context-commentstring' -- comments
--   'echasnovski/mini.ai' -- better text objects
--   'nvim-treesitter/nvim-treesitter-textobjects'
--
--   -- colorscheme.lua
--   'folke/tokyonight.nvim' -- default, style moon
--   'catppuccin/nvim'
--
--   -- editor.lua
--   'nvim-neo-tree/neo-tree.nvim' -- file explorer
--   'windwp/nvim-spectre' -- search/replace in multiple files
--   'nvim-telescope/telescope.nvim' -- fuzzy finder
--   'ggandor/leap.nvim' -- easily jump to any location
--   'ggandor/flit.nvim'
--   'folke/which-key.nvim' -- key completion help
--   'lewis6991/gitsigns.nvim'
--   'RRethy/vim-illuminate' -- references
--   'echasnovski/mini.bufremove'
--   'folke/trouble.nvim' -- better diagonistics, messages and notifications
--   'folke/todo-comments.nvim'
--
--   -- lsp/init.lua
--   'neovim/nvim-lspconfig' -- lsp config
--   'folke/neoconf.nvim'
--   'folke/neodev.nvim'
--   'jose-elias-alvarez/null-ls.nvim' -- formatters
--   'williamboman/mason.nvim' -- cmd line tools and lsp servers
--   'williamboman/mason-lspconfig.nvim'
--
--    -- treesitter.lua
--   'nvim-treesitter/nvim-treesitter'
--
--   -- ui.lua
--   'rcarriga/nvim-notify' -- better vim.notify()
--   'stevearc/dressing.nvim' -- better vim.ui
--   'akinsho/bufferline.nvim'
--   'nvim-lualine/lualine.nvim' -- statusline
--   'lukas-reineke/indent-blankline.nvim' -- indent guides
--   'echasnovski/mini.indentscope' -- active indent guide and text objects
--   'folke/noice.nvim' -- noicer ui
--   'goolord/alpha-nvim' -- dashboard
--   'SmiteshP/nvim-navic' -- lsp symbol nav for lualine
--   'nvim-tree/nvim-web-devicons' -- icons
--   'MunifTanjim/nui.nvim' -- ui components
--
--   -- util.lua
--   'dstein64/vim-startuptime' -- startup time
--   'folke/persistence.nvim' -- session management
--   'nvim-lua/plenary.nvim'  -- async coroutines
--   'tpope/vim-repeat'  -- make some plugins dot-repeatable, like leap
--
-- }}}
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
-- }}}
--
return {
  --=====[ General ]====={{{1
  --
  { "nathom/filetype.nvim" }, -- faster filetype support

  -- dashboard overrides
  {
    "goolord/alpha-nvim",
    opts = function()
      local dashboard = require("alpha.themes.dashboard")
      local logo = [[
      ██╗      █████╗ ███████╗██╗   ██╗          Z
      ██║     ██╔══██╗╚══███╔╝╚██╗ ██╔╝      Z    
      ██║     ███████║  ███╔╝  ╚████╔╝    z       
      ██║     ██╔══██║ ███╔╝    ╚██╔╝   z         
      ███████╗██║  ██║███████╗   ██║   
      ╚══════╝╚═╝  ╚═╝╚══════╝   ╚═╝   
      ]]

      dashboard.section.header.val = vim.split(logo, "\n")
      dashboard.section.buttons.val = {
        dashboard.button("f", " " .. " Find file", ":Telescope find_files <CR>"),
        dashboard.button("n", " " .. " New file", ":ene <BAR> startinsert <CR>"),
        dashboard.button("r", " " .. " Recent files", ":Telescope oldfiles <CR>"),
        dashboard.button("g", " " .. " Find text", ":Telescope live_grep <CR>"),
        dashboard.button("c", " " .. " Config", ":e $MYVIMRC <CR>"),
        dashboard.button("s", "勒" .. " Restore Session", [[:lua require("persistence").load() <cr>]]),
        dashboard.button("l", "鈴" .. " Lazy", ":Lazy<CR>"),
        dashboard.button("q", " " .. " Quit", ":qa<CR>"),
      }
      for _, button in ipairs(dashboard.section.buttons.val) do
        button.opts.hl = "AlphaButtons"
        button.opts.hl_shortcut = "AlphaShortcut"
      end
      dashboard.section.footer.opts.hl = "Type"
      dashboard.section.header.opts.hl = "AlphaHeader"
      dashboard.section.buttons.opts.hl = "AlphaButtons"
      dashboard.opts.layout[1].val = 8
      return dashboard
    end,
  },

  -- noice overrides
  {
    "folke/noice.nvim",
    opts = {
      -- Override to turn off the cmdline
      cmdline = {
        view = "cmdline", -- classic cmdline at the bottom
      },
      -- Override to hide all msg_show messages as they are spammy.
      -- TODO: Are there good messages we should see here? How do you know?
      routes = {
        {
          filter = { event = "msg_show", kind = "" },
          opts = { skip = true },
        },
      },
      -- enabled = false,  -- keep enabled for now
    },
  },

  -- }}}
  --=====[ Treesitter ]====={{{1
  --
  { "nvim-treesitter/nvim-treesitter-refactor" }, -- Highlight definition of current symbol, current scope
  { "nvim-treesitter/playground", cmd = "TSPlayground" },

  -- }}}
  --=====[ Telescope ]====={{{1
  --
  { -- faster alternative to both default and fzy sorting
    "nvim-telescope/telescope-fzf-native.nvim",
    branch = "main",
    build = (function()
      if vim.fn.has("win32") then
        return "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build"
      else
        return "make"
      end
    end)(),
  },
  { "AckslD/nvim-neoclip.lua" }, -- search previous copy/pastes with :Telescope neoclip

  -- }}}
  --=====[ Code Completion ]====={{{1
  --
  { "lukas-reineke/cmp-rg" },
  { "ray-x/cmp-treesitter" },

  -- }}}
  --=====[ File and Buffer Navigation ]====={{{1
  --
  { "ThePrimeagen/harpoon" }, -- requires "nvim-lua/plenary.nvim"
  { "tpope/vim-projectionist" }, -- allow for project files
  { "jlanzarotta/bufexplorer", cmd = "BufExplorer" },
  { "lambdalisue/fern.vim", branch = "main" },

  -- }}}
  --=====[ Git and Diff ]====={{{1
  --
  {
    "TimUntersberger/neogit",
    name = "neogit",
    cmd = {
      "Neogit",
      "Neogit commit",
    },
    config = function()
      -- require("plugins.neogit")
    end,
  },
  {
    "sindrets/diffview.nvim",
    dependencies = { "neogit" },
  },
  -- }}}
}
