-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Key mappings for navigating buffers
local opts = { noremap = true, silent = true, desc = "Go to Buffer" }
vim.keymap.set("n", "<Tab>", "<Cmd>BufferLineCycleNext<CR>", {})
vim.keymap.set("n", "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", {})
vim.keymap.set("n", "<leader>1", "<cmd>lua require('bufferline').go_to_buffer(1)<CR>", opts)
vim.keymap.set("n", "<leader>2", "<cmd>lua require('bufferline').go_to_buffer(2)<CR>", opts)
vim.keymap.set("n", "<leader>3", "<cmd>lua require('bufferline').go_to_buffer(3)<CR>", opts)
vim.keymap.set("n", "<leader>4", "<cmd>lua require('bufferline').go_to_buffer(4)<CR>", opts)
vim.keymap.set("n", "<leader>5", "<cmd>lua require('bufferline').go_to_buffer(5)<CR>", opts)
vim.keymap.set("n", "<leader>6", "<cmd>lua require('bufferline').go_to_buffer(6)<CR>", opts)
vim.keymap.set("n", "<leader>7", "<cmd>lua require('bufferline').go_to_buffer(7)<CR>", opts)
vim.keymap.set("n", "<leader>8", "<cmd>lua require('bufferline').go_to_buffer(8)<CR>", opts)
vim.keymap.set("n", "<leader>9", "<cmd>lua require('bufferline').go_to_buffer(9)<CR>", opts)
