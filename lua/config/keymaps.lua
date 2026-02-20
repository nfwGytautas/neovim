-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

--------------------------------
-- 's' -> Search
--------------------------------
map("n", "<leader>sf", function() Snacks.picker.files() end,                   { desc = "Files" })
map("n", "<leader>sb", function() Snacks.picker.buffers() end,                 { desc = "Buffers" })

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
