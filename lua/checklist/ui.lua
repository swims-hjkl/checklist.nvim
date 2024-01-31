local checklist_operations = require("checklist.checklistOperations")
M = {}

UIBufferId = nil
UIWindowId = nil

local create_buffer = function()
	local buffernr = vim.api.nvim_create_buf(false, false)
	vim.api.nvim_buf_set_keymap(buffernr, "n", "c", "<cmd>lua require('checklist.ui').toggle_completed()<cr>",
		{ noremap = true })
	vim.api.nvim_buf_set_keymap(buffernr, "n", "q", "<cmd>lua require('checklist.ui').close_window()<cr>",
		{ noremap = true })
	vim.api.nvim_buf_set_keymap(buffernr, "n", "d", "<cmd>lua require('checklist.ui').delete_item()<cr>",
		{ noremap = true })
	vim.api.nvim_buf_set_option(buffernr, "buftype", "nofile")
	vim.api.nvim_buf_set_option(buffernr, "swapfile", false)
	vim.api.nvim_buf_set_option(buffernr, "bufhidden", "delete")
	vim.api.nvim_buf_set_option(buffernr, "modifiable", false)
	UIBufferId = buffernr
	return buffernr
end


M.close_window = function()
	vim.api.nvim_win_close(UIWindowId, true)
	M.save_data()
end


M.toggle_completed = function()
	local line_number = vim.fn.line('.')
	local checklist_item = M.display_data.todo_list[line_number - 2]
	checklist_item.completed = not checklist_item.completed
	vim.api.nvim_buf_set_option(UIBufferId, "modifiable", true)
	if (checklist_item.completed == false) then
		vim.api.nvim_buf_set_lines(UIBufferId, line_number - 1, line_number, true,
			{ "N " .. checklist_item.description })
		vim.api.nvim_buf_add_highlight(UIBufferId, 0, "ErrorMsg", line_number - 1, 0, 1)
	else
		vim.api.nvim_buf_set_lines(UIBufferId, line_number - 1, line_number, true,
			{ "C " .. checklist_item.description })
		vim.api.nvim_buf_add_highlight(UIBufferId, 0, "Conditional", line_number - 1, 0, 1)
	end
	vim.api.nvim_buf_set_option(UIBufferId, "modifiable", false)
end

local populate_ui = function()
	vim.api.nvim_buf_set_option(UIBufferId, "modifiable", true)
	vim.api.nvim_buf_set_lines(UIBufferId, 0, -1, false, {})
	local col_width = vim.fn.winwidth(UIWindowId)
	local header_start_col = math.floor(col_width / 2) - math.floor(#M.display_data.display_filter_criteria / 2) - 1
	vim.api.nvim_buf_set_lines(UIBufferId, 0, 1, false,
		{ string.rep(' ', header_start_col) .. M.display_data.display_filter_criteria, "" })
	vim.api.nvim_buf_add_highlight(UIBufferId, 0, "TermCursor", 0, header_start_col,
		header_start_col + #M.display_data.display_filter_criteria)
	for index, item in ipairs(M.display_data.todo_list) do
		if (item.completed == false) then
			vim.api.nvim_buf_set_lines(UIBufferId, index + 1, index + 1, false,
				{ "N " .. item.description })
			vim.api.nvim_buf_add_highlight(UIBufferId, 0, "ErrorMsg", index + 1, 0, 1)
		else
			vim.api.nvim_buf_set_lines(UIBufferId, index + 1, index + 1, false,
				{ "C " .. item.description })
			vim.api.nvim_buf_add_highlight(UIBufferId, 0, "Conditional", index + 1, 0, 1)
		end
	end
	vim.api.nvim_buf_set_option(UIBufferId, "modifiable", false)
end

M.delete_item = function()
	local delete_confirmation = vim.fn.input("are you sure you want to delete item? (y/n): ")
	if (string.lower(delete_confirmation) == "y") then
		local line_number = vim.fn.line('.')
		local checklist_item = M.display_data.todo_list[line_number - 2]
		checklist_operations.delete_todo(checklist_item.id)
		vim.api.nvim_buf_set_option(UIBufferId, "modifiable", true)
		vim.api.nvim_buf_set_lines(UIBufferId, line_number - 1, line_number, false, {})
		vim.api.nvim_buf_set_option(UIBufferId, "modifiable", false)
	end
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
	local win_id = create_window(buffernr, 10, 50)
	populate_ui()
end



return M
