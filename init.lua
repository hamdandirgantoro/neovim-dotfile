-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out,                            "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		-- add your plugins here
		{
			"nvim-treesitter/nvim-treesitter",
			build = ":TSUpdate",
			config = function()
				local configs = require("nvim-treesitter.configs")
				configs.setup({
					ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "elixir", "heex", "javascript", "html", "php", "blade" },
					sync_install = false,
					highlight = { enable = true, additional_vim_regex_highlighting = false },
					indent = { enable = true },
				})
				local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
				parser_config.blade = {
					install_info = {
						url = "https://github.com/EmranMR/tree-sitter-blade",
						files = { "src/parser.c" },
						branch = "main",
					},
					filetype = "blade",
				}
			end
		},
		{ "ellisonleao/gruvbox.nvim", priority = 1000, config = true, opts = ... },
		{ "rebelot/kanagawa.nvim" },
		{
			"nvim-tree/nvim-tree.lua",
			version = "*",
			lazy = false,
			dependencies = {
				"nvim-tree/nvim-web-devicons",
			},
			config = function()
				require("nvim-tree").setup {}
			end,
		},
		{
			"neovim/nvim-lspconfig",
			config = function()
				local lspconfig = require("lspconfig")
				lspconfig.lua_ls.setup {
					settings = {
						Lua = {
							diagnostics = {
								globals = { "vim" }
							}
						}
					}
				}
				lspconfig.ts_ls.setup {
					filetype = { "javascript", "typescript", "html", "blade" }
				}
				lspconfig.pyright.setup {}
				--				lspconfig.phpactor.setup {}
				lspconfig.stimulus_ls.setup {
					root_dir = function()
						return vim.fn.getcwd()
					end
				}
				lspconfig.emmet_language_server.setup {
					filetypes = { "html", "php", "blade", "javascriptreact", "typescriptreact" },
				}
				lspconfig.intelephense.setup {
				}
				-- You can add more language servers here
			end,
		},
		{
			"williamboman/mason.nvim",
			build = ":MasonUpdate", -- Optional
			config = true,
		},
		{
			"williamboman/mason-lspconfig.nvim",
			dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
			config = function()
				require("mason").setup()
				require("mason-lspconfig").setup {
					ensure_installed = { "lua_ls", "ts_ls", "pyright", "clangd", "stimulus_ls", "emmet_language_server", "intelephense" }, -- Add your servers here
					automatic_installation = true,
				}
			end
		},
		{
			"hrsh7th/nvim-cmp",
			dependencies = {
				"hrsh7th/cmp-nvim-lsp",
				"L3MON4D3/LuaSnip",
				"saadparwaiz1/cmp_luasnip",
			},
			config = function()
				local cmp = require("cmp")
				local luasnip = require("luasnip")

				cmp.setup {
					snippet = {
						expand = function(args)
							luasnip.lsp_expand(args.body)
						end,
					},
					mapping = cmp.mapping.preset.insert({
						["<Tab>"] = cmp.mapping.select_next_item(),
						["<S-Tab>"] = cmp.mapping.select_prev_item(),
						["<CR>"] = cmp.mapping.confirm({ select = true }),
						["<C-Space>"] = cmp.mapping.complete(),
					}),
					sources = {
						{ name = "nvim_lsp" },
						{ name = "luasnip" },
					},
				}
			end
		},
		{
			"lukas-reineke/indent-blankline.nvim",
			main = "ibl",
			---@module "ibl"
			---@type ibl.config
			opts = {},
		},
		{
			'nvim-telescope/telescope.nvim',
			tag = '0.1.8',
			-- or                              , branch = '0.1.x',
			dependencies = { 'nvim-lua/plenary.nvim' },
		},
		{
			'stevearc/conform.nvim',
			opts = {},
		},
		{
			"folke/which-key.nvim",
			event = "VeryLazy",
			opts = {
				-- your configuration comes here
				-- or leave it empty to use the default settings
				-- refer to the configuration section below
			},
			keys = {
				{
					"<leader>?",
					function()
						require("which-key").show({ global = false })
					end,
					desc = "Buffer Local Keymaps (which-key)",
				},
			},
		},
		{ "lewis6991/gitsigns.nvim" },
		{
			"NeogitOrg/neogit",
			dependencies = {
				"nvim-lua/plenary.nvim", -- required
				"sindrets/diffview.nvim", -- optional - Diff integration

				-- Only one of these is needed.
				"nvim-telescope/telescope.nvim", -- optional
				"ibhagwan/fzf-lua", -- optional
				"echasnovski/mini.pick", -- optional
				"folke/snacks.nvim", -- optional
			},
		},
		{ 'mfussenegger/nvim-dap' },
		{
			"j-hui/fidget.nvim",
			opts = {
				-- options
			},
		}
	},
	-- Configure any other settings here. See the documentation for more details.
	-- colorscheme that will be used when installing plugins.
	install = { colorscheme = { "kanagawa" } },
	-- automatically check for plugin updates
	checker = { enabled = true },
})
--vim.filetype.add({
--	extension = {
--		['blade.php'] = 'blade',
--	}
--})




require("conform").setup({
	formatters_by_ft = {
		--lua = { "stylua" },
		-- Conform will run multiple formatters sequentially
		--python = { "isort", "black" },
		-- You can customize some of the format options for the filetype (:help conform.format)
		--rust = { "rustfmt", lsp_format = "fallback" },
		-- Conform will run the first available formatter
		javascript = { "prettierd", "prettier", stop_after_first = true },
		html = { 'prettier' },
		php = { 'pint' },
		blade = { 'blade-formatter' }
	},
})

