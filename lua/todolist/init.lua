local path = require("plenary.path")
local TodolistItem = require("todolist.TodolistItem")
local todolist_operations = require("todolist.todolistOperations")
local ui = require("todolist.ui")

M = {}

local data_folder = vim.fn.stdpath("data")
M.data_path = data_folder .. "/todolist_data.json"

M.data = {}
M.display_data = {}


local load_data = function()
	M.data = {}
	local data = nil
	if (vim.fn.filereadable(M.data_path) == 0) then
		data = path.new(M.data_path):write(vim.fn.json_encode(M.data), "w")
	else
		data = vim.fn.json_decode(path.new(M.data_path):read())
	end
	if (data ~= nil) then
		for _, item in ipairs(data) do
			local todolist_item = TodolistItem:initialize(
				item
			)
			table.insert(M.data, todolist_item)
		end
	end
end

local set_display_data = function(filter_criteria)
	local display_filter_criteria = nil
	if (filter_criteria == "project") then
		display_filter_criteria = "Project Related Todos"
	elseif (filter_criteria == "file") then
		display_filter_criteria = "File Related Todos"
	else
		display_filter_criteria = "All Todos"
	end
	M.display_data["display_filter_criteria"] = display_filter_criteria
	M.display_data["todo_list"] = {}
	if (filter_criteria == nil) then
		M.display_data.todo_list = M.data
	end
	if (filter_criteria == "file") then
		local current_file_path = vim.api.nvim_buf_get_name(0)
		M.display_data.todo_list = {}
		for _, item in ipairs(M.data) do
			if (item.file_path == current_file_path) then
				table.insert(M.display_data.todo_list, item)
			end
		end
	end
	if (filter_criteria == "project") then
		local current_project_path = vim.fn.getcwd()
		M.display_data.todo_list = {}
		for _, item in ipairs(M.data) do
			if (item.project_path == current_project_path) then
				table.insert(M.display_data.todo_list, item)
			end
		end
	end
end

M.save_data = function()
	todolist_operations.save_todos_to_storage(M.data_path)
end

function M.todolist_add()
	todolist_operations.add_todo()
	M.save_data()
end

function M.todolist_show_all()
	set_display_data(nil)
	ui.open()
end

function M.todolist_show_file()
	set_display_data("file")
	ui.open()
end

function M.todolist_show_project()
	set_display_data("project")
	ui.open()
end

M.setup = function(config)
	load_data()
	vim.keymap.set("n", config.add_todo, M.todolist_add)
	vim.keymap.set("n", config.show_todo_all, M.todolist_show_all)
	vim.keymap.set("n", config.show_todo_file, M.todolist_show_file)
	vim.keymap.set("n", config.show_todo_project, M.todolist_show_project)
end

local config = {
	add_todo = "<Leader>at",
	show_todo_all = "<Leader>t",
	show_todo_project = "<Leader>pt",
	show_todo_file = "<Leader>ft",
}


M.setup(config)
return M
