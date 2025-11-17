return {
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
			-- filetype = { "javascript", "typescript" }
		}
		if true then
			lspconfig.pyright.setup { cmd = { "docker", "exec", "-i", "kasir-next-js-backend-1", "pyright-langserver", "--stdio" },
				before_init = function(params)
					params.processId = vim.NIL
				end,
				root_dir = lspconfig.util.root_pattern(
					"pyrightconfig.json",
					"requirements.txt",
					".git"
				),
			}
		else
			lspconfig.pyright.setup {}
		end
		-- lspconfig.pyright.setup {}
		lspconfig.html.setup {
			filetypes = { "html", "blade", "templ", "php" },
			root_dir = function()
				return vim.fn.getcwd()
			end,
			init_options = {
				includeLanguages = {
					"blade"
				}
			}
		}
		lspconfig.emmet_language_server.setup {
			filetypes = { "html", "php", "blade", "javascriptreact", "typescriptreact" },
			root_dir = function()
				return vim.fn.getcwd()
			end,
			init_options = {
				includeLanguages = {
					blade = "html"
				}
			}
		}
		lspconfig.intelephense.setup {
			filetypes = { 'blade', 'php' },
			root_dir = function()
				return vim.fn.getcwd()
			end,
			settings = {
				filetypes = { 'blade', 'php' },
			}
		}
		lspconfig.cssls.setup {}
		lspconfig.css_variables.setup {}
		lspconfig.cssmodules_ls.setup {}
		-- You can add more language servers here
	end,
}
