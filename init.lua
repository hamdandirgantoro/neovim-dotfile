if require('helpers.file_exist').check('artisan') then
	vim.system({
		"sh", "-c",
		"ls routes/* | entr -n sh -c 'php artisan route:list --json > /tmp/laravelroutes.json'"
	}, { detach = true })
	vim.system({
		"sh", "-c",
		[[inotifywait -r -m /home/hamdan/php-shell/shop/resources/views -e create -e moved_to -e delete |
    while read path action file; do
        find resources/views -type f -name "*.blade.php" | sed -E 's|^resources/views/||; s|\.blade\.php$||; s|/|.|g' > /tmp/laraview
        # do something with the file
    done]]
	}, { detach = true })

	vim.system({
		"sh", "-c",
		[[find resources/views -type f -name "*.blade.php" | sed -E 's|^resources/views/||; s|\.blade\.php$||; s|/|.|g' > /tmp/laraview]]
	}, { detach = true })
end

vim.filetype.add({
	pattern = {
		[".*%.blade%.php"] = "blade",
	},
	extension = {
		blade = 'blade'
	}
})
require('lazy-init')
require('config')
require('keymaps')
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

local dapui = require("dapui")
dapui.setup()
local dap = require("dap")
local mason_path = vim.fn.stdpath("data") .. "/mason/packages"

dap.listeners.before.attach.dapui_config = function()
	dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
	dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
	dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
	dapui.close()
end

dap.adapters["php"] = {
	type = "executable",
	command = "node",
	host = "localhost",
	port = "${port}",
	executable = {
		command = "node",
		args = {
			mason_path .. "/php-debug-adapter/extension/out/phpDebug.js",
			"--server={}",
		},
	}
}

dap.adapters["pwa-node"] = {
	type = "server",
	host = "localhost",
	port = "${port}",
	executable = {
		command = "node",
		args = {
			mason_path .. "/js-debug-adapter/js-debug/src/dapDebugServer.js",
			"${port}",
		},
	}
}

dap.configurations.javascript = {
	{
		type = "pwa-node",
		request = "launch",
		name = "Launch file",
		program = "${file}",
		cwd = vim.fn.getcwd(),
		runtimeExecutable = "node",
		console = "integratedTerminal",
	},
}

dap.configurations.php = {
	{
		type = 'php',
		request = 'launch',
		name = "Listen for Xdebug",
		port = 9003
	},
}

require('lualine').setup {
	options = {
		icons_enabled = true,
		theme = 'auto',
		component_separators = { left = '', right = '' },
		section_separators = { left = '', right = '' },
		disabled_filetypes = {
			statusline = {},
			winbar = {},
		},
		ignore_focus = {},
		always_divide_middle = true,
		always_show_tabline = true,
		globalstatus = false,
		refresh = {
			statusline = 100,
			tabline = 100,
			winbar = 100,
		}
	},
	sections = {
		lualine_a = { 'mode' },
		lualine_b = { 'branch', 'diff', 'diagnostics' },
		lualine_c = { 'filename' },
		lualine_x = { 'encoding', 'fileformat', 'filetype' },
		lualine_y = { 'progress' },
		lualine_z = { 'location' }
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { 'filename' },
		lualine_x = { 'location' },
		lualine_y = {},
		lualine_z = {}
	},
	tabline = {},
	winbar = {},
	inactive_winbar = {},
	extensions = {}
}

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

