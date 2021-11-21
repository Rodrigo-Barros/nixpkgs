local awful=require("awful")
local wibox=require("wibox")
local naughty=require("naughty")
local dump=require("gears").debug.dump_return
local utils=require("utils")
local gears=require("gears")

-- settings

local widget = wibox.widget.textbox()
local popup = awful.popup {
	widget = {
        {
				text   = "undefined",
				font = "Font Awesome 9",
                widget = wibox.widget.textbox,
				id = 'popup_text'
        },
        margins = 10,
        widget  = wibox.container.margin,
    },
	visible = false,
	ontop=true
}

widget:buttons(
	awful.util.table.join(
        awful.button({}, 1, function()
			if popup.visible then
                popup.visible = not popup.visible
            else
                 popup:move_next_to(mouse.current_widget_geometry)
				 update_popup()
				 update_widget()
            end
		end),
		awful.button({},3,function()
			awful.spawn(settings.wifi_tool_cmd,{
				placement = awful.placement.centered,
				floating = true,
				focus=true
			})
		end)
	)
)

settings = {}

local function setup(values)
	if not values then
		values={}
	end
	settings.interface = values.interface or "wlp3s0"
	settings.icon = values.icon or ""
	settings.no_wifi=values.no_wifi or "no wifi"
	settings.wifi_tool_cmd=values.wifi_tool_cmd or "nixGL kitty -- /bin/bash -c 'LANG=pt_BR nmtui' "
	settings.icon_font = values.icon_font or "Font Awesome 11"
	settings.disconnected_popup_text = values.disconnected_popup_text or "You are disconneted :("
end

setup()

function get_wifi_info()
		local prepare_interface_name = "iwgetid %s | awk '{print $2,$3,$4,$5}'| sed -r 's/.+://' | sed -r 's/\"//g' "
		local wifi_name = utils.os_capture(string.format(prepare_interface_name,settings.interface))

		local prepare_interface_power = "echo 'scale=2;' $(iwconfig %s | grep Link | awk '{print $2}'| cut -d '=' -f2 ) |  bc "
		local wifi_power = utils.os_capture(string.format(prepare_interface_power,settings.interface))
		if type(tonumber(wifi_power)) == "number" then
			wifi_power = wifi_power * 100
		end

		return {
			name=wifi_name,
			power=wifi_power,
		}
end

function update_widget()
	local wifi = get_wifi_info()
	widget.font=settings.icon_font
	if string.len(wifi.name) > 0 then
		widget:set_text(settings.icon)
	else
		widget:set_text(settings.no_wifi)
		popup.widget:get_children_by_id("popup_text")[1]:set_text(settings.disconnected_popup_text)
	end
end

function update_popup()
	local popup=popup.widget:get_children_by_id("popup_text")[1]
	local wifi = get_wifi_info()
	popup:set_text(string.format("%s %s %%",wifi.name,wifi.power))
end

update_widget()

return widget