require('gitsigns').setup {
	signs                        = {
		add          = { text = '┃' },
		change       = { text = '┃' },
		delete       = { text = '_' },
		topdelete    = { text = '‾' },
		changedelete = { text = '~' },
		untracked    = { text = '┆' },
	},
	signs_staged                 = {
		add          = { text = '┃' },
		change       = { text = '┃' },
		delete       = { text = '_' },
		topdelete    = { text = '‾' },
		changedelete = { text = '~' },
		untracked    = { text = '┆' },
	},
	signs_staged_enable          = true,
	signcolumn                   = true, -- Toggle with `:Gitsigns toggle_signs`
	numhl                        = false, -- Toggle with `:Gitsigns toggle_numhl`
	linehl                       = false, -- Toggle with `:Gitsigns toggle_linehl`
	word_diff                    = false, -- Toggle with `:Gitsigns toggle_word_diff`
	watch_gitdir                 = {
		follow_files = true
	},
	auto_attach                  = true,
	attach_to_untracked          = false,
	current_line_blame           = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
	current_line_blame_opts      = {
		virt_text = true,
		virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
		delay = 100,
		ignore_whitespace = false,
		virt_text_priority = 100,
		use_focus = true,
	},
	current_line_blame_formatter = '<author>, <author_time:%R> - <summary>',
	sign_priority                = 6,
	update_debounce              = 100,
	status_formatter             = nil, -- Use default
	max_file_length              = 40000, -- Disable if file is longer than this (in lines)
	preview_config               = {
		-- Options passed to nvim_open_win
		style = 'minimal',
		relative = 'cursor',
		row = 0,
		col = 1
	},
}

-- vim.lsp.handlers["$/progress"] = function(_, result, ctx)
-- 	local value = result.value
-- 	if not value.kind then return end
--
-- 	local msg = value.message or ""
-- 	if value.percentage then
-- 		msg = string.format("%s (%.0f%%%%)", msg, value.percentage)
-- 	end
--
-- 	vim.notify(msg, vim.log.levels.INFO, { title = "LSP Progress" })
-- end

--------------------------------------------------------------------------------------------------------
-------------------------------------------[ KEYMAPS ]--------------------------------------------------
--------------------------------------------------------------------------------------------------------

local telescope = require("telescope.builtin")

-- Files
vim.keymap.set('n', '<leader>ff', telescope.find_files, { desc = 'Find File' })
vim.keymap.set('n', '<leader>fr', telescope.oldfiles, { desc = 'Recent Files' })
vim.keymap.set('n', '<leader>fg', telescope.live_grep, { desc = 'Grep Files' })
vim.keymap.set('n', '<leader>fs', telescope.grep_string, { desc = 'Search Word Under Cursor' })
vim.keymap.set('n', '<leader>fp', telescope.git_files, { desc = 'Find Git-tracked Files' })

-- Buffers
vim.keymap.set('n', '<leader>bb', telescope.buffers, { desc = 'Switch Buffer' })
vim.keymap.set('n', '<leader>bd', telescope.diagnostics, { desc = 'Buffer Diagnostics' })

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

vim.keymap.set('n', '<leader>/', ':noh<CR>')
vim.keymap.set('n', '<leader>ft', ':NvimTreeToggle<CR>', { desc = 'toggle file tree', noremap = true, silent = true })
vim.keymap.set('n', '<leader>gd', vim.lsp.buf.definition)
vim.keymap.set('n', 'K', vim.lsp.buf.hover)
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename)
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action)
vim.keymap.set('n', '<leader>ps', ':w<CR>', { desc = 'Save file' })
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
end, { desc = "Format file (Conform or LSP fallback)" })

-- Copy to clipboard
-- vim.keymap.set({ 'n', 'v' }, '<leader>y', '"+y')
vim.keymap.set('v', '<leader>Y', '"+y')

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

-- Window maximize (toggle)
-- keymap('n', '<leader>wm', ':MaximizerToggle<CR>', { desc = 'Maximize window' })

-- Optional: plugin for maximize functionality
-- You can install 'szw/vim-maximizer' for <leader>wm
-- use 'szw/vim-maximizer' in your plugin manager
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------
------------------------------------[ NEOVIM CONFIGURATION ]--------------------------------------------
--------------------------------------------------------------------------------------------------------
vim.filetype.add({
	pattern = {
		[".*%.blade%.php"] = "blade",
	},
})

vim.diagnostic.config({
	virtual_text = {
		prefix = "●", -- Or "■", "●", "▶", "▎", "", etc.
		spacing = 2,
	},
	signs = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
})
vim.cmd [[colorscheme kanagawa-dragon]]
vim.cmd [[
  highlight Normal guibg=NONE ctermbg=NONE
  highlight NormalNC guibg=NONE ctermbg=NONE
  highlight SignColumn guibg=NONE ctermbg=NONE
  highlight VertSplit guibg=NONE ctermbg=NONE
  highlight StatusLine guibg=NONE ctermbg=NONE
  highlight LineNr guibg=NONE ctermbg=NONE
  highlight Folded guibg=NONE ctermbg=NONE
]]
vim.opt.number = true
vim.opt.relativenumber = true
