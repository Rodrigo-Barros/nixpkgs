local awful=require("awful")
local wibox=require("wibox")
local widget = wibox.widget.textbox()
local naughty=require("naughty")
local dump=require("gears").debug.dump_return
local utils=require("utils")
local gears=require("gears")

local interface="wlp3s0"

local grep_interface=" | grep ESSID | awk '{print $4,$5}' | sed 's/\"//g' | sed -r 's/.+://' "
local con_name = utils.os_capture("iwconfig " .. interface .. grep_interface)
local icon=''

widget:set_text(icon .. " " .. con_name)
widget.font="Font Awesome 11"
widget:connect_signal('button::press',function (client,_,_,button)
	if (button==3) then
		awful.spawn("nixGL kitty -- /bin/sh -c 'LANG=pt_BR nmtui'", {
			floating = true,
			placement = awful.placement.centered,
			focus=true
		})
	end
end)


local popup = awful.popup {
	widget = {
        {
            {
                text   = 'foobar',
				font = "Font Awesome 14",
                widget = wibox.widget.textbox,
				id = 'popup_text'
            },
            {
                {
                    text   = 'foobar',
                    widget = wibox.widget.textbox
                },
                bg     = '#ff00ff',
                clip   = true,
                shape  = gears.shape.rounded_bar,
                widget = wibox.widget.background
            },
            {
                value         = 0.5,
                forced_height = 30,
                forced_width  = 100,
                widget        = wibox.widget.progressbar
            },
            layout = wibox.layout.fixed.vertical,
        },
        margins = 10,
        widget  = wibox.container.margin
    },
    border_color = '#00ff00',
    border_width = 5,
    placement    = awful.placement.top_right,
}
popup:bind_to_widget(widget)

return widget
