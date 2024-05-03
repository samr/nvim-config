local vim = vim
local autocmd = {}

function autocmd.nvim_create_augroups(definitions)
  for group_name, definition in pairs(definitions) do
    vim.api.nvim_command('augroup '..group_name)
    vim.api.nvim_command('autocmd!')
    for _, def in ipairs(definition) do
      local command = table.concat(vim.tbl_flatten{'autocmd', def}, ' ')
      vim.api.nvim_command(command)
    end
    vim.api.nvim_command('augroup END')
  end
end

function autocmd.load_autocmds()
  local definitions = {
    -- packer = {
    --   {"BufWritePost","*.lua","lua require('core.pack').auto_compile()"};
    -- },
    bufs = {
      {"BufWritePre","/tmp/*","setlocal noundofile"};
      {"BufWritePre","COMMIT_EDITMSG","setlocal noundofile"};
      {"BufWritePre","MERGE_MSG","setlocal noundofile"};
      {"BufWritePre","*.tmp","setlocal noundofile"};
      {"BufWritePre","*.bak","setlocal noundofile"};
      {"BufWritePre","*.tsx","lua vim.api.nvim_command('Format')"};
      {"BufWritePre","*.go","lua require('internal.golines').golines_format()"};
    };

    wins = {
      -- Force write shada on leaving nvim
      {"VimLeave", "*", [[if has('nvim') | wshada! | else | wviminfo! | endif]]};
      -- Check if file changed when its window is focus, more eager than 'autoread'
      {"FocusGained", "* checktime"};
      --
      -- Disable these as they do not seem to work currently:
      --
      -- Highlight current line only on focused window
      -- {"WinEnter,BufEnter,InsertLeave", "*", "[[if ! &cursorline && &filetype !~# '^\(dashboard\|clap_\)' && ! &pvw | setlocal cursorline | endif]]"};
      -- {"WinLeave,BufLeave,InsertEnter", "*", "[[if &cursorline && &filetype !~# '^\(dashboard\|clap_\)' && ! &pvw | setlocal nocursorline | endif]]"};
      --
      -- Equalize window dimensions when resizing vim window
      -- {"VimResized", "*", "[[tabdo wincmd =]]"};
    };

    ft = {
      {"FileType", "NvimTree", "hi Cursor blend=100"};
      {"FileType", "dashboard", "set showtabline=0 | autocmd WinLeave <buffer> set showtabline=2"};
      {"FileType", "cpp", "setlocal shiftwidth=4 tabstop=4 softtabstop=4"};
      {"FileType", "cpp", "setlocal textwidth=120"};
      {"FileType", "cpp", "setlocal expandtab wrap cindent"};
      {"FileType", "cpp", "setlocal cinoptions=h1,l1,g1,t0,i4,+4,(0,w1,W4"};
      {"BufNewFile,BufRead","*.toml"," setf toml"};
    };

    -- yank = {
    --   -- Highlight what was yanked after it was yanked
    --   {"TextYankPost", [[* silent! lua vim.highlight.on_yank({higroup="IncSearch", timeout=400})]]};
    -- };
  }

  autocmd.nvim_create_augroups(definitions)
end

autocmd.load_autocmds()
