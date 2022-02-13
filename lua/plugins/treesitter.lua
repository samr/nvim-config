local present, ts_config = pcall(require, "nvim-treesitter.configs")
if not present then
   return
end

local parser_configs = require("nvim-treesitter.parsers").get_parser_configs()
parser_configs.norg = {
   -- on macOS: https://github.com/nvim-neorg/neorg/issues/74#issuecomment-906627223
   install_info = {
      url = "https://github.com/nvim-neorg/tree-sitter-norg",
      files = { "src/parser.c", "src/scanner.cc" },
      branch = "main",
   },
}
parser_configs.org = {
   install_info = {
      url = "https://github.com/milisims/tree-sitter-org",
      revision = "main",
      files = { "src/parser.c", "src/scanner.cc" },
   },
   filetype = "org",
}

ts_config.setup {
   ensure_installed = {
      "typescript",
      "javascript",
      "jsdoc",
      "json",
      "html",
      "css",
      "php",
      "graphql",
      "rust",
      "tsx",
      "cpp",
      "python",
      "lua",
      "yaml",
      "toml",
      "nix",
      "go",
      "query",
   },

   indent = { enable = true },
   highlight = {
      enable = false,
      use_languagetree = true,
      additional_vim_regex_highlighting = { "org" },
   },
   rainbow = {
      enable = false,
      extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
      max_file_lines = nil, -- Do not enable for files with more than n lines, int
   },
   playground = {
      enable = false,
      updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
      persist_queries = false, -- Whether the query persists across vim sessions
   },
   incremental_selection = {

      enable = false,
      keymaps = {
         init_selection = "<CR>",
         scope_incremental = "<CR>",
         node_incremental = "<TAB>",
         node_decremental = "<S-TAB>",
      },
   },
   textobjects = {
      select = {
         enable = true,
         lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
         keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            -- ["ac"] = "@comment.outer",  -- doesn't really work well for C++ comments of form //
            -- ["ic"] = "@comment.outer",
         },
      },
      lsp_interop = {
         enable = true,
      },
      move = {
         enable = true,
         set_jumps = true, -- whether to set jumps in the jumplist
         goto_next_start = {
            ["]m"] = "@function.outer",
            ["]]"] = "@parameter.inner",
         },
         goto_next_end = {
            ["]M"] = "@function.outer",
            ["]["] = "@parameter.outer",
         },
         goto_previous_start = {
            ["[m"] = "@function.outer",
            ["[["] = "@parameter.inner",
         },
         goto_previous_end = {
            ["[M"] = "@function.outer",
            ["[]"] = "@parameter.outer",
         },
      },
   },
}
