local utils = {}
local execute = require("awful").spawn.with_shell

utils.enable_touchpad = function()
	-- Enable touchpad
	execute('xinput set-prop "$(xinput list --name-only | grep -i touch)" "libinput Tapping Enabled" 1')
end

utils.enable_dbus = function()
	execute('dbus-launch --exit-with-session awesome')
end

utils.setup_second_monitor = function()
	execute('xrandr --output eDP-1-1 --right-of HDMI-1-1')
end

utils.enable_picom = function()
	execute('sleep 10 && nixGL picom --config $HOME/.config/compton/compton.conf -f -b --dbus')
end

utils.enable_remind_service = function()
	execute("$HOME/.config/nixpkgs/scripts/remind.sh")
end

return utils
