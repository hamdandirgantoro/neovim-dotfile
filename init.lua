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
					ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "elixir", "heex", "javascript", "html" },
					sync_install = false,
					highlight = { enable = true },
					indent = { enable = true },
				})
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
				require("lspconfig").lua_ls.setup {}
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
					ensure_installed = { "lua_ls", "ts_ls", "pyright" }, -- Add your servers here
					automatic_installation = true,
				}

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
				lspconfig.ts_ls.setup {}
				lspconfig.pyright.setup {}
				lspconfig.emmet_ls.setup {}
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
require('nvim-treesitter.install').compilers = { 'gcc' }
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
	},
})

vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', { noremap = true, silent = true })
vim.keymap.set('n', 'gd', vim.lsp.buf.definition)
vim.keymap.set('n', 'K', vim.lsp.buf.hover)
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename)
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action)
vim.keymap.set("n", "<leader>F", function()
	require("conform").format()
end, { desc = "Format file" })
vim.keymap.set("n", "<leader>LF", function()
	vim.lsp.buf.format({ async = true })
end, { desc = "Format file (LSP)" })

-- Copy to clipboard
vim.keymap.set({ 'n', 'v' }, '<leader>y', '"+y')
vim.keymap.set('n', '<leader>Y', '"+Y')

-- Paste from clipboard
vim.keymap.set({ 'n', 'v' }, '<leader>p', '"+p')
vim.keymap.set('n', '<leader>P', '"+P')
vim.keymap.set('n', 'U', '<C-r>')


vim.cmd [[colorscheme gruvbox]]
vim.opt.number = true
