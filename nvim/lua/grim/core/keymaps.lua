vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" }) -- increment
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- decrement

-- alt word-nav — the terminal sends alt-left/right as Esc+b / Esc+f. Unmapped,
-- nvim degrades <M-b> to plain `b` (works) but <M-f> to `f` (find-char, hangs
-- waiting for a char). Map both explicitly; <M-Left>/<M-Right> cover profiles
-- that send CSI alt-arrows instead.
keymap.set("n", "<M-f>", "w", { desc = "Word forward (alt-right)" })
keymap.set("n", "<M-b>", "b", { desc = "Word back (alt-left)" })
keymap.set("n", "<M-Right>", "w", { desc = "Word forward (alt-right)" })
keymap.set("n", "<M-Left>", "b", { desc = "Word back (alt-left)" })

-- INSERT mode too, or the terminal's raw Esc-prefix leaks through: alt-left
-- became Esc + `b` (right by accident) while alt-right became Esc + `f`, and
-- flash.nvim owns `f` — it dimmed the buffer and sat waiting for a character.
-- Both now hop to normal deliberately, which is the half that was worth keeping.
keymap.set("i", "<M-Left>", "<Esc>b", { desc = "Word back (alt-left), to normal" })
keymap.set("i", "<M-Right>", "<Esc>w", { desc = "Word forward (alt-right), to normal" })

-- Markdown prose on a SCRATCH buffer. after/ftplugin/markdown.lua keys off the
-- FILETYPE, not the filename and not saving — so a `:enew` notepad has ft="" and
-- gets none of it (no wrap, no conceal, no textwidth). Setting the filetype fires
-- the ftplugin immediately, on an unnamed unsaved buffer, exactly as if it were a
-- .md file. This binding can't live in the ftplugin itself: that file only loads
-- once the filetype is already markdown.
-- md=markdown · mm=conceal (ftplugin) · mp=prettier (conform).
keymap.set("n", "<leader>md", function()
  vim.bo.filetype = "markdown"
end, { desc = "Markdown mode on this buffer (scratch notes)" })

-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab

-- ── nnow QoL — merged from the nmix overlay 2026-07-20 ──
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

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
-- nnow's <leader>d (black-hole delete) is NOT grafted — the daily lsp.lua owns
-- <leader>d as diagnostic-float; x and visual p already avoid register clobber.
map("n", "x", '"_x', opts)

map("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Replace word under cursor globally" })
map("n", "<leader>X", "<cmd>!chmod +x %<CR>", { silent = true, desc = "Make file executable" })

map("n", "<leader>fp", function()
  local filePath = vim.fn.expand("%:~")
  vim.fn.setreg("+", filePath)
  print("File path copied to clipboard: " .. filePath)
end, { desc = "Copy file path to clipboard" })
