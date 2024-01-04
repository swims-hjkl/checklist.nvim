local path = require("plenary.path")
local ChecklistItem = require("checklist.checklistItem")
local ChecklistOperations = require("checklist.checklistOperations")
local ui = require("checklist.ui")

print("test change")

M = {}

local data_folder = vim.fn.stdpath("data")
local data_path = data_folder .. "/checklist_data.json"

M.data = {}
M.display_data = {}

local set_items = function()
	if (vim.fn.filereadable(data_path) == 0) then
		data = path.new(data_path):write(vim.fn.json_encode(M.data), "w")
	else
		data = vim.fn.json_decode(path.new(data_path):read())
	end
	if (data ~= nil) then
		for _, item in ipairs(data) do
			local checklist_item = ChecklistItem:initialize(
				item
			)
			table.insert(M.data, checklist_item)
		end
	end
end

local set_display_data = function(filter_criteria)
	print("setting display data")
	print(filter_criteria)
	if (filter_criteria == nil) then
		print("exec all")
		M.display_data = M.data
	end
	if (filter_criteria == "file") then
		print("exec file")
		local current_file_path = vim.api.nvim_buf_get_name(0)
		M.display_data = {}
		for _, item in ipairs(M.data) do
			if (item.file_path == current_file_path) then
				table.insert(M.display_data, item)
			end
		end
	end
	if (filter_criteria == "project") then
		print("exec project")
		local current_project_path = vim.fn.getcwd()
		print(current_prject_path)
		M.display_data = {}
		for _, item in ipairs(M.data) do
			if (item.project_path == current_project_path) then
				table.insert(M.display_data, item)
			end
		end
	end
end

M.setup = function()
	set_items()
	vim.keymap.set("n", "<Leader>at", ChecklistOperations.add_todo)
	vim.keymap.set("n", "<Leader>sta", function()
		set_display_data(nil)
		ui.open()
	end)
	vim.keymap.set("n", "<Leader>stf", function()
		set_display_data("file")
		ui.open()
	end)
	vim.keymap.set("n", "<Leader>stp", function()
		set_display_data("project")
		ui.open()
	end)
end

M.setup()
return
