-- Keymaps (video 00:11:57) — Sin-cy's editing set; lines marked `ours` keep
-- muscle memory from the old grim config (jk, nh, +/-).
-- Skipped from the reference until their phase lands: <leader>f (lsp format),
-- <leader>re (:restart, nightly), <leader>lr (lsp restart).
vim.g.mapleader = " "

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

map("i", "jk", "<Esc>", { desc = "Exit insert mode with jk" }) -- ours
map("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" }) -- ours

-- move visual selection up/down, reindenting as it goes
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- cursor stays put / centered
map("n", "J", "mzJ`z", { desc = "Join line, keep cursor" })
map("n", "<C-d>", "<C-d>zz", { desc = "Half-page down, centered" })
map("n", "<C-u>", "<C-u>zz", { desc = "Half-page up, centered" })
map("n", "n", "nzzzv", { desc = "Next match, centered" })
map("n", "N", "Nzzzv", { desc = "Prev match, centered" })

-- reindent keeps the selection
map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)

-- registers: paste/delete without clobbering the yank
map("x", "p", [["_dP]], { desc = "Paste over selection, keep yank" })
map({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete to black hole" })
map("n", "x", '"_x', opts)

map("n", "<leader>+", "<C-a>", { desc = "Increment number" }) -- ours
map("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- ours

map("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Replace word under cursor globally" })
map("n", "<leader>X", "<cmd>!chmod +x %<CR>", { silent = true, desc = "Make file executable" })

-- tabs
map("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" })
map("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" })
map("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" })
map("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" })
map("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" })

-- splits
map("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
map("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
map("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })
map("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" })

map("n", "<leader>fp", function()
  local filePath = vim.fn.expand("%:~")
  vim.fn.setreg("+", filePath)
  print("File path copied to clipboard: " .. filePath)
end, { desc = "Copy file path to clipboard" })
