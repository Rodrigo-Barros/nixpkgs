local utils = require("utils")
local screen_count = screen.count()
-- startup
utils.enable_touchpad()
utils.enable_dbus()
if (screen_count == 2) then
	utils.setup_second_monitor()
end
