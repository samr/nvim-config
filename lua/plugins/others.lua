local M = {}

M.blankline = function()
   require("indent_blankline").setup {
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

M.signature = function()
   local present, lspsignature = pcall(require, "lsp_signature")
   if present then
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
end

M.comment = function()
   local present, comment = pcall(require, "Commment")
   if present then
      comment.setup {
         padding = true,
      }
   end
end

return M
