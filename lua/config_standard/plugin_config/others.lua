local global = require('global')

local M = {}

M.blankline = function()
  local present, indent_blankline = pcall(require, "indent_blankline")
  if not present then
    return
  end
  indent_blankline.setup {
    show_current_context = true,
    context_patterns = {
      "class",
      "return",
      "function",
      "method",
      "^if",
      "^while",
      "jsx_element",
      "^for",
      "^object",
      "^table",
      "block",
      "arguments",
      "if_statement",
      "else_clause",
      "jsx_element",
      "jsx_self_closing_element",
      "try_statement",
      "catch_clause",
      "import_statement",
      "operation_type",
    },
    filetype_exclude = {
      "help",
      "terminal",
      "dashboard",
      "packer",
      "lspinfo",
      "TelescopePrompt",
      "TelescopeResults",
    },
    buftype_exclude = { "terminal" },
    show_trailing_blankline_indent = false,
    show_first_indent_level = false,
  }
end

M.luasnip = function()
  local present, luasnip = pcall(require, "luasnip")
  if not present then
    return
  end
  luasnip.config.set_config {
    history = true,
    updateevents = "TextChanged,TextChangedI",
  }
  require("luasnip/loaders/from_vscode").load()
end

M.lsp_signature = function()
  local present, lspsignature = pcall(require, "lsp_signature")
  if not present then
    return
  end
  lspsignature.setup {
    bind = true,
    doc_lines = 2,
    floating_window = true,
    fix_pos = true,
    hint_enable = true,
    hint_prefix = " ",
    hint_scheme = "String",
    hi_parameter = "Search",
    max_height = 22,
    max_width = 120, -- max_width of signature floating_window, line will be wrapped if exceed max_width
    handler_opts = {
      border = "single", -- double, single, shadow, none
    },
    zindex = 200, -- by default it will be on top of all floating windows, set to 50 send it to bottom
    padding = "", -- character to pad on left and right of signature can be ' ', or '|'  etc
  }
end

M.comment = function()
  local present, comment = pcall(require, "Comment")
  if not present then
    print("unable to load comment")
    return
  end
  comment.setup {
    padding = true,
  }
end

M.lspsaga = function ()
  local present, saga = pcall(require, "lspsaga")
  if not present then
    return
  end
  saga.init_lsp_saga {
    -- code_action_icon = '💡'

    -- Default values:
    -- use_saga_diagnostic_sign = true
    -- error_sign = '',
    -- warn_sign = '',
    -- hint_sign = '',
    -- infor_sign = '',
    -- dianostic_header_icon = '   ',
    -- code_action_icon = ' ',
    -- code_action_prompt = {
    --   enable = true,
    --   sign = true,
    --   sign_priority = 20,
    --   virtual_text = true,
    -- },
    -- finder_definition_icon = '  ',
    -- finder_reference_icon = '  ',
    -- max_preview_lines = 10, -- preview lines of lsp_finder and definition preview
    -- finder_action_keys = {
    --   open = 'o', vsplit = 's',split = 'i',quit = 'q',scroll_down = '<C-f>', scroll_up = '<C-b>' -- quit can be a table
    -- },
    -- code_action_keys = {
    --   quit = 'q',exec = '<CR>'
    -- },
    -- rename_action_keys = {
    --   quit = '<C-c>',exec = '<CR>'  -- quit can be a table
    -- },
    -- definition_preview_icon = '  '
    -- "single" "double" "round" "plus"
    -- border_style = "single"
    -- rename_prompt_prefix = '➤',
    -- if you don't use nvim-lspconfig you must pass your server name and
    -- the related filetypes into this table
    -- like server_filetype_map = {metals = {'sbt', 'scala'}}
    -- server_filetype_map = {}
  }
end

M.trouble = function ()
  local present, trouble = pcall(require, "trouble")
  if not present then
    return
  end
  trouble.setup {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  }
end

