return
{
	"hrsh7th/nvim-cmp",
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"L3MON4D3/LuaSnip",
		"saadparwaiz1/cmp_luasnip",
	},
	config = function()
		local cmp_types = require("cmp.types")
		local cmp = require("cmp")
		local luasnip = require("luasnip")

		cmp_types.lsp.CompletionItemKind["Blade_view"] = "Blade_view"
		-- In your init.lua or a separate config file
		cmp.setup {
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			window = {
				completion = {
					border = "rounded",
					winhighlight = "Normal:WinBar,FloatBorder:WinBar,CursorLine:PmenuThumb,Search:None"
				},
				documentation = {
					border = "rounded",
					winhighlight = "Normal:WinBar,FloatBorder:WinBar,CursorLine:PmenuThumb,Search:None"
				},
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
				{ name = "blade_views" },
			},
			formatting = {
				format = function(entry, item)
					local kind_icons = {
						Text = "",
						Method = "",
						Function = "",
						Constructor = "",
						Field = "",
						Variable = "",
						Class = "",
						Interface = "",
						Module = "",
						Property = "",
						Unit = "",
						Value = "",
						Enum = "",
						Keyword = "",
						Snippet = "",
						Color = "",
						File = "",
						Reference = "",
						Folder = "",
						EnumMember = "",
						Constant = "",
						Struct = "",
						Event = "",
						Operator = "",
						TypeParameter = "",
						Blade_view = ""
					}
					vim.api.nvim_set_hl(0, "Blade_view", { fg = "#fb4934" }) -- orange icon

					local kind = item.kind
					item.kind = (kind_icons[kind] or kind)
					if kind == "Blade_view" then
						item.kind_hl_group = "Blade_view"
					end
					-- item.kind = (kind_icons[kind] or "") .. " " .. kind

					-- Custom source menu
					-- item.menu = ({
					-- 	nvim_lsp = "[LSP]",
					-- 	luasnip  = "[Snip]",
					-- 	buffer   = "[Buf]",
					-- 	path     = "[Path]",
					-- 	mysource = "[MySrc]",
					-- })[entry.source.name] or "[" .. entry.source.name .. "]"

					-- Optional: truncate abbr to 50 chars with ellipsis
					-- local max_width = 50
					-- if #item.abbr > max_width then
					-- 	item.abbr = vim.fn.strcharpart(item.abbr, 0, max_width) .. "…"
					-- end

					return item
				end,
			}
		}
		require("cmp").register_source("blade_views", require("completion_sources.blade_views"))
	end
}
