vim.cmd[[packadd nvim-lspconfig]]
vim.cmd[[packadd lsp-status.nvim]]
vim.cmd[[packadd nvim-lsp-installer]]

local has_nvim_lsp, nvim_lsp = pcall(require, "lspconfig")
local has_lsp_status, lsp_status = pcall(require, "lsp-status")
local has_lsp_installer, lsp_installer = pcall(require, "nvim-lsp-installer")
local has_lsp_window, window = pcall(require, "plugins.modules.lsp_window")
local coq = require "coq"

local lsp = vim.lsp

if not has_nvim_lsp then
  print("Failed to load nvim-lspconfig")
  return
end
if not has_lsp_status then
  print("Failed to load lsp-status")
  return
end

lsp_status.register_progress()

-- TODO: requires remap()
-- local lsp_mappings = function(client)
--   remap('n', 'gK', '<cmd>lua vim.lsp.buf.hover()<CR>', { noremap = true, silent = true })
--   remap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', { noremap = true, silent = true })
-- 	remap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', { noremap = true, silent = true })
--   remap('n', 'gD', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', { noremap = true, silent = true })
--   remap('n', 'gr', '<cmd>lua require"telescope.builtin".lsp_references()<CR>', { noremap = true, silent = true })
--   remap('n', 'gR', '<cmd>lua vim.lsp.buf.rename()<CR>', { noremap = true, silent = true })
--   remap('n', 'gw', '<cmd>lua vim.lsp.buf.document_symbol()<CR>', { noremap = true, silent = true })
--   remap('n', 'ga', '<cmd>lua vim.lsp.buf.code_action()<CR>', { noremap = true, silent = true })
-- 	remap('n', 'go', '<cmd>lua vim.lsp.buf.code_action({source = {organizeImports = true}})<CR>', { noremap = true, silent = true })
-- 
--   -- I don't like input mode mappings that collide with words like "length"
--   --remap('i', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<CR>', { noremap = true, silent = true })
--   --remap('i', 'gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', { noremap = true, silent = true })
-- 
-- 	-- Few language severs support these three
-- 	remap('n', '<leader>ff',  '<cmd>lua vim.lsp.buf.formatting()<CR>', { noremap = true, silent = true })
-- 	remap('n', '<leader>ai',  '<cmd>lua vim.lsp.buf.incoming_calls()<CR>', { noremap = true, silent = true })
-- 	remap('n', '<leader>ao',  '<cmd>lua vim.lsp.buf.outgoing_calls()<CR>', { noremap = true, silent = true })
-- 
-- 	-- if diagnostic plugin is installed
-- 	remap('n', '<leader>ep', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', { noremap = true, silent = true })
-- 	remap('n', '<leader>en', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', { noremap = true, silent = true })
-- 	remap('n', '<leader>eo', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', { noremap = true, silent = true })
-- 
--   -- if client.resolved_capabilities.hover then
--   --   mega.bmap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
--   -- end
--   -- if client.resolved_capabilities.goto_definition then
--   --   mega.bmap("n", "<C-]>", "<cmd>lua vim.lsp.buf.definition()<CR>")
--   --   mega.bmap("n", "<Leader>lgd", "<cmd>lua vim.lsp.buf.definition()<CR>")
--   -- end
--   -- if client.resolved_capabilities.find_references then
--   --   mega.bmap("n", "<Leader>lr", "<cmd>lua vim.lsp.buf.references()<CR>")
--   --   mega.bmap("n", "<Leader>lgr", "<cmd>lua vim.lsp.buf.references()<CR>")
--   -- -- mega.bmap("n", "<Leader>lgr", '<cmd>lua require("telescope.builtin").lsp_references()<CR>')
--   -- end
--   -- if client.resolved_capabilities.rename then
--   --   mega.bmap("n", "<Leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>")
--   --   mega.bmap("n", "<Leader>ln", "<cmd>lua vim.lsp.buf.rename()<CR>")
--   -- end
-- 
-- 	-- command! LspRestart lua vim.lsp.stop_client(vim.lsp.get_active_clients()); vim.cmd('edit')
-- 	-- command! LspClearLineDiagnostics lua require('mode-diagnostic')()
-- 
--   -- show/hide diagnostics to be solved in https://github.com/neovim/neovim/issues/13324
-- end

local custom_on_attach = function(client)
  --lsp_mappings(client)

  if client.config.flags then
    client.config.flags.allow_incremental_sync = true
  end
end

local custom_on_init = function(client)
  print('Language Server Protocol started!')
  print(string(client.name()))
end

--[[
  taken from https://github.com/glepnir/nvim
  modified a bit
  big thanks to @glepnir
--]]
lsp.handlers['textDocument/hover'] = function(_, method, result)
  lsp.util.focusable_float(method, function()
      if not (result and result.contents) then return end
      local markdown_lines = lsp.util.convert_input_to_markdown_lines(result.contents)
      markdown_lines = lsp.util.trim_empty_lines(markdown_lines)
      if vim.tbl_isempty(markdown_lines) then return end

      local opts = { max_width = 80 }

      local bufnr, contents_winid, _, border_winid = window.fancy_floating_markdown(markdown_lines, opts)
      lsp.util.close_preview_autocmd({"CursorMoved", "BufHidden", "InsertCharPre"}, contents_winid)
      lsp.util.close_preview_autocmd({"CursorMoved", "BufHidden", "InsertCharPre"}, border_winid)
      return bufnr,contents_winid
  end)
end

-- add smol icon before diagnostics
lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
   virtual_text = {
      prefix = "",
      spacing = 0,
   },
   signs = true,
   underline = true,
   update_in_insert = false, -- update diagnostics insert mode
})

-- rounded borders
lsp.handlers["textDocument/hover"] = lsp.with(lsp.handlers.hover, { border = "rounded" })
lsp.handlers["textDocument/signatureHelp"] = lsp.with(lsp.handlers.signature_help, { border = "rounded" })


-- [Notes on clangd LSP]
--
-- Set --log=verbose for debugging.
--
-- To find the location of the logs in neovim:
--    :lua print(vim.lsp.get_log_path())
--
-- To turn on c++17 support create %LocalAppData%/clangd/config.yaml, ~/.config/clangd/config.yaml, or .clangd in the
-- source tree with the following (even on Windows, don't use "/std:c++17"):
--     CompileFlags:
--       Add: -std=c++17
--
nvim_lsp.clangd.setup{
  coq.lsp_ensure_capabilities{
    handlers = lsp_status.extensions.clangd.setup(),
    cmd={"clangd", "--background-index", "--enable-config", "--log=info"},
    filetypes = { "c", "cpp", "objc", "objcpp", "cuh", "cu" },
    init_options = {
      clangdFileStatus = true,
      -- TODO: Try these
      --usePlaceholders = true,
      --completeUnimported = true
    },
-- TODO: Try these
--   capabilities = {
--     textDocument = {
--       completion = {
--         completionItem = {
--           snippetSupport = true
--         }
--       }
--     }
--   },
    on_attach = function(client)
      lsp_status.on_attach(client)
      custom_on_attach(client)

      -- TODO: Maybe enable these?
      --vim.api.nvim_command(
      --  [[autocmd CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()]])
      --vim.api.nvim_command(
      --  [[autocmd CursorMoved <buffer> lua vim.lsp.util.buf_clear_references()]])
    end,
    on_init = function(client)
      lsp_status.on_init(client)
      custom_on_init(client)
    end,
  }
}

if not (present1 or present2) then
   return
end

-- Ugly, but if we have no HOME directory then guess...
local home_dir = os.getenv("HOME")
if home_dir == nil or home_dir == '' then
  home_dir = "C:\\Users\\sriesland"
end
local sumneko_root = home_dir .. "\\Dev\\lua-language-server"

nvim_lsp.sumneko_lua.setup{
  coq.lsp_ensure_capabilities{
    cmd = {
      sumneko_root
      .. "\\bin\\Windows\\lua-language-server", "-E",
      sumneko_root .. "\\main.lua"
    },
    on_attach = custom_on_attach,
    on_init = custom_on_init,
    settings = {
      Lua = {
        runtime = { version = "LuaJIT", path = vim.split(package.path, ';'), },
        completion = { keywordSnippet = "Disable" },
        diagnostics = {
          enable = true,
          globals = {
            "vim", "describe", "it", "before_each", "after_each",
            "awesome", "theme", "client"
          },
        },
      }
    }
  }
}

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.documentationFormat = { "markdown", "plaintext" }
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.preselectSupport = true
capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
capabilities.textDocument.completion.completionItem.deprecatedSupport = true
capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
capabilities.textDocument.completion.completionItem.tagSupport = { valueSet = { 1 } }
capabilities.textDocument.completion.completionItem.resolveSupport = {
   properties = {
      "documentation",
      "detail",
      "additionalTextEdits",
   },
}

-- nvim-lsp-installer
if has_lsp_installer then
  lsp_installer.on_server_ready(function(server)
    local opts = {}
    server:setup(opts)
  end)
end

-- replace the default lsp diagnostic symbols
local function lspSymbol(name, icon)
   vim.fn.sign_define("LspDiagnosticsSign" .. name, { text = icon, numhl = "LspDiagnosticsDefaul" .. name })
end
lspSymbol("Error", "")
lspSymbol("Information", "")
lspSymbol("Hint", "")
lspSymbol("Warning", "")
