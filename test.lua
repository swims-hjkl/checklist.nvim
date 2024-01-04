local ui = require("checklist.ui")
local init = require("checklist")

M = {}
M.data = {}
init.set_items()
PT(M.data)
UIBufferId = ui.create_buffer()
UIWindwId = ui.create_window(UIBufferId, 10, 50)
print("creating window")
print(UIWindowId)
ui.populate_ui()
return M
