return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        gopls = {
          root_markers = { "go.mod" },
          settings = {
            gopls = {
              buildFlags = { "-tags=dev,integration_test,unit_test" },
            },
          },
        },
        golangci_lint_ls = {
          root_markers = { "go.mod" },
          init_options = {
            command = {
              "golangci-lint", "run", "--build-tags", "dev,integration_test,unit_test",
              "--output.json.path=stdout", "--show-stats=false", "--issues-exit-code=0",
            },
          },
        },
      },
    },
  },
  -- Disable golangci-lint from nvim-lint (now handled by golangci_lint_ls above)
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        go = {},
      },
    },
  },
}
