require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
--

-- Resize windows using Ctrl + Arrow keys
map("n", "<C-Up>", ":resize +2<CR>", { desc = "Increase window height" })
map("n", "<C-Down>", ":resize -2<CR>", { desc = "Decrease window height" })
map("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Decrease window width" })
map("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Increase window width" })

-- Keybinding for toggling CopilotChat (open/close)
map("n", "<Leader>cc", ":CopilotChatToggle<CR>", { noremap = true, silent = true })

-- Keybinding for submitting a prompt in insert mode
map("i", "<C-s>", ":CopilotChatSubmitPrompt<CR>", { noremap = true, silent = true })

-- Keybinding for accepting the nearest diff in CopilotChat
map("n", "<Leader>ga", ":CopilotChatAcceptNearestDiff<CR>", { noremap = true, silent = true })

-- Keybinding for jumping to the section of the nearest diff
map("n", "<Leader>gj", ":CopilotChatJumpToDiffSection<CR>", { noremap = true, silent = true })

-- Keybinding for yanking the nearest diff to register
map("n", "<Leader>gy", ":CopilotChatYankNearestDiff<CR>", { noremap = true, silent = true })

-- Keybinding for showing current chat context
map("n", "<Leader>gc", ":CopilotChatShowContext<CR>", { noremap = true, silent = true })
