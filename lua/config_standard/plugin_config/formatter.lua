-- vim.cmd[[packadd formatter.nvim]]

local global = require('global')
local remap = vim.api.nvim_set_keymap
local fn = vim.fn
local is_cfg_present = require('global').is_cfg_present

-- Makes javascript and typescript prettier https://prettier.io/docs/
local prettier = function()
  if is_cfg_present("/.prettierrc") then
    return {
      exe = "prettier",
      args = {
        string.format(
          "--stdin-filepath '%s' --config '%s'",
          vim.api.nvim_buf_get_name(0), vim.uv.cwd() .. global.path_sep .. ".prettierrc"
        )
      },
      stdin = true
    }
  else
    -- fallback to global config
    return {
      exe = "prettier",
      args = {
        string.format(
          "--stdin-filepath '%s' --config '%s'",
          vim.api.nvim_buf_get_name(0), vim.fn.stdpath("config") .. global.path_sep .. ".prettierrc"
        )
      },
      stdin = true
    }
  end
end

-- https://stedolan.github.io/jq/download/
local jq = function()
  return {exe = "jq", args = {}, stdin = true}
end

local pythonjson = function()
  return {
    exe = "python",
    args = {
      "-c \"import json, sys; json_str = json.dumps(json.loads(sys.stdin.read()), indent=2, sort_keys=True); print(json_str.replace(r'\r',''))\""
    },
    stdin = true
  }
end

local clangfmt = function()
  return {exe = "clang-format", args = {}, stdin = true}
end

local rustfmt = function()
  return {exe = "rustfmt", args = {"--emit=stdout"}, stdin = true}
end

local gofmt = function()
  return {exe = "gofumpt", stdin = true}
end

local luafmt = function()
    -- Note: LuaFormatter is best compiled from source directly, luarocks was a no-go.
    return {
      exe = "lua-format",
      args = {"-i", "--config", global.vim_path .. global.path_sep .. ".luafmt"},
      stdin = true
    }
end

require('formatter').setup{
  logging = false,
  filetype = {
    javascript = {prettier},
    typescript = {prettier},
    typescriptreact = {prettier},
    svelte = {prettier},
    css = {prettier},
    jsonc = {pythonjson},
    html = {prettier},
    php = {prettier},
    cpp = {clangfmt},
    rust = {rustfmt},
    lua = {luafmt},
    go = {gofmt}
  }
}
