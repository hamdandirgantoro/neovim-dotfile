return {
	check = function(filename)
		return vim.fn.filereadable(filename) == 1
	end
}
