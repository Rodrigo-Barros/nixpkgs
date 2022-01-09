local utils = require("utils")
local awful = require("awful")
local screen_count = screen:instances()
local naughty = require("naughty")
local dump = require("gears").debug.dump_return
-- startup
utils.enable_touchpad()
utils.enable_dbus()
utils.enable_picom()
utils.fix_super_key()
utils.enable_conky()
utils.enable_print_screen()

local displays = tonumber(utils.os_capture("xrandr -q | grep connected | wc -l"))
if displays == 2 then
	utils.setup_second_monitor()
end
