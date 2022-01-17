local present, cmp = pcall(require, "cmp")

if not present then
   return
end

--vim.opt.completeopt = "menuone,noselect"

-- vim.g.copilot_no_tab_map = true
-- vim.g.copilot_assume_mapped = true
-- vim.g.copilot_tab_fallback = ""

-- nvim-cmp setup
cmp.setup {
  completion = {
    autocomplete = false, -- disable auto-completion
  },
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  formatting = {
    format = function(entry, vim_item)
      vim_item.menu = ({
        rg = "ripg",
        nvim_lsp = "LSP",
        nvim_lua = "Lua",
        Path = "Path",
        luasnip = "LuaSnip",
        neorg = "Neorg",
        orgmode = "Org",
        treesitter = "ts",
      })[entry.source.name]
      vim_item.kind = ({
        Text = "",
        Method = "",
        Function = "",
        Constructor = "",
        Field = "ﰠ",
        Variable = "",
        Class = "ﴯ",
        Interface = "",
        Module = "",
        Property = "ﰠ",
        Unit = "塞",
        Value = "",
        Enum = "",
        Keyword = "",
        Snippet = "",
        Color = "",
        File = "",
        Reference = "",
        Folder = "",
        EnumMember = "",
        Constant = "",
        Struct = "פּ",
        Event = "",
        Operator = "",
        TypeParameter = "",
      })[vim_item.kind]
      return vim_item
    end,
  },
  mapping = {
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.close(),
    ["<CR>"] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    -- Smarter tab completion:
    --   1. When the preceding character is whitespace or at the beginning of the line, then do nothing
    --      but normal tab behvior.
    --   2. If the tab completion drop down is open, go to the next/prev entry.
    --   3. If there is a snippet marker to jump to, then do that.
    --   4. Open the tab completion drop down with potential options.
    ["<Tab>"] = function(fallback)
      local win = vim.api.nvim_get_current_win()
      local col = vim.api.nvim_win_get_cursor(win)[2]
      local line = vim.api.nvim_get_current_line()
      local char = (col == nil or line == nil or line == '') and " " or string.sub(line, col, col)
      if char and string.find(char, '%s') ~= nil then
        fallback()
      elseif cmp.visible() then
        cmp.select_next_item()
      elseif require("luasnip").expand_or_jumpable() then
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true), "")
      else
        cmp.complete()
        -- TODO: Experiment with copilot at some point
        -- local copilot_keys = vim.fn["copilot#Accept"]()
        -- if copilot_keys ~= "" then
        --   vim.api.nvim_feedkeys(copilot_keys, "i", true)
        -- else
        --   cmp.complete()
        -- end
      end
    end,
    ["<S-Tab>"] = function(fallback) -- Similar to smart tab completion above, but looking backward.
      local win = vim.api.nvim_get_current_win()
      local col = vim.api.nvim_win_get_cursor(win)[2]
      local line = vim.api.nvim_get_current_line()
      local char = (col == nil or line == nil or line == '') and " " or string.sub(line, col, col)
      if char and string.find(char, '%s') ~= nil then
        fallback()
      elseif cmp.visible() then
        cmp.select_prev_item()
      elseif require("luasnip").jumpable(-1) then
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-jump-prev", true, true, true), "")
      else
        fallback()
      end
    end,
  },
  sources = {
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "treesitter" },
    -- { name = "rg" },  -- this can be slow
    -- { name = "nvim_lua" },
  },
}