require('telescope').setup { defaults = { file_ignore_patterns = { "node_modules", "vendor" } } }
require 'colorizer'.setup()
require("toggleterm").setup {
	-- size can be a number or function which is passed the current terminal
	-- size = 20 | function(term)
	--   if term.direction == "horizontal" then
	--     return 15
	--   elseif term.direction == "vertical" then
	--     return vim.o.columns * 0.4
	--   end
	-- end,
	-- open_mapping = [[<c-\>]], -- or { [[<c-\>]], [[<c-¥>]] } if you also use a Japanese keyboard.
	-- on_create = fun(t: Terminal), -- function to run when the terminal is first created
	-- on_open = fun(t: Terminal), -- function to run when the terminal opens
	-- on_close = fun(t: Terminal), -- function to run when the terminal closes
	-- on_stdout = fun(t: Terminal, job: number, data: string[], name: string) -- callback for processing output on stdout
	-- on_stderr = fun(t: Terminal, job: number, data: string[], name: string) -- callback for processing output on stderr
	-- on_exit = fun(t: Terminal, job: number, exit_code: number, name: string) -- function to run when terminal process exits
	-- hide_numbers = true, -- hide the number column in toggleterm buffers
	-- shade_filetypes = {},
	-- autochdir = false, -- when neovim changes it current directory the terminal will change it's own when next it's opened
	-- highlights = {
	-- highlights which map to a highlight group name and a table of it's values
	-- NOTE: this is only a subset of values, any group placed here will be set for the terminal window split
	--   Normal = {
	--     guibg = "<VALUE-HERE>",
	--   },
	--   NormalFloat = {
	--     link = 'Normal'
	--   },
	--   FloatBorder = {
	--     guifg = "<VALUE-HERE>",
	--     guibg = "<VALUE-HERE>",
	--   },
	-- },
	-- shade_terminals = true, -- NOTE: this option takes priority over highlights specified so if you specify Normal highlights you should set this to false
	-- shading_factor = '<number>', -- the percentage by which to lighten dark terminal background, default: -30
	-- shading_ratio = '<number>', -- the ratio of shading factor for light/dark terminal background, default: -3
	-- start_in_insert = true,
	-- insert_mappings = true, -- whether or not the open mapping applies in insert mode
	-- terminal_mappings = true, -- whether or not the open mapping applies in the opened terminals
	-- persist_size = true,
	-- persist_mode = true, -- if set to true (default) the previous terminal mode will be remembered
	direction = 'float', --'vertical' | 'horizontal' | 'tab' | 'float'
	-- close_on_exit = true, -- close the terminal window when the process exits
	-- clear_env = false, -- use only environmental variables from `env`, passed to jobstart()
	-- Change the default shell. Can be a string or a function returning a string
	-- shell = vim.o.shell,
	-- auto_scroll = true, -- automatically scroll to the bottom on terminal output
	-- This field is only relevant if direction is set to 'float'
	-- float_opts = {
	-- The border key is *almost* the same as 'nvim_open_win'
	-- see :h nvim_open_win for details on borders however
	-- the 'curved' border is a custom border type
	-- not natively supported but implemented in this plugin.
	float_opts = {
		border = "rounded", -- ← this enables rounded borders
	},
	-- like `size`, width, height, row, and col can be a number or function which is passed the current terminal
	-- width = <value>,
	-- height = <value>,
	-- row = <value>,
	-- col = <value>,
	-- winblend = 3,
	-- zindex = <value>,
	-- title_pos = 'left' | 'center' | 'right', position of the title of the floating window
	-- },
	-- winbar = {
	--   enabled = false,
	--   name_formatter = function(term) --  term: Terminal
	--     return term.name
	--   end
	-- },
	-- responsiveness = {
	-- breakpoint in terms of `vim.o.columns` at which terminals will start to stack on top of each other
	-- instead of next to each other
	-- default = 0 which means the feature is turned off
	-- horizontal_breakpoint = 135,
	-- }
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
-- Window maximize (toggle)
-- keymap('n', '<leader>wm', ':MaximizerToggle<CR>', { desc = 'Maximize window' })
-- Optional: plugin for maximize functionality
-- You can install 'szw/vim-maximizer' for <leader>wm
-- use 'szw/vim-maximizer' in your plugin manager
-- require('custom_features.devel.embedded_language_support')
-- function _G.Reload()
--   package.loaded['custom_features.devel.embedded_language_support'] = nil
--   return require('custom_features.devel.embedded_language_support')
-- end
--
-- vim.api.nvim_create_user_command("Reload", function()
--   Reload()
-- end, { })
--
-- vim.keymap.set('n', '<leader>dr', Reload(), { desc = 'development reload' })
