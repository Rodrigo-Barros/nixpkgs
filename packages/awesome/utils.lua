local utils = {}
local execute = require("awful").spawn.with_shell

-- launch only one instance of given command
local spawn_once = function(command,filter)
	local running
	if type(filter)=="string" then
		running=os.execute("pgrep ".. filter)
	else
		for _,program_name in ipairs(filter)do
			running=os.execute("pgrep ".. program_name)
			if running then break end
		end
	end

	if not running then execute(command) end
end

utils.os_capture = function(cmd, raw)
  local f = assert(io.popen(cmd, 'r'))
  local s = assert(f:read('*a'))
  f:close()
  if raw then return s end
  s = string.gsub(s, '^%s+', '')
  s = string.gsub(s, '%s+$', '')
  s = string.gsub(s, '[\n\r]+', ' ')
  return s
end


utils.enable_touchpad = function()
	-- Enable touchpad
	execute('xinput set-prop "$(xinput list --name-only | grep -i touch)" "libinput Tapping Enabled" 1')
end


utils.enable_dbus = function()
	spawn_once('dbus-launch --exit-with-session awesome','dbus-launch')
end

utils.setup_second_monitor = function()
	execute('xrandr --output eDP-1-1 --right-of HDMI-1-1')
end

utils.enable_picom = function()
	spawn_once('sleep 10 && nixGL picom --config $HOME/.config/compton/compton.conf -f -b --dbus',{'picom','compton'})
end

utils.fix_super_key=function()
	spawn_once('xcape -t 250 -e "Super_L=Alt_L|F1;Super_R=Alt_L|F1"','xcape')
end

utils.enable_conky = function()
    local conky_path=os.getenv("HOME") .. "/.config/nixpkgs/packages/remind/conky"

    local start_cmd = string.format([[
        export LOCALE_ARCHIVE=$(nix-build --no-out-link '<nixpkgs>' -A glibcLocales)/lib/locale/locale-archive
        export TASKRC=$HOME/.config/taskrc
        cd %s 
        conky -c Gotham &
        conky -c TODO &
    ]],conky_path)
    spawn_once(start_cmd,{'conky'})
end

utils.enable_print_screen = function ()
    spawn_once("flameshot",{"flameshot"})
end

return utils
