-- Default key bindings:
-- <esc> -> exit to normal
-- <bs> -> backspace always, even when completion menu is open
-- <c-w> -> delete word before the cursor, even when completion menu is open
-- <c-u> -> delete all entered characters before the cursor, even when completion menu is open
-- <c-k> -> move from floating window to fixed window
-- <c-h> -> jump to mark
-- <c-c> -> resume editing as normal
-- <cr> -> select completion if completion menu is open
-- <tab> -> if completion menu is open: select next item
-- <s-tab> -> if completion menu is open: select prev item
--
-- To get list of kind keys... :lua print(vim.inspect(vim.lsp.protocol.CompletionItemKind))
--
-- Snippets:
--
-- Workflow
-- 1. :COQsnips edit -- edits snippet for current filetype
-- 2. <eval_snips> -- live repl to ensure snippet is what you want
-- 3. :COQsnips compile -- boom, you are good to do
--
-- To see where snips are stored
--   :COQsnips cd
--   :COQsnips ls
--
-- https://github.com/ms-jpq/coq_nvim/blob/coq/docs/SNIPS.md
-- Snippets use https://github.com/microsoft/language-server-protocol/blob/main/snippetSyntax.md
--
--coq = {
--  { src = "nvimlua", short_name = "nLUA" },
--  { src = "vimtex", short_name = "vTEX" },
--  { src = "copilot", short_name = "COP", tmp_accept_key = "<c-r>" },
--  { src = "demo" },
--}
--
local present, coq = pcall(require, "coq")
if not present then
  print("Coq not present.")
  return
end

vim.g.coq_settings = {
  keymap = {
    -- recommended = false,
    -- jump_to_mark = '<C-g>', -- <c-h> conflicts with my binding for :TmuxNavigateLeft

    -- evaluate current visual selection or buffer as a user defined snippet (unbound by default)
    eval_snips = '<leader>j',
  },
  auto_start = 'shut-up',
  display {
    icons {
      mode = 'none',  -- disable icons
    },
    pum {
      --y_max_len,
      --y_ratio,
      fast_close = false
    },
  },
  auto_start = 'shut-up',
  clients = {
    tmux = {
      enabled = false
    },
    buffers = {
      enabled = true,
      weight_adjust = -1.9,
    },
    tree_sitter = {
      enabled = true,
      weight_adjust = -1.5
    },
    lsp = {
      enabled = false,
      weight_adjust = 1.5
    },
    snippets = {
      enabled = true,
      weight_adjust = 1.9
      --user_path = ""
    },
  -- On Linux use XDG
  -- ["xdg"] = true
  }
}

vim.opt.showmode = false
vim.opt.shortmess = vim.opt.shortmess + {c=true}

-- -- Aint nobody got time to figure out the nuances of doing a keybind
-- -- with native lua with expr=true
-- vim.api.nvim_exec(
-- [[
-- inoremap <silent><expr> <Esc>   pumvisible() ? "\<C-e><Esc>" : "\<Esc>"
-- inoremap <silent><expr> <C-c>   pumvisible() ? "\<C-e><C-c>" : "\<C-c>"
-- inoremap <silent><expr> <BS>    pumvisible() ? "\<C-e><BS>"  : "\<BS>"
-- inoremap <silent><expr> <CR>    pumvisible() ? (complete_info().selected == -1 ? "\<C-e><CR>" : "\<C-y>") : "\<CR>"
-- inoremap <silent><expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
-- inoremap <silent><expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<BS>"
-- ]],
-- false
-- )
