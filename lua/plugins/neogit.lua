local present, neogit = pcall(require, "neogit")
if not present then
   return
end

print("loaded neogit config")

neogit.setup {
  disable_signs = false,
  disable_hint = false,
  disable_context_highlighting = false,
  disable_commit_confirmation = false,
  auto_refresh = true,
  disable_builtin_notifications = false,
  use_magit_keybindings = false,
  commit_popup = {
    kind = "split",
  },
  kind = "split", -- Change the default way of opening neogit
  signs = { -- Customize displayed signs
    section = { ">", "v" }, -- { closed, opened }
    item = { ">", "v" },
    hunk = { "", "" },
  },
  integrations = {
    -- Neogit only does inline diffs. The diffview integration enables the diff popup.
    -- Requires that `sindrets/diffview.nvim` be installed.
    diffview = true,
  },
  sections = {
    -- Setting any section to `false` will make the section not render at all
    untracked = {
      folded = false
    },
    unstaged = {
      folded = false
    },
    staged = {
      folded = false
    },
    stashes = {
      folded = true
    },
    unpulled = {
      folded = true
    },
    unmerged = {
      folded = false
    },
    recent = {
      folded = true
    },
  },
  --
  -- Default Key Mappings:
  --  Tab: Toggle diff
  --  1, 2, 3, 4: Set a foldlevel
  --  $: Command history
  --  b: Branch popup
  --  s: Stage (also supports staging selection/hunk)
  --  S: Stage unstaged changes
  --  <C-s>: Stage Everything
  --  u: Unstage (also supports staging selection/hunk)
  --  U: Unstage staged changes
  --  c: Open commit popup
  --  r: Open rebase popup
  --  L: Open log popup
  --  p: Open pull popup
  --  P: Open push popup
  --  Z: Open stash popup
  --  ?: Open help popup
  --  x: Discard changes (also supports discarding hunks)
  --  <enter>: Go to file
  --  <C-r>: Refresh Buffer
  -- d: Open diffview.nvim at hovered file
  mappings = { -- Override/add mappings.
    status = { -- Status buffer mappings.
      -- Adds a mapping with "B" as key that does the "BranchPopup" command
      ["B"] = "BranchPopup",
      -- Removes the default mapping of "s"
      -- ["s"] = "",
    }
  }
}
