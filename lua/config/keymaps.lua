-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

--------------------------------
-- 'g' -> GoTo
--------------------------------
map("n", "gf", function()
  Snacks.picker.files()
end, { desc = "Search File" })
map("n", "gl", function()
  local line = vim.fn.input("Go to line: ")
  if line ~= "" then
    vim.cmd(line)
  end
end, { desc = "Go to Line" })
map("n", "gg", function()
  Snacks.picker.grep()
end, { desc = "Grep" })
map("n", "gs", function()
  Snacks.picker.lsp_symbols()
end, { desc = "Go to Symbol" })

--------------------------------
-- '<leader>C' -> Claude
--------------------------------
map("n", "<leader>C", function()
  vim.fn.system('tmux select-window -t claude 2>/dev/null || tmux new-window -n claude "claude"')
end, { desc = "Jump to Claude" })

--------------------------------
-- '<leader>g' -> Git
--------------------------------
map("n", "<leader>gp", function()
  vim.cmd("Git pull")
end, { desc = "Git Pull" })
map("n", "<leader>ga", function()
  vim.cmd("Git add -A")
end, { desc = "Git Add All" })
map("n", "<leader>gc", function()
  local msg = vim.fn.input("Commit message: ")
  if msg ~= "" then
    vim.cmd("Git commit -m '" .. msg .. "'")
  end
end, { desc = "Git Commit" })
map("n", "<leader>gP", function()
  vim.cmd("Git push")
end, { desc = "Git Push" })

--------------------------------
-- 'd' -> Debug
--------------------------------
map("n", "<leader>dy", function()
  local diag = vim.diagnostic.get(0, { lnum = vim.api.nvim_win_get_cursor(0)[1] - 1 })
  if #diag > 0 then
    local msg = diag[1].message
    vim.fn.setreg("+", msg)
    vim.notify("Copied: " .. msg, vim.log.levels.INFO)
  else
    vim.notify("No diagnostic on this line", vim.log.levels.WARN)
  end
end, { desc = "Copy Diagnostics Message" })
