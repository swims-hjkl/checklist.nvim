M = {}

local Todo = {
	id = 0,
	description = "",
	file_path = "",
	project_path = "",
	completed = false
}

function Todo.new(id, desc, file_path, project_path, completed_status)
	local self = setmetatable({}, Todo)
	self.id = id
	self.desc = desc
	self.file_path = file_path
	self.project_path = project_path
	self.completed_status = completed_status
	return self
end

function Todo:repr()
	return tostring(self.id) ..
	    " " ..
	    self.desc .. " " .. self.file_path .. " " .. self.project_path .. " " .. tostring(self.completed_status)
end

function Todo.__index(table, key)
	return Todo[key]
end

local obj = Todo.new(1, "something", "file", "project", true)

print(obj:repr())
