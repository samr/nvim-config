vim.cmd[[packadd nvim-lspconfig]]
vim.cmd[[packadd lsp-status.nvim]]
vim.cmd[[packadd nvim-lsp-installer]]

local has_nvim_lsp, nvim_lsp = pcall(require, "lspconfig")
local has_lsp_status, lsp_status = pcall(require, "lsp-status")
local has_lsp_installer, lsp_installer = pcall(require, "nvim-lsp-installer")
local has_lsp_signature, lsp_signature = pcall(require, "lsp_signature")
local has_cmp_nvim_lsp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")

local global = require "global"
local lsp = vim.lsp
local remap = vim.api.nvim_set_keymap

if not has_nvim_lsp then
  print("Failed to load nvim-lspconfig")
  return
end
if not has_lsp_status then
  print("Failed to load lsp-status")
  return
end

lsp_status.register_progress()

-- Allow toggling of showing diagnostics from the LSP.
-- Taken from, https://github.com/neovim/neovim/issues/14825
function _G.toggle_diagnostics()
  if vim.g.diagnostics_visible then
    vim.g.diagnostics_visible = false
    vim.diagnostic.disable()
  else
    -- Note, there appears to be a race condition where if this error randomly gets triggered when enabling diagnostics:
    -- "E5108: ... diagnostic.lua:945: line value outside range"
    vim.g.diagnostics_visible = true
    vim.diagnostic.enable()
  end
end

-- Control the appearance of the diagnostics.
lsp.handlers["textDocument/publishDiagnostics"] = lsp.with(
  lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = {
      source = "always",  -- Or "if_many"
    },
    signs = {
      enable = true,
      priority = 20
    },
    underline = true,
    update_in_insert = false,
    -- float = { border = "single" },
  }
)

-- Show line diagnostics automatically in hover window.
-- Set updatetime which affects CursorHold
-- vim.o.updatetime = 250
-- vim.cmd [[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]]
-- or...
-- vim.cmd [[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false, scope="cursor"})]]

-- Do not show diagnostics by default.
vim.g.diagnostics_visible = false
vim.diagnostic.disable()

local lsp_mappings = function(client)
  -- TODO: clangd appears to be lying about its capabilities or this isn't working...
  if client.server_capabilities.find_references then
    remap("n", "<leader>lr", "<cmd>lua vim.lsp.buf.references()<CR>", { noremap = true })
    remap("n", "<leader>lgr", "<cmd>lua vim.lsp.buf.references()<CR>", { noremap = true })
    remap('n', 'gr', '<cmd>lua require"telescope.builtin".lsp_references()<CR>', { noremap = true, silent = true })
  end

  -- if client.resolved_capabilities.hover then
  --   mega.bmap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
  -- end
  -- if client.resolved_capabilities.goto_definition then
  --   mega.bmap("n", "<C-]>", "<cmd>lua vim.lsp.buf.definition()<CR>")
  --   mega.bmap("n", "<Leader>lgd", "<cmd>lua vim.lsp.buf.definition()<CR>")
  -- end
  -- if client.resolved_capabilities.rename then
  --   remap("n", "<Leader>gR", "<cmd>lua vim.lsp.buf.rename()<CR>")
  -- end
end

local custom_on_attach = function(client)
  lsp_mappings(client)

  if has_lsp_signature then
    lsp_signature.on_attach()
  end

  if client.config.flags then
    client.config.flags.allow_incremental_sync = true
  end
end

local custom_on_init = function(client)
  print('Language Server Protocol started!')
  print(string(client.name()))
end

-- --[[
--   taken from https://github.com/glepnir/nvim
--   modified a bit
--   big thanks to @glepnir
-- --]]
-- lsp.handlers['textDocument/hover'] = function(_, method, result)
--   lsp.util.focusable_float(method, function()
--       if not (result and result.contents) then return end
--       local markdown_lines = lsp.util.convert_input_to_markdown_lines(result.contents)
--       markdown_lines = lsp.util.trim_empty_lines(markdown_lines)
--       if vim.tbl_isempty(markdown_lines) then return end
-- 
--       local opts = { max_width = 80 }
-- 
--       local bufnr, contents_winid, _, border_winid = window.fancy_floating_markdown(markdown_lines, opts)
--       lsp.util.close_preview_autocmd({"CursorMoved", "BufHidden", "InsertCharPre"}, contents_winid)
--       lsp.util.close_preview_autocmd({"CursorMoved", "BufHidden", "InsertCharPre"}, border_winid)
--       return bufnr,contents_winid
--   end)
-- end