M.lualine = function()
  local present, lualine = pcall(require, "lualine")
  if not present then
    print("unable to load lualine")
    return
  end

  -- Bubbles config for lualine
  -- Author: lokesh-krishna
  -- MIT license, see LICENSE for more details.

  -- stylua: ignore
  local colors = {
    blue   = '#80a0ff',
    cyan   = '#79dac8',
    black  = '#080808',
    white  = '#c6c6c6',
    red    = '#ff5189',
    violet = '#d183e8',
    grey   = '#303030',
  }

  local bubbles_theme = {
    normal = {
      a = { fg = colors.black, bg = colors.violet },
      b = { fg = colors.white, bg = colors.grey },
      c = { fg = colors.black, bg = colors.black },
    },

    insert = { a = { fg = colors.black, bg = colors.blue } },
    visual = { a = { fg = colors.black, bg = colors.cyan } },
    replace = { a = { fg = colors.black, bg = colors.red } },

    inactive = {
      a = { fg = colors.white, bg = colors.grey },
      b = { fg = colors.white, bg = colors.grey },
      c = { fg = colors.black, bg = colors.grey },
    },
  }

  require('lualine').setup {
    options = {
      theme = bubbles_theme,
      -- theme = onedark,
      component_separators = '|',
      section_separators = { left = '', right = '' },
    },
    sections = {
      lualine_a = {
        {
          'mode',
          -- separator = { left = '' },
          right_padding = 2
        },
      },
      lualine_b = {
        { 'filename', path = 1 },
        -- { 'buffers', show_filename_only = false, },
      },
      lualine_c = {
        'fileformat'
      },
      lualine_x = {},
      lualine_y = {
        "aerial",
        'branch',
        'filetype',
        'progress',
      },
      lualine_z = {
        {
          'location',
          --separator = { right = '' },
          left_padding = 2
        },
      },
    },
    inactive_sections = {
      lualine_a = {
        { 'filename', path = 1 },
      },
      lualine_b = {},
      lualine_c = {},
      lualine_x = {},
      lualine_y = {},
      lualine_z = { 'location' },
    },
    tabline = {},
    extensions = {},
  }
end

M.feline = function()
  local present, feline = pcall(require, "feline")
  if not present then
    return
  end
  print("loading feline")
  feline.setup({
      -- preset = 'noicon'
  })
end

M.windline = function()
  local present, windline = pcall(require, "windline")
  if not present then
    return
  end
  print("loading windline")
  windline.setup({
    statuslines = {
      --require('wlsample.bubble2')
      require('wlsample.airline')
    },
    colors = {
      black          = '#282828',
      white          = '#ebdbb2',
      red            = '#fb4934',
      green          = '#b8bb26',
      blue           = '#83a598',
      yellow         = '#fe8019',
      cyan           = "#00cccc",
      magenta        = '#c6c6c6',
      black_light    = '#3c3836',
      white_light    = '#a89984',
      red_light      = '#ff5a67',
      yellow_light   = '#fabd2f',
      blue_light     = "#517f8d",
      magenta_light  = "#c694ff",
      green_light    = '#7eca9c',
      cyan_light     = '#00ffff',
      NormalFg       = "#ebdbb2",
      NormalBg       = "#282828",
      InactiveFg     = '#c6c6c6',
      InactiveBg     = '#3c3836',
      ActiveFg       = '#928b95',
      ActiveBg       = '#282828',
      TabSelectionBg = "#b8bb26",
      TabSelectionFg = "#282828",
    },
    -- this function will run on ColorScheme autocmd
    -- colors_name = function(colors)
    --   --- add new colors
    --   colors.FilenameFg = colors.white_light
    --   colors.FilenameBg = colors.black

    --   -- this color will not update if you change a colorscheme
    --   colors.gray = "#fefefe"

    --   -- dynamically get color from colorscheme hightlight group
    --   local searchFg, searchBg = require('windline.themes').get_hl_color('Search')
    --   colors.SearchFg = searchFg or colors.white
    --   colors.SearchBg = searchBg or colors.yellow

    --   return colors
    -- end,
  })
end

M.neo_tree = function()
  local present, neo_tree = pcall(require, "neo-tree")
  if not present then
    return
  end
  neo_tree.setup({
    popup_border_style = "rounded",
    enable_git_status = true,
    enable_diagnostics = true,
    filesystem = {
      window = {
        position = "left",
        width = 40,
        mappings = {
          ["<2-LeftMouse>"] = "open",
          ["<cr>"] = "open",
          ["S"] = "open_split",
          ["s"] = "open_vsplit",
          ["C"] = "close_node",
          ["<bs>"] = "navigate_up",
          ["."] = "set_root",
          ["H"] = "toggle_hidden",
          ["I"] = "toggle_gitignore",
          ["R"] = "refresh",
          ["/"] = "filter_as_you_type",
          ["f"] = "filter_on_submit",
          ["<c-x>"] = "clear_filter",
          ["a"] = "add",
          ["d"] = "delete",
          ["r"] = "rename",
          ["c"] = "copy_to_clipboard",
          ["x"] = "cut_to_clipboard",
          ["p"] = "paste_from_clipboard",
          ["bd"] = "buffer_delete",
        }
      }
    },
    buffers = {
      show_unloaded = true,
      window = {
        position = "left",
        mappings = {
          ["<2-LeftMouse>"] = "open",
          ["<cr>"] = "open",
          ["S"] = "open_split",
          ["s"] = "open_vsplit",
          ["<bs>"] = "navigate_up",
          ["."] = "set_root",
          ["R"] = "refresh",
          ["a"] = "add",
          ["d"] = "delete",
          ["r"] = "rename",
          ["c"] = "copy_to_clipboard",
          ["x"] = "cut_to_clipboard",
          ["p"] = "paste_from_clipboard",
        }
      },
    },
    git_status = {
      window = {
        position = "float",
        mappings = {
          ["<2-LeftMouse>"] = "open",
          ["<cr>"] = "open",
          ["S"] = "open_split",
          ["s"] = "open_vsplit",
          ["C"] = "close_node",
          ["R"] = "refresh",
          ["d"] = "delete",
          ["r"] = "rename",
          ["c"] = "copy_to_clipboard",
          ["x"] = "cut_to_clipboard",
          ["p"] = "paste_from_clipboard",
          ["A"]  = "git_add_all",
          ["gu"] = "git_unstage_file",
          ["ga"] = "git_add_file",
          ["gr"] = "git_revert_file",
          ["gc"] = "git_commit",
          ["gp"] = "git_push",
          ["gg"] = "git_commit_and_push",
        }
      }
    }
  })
