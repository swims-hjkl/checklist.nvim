local random = math.random

local function uuid()
	local template = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
	return string.gsub(template, '[xy]', function(c)
		local v = (c == 'x') and random(0, 0xf) or random(8, 0xb)
		return string.format('%x', v)
	end)
end

TodoListItem = {
	id = nil,
	description = nil,
	file_path = nil,
	project_path = nil,
	completed = nil
}

function TodoListItem:newItem(description)
	local o = {}
	o.id = uuid()
	o.description = description
	o.file_path = vim.api.nvim_buf_get_name(0)
	o.project_path = vim.fn.getcwd()
	o.completed = false
	setmetatable(o, self)
	self.__index = self
	return o
end

function TodoListItem:initialize(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end

function TodoListItem:complete_task()
	self.completed = true
end

function TodoListItem:get_item()
	return {
		id = self.id,
		description = self.description,
		file_path = self.file_path,
		project_path = self.project_path,
		completed = self.completed
	}
end

return TodoListItem
