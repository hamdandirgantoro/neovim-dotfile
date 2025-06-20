local telescope, dapui, dap = require("telescope.builtin"), require("dapui"), require("dap")
-- Files
vim.keymap.set('n', '<leader>ff', telescope.find_files, { desc = 'Find File' })
vim.keymap.set('n', '<leader>fr', telescope.oldfiles, { desc = 'Recent Files' })
vim.keymap.set('n', '<leader>fg', telescope.live_grep, { desc = 'Grep Files' })
vim.keymap.set('n', '<leader>fw', telescope.grep_string, { desc = 'Search Word Under Cursor' })
vim.keymap.set('n', '<leader>fp', telescope.git_files, { desc = 'Find Git-tracked Files' })

-- Buffers
vim.keymap.set('n', '<leader>bs', telescope.buffers, { desc = 'Switch Buffer' })
vim.keymap.set('n', '<leader>bc', telescope.diagnostics, { desc = 'Buffer Diagnostics' })

-- Help
vim.keymap.set('n', '<leader>hh', telescope.help_tags, { desc = 'Help Tags' })

-- Search
vim.keymap.set('n', '<leader>sk', telescope.keymaps, { desc = 'Search Keymaps' })
vim.keymap.set('n', '<leader>sc', telescope.commands, { desc = 'Search Commands' })

-- Project/Workspace
vim.keymap.set('n', '<leader>pf', telescope.git_files, { desc = 'Project Files (Git)' })

-- Optional: LSP
vim.keymap.set('n', '<leader>lr', telescope.lsp_references, { desc = 'LSP References' })
vim.keymap.set('n', '<leader>ld', telescope.lsp_definitions, { desc = 'LSP Definitions' })

vim.keymap.set('n', '<leader>nh', ':noh<CR>', { desc = 'no highlights' })
vim.keymap.set('n', '<leader>ft', ':NvimTreeToggle<CR>', { desc = 'toggle file tree', noremap = true, silent = true })
vim.keymap.set('n', '<leader>gd', vim.lsp.buf.definition)
vim.keymap.set('n', 'K', vim.lsp.buf.hover)
vim.keymap.set('n', '<leader>cr', vim.lsp.buf.rename)
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action)
vim.keymap.set('n', '<leader>ss', ':w<CR>', { desc = 'Save file' })
--vim.keymap.set("n", "<leader>fo", function()
--	require("conform").format({
--		timeout_ms = 10000000
--	})
--end, { desc = "Format file" })
--vim.keymap.set("n", "<leader>lfo", function()
--	vim.lsp.buf.format({ async = true })
--end, { desc = "Format file (LSP)" })
vim.keymap.set("n", "<leader>fo", function()
	local conform = require("conform")

	-- Check if Conform has a formatter for the current filetype
	local filetype = vim.bo.filetype
	local formatters = conform.list_formatters_for_buffer(0)

	if #formatters > 0 then
		conform.format({ timeout_ms = 10000 }) -- adjust timeout as needed
	else
		vim.lsp.buf.format({ async = true })
	end
end, { desc = "Format file" })

-- Copy to clipboard
-- vim.keymap.set({ 'n', 'v' }, '<leader>y', '"+y')
vim.keymap.set('v', '<leader>Y', '"+y')

-- debug adapter ui
vim.keymap.set('n', '<leader>db', function() dapui.toggle() end, { desc = "toggle dap ui" })
vim.keymap.set('n', '<leader>dp', function() dap.toggle_breakpoint() end, { desc = "toggle debug breakpoint" })
vim.keymap.set('n', '<leader>dl', function() dap.continue() end, { desc = "toggle debug breakpoint" })
vim.keymap.set('n', '<leader>dl', function() dap.step_over() end, { desc = "toggle debug breakpoint" })
vim.keymap.set('n', '<leader>dl', function() dap.step_into() end, { desc = "toggle debug breakpoint" })
vim.keymap.set('n', '<leader>dl', function() dap.repl.open() end, { desc = "toggle debug breakpoint" })

-- Paste from clipboard
--vim.keymap.set({ 'n', 'v' }, '<leader>p', '"+p', { desc = "copy to clipboard" })
vim.keymap.set('n', '<leader>P', '"+p', { desc = "paste from clipboard" })
vim.keymap.set('n', 'U', '<C-r>', { desc = "redo" })
vim.keymap.set('n', '<leader>qq', ':confirm qa<CR>', { desc = 'Quit with confirmation' })
vim.keymap.set('n', '<leader>qs', ':confirm wqa<CR>', { desc = 'Save and quit' })
vim.keymap.set('n', '<leader>qQ', ':qa!<CR>', { desc = 'Quit without confirmation' })

