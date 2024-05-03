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

local global = require('global')

local function bind_option(options)
  for k, v in pairs(options) do
    if v == true or v == false then
      vim.cmd('set ' .. k)
    else
      vim.cmd('set ' .. k .. '=' .. v)
    end
  end
end

--=====[ Options ]====={{{1

local function load_options()
  -------[ Global options ]-----{{{2
  local global_and_local = {
    mouse          = "a"; -- enable mouse
    autoread       = true; -- reread files when changed outside vim
    autochdir      = false; -- disable auto changedir
    cursorline     = false;
    modeline       = false; --  modelines have historically been a source of security vulnerabilities
    backupcopy     = "no"; -- disable backup, or set to "yes" to fix weirdness in postcss
    termguicolors  = true; -- truecolours for better experience
    errorbells     = true;
    visualbell     = true;
    hidden         = true; -- keep hidden buffers
    fileformats    = "unix,mac,dos";
    magic          = true;
    virtualedit    = "block";
    encoding       = "utf-8";
    viewoptions    = "folds,cursor,curdir,slash,unix";
    sessionoptions = "curdir,help,tabpages,winsize";
    clipboard      = "unnamed,unnamedplus";
    wildignorecase = true;
    wildignore     = ".git,.hg,.svn,*.pyc,*.o,*.out,*.dvi,*.jpg,*.jpeg,*.png,*.gif,*.zip,**/tmp/**,*.DS_Store,**/node_modules/**,**/bower_modules/**";
    --               lower priority when matching multiple files or completely ignore the file
    suffixes       = ".bak,~,.o,.info,.swp,.obj,.out,.aux,.log,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.toc";
    backup         = false;
    writebackup    = false;
    swapfile       = false;
    history        = 5000;
    undolevels     = 1000;
    undoreload     = 10000;
    shada          = "!,'300,<50,@100,s10,h";
    backupskip     = "/tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*,/private/var/*,.vault.vim";
    smarttab       = true; -- make tab behaviour smarter
    shiftround     = true;
    timeout        = true;
    ttimeout       = true;
    timeoutlen     = 400; -- faster timeout wait time
    ttimeoutlen    = 10;
    updatetime     = 100;
    redrawtime     = 1500;
    ignorecase     = true; -- case insensitive on search
    smartcase      = true; -- improve searching using '/'
    hlsearch       = true; -- don't highlight matching search
    infercase      = true;
    incsearch      = true;
    wrapscan       = true;
    complete       = ".,w,b,t,k"; -- controls what is scanned with Ctrl-N and Ctrl-P
    inccommand     = "split"; -- incrementally show result of command
    grepformat     = "%f:%l:%c:%m";
    grepprg        = 'rg --hidden --vimgrep --smart-case --';
    --breakat      = [[\ \	;:,!?]];
    startofline    = false;
    whichwrap      = "h,l,<,>,[,],~";
    splitbelow     = true; -- split below instead of above
    splitright     = true; -- split right instead of left
    switchbuf      = "useopen";
    backspace      = "indent,eol,start"; -- allow backspacing to previous line
    diffopt        = "filler,iwhite,internal,algorithm:patience";
    completeopt    = 'menu,menuone,noinsert,noselect'; -- better completion
    jumpoptions    = "stack";
    showmode       = false;
    shortmess      = "filnxocsaIF"; -- disable some stuff on shortmess
    --shortmess    = "aoOTIcF"; -- glepnir defaults
    --shortmess    = "filnxtToOFcaI"; -- default + caI
    scrolloff      = 2;
    sidescrolloff  = 15;
    foldlevelstart = 99;
    ruler          = false;
    list           = true; -- display listchars
    --showtabline    = 2;
    winwidth       = 30;
    winminwidth    = 10;
    pumheight      = 15; -- limit completion items
    --helpheight     = 12;
    --previewheight  = 12;
    --cmdwinheight   = 5;
    cmdheight      = 1;
    showcmd        = true;
    equalalways    = false;
    laststatus     = 2; -- show statusline on inactive windows
    display        = "lastline";
    showbreak      = "↳  ";
    --fillchars      = "vert:│,eob:\\ "; -- make vertical split sign better
    --listchars    = "tab:→\\ ,trail:·"; -- set listchars
    listchars      = "tab:»·,nbsp:+,trail:·,extends:→,precedes:←";
    pumblend       = 10;
    winblend       = 10;
    re             = 0; -- set regexp engine to auto
    guicursor      = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20,i:blinkwait700-blinkon400-blinkoff250";
    ----
    directory      = global.cache_dir .. "swap/";
    undodir        = global.cache_dir .. "undo/";
    backupdir      = global.cache_dir .. "backup/";
    viewdir        = global.cache_dir .. "view/";
    spellfile      = global.cache_dir .. "spell/en.uft-8.add";
    ----
    -- Seems this is better set in ginit.vim with :Guifont!
    --guifont        = 'Roboto\\ Mono\\ Medium\\ for\\ Powerlin:h7';
    --guifontwide    = 'Roboto\\ Mono\\ Medium\\ for\\ Powerlin:h7';
  }

  -------[ Buffer and Window options ]-----{{{2
  local bw_local  = {
    undofile       = true; -- enable persistent undo
    synmaxcol      = 500; -- avoid syntax highlighting for long lines
    --formatoptions  = "1jcroql";
    formatoptions  = "1jql";
    textwidth      = 120;
    --colorcolumn    = "120";
    expandtab      = true;
    autoindent     = true;
    cindent        = true; -- enable cindent
    tabstop        = 2;
    shiftwidth     = 2;
    softtabstop    = -1;
    breakindentopt = "shift:2,min:20";
    wrap           = false;
    --linebreak      = true;
    number         = true; -- show line numbers
    relativenumber = true; -- enable relativenumber
    foldenable     = true;
    signcolumn     = "yes"; -- enable sign column all the time, 4 column
    conceallevel   = 2;
    concealcursor  = "niv";
  }

  local options_info = {}
  for _, v in pairs(vim.api.nvim_get_all_options_info()) do
     options_info[v.name] = true
     if v.shortname ~= "" then options_info[v.shortname] = true end
  end

  for name, value in pairs(global_and_local) do
    if not options_info[name] then
      print("unsupported option: "..name)
    else
      vim.o[name] = value
    end
  end
  bind_option(bw_local)
end

load_options()

if global.is_windows then
  vim.opt.shell = "cmd.exe"; -- necessary for formatter.nvim and gutentags
end

--=====[ Filetype options ]====={{{1
-- 2 spaces for selected filetypes
--vim.cmd [[
--  autocmd FileType xml,html,xhtml,css,scss,javascript,lua,yaml setlocal shiftwidth=3 tabstop=3
--]]

