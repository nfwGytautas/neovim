return {
  -- Disable the default <leader>/ grep mapping from snacks
  {
    "folke/snacks.nvim",
    keys = {
      { "<leader>/", false }, -- remove default grep
    },
  },
  { "nvim-tree/nvim-web-devicons", lazy = true },
}
