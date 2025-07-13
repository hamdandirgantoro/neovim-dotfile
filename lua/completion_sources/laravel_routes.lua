local source = {}

-- Required: check whether this source should be active
function source:is_available()
	local ft = vim.bo.filetype
	return ft == "blade" or ft == "php"
end

-- -- Optional: define the trigger characters (like `.`, `:`, etc)
function source:get_trigger_characters()
	return { '/' }
end

--
-- -- Optional: define keyword pattern
-- function source:get_keyword_pattern()
--   return [[\k\+]]
-- end

-- Required: completion function
function source:complete(params, callback)
	local context = params.context or {}
	local line = context.cursor_before_line or ""

	local has_match = line:match("action=['\"]") or line:match("href=['\"]")
	if not (has_match) then
		callback({ items = {}, isIncomplete = false })
		return
	end
	local handle = io.popen(
		[[cat $PREFIX/tmp/laravelroutes.json | jq -r '.[].uri']]
	-- [[php artisan route:list --json | jq -r '.[].uri']]
	)
	if not handle then return {} end

	local views = {}

	for item in handle:lines() do
		if item == "/" then
			item = ""
		end
		table.insert(views, { label = "/" .. item, kind = "Route" })
	end

	handle:close()

	callback({
		items = views,
		isIncomplete = false,
	})
end

return source
