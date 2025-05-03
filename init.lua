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
					highlight = { enable = true, additional_vim_regex_highlighting = { "blade" } },
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
					root_dir = function()
						return vim.fn.getcwd()
					end,
					filetype = { "javascript", "typescript", "html", "blade" }
				}
				lspconfig.pyright.setup {}
				lspconfig.phpactor.setup {}
				lspconfig.stimulus_ls.setup {
					root_dir = function()
						return vim.fn.getcwd()
					end
				}
				lspconfig.emmet_language_server.setup {
					filetypes = { "html", "php", "blade", "javascriptreact", "typescriptreact" },
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
					ensure_installed = { "lua_ls", "ts_ls", "pyright", "phpactor", "stimulus_ls", "emmet_language_server" }, -- Add your servers here
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
			config = function()
				local builtin = require('telescope.builtin')
				vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
				vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
				vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
				vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
			end
		},
		{
			'stevearc/conform.nvim',
			opts = {},
		}
	},
	-- Configure any other settings here. See the documentation for more details.
	-- colorscheme that will be used when installing plugins.
	install = { colorscheme = { "gruvbox" } },
	-- automatically check for plugin updates
	checker = { enabled = true },
})
--vim.filetype.add({
--	extension = {
--		['blade.php'] = 'blade',
--	}
--})

vim.filetype.add({
	pattern = {
		[".*%.blade%.php"] = "blade",
	},
})

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

vim.keymap.set('n', '<leader>/', ':noh<CR>')
vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', { noremap = true, silent = true })
vim.keymap.set('n', 'gd', vim.lsp.buf.definition)
vim.keymap.set('n', 'K', vim.lsp.buf.hover)
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename)
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action)
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
vim.keymap.set({ 'n', 'v' }, '<leader>y', '"+y')
vim.keymap.set('n', '<leader>Y', '"+Y')

-- Paste from clipboard
vim.keymap.set({ 'n', 'v' }, '<leader>p', '"+p')
vim.keymap.set('n', '<leader>P', '"+P')
vim.keymap.set('n', 'U', '<C-r>')


vim.cmd [[colorscheme gruvbox]]
vim.opt.number = true