-- Window navigation
vim.keymap.set('n', '<leader>wh', '<C-w>h', { desc = "Move to the window on the left" })
vim.keymap.set('n', '<leader>wj', '<C-w>j', { desc = "Move to the window on the bottom" })
vim.keymap.set('n', '<leader>wk', '<C-w>k', { desc = "Move to the window on the top" })
vim.keymap.set('n', '<leader>wl', '<C-w>l', { desc = "Move to the window on the right" })

-- Window split
vim.keymap.set('n', '<leader>wv', '<C-w>v', { desc = 'Vertical split' })
vim.keymap.set('n', '<leader>ws', '<C-w>s', { desc = 'Horizontal split' })

-- Window close
vim.keymap.set('n', '<leader>wc', '<C-w>c', { desc = 'Close window' })

-- buffer operations
-- vim.keymap.set('n', '<leader>bb', '<cmd>e #<CR>', { desc = 'Switch to last buffer' })
vim.keymap.set('n', '<leader>bd', '<cmd>bd<CR>', { desc = 'Kill current buffer' })
vim.keymap.set('n', '<leader>bn', '<cmd>enew<CR>', { desc = 'New buffer' })
vim.keymap.set('n', '<leader>bp', '<cmd>bprevious<CR>', { desc = 'Previous buffer' })
vim.keymap.set('n', '<leader>bj', '<cmd>bnext<CR>', { desc = 'Next buffer' })
vim.keymap.set('n', '<leader>bl', '<cmd>ls<CR>:b ', { desc = 'List buffers (manual switch)' })

-- tabs operations
vim.keymap.set('n', '<leader>tn', '<cmd>tabnew<CR>', { desc = 'New tab' })
vim.keymap.set('n', '<leader>tc', '<cmd>tabclose<CR>', { desc = 'Close tab' })
vim.keymap.set('n', '<leader>tl', '<cmd>tabnext<CR>', { desc = 'Next tab' })
vim.keymap.set('n', '<leader>th', '<cmd>tabprevious<CR>', { desc = 'Previous tab' })
vim.keymap.set('n', '<leader>to', '<cmd>tabonly<CR>', { desc = 'Close all other tabs' })
vim.keymap.set('n', '<leader>tm', '<cmd>tabs<CR>', { desc = 'List tabs' }) -- shows tab list in cmdline

-- git operations
vim.keymap.set('n', '<leader>gs', '<cmd>Neogit<CR>', { desc = 'Git status (Neogit)' }) -- Like `SPC g s` in Spacemacs
vim.keymap.set('n', '<leader>gc', '<cmd>Neogit commit<CR>', { desc = 'Git commit' })
vim.keymap.set('n', '<leader>gp', '<cmd>Neogit push<CR>', { desc = 'Git push' })
vim.keymap.set('n', '<leader>gl', '<cmd>Neogit log<CR>', { desc = 'Git log' }) -- Neogit shows commits via `:Neogit log`
vim.keymap.set('n', '<leader>gb', '<cmd>Neogit branch<CR>', { desc = 'Git branches' })
vim.keymap.set('n', '<leader>gd', '<cmd>Neogit diff<CR>', { desc = 'Git diff' })
vim.keymap.set('n', '<leader>gh', '<cmd>Gitsigns preview_hunk<CR>', { desc = 'Preview hunk' })
vim.keymap.set('n', '<leader>gr', '<cmd>Gitsigns reset_hunk<CR>', { desc = 'Reset hunk' })
vim.keymap.set('n', '<leader>gS', '<cmd>Gitsigns stage_hunk<CR>', { desc = 'Stage hunk' })

--toggle terminal
vim.keymap.set({ "n" }, "<leader>tt", "<cmd>ToggleTerm<CR>", { desc = "Toggle Terminal" })
vim.keymap.set({ "t" }, "<Esc>", "<cmd>ToggleTerm<CR>", { desc = "Toggle Terminal" })
vim.keymap.set({ "t" }, "<C-q>", "<cmd>ToggleTerm<CR>", { desc = "Toggle Terminal" })

--navigation
-- vim.keymap.set("i", "<C-h>", "<Left>")
-- vim.keymap.set("i", "<C-j>", "<Down>")
-- vim.keymap.set("i", "<C-k>", "<Up>")
-- vim.keymap.set("i", "<C-l>", "<Right>")
