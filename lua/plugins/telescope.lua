local present, telescope = pcall(require, "telescope")
if not present then
   print("Unable to load telescope.")
   return
end

-- LuaFormatter off
telescope.setup {
  defaults = {
    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--no-ignore-messages",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
      "--max-filesize", "10M",
      "--glob", "!.git*",
      "--glob", "!.*cache*",
      "--glob", "!.vscode",
      "--glob", "!tags",
    },
    prompt_prefix = " λ ",
    selection_caret = " > ",
    entry_prefix = "  ",
    initial_mode = "insert",
    selection_strategy = "reset",
    sorting_strategy = "ascending",
    layout_strategy = "horizontal",
    --scroll_strategy = "cycle",
    --layout_strategy = "flex",
    layout_config = {
      horizontal = {
        prompt_position = "top",
        preview_width = 0.55,
        results_width = 0.8,
      },
      vertical = {
        mirror = false,
      },
      width = 0.87,
      height = 0.80,
      preview_cutoff = 120,
    },
    file_sorter = require("telescope.sorters").get_fuzzy_file,
    file_ignore_patterns = {},
    generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
    path_display = { "absolute" },
    winblend = 0,
    border = {},
    borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    color_devicons = true,
    use_less = true,
    set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
    file_previewer = require("telescope.previewers").vim_buffer_cat.new,
    grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
    qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
    -- Developer configurations: Not meant for general override
    buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
    --default_mappings = {
    --  i = {
    --    ['<C-j>'] = actions.move_selection_next,
    --    ['<C-k>'] = actions.move_selection_previous,
    --    ['<CR>'] = actions.select_default + actions.center,

    --    ['<C-x>'] = actions.select_horizontal,
    --    -- ['<C-v>'] = actions.goto_file_selection_vsplit,
    --    -- ['<C-t>'] = actions.goto_file_selection_tabedit,
    --    ['<C-c>'] = actions.close,
    --    ['<Esc>'] = actions.close,

    --    ['<C-u>'] = actions.preview_scrolling_up,
    --    ['<C-d>'] = actions.preview_scrolling_down,
    --    ['<C-q>'] = actions.send_to_qflist
    --  },
    --  n = {
    --    ['<CR>'] = actions.select_default + actions.center,
    --    ['<C-x>'] = actions.select_horizontal,
    --    -- ['<C-v>'] = actions.goto_file_selection_vsplit,
    --    -- ['<C-t>'] = actions.goto_file_selection_tabedit,
    --    ['<Esc>'] = actions.close,

    --    ["j"] = actions.move_selection_next,
    --    ["k"] = actions.move_selection_previous,

    --    ['<C-u>'] = actions.preview_scrolling_up,
    --    ['<C-d>'] = actions.preview_scrolling_down,
    --    ['<C-q>'] = actions.send_to_qflist
    --  }
    --}
  },
  extensions = {
    fzf = {
      fuzzy = true, -- false will only do exact matching
      override_generic_sorter = false, -- override the generic sorter
      override_file_sorter = true, -- override the file sorter
      case_mode = "smart_case", -- or "ignore_case" or "respect_case"
      -- the default case_mode is "smart_case"
    },
  },
}
-- LuaFormatter on

local extensions = { "themes", "terms", "fzf" }
local packer_repos = [["extensions", "telescope-fzf-native.nvim"]] -- superfast sorter

pcall(function()
   for _, ext in ipairs(extensions) do
      telescope.load_extension(ext)
   end
end)

local M = {}

local mru_buffers = {}
local actions = require('telescope.actions')
local actions_set = require('telescope.actions.set')
local finders = require('telescope.finders')
local make_entry = require('telescope.make_entry')
local pickers = require('telescope.pickers')
local conf = require('telescope.config').values

-- Track MRU file history (based on https://github.com/nvim-telescope/telescope.nvim/issues/433)
-- LuaFormatter off
vim.cmd[[augroup telescope_buffers]]
  vim.cmd[[autocmd!]]
  vim.cmd[[autocmd BufWinEnter,WinEnter * call v:lua.save_mru_buf(bufnr(''))]]
  vim.cmd[[autocmd BufDelete * silent! call v:lua.remove_mru_buf(expand('<abuf>'))]]
vim.cmd[[augroup END]]
-- LuaFormatter on

function _G.save_mru_buf(bufnr)
  mru_buffers[tostring(bufnr)] = vim.fn.reltimefloat(vim.fn.reltime())
  return mru_buffers
end

function _G.remove_mru_buf(bufnr)
  mru_buffers[tostring(bufnr)] = nil
  return mru_buffers
end

M.oldfiles_buffers = function()
  local bufnrs = vim.tbl_filter(function(b)
    local bufnr = tonumber(b)
    return vim.api.nvim_buf_is_loaded(bufnr) and 1 == vim.fn.buflisted(bufnr)
  end, vim.tbl_keys(mru_buffers))

  local bufs = vim.fn.sort(bufnrs, function(b1, b2)
    local buf1 = mru_buffers[b1]
    local buf2 = mru_buffers[b2]
    return buf1 < buf2 and 1 or -1
  end)

  bufs = vim.tbl_map(function(bufnr)
    return vim.fn.bufname(tonumber(bufnr))
  end, bufs)

  local oldfiles = vim.tbl_filter(function(val)
    return 0 ~= vim.fn.filereadable(val)
  end, vim.v.oldfiles)

  local default_selection_index = 1
  local results = vim.tbl_extend('keep', bufs, oldfiles)
  if #bufs > 0 then
    default_selection_index = 2
  end

  -- LuaFormatter off
  pickers.new({}, {
    prompt_title = 'History',
    finder = finders.new_table{
      results = results,
      entry_maker = make_entry.gen_from_file({}),
    },
    sorter = conf.file_sorter({}),
    previewer = conf.file_previewer({}),
    default_selection_index = default_selection_index
  }):find()
  -- LuaFormatter on
end

M.grep_prompt = function()
  require'telescope.builtin'.grep_string{
    shorten_path = false,
    search = vim.fn.input("Grep String > ")
  }
end

return M
