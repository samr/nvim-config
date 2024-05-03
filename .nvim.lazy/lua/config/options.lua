-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add or override any options here
--
-- Fold Commands
--   (this is first in case file opens with folds folded)

--   :set foldmethod=marker  (or <F11> currently)
--   zo/zc open/close one fold
--   zr increment foldlevel
--   zm decrement foldlevel
--   zR open all folds
--   zM close all folds
--
--=====[ Initialization ]====={{{1

local global = require("global")
local Util = require("lazy.core.util")

--=====[ Options ]====={{{1

vim.g.mapleader = ","
vim.g.maplocalleader = ";"

local function load_options()
  -------[ Global options ]-----{{{2
  local global_and_local = {
    confirm = true, -- Confirm to save changes before exiting modified buffer
    smartindent = true, -- Insert indents automatically
    spelllang = "en",
    mouse = "a", -- enable mouse
    autoread = true, -- reread files when changed outside vim
    autowrite = false,
    autochdir = false, -- disable auto changedir
    cursorline = false, -- Enable highlighting of the current line
    modeline = false, --  modelines have historically been a source of security vulnerabilities
    backupcopy = "no", -- disable backup, or set to "yes" to fix weirdness in postcss
    termguicolors = true, -- truecolours for better experience
    errorbells = true,
    visualbell = true,
    hidden = true, -- keep hidden buffers
    fileformats = "unix,mac,dos",
    magic = true,
    virtualedit = "block",
    encoding = "utf-8",
    viewoptions = "folds,cursor,curdir,slash,unix",
    sessionoptions = "curdir,help,tabpages,winsize",
    clipboard = "unnamed,unnamedplus",
    wildmode = "longest:full,full", -- Command-line completion mode
    wildignorecase = true,
    wildignore = ".git,.hg,.svn,*.pyc,*.o,*.out,*.dvi,*.jpg,*.jpeg,*.png,*.gif,*.zip,**/tmp/**,*.DS_Store,**/node_modules/**,**/bower_modules/**",
    suffixes = ".bak,~,.o,.info,.swp,.obj,.out,.aux,.log,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.toc",
    backup = false,
    writebackup = false,
    swapfile = false,
    history = 5000,
    undolevels = 10000,
    undoreload = 10000,
    shada = "!,'300,<50,@100,s10,h",
    backupskip = "/tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*,/private/var/*,.vault.vim",
    smarttab = true, -- make tab behaviour smarter
    shiftround = true, -- round indent
    timeout = true,
    ttimeout = true,
    timeoutlen = 300, -- faster timeout wait time
    ttimeoutlen = 10,
    updatetime = 200,
    redrawtime = 1500,
    ignorecase = true, -- case insensitive on search
    smartcase = true, -- improve searching using '/'
    hlsearch = true, -- don't highlight matching search
    infercase = true,
    incsearch = true,
    wrapscan = true,
    complete = ".,w,b,t,k", -- controls what is scanned with Ctrl-N and Ctrl-P
    inccommand = "split", -- incrementally show result of command
    grepformat = "%f:%l:%c:%m",
    grepprg = "rg --hidden --vimgrep --smart-case --",
    startofline = false,
    whichwrap = "h,l,<,>,[,],~",
    splitbelow = true, -- split new windows below instead of above
    splitright = true, -- split new windows right instead of left
    switchbuf = "useopen",
    backspace = "indent,eol,start", -- allow backspacing to previous line
    diffopt = "filler,iwhite,internal,algorithm:patience",
    completeopt = "menu,menuone,noinsert,noselect", -- better completion
    jumpoptions = "stack",
    showmode = false,
    shortmess = "csaIWF", -- disable some stuff on shortmess (maybe try astWAIc)
    scrolloff = 2, -- lines of context
    sidescrolloff = 15, -- columns of context
    foldlevelstart = 99,
    ruler = false,
    list = true, -- display listchars, showing invisible characters
    winwidth = 30,
    winminwidth = 10, -- Minimum window width
    pumheight = 15, -- limit completion items
    cmdheight = 2,
    showcmd = true,
    equalalways = false,
    laststatus = 0, -- disable statusline
    display = "lastline",
    showbreak = "↳  ",
    listchars = "tab:»·,nbsp:+,trail:·,extends:→,precedes:←",
    pumblend = 10,
    winblend = 10,
    re = 0, -- set regexp engine to auto
    guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20,i:blinkwait700-blinkon400-blinkoff250",
    ----
    directory = global.cache_dir .. "swap/",
    undodir = global.cache_dir .. "undo/",
    backupdir = global.cache_dir .. "backup/",
    viewdir = global.cache_dir .. "view/",
    spellfile = global.cache_dir .. "spell/en.uft-8.add",
    ----
    -- Seems this is better set in ginit.vim with :Guifont!
    --guifont        = 'Roboto\\ Mono\\ Medium\\ for\\ Powerlin:h7';
    --guifontwide    = 'Roboto\\ Mono\\ Medium\\ for\\ Powerlin:h7';
  }

  -------[ Buffer and Window options ]-----{{{2
  local bw_local = {
    undofile = true, -- enable persistent undo
    synmaxcol = 500, -- avoid syntax highlighting for long lines
    --formatoptions  = "1jcroql",
    --formatoptions = "jcroqlnt", -- tcqj
    formatoptions = "1jql",
    textwidth = 120,
    --colorcolumn    = "120";
    expandtab = true, -- Use spaces instead of tabs
    autoindent = true,
    cindent = true, -- enable cindent
    tabstop = 2, -- number of spaces tabs count for
    shiftwidth = 2, -- size of indent
    softtabstop = -1,
    breakindentopt = "shift:2,min:20",
    wrap = false, -- Disable line wrap
    --linebreak      = true;
    number = true, -- show line numbers
    relativenumber = true, -- enable relativenumber
    foldenable = true,
    signcolumn = "yes", -- enable sign column all the time, 4 column
    conceallevel = 2,
    concealcursor = "niv",
  }

  -------[ Loading logic ]-----{{{2
  local function bind_option(options)
    for k, v in pairs(options) do
      if v == true or v == false then
        vim.cmd("set " .. k)
      else
        vim.cmd("set " .. k .. "=" .. v)
      end
    end
  end

  local options_info = {}
  for _, v in pairs(vim.api.nvim_get_all_options_info()) do
    options_info[v.name] = true
    if v.shortname ~= "" then
      options_info[v.shortname] = true
    end
  end

  for name, value in pairs(global_and_local) do
    if not options_info[name] then
      print("unsupported option: " .. name)
    else
      Util.try(function()
        vim.o[name] = value
      end, {
        msg = "Failed loading " .. name,
        on_error = function(msg)
          Util.error(msg)
        end,
      })
    end
  end
  bind_option(bw_local)
end

load_options()

if global.is_windows then
  vim.opt.shell = "cmd.exe" -- necessary for formatter.nvim and gutentags
end

--=====[ Filetype settings ]====={{{1
-- 2 spaces for selected filetypes
--vim.cmd [[
--  autocmd FileType xml,html,xhtml,css,scss,javascript,lua,yaml setlocal shiftwidth=3 tabstop=3
--]]

--=====[ Global options ]====={{{1

-- git
vim.g.author = "sriesland"
vim.g.author_short = "sriesland"

if global.is_windows then
  -- Set python and node provider path to make startup faster
  vim.g.python_host_prog = "C:/Python27/python.exe"
  vim.g.python3_host_prog = "C:/Python38/python.exe"

  -- Set the clipboard explicitly for windows so that clipboard.vim loads faster.
  vim.g.clipboard = {
    name = "win32yank",
    copy = {
      ["+"] = { "win32yank.exe", "-i", "--crlf" },
      ["*"] = { "win32yank.exe", "-i", "--crlf" },
    },
    paste = {
      ["+"] = { "win32yank.exe", "-o", "--lf" },
      ["*"] = { "win32yank.exe", "-o", "--lf" },
    },
    cache_enabled = 1,
  }
end

--=====[ Plugin options ]====={{{1
--
-------[ Assorted plugins ]-----{{{2

-- Auto start the coq nvim plugin, but quietly
vim.g.coq_settings = { auto_start = "shut-up" }

-- disable git messenger default mappings
vim.g.git_messenger_no_default_mappings = true

vim.g.vimsyn_embed = "lPr" -- allow embedded syntax highlighting for lua, python, ruby

vim.g.neovide_cursor_vfx_mode = "pixiedust" -- neovide trail

-- In millisecond, used for both CursorHold and CursorHoldI, use updatetime instead if not defined
vim.g.cursorhold_updatetime = 100

-- Don't implicitly change to the directory of the opened file with vim-startify.
vim.g.startify_change_to_dir = 0

vim.g.NERDSpaceDelims = 1 -- Add a space after comment delim and before line in question.
vim.g.NERDCommentEmptyLines = 1 -- Ensure empty lines also get a comment.

-------[ airline ]-----{{{2
-- See airline faq for the rendering tradeoffs:
-- https://github.com/vim-airline/vim-airline/wiki/FAQ#the-powerline-font-symbols-are-not-showing-up
vim.g.airline_powerline_fonts = 1 -- use the nice powerline fonts
--vim.g.airline_highlighting_cache = 1 -- if you see weirdness, use :AirlineRefresh

-------[ indentline ]-----{{{2

-- Set indentline characters
vim.g.indentLine_first_char = "▏"
vim.g.indentLine_char = "▏"
vim.g.indentLine_faster = 1
vim.g.indentLine_leadingSpaceChar = "˽"

-- Set indentline ignored list
vim.g.indentLine_bufTypeExclude = { "help" }
vim.g.indentLine_bufNameExclude = { "startify", "NERD_tree_*", "fern" }
vim.g.indentLine_fileTypeExclude = { "markdown", "defx", "" }

-- Enable indentation at first level
vim.g.indentLine_showFirstIndentLevel = 1

-- svelte
vim.g.vim_svelte_plugin_has_init_indent = 0

-- highlight yanked text for 250ms
--vim.cmd("au TextYankPost * silent! lua vim.highlight.on_yank{ timeout = 250 }")

-- Disable until https://github.com/vim-airline/vim-airline/issues/2324 is resolved.
-- vim.g["airline#extensions#nvimlsp#enabled"] = 0

-- To choose a theme look at the wiki:
-- https://github.com/vim-airline/vim-airline/wiki/Screenshots
vim.g.airline_theme = "deus"
