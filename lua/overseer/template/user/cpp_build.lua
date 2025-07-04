return {
  name = "VS2022 C++ build",

  builder = function()
    local file = vim.fn.expand("%:p")
    local build_dir = vim.fn.getcwd()

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

    -- TODO: This still does not work, the batch file runs, then cl, but in two distinct cmd processes.
    ---@type overseer.TaskDefinition
    return {
      name = "VS2022 C++ build",
      cmd = "cl",
      args = { "/EHsc", file },
      components = {
        { "display_duration", detail_level = 2 },
        "on_output_summarize",
        "on_exit_set_status",
        "on_complete_notify",
        {
          "dependencies",
          task_names = {
            {
              cmd = [["C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat"]],
            },
          },
        },
      },
    }
  end,

  condition = {
    filetype = { "cpp" },
  },
}
