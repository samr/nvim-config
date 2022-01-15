local eval = vim.api.nvim_eval

local hl = function(group, options)
  local bg = options.bg == nil and '' or 'guibg=' .. options.bg
  local fg = options.fg == nil and '' or 'guifg=' .. options.fg
  local gui = options.gui == nil and '' or 'gui=' .. options.gui

  vim.cmd(string.format(
    'hi %s %s %s %s',
    group, bg, fg, gui
  ))
end

ColorUtil = {}

ColorUtil.override_gruvbox8 = function()
  local highlights = {
    -- normal stuff
    {'Normal', { bg = 'NONE' }},
    {'Comment', { gui = 'italic' }},
    {'SignColumn', { bg = 'NONE' }},
    {'ColorColumn', { bg = '#3C3836' }},
    {'EndOfBuffer', { bg = 'NONE', fg = '#282828' }},
    {'IncSearch', { bg = '#928374' }},
    {'String', { gui = 'NONE' }},
    {'Special', { gui = 'NONE' }},

    {'SignAdd', { fg = '#458588', bg = 'NONE' }},
    {'SignChange', { fg = '#D79921', bg = 'NONE' }},
    {'SignDelete', { fg = '#fb4934', bg = 'NONE' }},
    {'GitGutterChange', { fg = '#D79921' }},
    {'GitGutterDelete', { fg = '#fb4934' }},

    -- misc
    {'htmlLink', { gui = 'NONE', fg = '#ebdbb2' }},
    {'jsonNoQuotesError', { fg = '#fb4934' }},
    {'jsonMissingCommaError', { fg = '#fb4934' }},
    {'IncSearch', { bg='#282828', fg='#928374' }},
    {'mkdLineBreak', { bg='NONE' }},

    -- statusline colours
    {'StatusLine', { fg = '#3C3836', bg = '#EBDBB2' }},
    {'StatusLineNC', { fg = '#3C3836', bg = '#928374' }},
    {'Mode', { bg = '#928374', fg = '#1D2021', gui="bold" }},
    {'LineCol', { bg = '#928374', fg = '#1D2021', gui="bold" }},
    {'Git', { bg = '#504945', fg = '#EBDBB2' }},
    {'Filetype', { bg = '#504945', fg = '#EBDBB2' }},
    {'Filename', { bg = '#504945', fg = '#EBDBB2' }},

    {'ModeAlt', { bg = '#504945', fg = '#928374' }},
    {'GitAlt', { bg = '#3C3836', fg = '#504945' }},
    {'LineColAlt', { bg = '#504945', fg = '#928374' }},
    {'FiletypeAlt', { bg = '#3C3836', fg = '#504945' }},

    -- luatree
    {'NvimTreeFolderIcon', { fg = '#d79921' }},
    {'NvimTreeIndentMarker', { fg = '#928374' }},

    -- telescope
    {'TelescopeSelection', { bg='NONE', fg='#d79921', gui='bold' }},
    {'TelescopeMatching', { bg='NONE', fg='#fb4934', gui='bold' }},
    {'TelescopeBorder', { bg='NONE', fg='#928374', gui='bold' }},

    -- diagnostic nvim
    {'LspDiagnosticsDefaultError', { bg='NONE', fg='#fb4934' }},
    {'LspDiagnosticsDefaultWarning', { bg='NONE', fg='#d79921' }},
    {'LspDiagnosticsDefaultInformation', { bg='NONE', fg='#458588' }},
    {'LspDiagnosticsDefaultHint', { bg='NONE', fg='#689D6A' }},

    -- ts override
    {'TSKeywordOperator', { bg='NONE', fg='#fb4934' }},
    {'TSOperator', { bg='NONE', fg='#fe8019' }},
  }

  for _, highlight in pairs(highlights) do
    hl(highlight[1], highlight[2])
  end
end

ColorUtil.override_desert2 = function()
  local highlights = {
    {'ColorColumn', { bg = '#111111' }},
    {'Pmenu', { bg = 'brown', gui="bold" }},  -- Tab/Omni completion color
  }

  for _, highlight in pairs(highlights) do
    hl(highlight[1], highlight[2])
  end
end

ColorUtil.override_eunoia = function()
  local highlights = {
    -- Disable background
    {'Normal', { bg = 'NONE'}},

    -- statusline colours
    {'Active', { bg = '#211D35', fg = '#ECEBE6' }},
    {'Inactive', { bg = '#2C2941', fg = '#4B5573' }},
    {'Mode', { bg = '#6391F4', fg = '#211D35', gui="bold" }},
    {'LineCol', { bg = '#E64557', fg = '#211D35', gui="bold" }},
    {'Git', { bg = '#2C2941', fg = '#ECEBE6' }},
    {'Filetype', { bg = '#2C2941', fg = '#ECEBE6' }},
    {'Filename', { bg = '#2C2941', fg = '#ECEBE6' }},

    {'ModeAlt', { bg = '#2C2941', fg = '#6391F4' }},
    {'GitAlt', { bg = '#211D35', fg = '#2C2941' }},
    {'LineColAlt', { bg = '#2C2941', fg = '#E64557' }},
    {'FiletypeAlt', { bg = '#211D35', fg = '#2C2941' }},

    -- telescope
    {'TelescopeSelection', { bg='#2C2941', fg='#dedbd6' }},
    {'TelescopeMatching', { bg='NONE', fg='#FF496F' }},
    {'TelescopeBorder', { bg='#151326', fg='#4D5980' }},
    {'TelescopeNormal', { bg='#151326' }},
  }
  for _, highlight in pairs(highlights) do
    hl(highlight[1], highlight[2])
  end
