local init = {}

init.enable_touchpad = function()
	-- Enable touchpad
	os.execute('xinput set-prop "$(xinput list --name-only | grep -i touch)" "libinput Tapping Enabled" 1')
end

init.enable_dbus = function()
	os.execute('dbus-launch --exit-with-session awesome')
end

return init