-- rounded borders
-- lsp.handlers["textDocument/hover"] = lsp.with(lsp.handlers.hover, { border = "rounded" })
-- lsp.handlers["textDocument/signatureHelp"] = lsp.with(lsp.handlers.signature_help, { border = "rounded" })

local capabilities = vim.lsp.protocol.make_client_capabilities()
if has_cmp_nvim_lsp then
  capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
end

-- For C++ use the clangd LSP
--
-- Install clangd from LLVM source/releases.
--
-- To find the location of the clangd logs from neovim:
--    :lua print(vim.lsp.get_log_path())
--
-- To turn on c++17 support create %LocalAppData%/clangd/config.yaml, ~/.config/clangd/config.yaml, or .clangd in the
-- source tree with the following (even on Windows, don't use "/std:c++17"):
--     CompileFlags:
--       Add: -std=c++17
--
nvim_lsp.clangd.setup{
  handlers = lsp_status.extensions.clangd.setup(),
  capabilities = capabilities,
  cmd = {
    "clangd",
    "--background-index",
    "--enable-config",  -- Respect config.yaml and .clangd files.
    "--log=info",  -- To help debugging, set "--log=verbose" can help.
    --
    -- TODO: Maybe try these
    -- "--suggest-missing-includes",
    -- "--clang-tidy",
    -- "--header-insertion=iwyu",
  },
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

-- For CMake LSP use the cmake-language-server
-- https://github.com/regen100/cmake-language-server
-- pip install cmake-language-server
nvim_lsp.cmake.setup{
  capabilities = capabilities,
  cmd = { "cmake-language-server" },
  filetypes = { "cmake" },
  init_options = {
    buildDirectory = "build"
  },
  root_dir = nvim_lsp.util.root_pattern(".git", "compile_commands.json", "build"),
  on_attach = custom_on_attach,
  on_init = custom_on_init,
}

-- TODO: Figure out how this is useful
-- local capabilities = vim.lsp.protocol.make_client_capabilities()
-- capabilities.textDocument.completion.completionItem.documentationFormat = { "markdown", "plaintext" }
-- capabilities.textDocument.completion.completionItem.snippetSupport = true
-- capabilities.textDocument.completion.completionItem.preselectSupport = true
-- capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
-- capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
-- capabilities.textDocument.completion.completionItem.deprecatedSupport = true
-- capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
-- capabilities.textDocument.completion.completionItem.tagSupport = { valueSet = { 1 } }
-- capabilities.textDocument.completion.completionItem.resolveSupport = {
--    properties = {
--       "documentation",
--       "detail",
--       "additionalTextEdits",
--    },
-- }


-- The williamboman/nvim-lsp-installer plugin manages the installation and startup of some language servers. Configure
-- them here.
if has_lsp_installer then
  lsp_installer.on_server_ready(function(server)
    local opts = {
      capabilities = capabilities,
      on_attach = custom_on_attach,
      on_init = custom_on_init,
    }

    if server.name == 'sumenko_lua' then
      -- Configure the Sumenko Lua Language Server
      opts.settings = {
        Lua = {
          runtime = {
            -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
            version = "LuaJIT",
            -- Setup the lua path
            path = vim.split(package.path, ';'),
          },
          completion = { keywordSnippet = "Disable" },
          diagnostics = {
            -- Get the language server to recognize the `vim` global and others
            enable = true,
            globals = {
              "vim", "describe", "it", "before_each", "after_each",
              "awesome", "theme", "client", "packer_plugins",
            },
          },
          workspace = {
            -- Make the server aware of Neovim runtime files
            library = vim.list_extend({
              [vim.fn.expand("$VIMRUNTIME/lua")] = true,
              [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
          },{}),
          },
        },
      }
    end

    server:setup(opts)
    vim.cmd([[ do User LspAttach Buffers ]])
  end)
end

-- -- replace the default lsp diagnostic symbols
-- local function lspSymbol(name, icon)
--    vim.fn.sign_define("LspDiagnosticsSign" .. name, { text = icon, numhl = "LspDiagnosticsDefaul" .. name })
-- end
-- lspSymbol("Error", "")
-- lspSymbol("Information", "")
-- lspSymbol("Hint", "")
-- lspSymbol("Warning", "")
