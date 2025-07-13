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
		cmp_types.lsp.CompletionItemKind["Route"] = "Route"
		cmp_types.lsp.CompletionItemKind["Route_path"] = "Route_path"
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
				{ name = "laravel_routes" },
				{ name = "laravel_route_names" },
			},
			formatting = {
				fields = { "kind", "abbr", "menu" },
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
						Blade_view = "",
						Route = "󰑪",
						Route_path = "󰑪",
					}
					vim.api.nvim_set_hl(0, "Blade_view", { fg = "#fb4934" }) -- orange icon
					vim.api.nvim_set_hl(0, "Route", { fg = "#895129" }) -- orange icon
					vim.api.nvim_set_hl(0, "Route_path", { fg = "#895129" }) -- orange icon

					local kind = item.kind
					item.kind = (kind_icons[kind] or kind)
					-- item.kind = (kind_icons[kind] or "") .. " " .. kind

					-- Custom source menu
					-- item.menu = ({
					-- 	nvim_lsp = "[LSP]",
					-- 	luasnip  = "[Snip]",
					-- 	buffer   = "[Buf]",
					-- 	path     = "[Path]",
					-- 	blade_view = '',
					-- 	laravel_route_names = '',
					-- 	laravel_routes = '',
					-- })[entry.source.name] or entry.source.name
					if kind == "Blade_view" then
						item.kind_hl_group = "Blade_view"
						-- item.menu_hl_group = "Blade_view"
					end
					if kind == "Route" then
						item.kind_hl_group = "Route"
						-- item.menu_hl_group  = "Blade_view"
					end
					if kind == "Route_path" then
						item.kind_hl_group = "Route_path"
						-- item.menu_hl_group = "Blade_view"
					end

					-- Optional: truncate abbr to 50 chars with ellipsis
					-- local max_width = 50
					-- if #item.abbr > max_width then
					-- 	item.abbr = vim.fn.strcharpart(item.abbr, 0, max_width) .. "…"
					-- end

					return item
				end,
			}
		}
		if require('helpers.file_exist').check('artisan') then
			require("cmp").register_source("blade_views", require("completion_sources.blade_views"))
			require("cmp").register_source("laravel_routes", require("completion_sources.laravel_routes"))
			require("cmp").register_source("laravel_route_names",
				require("completion_sources.laravel_routes_name"))
		end
	end
}
