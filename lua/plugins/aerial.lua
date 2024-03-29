local present, aerial = pcall(require, "aerial")

if not present then
   return
end

aerial.setup({
  on_attach = function(bufnr)
    -- Toggle the aerial window with <leader>a
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>a', '<cmd>AerialToggle!<CR>', {})
    -- Jump forwards/backwards with '{' and '}'
    -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '{', '<cmd>AerialPrev<CR>', {})
    -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '}', '<cmd>AerialNext<CR>', {})
    -- -- Jump up the tree with '[[' or ']]'
    -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '[[', '<cmd>AerialPrevUp<CR>', {})
    -- vim.api.nvim_buf_set_keymap(bufnr, 'n', ']]', '<cmd>AerialNextUp<CR>', {})
  end,

  -- Priority list of preferred backends for aerial.
  -- This can be a filetype map (see :help aerial-filetype-map)
  backends = { "lsp", "treesitter", "markdown" },

  -- Aerial window will stay open as long as there is a visible buffer to attach to
  close_automatic_events = { "unsupported" },

  -- Set to false to remove the default keybindings for the aerial buffer
  default_bindings = true,

  -- Disable aerial on files with this many lines
  disable_max_lines = 10000,

  -- A list of all symbols to display. Set to false to display all symbols.
  -- This can be a filetype map (see :help aerial-filetype-map)
  -- To see all available values, see :help SymbolKind
  filter_kind = {
    "Class",
    "Constructor",
    "Enum",
    "Function",
    "Interface",
    "Module",
    "Method",
    "Struct",
  },

  -- Enum: split_width, full_width, last, none
  -- Determines line highlighting mode when multiple splits are visible.
  -- split_width   Each open window will have its cursor location marked in the
  --               aerial buffer. Each line will only be partially highlighted
  --               to indicate which window is at that location.
  -- full_width    Each open window will have its cursor location marked as a
  --               full-width highlight in the aerial buffer.
  -- last          Only the most-recently focused window will have its location
  --               marked in the aerial buffer.
  -- none          Do not show the cursor locations in the aerial window.
  highlight_mode = "split_width",

  -- Highlight the closest symbol if the cursor is not exactly on one.
  highlight_closest = true,

  -- When jumping to a symbol, highlight the line for this many ms.
  -- Set to false to disable
  highlight_on_jump = 300,

  -- Define symbol icons. You can also specify "<Symbol>Collapsed" to change the
  -- icon when the tree is collapsed at that symbol, or "Collapsed" to specify a
  -- default collapsed icon. The default icon set is determined by the
  -- "nerd_font" option below.
  -- If you have lspkind-nvim installed, aerial will use it for icons.
  icons = {},

  -- When you fold code with za, zo, or zc, update the aerial tree as well.
  -- Only works when manage_folds = true
  link_folds_to_tree = false,

  -- Fold code when you open/collapse symbols in the tree.
  -- Only works when manage_folds = true
  link_tree_to_folds = true,

  -- Use symbol tree for folding. Set to true or false to enable/disable
  -- 'auto' will manage folds if your previous foldmethod was 'manual'
  manage_folds = false,

  layout = {
    -- Enum: prefer_right, prefer_left, right, left, float
    -- Determines the default direction to open the aerial window. The 'prefer'
    -- options will open the window in the other direction *if* there is a
    -- different buffer in the way of the preferred direction
    default_direction = "prefer_right",

    -- The maximum width of the aerial window
    max_width = 40,

    -- The minimum width of the aerial window.
    -- To disable dynamic resizing, set this to be equal to max_width
    min_width = 10,

    -- Set to true to only open aerial at the far right/left of the editor
    -- Default behavior opens aerial relative to current window
    placement_editor_edge = false,
  },

  -- Set default symbol icons to use patched font icons (see https://www.nerdfonts.com/)
  -- "auto" will set it to true if nvim-web-devicons or lspkind-nvim is installed.
  nerd_font = "auto",

  -- Call this function when aerial attaches to a buffer.
  -- Useful for setting keymaps. Takes a single `bufnr` argument.
  on_attach = nil,

  -- Automatically open aerial when entering supported buffers.
  -- This can be a function (see :help aerial-open-automatic)
  open_automatic = false,

  -- Run this command after jumping to a symbol (false will disable)
  post_jump_cmd = "normal! zz",

  -- When true, aerial will automatically close after jumping to a symbol
  close_on_select = false,

  -- Show box drawing characters for the tree hierarchy
  show_guides = false,

  -- Customize the characters used when show_guides = true
  guides = {
    -- When the child item has a sibling below it
    mid_item = "├─",
    -- When the child item is the last in the list
    last_item = "└─",
    -- When there are nested child guides to the right
    nested_top = "│ ",
    -- Raw indentation
    whitespace = "  ",
  },

  -- Options for opening aerial in a floating win
  float = {
    -- Controls border appearance. Passed to nvim_open_win
    border = "rounded",

    -- override = function(conf, source_winid)
    --   conf = {
    --     -- Controls row offset from cursor. Passed to nvim_open_win
    --     row = 1,
    --     -- Controls col offset from cursor. Passed to nvim_open_win
    --     col = 0,
    --   }
    --   return conf
    -- end,

    -- The maximum height of the floating aerial window
    max_height = 100,

    -- The minimum height of the floating aerial window
    -- To disable dynamic resizing, set this to be equal to max_height
    min_height = 4,
  },

  lsp = {
    -- Fetch document symbols when LSP diagnostics update.
    -- If false, will update on buffer changes.
    diagnostics_trigger_update = true,

    -- Set to false to not update the symbols when there are LSP errors
    update_when_errors = true,
  },

  treesitter = {
    -- How long to wait (in ms) after a buffer change before updating
    update_delay = 300,
  },

  markdown = {
    -- How long to wait (in ms) after a buffer change before updating
    update_delay = 300,
  },
})
