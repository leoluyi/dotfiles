-- https://github.com/greggh/claude-code.nvim
return {
  {
    "greggh/claude-code.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "ClaudeCode", "ClaudeCodeContinue", "ClaudeCodeResume", "ClaudeCodeVerbose" },
    keys = {
      { "<C-,>", desc = "Toggle Claude Code" },
      { "<leader>cC", desc = "Claude Code: resume recent" },
      { "<leader>cV", desc = "Claude Code: verbose" },
    },
    opts = {
      window = {
        position = "botright",
        split_ratio = 0.35,
      },
      git = {
        use_git_root = true,
      },
    },
  },
}
