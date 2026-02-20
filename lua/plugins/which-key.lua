return {
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "<leader>s", group = "search" },
        { "<leader>g", group = "git" },
        { "<leader>C", group = "Claude", icon = { icon = "🤖", color = "orange" } },
        { "g", group = "goto" },
      },
    },
  },
}
