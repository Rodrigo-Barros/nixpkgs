-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")
package.path = package.path .. ";" .. os.getenv("HOME") .. "/.config/nixpkgs/packages/awesome/?.lua"

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")

require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
local utils = require('utils')
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
local battery = require("widgets.battery")
local wifi = require("widgets.wifi")
local settings = require("settings")
local tags = settings.tags

-- nix fixes

local function patch_volume_icon_dir()
    local awesome_path = os.getenv('HOME') .. '.config/nixpkgs/packages/awesome'
    local cmd = "nix build --no-out-link " .. awesome_path .. "/default.nix -A awesome"
    local icon_dir = utils.os_capture(cmd) .. "/share/awesome/lib/awesome-wm-widgets/volume-widget/icons/"
    return icon_dir
end

-- awesome-wm-widgets
local volume_widget = require('awesome-wm-widgets.volume-widget.volume')
volume_widget = volume_widget({})

local logout_popup = require("awesome-wm-widgets.logout-popup-widget.logout-popup")

require('startup')

-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
require("theme")

-- }}}

-- {{{ Notification settings
naughty.config.presets = {
	low = {
		bg = "#0000ff",
		fg = "#ffffff"
	},
	info  = {
		bg = "#0000ff",
		fg = "#ffffff"
	}
}


-- This is used later as the default terminal and editor to run.
terminal = "nixGL kitty"
editor = os.getenv("EDITOR") or "nano"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
   { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end },
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", terminal }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Wibar
-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- Create a textclock widget
mytextclock = wibox.widget.textclock("%H:%M")

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
                    awful.button({ }, 1, function(t) t:view_only() end),
                    awful.button({ modkey }, 1, function(t)
                                              if client.focus then
                                                  client.focus:move_to_tag(t)
                                              end
                                          end),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, function(t)
                                              if client.focus then
                                                  client.focus:toggle_tag(t)
                                              end
                                          end),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
                )

local tasklist_buttons = gears.table.join(
                     -- awful.button({ }, 1, function (c)
                     --                          if c == client.focus then
                     --                              c.minimized = true
                     --                          else
                     --                              c:emit_signal(
                     --                                  "request::activate",
                     --                                  "tasklist",
                     --                                  {raise = true}
                     --                              )
                     --                          end
                     --                      end),
                     awful.button({ }, 3, function()
                                              awful.menu.client_list({ theme = { width = 250 } })
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                          end))

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)


awful.layout.layouts = {
	awful.layout.suit.tile.left,
	awful.layout.suit.spiral,
	awful.layout.suit.magnifier,
    awful.layout.suit.floating,
    --awful.layout.suit.tile,
    --awful.layout.suit.tile.bottom,
    --awful.layout.suit.tile.top,
    --awful.layout.suit.fair,
    --awful.layout.suit.fair.horizontal,
    --awful.layout.suit.spiral.dwindle,
    --awful.layout.suit.max,
    --awful.layout.suit.max.fullscreen,
    --awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}

