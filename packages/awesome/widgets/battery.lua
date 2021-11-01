local awful = require("awful")
local naughty = require("naughty")
local debug = require("gears").debug.dump_return
local widget = awful.widget.watch(
    { awful.util.shell, "-c", "upower -i /org/freedesktop/UPower/devices/battery_BAT0 | sed -n '/present/,/icon-name/p'" },
    30,
    function(widget, stdout)
		widget.font = "Font Awesome 9"
        local bat_now = {
            present      = "N/A",
            state        = "N/A",
            warninglevel = "N/A",
            energy       = "N/A",
            energyfull   = "N/A",
            energyrate   = "N/A",
            voltage      = "N/A",
            percentage   = "N/A",
            capacity     = "N/A",
            icon         = "N/A"
        }
        for k, v in string.gmatch(stdout, '([%a]+[%a|-]+):%s*([%a|%d]+[,|%a|%d]-)') do
            if     k == "present"       then bat_now.present      = v
            elseif k == "state"         then bat_now.state        = v
            elseif k == "warning-level" then bat_now.warninglevel = v
            elseif k == "energy"        then bat_now.energy       = string.gsub(v, ",", ".") -- Wh
            elseif k == "energy-full"   then bat_now.energyfull   = string.gsub(v, ",", ".") -- Wh
            elseif k == "energy-rate"   then bat_now.energyrate   = string.gsub(v, ",", ".") -- W
            elseif k == "voltage"       then bat_now.voltage      = string.gsub(v, ",", ".") -- V
            elseif k == "percentage"    then bat_now.percentage   = tonumber(v)              -- %
            elseif k == "capacity"      then bat_now.capacity     = string.gsub(v, ",", ".") -- %
            elseif k == "icon-name"     then bat_now.icon         = v
            end
        end

		local percentage = bat_now.percentage
		local state  = bat_now.state:gsub('%W','')
		local icon = ''
		local warning_level = 15

		-- localização
		if state == 'charging' then
			state = 'carregando'
		else
			state = 'descarregando'
		end

		if state == 'descarregando' and percentage <= warning_level then
			naughty.notify({
				title = "O computador está " .. state .. " por favor conecte a uma fonte de energia",
				ignore_suspend = true
			})
		end

		if percentage <= 10 then
			icon = ''
		elseif percentage <= 25 then
			icon = ''
		elseif percentage <= 50 then
			icon = ''
		elseif percentage <= 75 then
			icon = ''
		elseif percentage <= 100 then
			icon = ''
		end
        -- customize here
		local widget_text = " " .. icon .. " " .. percentage .. "% "
        widget:set_text(widget_text)
		widget:connect_signal("mouse::enter", function(w)
			w.text = state
		end)
		widget:connect_signal("mouse::leave",function(w)
			w.text = widget_text
		end)
    end
)
return widget

