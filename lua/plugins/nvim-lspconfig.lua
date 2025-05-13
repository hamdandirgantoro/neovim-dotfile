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
		lspconfig.pyright.setup {}
		lspconfig.html.setup {
			filetypes = { "html", "blade", "templ", "php" },
			root_dir = function()
				return vim.fn.getcwd()
			end,
		}
		lspconfig.emmet_language_server.setup {
			filetypes = { "html", "php", "blade", "javascriptreact", "typescriptreact" },
		}
		lspconfig.intelephense.setup {}
		lspconfig.cssls.setup {}
		lspconfig.css_variables.setup {}
		lspconfig.cssmodules_ls.setup {}
		-- You can add more language servers here
	end,
}
