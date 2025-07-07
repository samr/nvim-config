return {
  name = "VS2022 C++ build",

  builder = function()
    local file = vim.fn.expand("%:p")
    local build_dir = vim.fn.getcwd()
    local compile_bat_path = vim.fn.stdpath("config") .. "/lua/overseer/vc_compile.bat"

    ---@type overseer.TaskDefinition
    return {
      name = "VS2022 C++ build",
      cmd = compile_bat_path,
      args = {
        "/EHsc",
        "/FC",
        "/std:c++17",
        file
      },
      components = {
        {
          "on_output_parse",
          parser = {
            -- Put the parser results into the 'diagnostics' field on the task result
            diagnostics = {
              -- Extract fields using lua patterns
              -- To integrate with other components, items in the "diagnostics" result should match
              -- vim's quickfix item format (:help setqflist)
              { "extract", "^%s*([^%(]+)%((%d+)%): (.+)$", "filename", "lnum", "text" },
            }
          }
        },
        {
          "on_result_diagnostics_quickfix",
        },
        -- TODO: This does not seem to work, so accomplishing the same thing more manually (above) with on_output_parse
        -- and on_result_diagnostics_quickfix
        -- {
        --   "on_output_quickfix",
        --   errorformat = [["\\ %#%f(%l\\\\\\,%c):\\ %#%m"]],
        --   open_on_match = true,
        -- },
      },
    }

    -- TODO: These multi-stage tasks still do not work, the batch file runs, then cl, but in two distinct cmd processes.
    -- ---@type overseer.TaskDefinition
    -- return {
    --   name = "VS2022 C++ build",
    --   strategy = {
    --     "orchestrator",
    --     tasks = {
    --       {
    --         cmd = [["C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat"]],
    --       },
    --       {
    --         cmd = "cl",
    --         args = { "/EHsc", file },
    --       },
    --     },
    --   },
    -- }

    -- ---@type overseer.TaskDefinition
    -- return {
    --   name = "VS2022 C++ build",
    --   cmd = [["C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat"]],
    --   components = {
    --     "default",
    --     {
    --       "run_after",
    --       task_names = {
    --         {
    --           cmd = "cl",
    --           args = { "/EHsc", file },
    --         },
    --       },
    --     },
    --   },
    -- }

    -- ---@type overseer.TaskDefinition
    -- return {
    --   name = "VS2022 C++ build",
    --   cmd = "cl",
    --   args = { "/EHsc", file },
    --   components = {
    --     { "display_duration", detail_level = 2 },
    --     "on_output_summarize",
    --     "on_exit_set_status",
    --     "on_complete_notify",
    --     {
    --       "dependencies",
    --       task_names = {
    --         {
    --           cmd = [["C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat"]],
    --         },
    --       },
    --     },
    --   },
    -- }
  end,

  condition = {
    filetype = { "cpp" },
  },
}
