vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true
vim.opt.termguicolors = true
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
vim.cmd [[colorscheme gruvbox]]
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
