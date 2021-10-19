function os.capture(cmd, raw)
  local f = assert(io.popen(cmd, 'r'))
  local s = assert(f:read('*a'))
  f:close()
  if raw then return s end
  s = string.gsub(s, '^%s+', '')
  s = string.gsub(s, '%s+$', '')
  s = string.gsub(s, '[\n\r]+', ' ')
  return s
end

local utils = require("utils")
local screen_count = screen:instances()
local naughty = require("naughty")
local dump = require("gears").debug.dump_return
-- startup
utils.enable_touchpad()
utils.enable_dbus()

local displays = tonumber(os.capture("xrandr -q | grep connected | wc -l"))
if displays == 2 then
	utils.setup_second_monitor()
end