end

M.nvim_mapper = function()
  local present, nvim_mapper = pcall(require, "nvim-mapper")
  if not present then
    return
  end

  nvim_mapper.setup({
    -- do not assign the default keymap (<leader>MM)
    no_map = false,
    -- where should ripgrep look for your keybinds definitions.
    -- Default config search path is ~/.config/nvim/lua
    search_path = global.lua_dir,
    -- what should be done with the selected keybind when pressing enter.
    -- Available actions:
    --   * "definition" - Go to keybind definition (default)
    --   * "execute" - Execute the keybind command
    action_on_enter = "definition",
  })
end

M.neoclip = function()
  require('neoclip').setup({
    history = 1000,
    enable_persistent_history = false,
    db_path = vim.fn.stdpath("data") .. "/databases/neoclip.sqlite3",
    filter = nil,
    preview = true,
    default_register = '"',
    default_register_macros = 'q',
    enable_macro_history = true,
    content_spec_column = false,
    on_paste = {
      set_reg = false,
    },
    on_replay = {
      set_reg = false,
    },
    keys = {
      telescope = {
        i = {
          select = '<cr>',
          paste = '<c-p>',
          paste_behind = '<c-k>',
          replay = '<c-q>',
          custom = {},
        },
        n = {
          select = '<cr>',
          paste = 'p',
          paste_behind = 'P',
          replay = 'q',
          custom = {},
        },
      },
      fzf = {
        select = 'default',
        paste = 'ctrl-p',
        paste_behind = 'ctrl-k',
        custom = {},
      },
    },
  })
end

M.indentomatic = function()
  require('indent-o-matic').setup({
    -- Number of lines without indentation before giving up (use -1 for infinite)
    max_lines = 2048,

    -- Space indentations that should be detected
    standard_widths = { 2, 3, 4, },

    -- -- Disable indent-o-matic for LISP files
    -- filetype_lisp = {
    --     max_lines = 0,
    -- },

    -- -- Only detect 2 and 4 spaces and tabs for Rust files
    -- filetype_rust = {
    --     standard_widths = { 2, 4 },
    -- },
  })
end

M.vim_expand_region = function()
  -- In the dictionaries below, '1' indicates that the text object is recursive
  -- (think of nested parens or brackets)

  vim.fn['expand_region#custom_text_objects']({
    ['a]'] = 1, -- Support nesting of 'around' brackets
    ['ab'] = 1, -- Support nesting of 'around' parentheses
    ['aB'] = 1, -- Support nesting of 'around' braces
    ['ii'] = 0, -- 'inside indent'. Available through https://github.com/kana/vim-textobj-indent
    ['ai'] = 0, -- 'around indent'. Available through https://github.com/kana/vim-textobj-indent
    ['i '] = 0, -- 'space below'.
    ['a '] = 0, -- 'space above'.
    ["af"] = 0, -- function
    ["if"] = 0, -- function
    ["a?"] = 0, -- conditional
    ["i?"] = 0, -- conditional
    ["ao"] = 0, -- loop
    ["io"] = 0, -- loop
    })

  -- Dicates the order in which + tries to grow the visual selection with text objects.
  vim.g.expand_region_text_objects = {
    ['iw']    = 0,
    ['iW']    = 0,
    ['i"']    = 0,
    ['i\'']   = 0,
    ['i]']    = 1, -- Support nesting of square brackets
    ['ib']    = 1, -- Support nesting of parentheses
    ['al']    = 0, -- 'outside line'. Available through https://github.com/kana/vim-textobj-line
    ['a?']    = 0,
    ['ao']    = 0,
    ['iB']    = 1, -- Support nesting of braces
    ['ip']    = 0,
    ['ie']    = 0, -- 'entire file'. Available through https://github.com/kana/vim-textobj-entire
    }
end

return M
