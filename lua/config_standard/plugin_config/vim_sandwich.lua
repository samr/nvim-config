-- Make vim-sandwich behave as if it were vim-surround.
-- Note that this obviously depends on where lazy.nvim is downloading its plugins to.
vim.api.nvim_exec('source '..vim.fn.stdpath("data")..'/lazy/vim-sandwich/macros/sandwich/keymap/surround.vim', true)
