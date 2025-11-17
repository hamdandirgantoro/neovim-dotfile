return {
	"williamboman/mason-lspconfig.nvim",
	dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
	config = function()
		require("mason").setup()
		require("mason-lspconfig").setup {
			ensure_installed = { "tailwindcss","cssls", "css_variables", "cssmodules_ls", "lua_ls", "ts_ls", "pyright", "clangd", "html", "emmet_language_server", "intelephense" }, -- Add your servers here
			automatic_installation = true,
		}
	end
}