awful.screen.connect_for_each_screen(function(s)
    -- awful.tag(tags, s, awful.layout.layouts[1])

    for i =1,9 do
      selected = false
      if i == 1 then 
        selected = true
      end
      awful.tag.add(tags[i],{
        layout=awful.layout.suit.tile.left,
        gap = 2.5,
        gap_single_client = false,
        selected = selected,
		screen = s
      })
  	end

    -- Wallpaper
    set_wallpaper(s)


    -- Each screen has its own tag table.
    -- awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.noempty,
        buttons = taglist_buttons,
		style = {
			font ="Font Awesome 12"
		}
    }

	local calendar = awful.widget.calendar_popup.month({
		start_sunday = true
	})
	calendar:attach(mytextclock)

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.focused,
        buttons = tasklist_buttons,
		widget_template = {
			{
				{
					{
						widget = wibox.widget.imagebox,
						id = 'icon_role'
					},
					right = 7,
					widget = wibox.container.margin,
				},
				{
					widget = wibox.widget.textbox,
					align = "center",
					id = 'text_role'
				},
				layout = wibox.layout.fixed.horizontal,
			},
			widget = wibox.container.place,
		}
    }

	local player_text = wibox.widget.textbox()
	player_text.align = 'center'

	s.player_stage = awful.wibar({
		position='bottom', 
		screen = s,
		width = '50%',
		visible = false
	})

	s.player = {
		set_text = function(text)
			player_text:set_text(text)
		end,
		set_control = function(play_status)
			local current_text = string.gsub(player_text.text,"%W","")
			player_text:set_text(current_text .. play_status)
		end
	}

	s.player_stage:setup{
		player_text,
		layout = wibox.layout.constraint
	}

	-- Pread (Awesome freezes  while waiting for response)

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            mylauncher,
            s.mylayoutbox,
            s.mytaglist,
            s.mypromptbox,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
			wifi,
			battery,
            volume_widget,
            wibox.widget.systray(),
            mykeyboardlayout,
            mytextclock,
            -- /nix/store/mk22s9fgd9054v6223avrsi4q95v0c6i-awesome-4.3/share/awesome/lib/awesome-wm-widgets/volume-widget/icons/
        },
    }
end)
-- }}}

	-- {{{ Mouse bindings
root.buttons(gears.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
local keybinds = require("mappings")
local globalkeys = keybinds.globalkeys
-- Set keys
root.keys(globalkeys)

    -- The following will **NOT** trigger the keygrabbing because it isn't exported
    -- to the root (global) keys. Adding export_keybindings would solve that



-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
require("rules")
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end
	-- screen[1]

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c) : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

client.connect_signal("focus", function(c) 
	local clients = awful.screen.focused().get_clients()

	if #clients > 1 and c.maximized == false then
		c.border_color = beautiful.border_focus
	end
end)

client.connect_signal("unfocus", function(c)
	c.border_color = beautiful.border_normal
end)
client.connect_signal("request::geometry", function(c)
	c.border_color = beautiful.border_normal
	local clients = awful.screen.focused().get_clients()

	if #clients > 1 and c.maximized == false then
		c.border_color = beautiful.border_focus
	end
end)

client.connect_signal("property::fullscreen",function(c)
	local text=""
	if (c.fullscreen) then
		text="Notificações desabilitadas"
	else
		text="Notificações habilitadas"
	end
	naughty.notify({
		title="Info:",
		text=text,
		preset=naughty.config.presets.info
	})

	naughty.toggle()

end)

-- }}}

-- Dbus tests
-- {{{
	dbus.connect_signal("org.freedesktop.DBus.Properties",function(args,interface,player)
		local scr = screen[1]
		if player.Metadata then
			local data = player.Metadata
			local title = data['xesam:title']
			local artist = data['xesam:artist'][1]
			local thumbnail = data['mpris:artUrl']
			local player_text = ' ' .. artist .. ' ' .. title
			if title ~= '' then
				scr.player_stage.visible = true
			else
				scr.player_stage.visible = false
			end

			scr.player.set_text(player_text)
		end

		if player.PlaybackStatus == "Paused" then
			scr.player.set_control('  ')
		elseif player.PlaybackStatus == "Playing" then
			scr.player.set_control('  ')
		end

		-- naughty.notify({
		-- 	title=gears.debug.dump_return(player),
		-- 	timeout=0
		-- })
	end)
	dbus.add_match("session","path=/org/mpris/MediaPlayer2")

	-- Bateria via dbus
	-- connected = dbus.connect_signal("org.freedesktop.DBus.Properties",function(args,interface,power)
	-- 	naughty.notify({
	-- 		title=gears.debug.dump_return(power),
	-- 		timeout = 0
	-- 	})
	-- end)
	-- dbus.add_match("system","path=/org/freedesktop/UPower/devices/battery_BAT0")
	-- naughty.notify({
	-- 	title = gears.debug.dump_return(connected)
	-- })

-- }}}
-- vim: set foldmethod=marker:
