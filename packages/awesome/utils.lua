local init = {}
local execute = require("awful").spawn.with_shell

init.enable_touchpad = function()
	-- Enable touchpad
	execute('xinput set-prop "$(xinput list --name-only | grep -i touch)" "libinput Tapping Enabled" 1')
end

init.enable_dbus = function()
	execute('dbus-launch --exit-with-session awesome')
end

init.setup_second_monitor = function()
	execute('xrandr --output eDP-1-1 --right-of HDMI-1-1')
end

init.enable_picom = function()
	execute('sleep 10 && nixGL picom --config $HOME/.config/compton/compton.conf -f -b')
end

return init
