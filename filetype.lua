-- Overrides and special filetype detectors using the new filetype.lua functionality.
vim.filetype.add({
    extension = {
        h = "cpp",
        -- h = function()
        --     -- Use a lazy heuristic that #including a C++ header means it's a
        --     -- C++ header
        --     if vim.fn.search("\\C^#include <[^>.]\\+>$", "nw") == 1 then
        --         return "cpp"
        --     end
        --     return "c"
        -- end,
        cu = "cuda",
        cuh = "cuda",
        csv = "csv",
        cl = "opencl",
        env = "env",
    },
})
