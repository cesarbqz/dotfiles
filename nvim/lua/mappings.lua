require "nvchad.mappings"

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- quit
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit All" })