end


ColorUtil.override_darkdevel3 = function()
  local highlights = {
    -- Treesitter highlights (:h nvim-treesitter-highlights)
    {'TSTypeBuiltin', { bg='NONE', fg='#4B5573', gui="bold"}}, -- Does not appear to work
    {'TSType', { bg='NONE', fg='#A3E184' }},
    {'TSKeyword', { bg='NONE', fg='#95F5F8' }},

    -- Language server diagnostics
    {'LspDiagnosticsDefaultError', { bg='NONE', fg='#E64557' }},
    {'LspDiagnosticsDefaultWarning', { bg='NONE', fg='#d79921' }},
    {'LspDiagnosticsDefaultInformation', { bg='NONE', fg='#458588' }},
    {'LspDiagnosticsDefaultHint', { bg='NONE', fg='#689D6A' }},

    -- TODO: Maybe defined colors for these as well.
    -- {'LspDiagnosticsDefaultErrorFloating', { bg='NONE', fg='#fb4934' }},
    -- {'LspDiagnosticsDefaultErrorSign', { bg='NONE', fg='#fb4934' }},

    -- TODO: Maybe move darkdevel3 to a colorbuddy definition
    -- Group.new('LspDiagnosticsUnderline', nil, nil, s.underline)
    -- Group.new('LspDiagnosticsUnderlineError', nil, nil, s.underline)
    -- Group.new('LspDiagnosticsUnderlineHint', nil, nil, s.underline)
    -- Group.new('LspDiagnosticsUnderlineInfo', nil, nil, s.underline)
    -- Group.new('LspDiagnosticsUnderlineWarning', nil, nil, s.underline)
  }
  for _, highlight in pairs(highlights) do
    hl(highlight[1], highlight[2])
  end
end

-- Change the pop-up auto-completion box.
ColorUtil.vscode_dark_for_cmp = function()
  local highlights = {
    -- dark gray
    {'Pmenu', { bg = '#303030', fg="NONE" }},
    -- emerald green
    {'PmenuSel', { bg = '#105E26', fg="NONE" }},
    -- gray
    {'CmpItemAbbrDeprecated', { bg='NONE', gui="strikethrough", fg='#808080'}},
    -- blue
    {'CmpItemAbbrMatch', { bg='NONE', fg='#569CD6' }},
    {'CmpItemAbbrMatchFuzzy', { bg='NONE', fg='#569CD6' }},
    -- light blue
    {'CmpItemKindVariable', { bg='NONE', fg='#9CDCFE' }},
    {'CmpItemKindInterface', { bg='NONE', fg='#9CDCFE' }},
    {'CmpItemKindText', { bg='NONE', fg='#9CDCFE' }},
    -- pink
    {'CmpItemKindFunction', { bg='NONE', fg='#C586C0' }},
    {'CmpItemKindMethod', { bg='NONE', fg='#C586C0' }},
    -- front
    {'CmpItemKindKeyword', { bg='NONE', fg='#D4D4D4' }},
    {'CmpItemKindProperty', { bg='NONE', fg='#D4D4D4' }},
    {'CmpItemKindUnit', { bg='NONE', fg='#D4D4D4' }},
  }
  for _, highlight in pairs(highlights) do
    hl(highlight[1], highlight[2])
  end
end

--ColorUtil.vscode_dark_for_cmp()

-- italicize comments
hl('Comment', { gui = 'italic' })

-- automatically override colourscheme
vim.cmd('augroup NewColor')
vim.cmd('au!')
vim.cmd('au ColorScheme desert2 call v:lua.ColorUtil.override_desert2()')
vim.cmd('au ColorScheme gruvbox8 call v:lua.ColorUtil.override_gruvbox8()')
vim.cmd('au ColorScheme eunoia call v:lua.ColorUtil.override_eunoia()')
vim.cmd('au ColorScheme darkdevel3 call v:lua.ColorUtil.override_darkdevel3()')
vim.cmd('au ColorScheme * call v:lua.ColorUtil.vscode_dark_for_cmp()')
vim.cmd('augroup END')

-- disable invert selection for gruvbox
-- vim.g.gruvbox_invert_selection = false

if eval('has("win32")') == 1 then
  vim.cmd('colorscheme darkdevel3')
elseif eval('has("mac")') == 1 then
  vim.cmd('colorscheme darkdevel3osx')
else
  vim.cmd('colorscheme desert2')
end

-- -- needs to be loaded after setting colourscheme
-- vim.cmd[[packadd nvim-web-devicons]]
-- require'nvim-web-devicons'.setup {
--   override = {
--     svg = {
--       icon = '',
--       color = '#ebdbb2',
--       name = 'Svg'
--     }
--   };
--   default = true
-- }
--
-- -- Neogit has some highlight overrides
-- hi NeogitNotificationInfo guifg=#80ff95
-- hi NeogitNotificationWarning guifg=#fff454
-- hi NeogitNotificationError guifg=#c44323
-- hi def NeogitDiffAddHighlight guibg=#404040 guifg=#859900
-- hi def NeogitDiffDeleteHighlight guibg=#404040 guifg=#dc322f
-- hi def NeogitDiffContextHighlight guibg=#333333 guifg=#b2b2b2
-- hi def NeogitHunkHeader guifg=#cccccc guibg=#404040
-- hi def NeogitHunkHeaderHighlight guifg=#cccccc guibg=#4d4d4d
