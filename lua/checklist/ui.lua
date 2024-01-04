M = {}

UIBufferId = nil
UIWindowId = nil

local create_buffer = function()
	local buffernr = vim.api.nvim_create_buf(false, false)
	vim.api.nvim_buf_set_keymap(buffernr, "n", "d", "<cmd>lua require('checklist.ui').del()<cr>", { noremap = true })
	vim.api.nvim_buf_set_option(buffernr, "buftype", "nofile")
	vim.api.nvim_buf_set_option(buffernr, "swapfile", false)
	vim.api.nvim_buf_set_option(buffernr, "bufhidden", "delete")
	vim.api.nvim_buf_set_option(buffernr, "modifiable", false)
	UIBufferId = buffernr
	return buffernr
end


M.close_window = function()
	vim.api.nvim_win_close(UIWindowId, true)
end

local populate_ui = function()
	PT(M.display_data)
	local list_of_strings_to_display = {}
	for index, item in ipairs(M.display_data) do
		table.insert(list_of_strings_to_display, item.description)
	end
	vim.api.nvim_buf_set_option(UIBufferId, "modifiable", true)
	vim.api.nvim_buf_set_lines(UIBufferId, 0, #list_of_strings_to_display, false, list_of_strings_to_display)
	vim.api.nvim_buf_set_option(UIBufferId, "modifiable", false)
end

local create_window = function(buffernr, start_line, start_col)
	local win_id = vim.api.nvim_open_win(buffernr, true,
		{ relative = "editor", row = start_line, col = start_col, width = 60, height = 30, border = 'rounded' })
	vim.api.nvim_win_set_option(win_id, "number", false)
	vim.api.nvim_win_set_option(win_id, "relativenumber", false)
	vim.cmd(
		"autocmd BufLeave <buffer> ++nested ++once lua require('checklist.ui').close_window()"

	)
	UIWindowId = win_id
	return win_id
end

M.open = function()
	local buffernr = create_buffer()
	local win_id = create_window(buffernr, 0, 50)
	populate_ui()
end


return M
