local global = require('global')

local vscode = require('vscode')

-- Set vscode.notify as the default notify function
vim.notify = vscode.notify

vim.notify("loaded vscode options")
