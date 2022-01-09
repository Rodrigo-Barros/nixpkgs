local awful = require("awful")
local beautiful = require("beautiful")
local keybinds = require("mappings")
local clientkeys = keybinds.clientkeys
local clientbuttons = keybinds.clientbuttons
local settings = require("settings")
local tags = settings.tags

awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
          "pinentry",
        },
        class = {
          "Arandr",
          "Blueman-manager",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
          "Wpa_gui",
          "veromix",
          "xtightvncviewer"},

        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "ConfigManager",  -- Thunderbird's about:config.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},

    -- Add titlebars to normal clients and dialogs
    { rule_any = {
        type = { "normal", "dialog","Dialog",
        },
      }, properties = { titlebars_enabled = false, placement = awful.placement.centered }
    },
	{
		rule_any = {
			class = {
				"Firefox",
			}
		}, properties = { maximized=true, tag=tags[2], switch_to_tags=true }
	},
    -- Centered windows
    {
        rule_any ={
            role = { "MigrationWizard", "Organizer", "Dialog", "About" }
        }, properties = { floating=true, placement = awful.placement.centered,  maximized = false }
    },
	{
		rule_any = {
			class = {
				"Element",
                "discord",
                "TelegramDesktop"
			}
		}, properties = { maximized=true, tag=tags[4] }
	},
	{
		rule_any = {
			class = {
				"kitty",
			}
		}, properties = { tag=tags[3], switch_to_tags=true }
	},
	{
		rule_any = {
			class = {
				"Steam"
			},
            name = {
                "Steam"
            },
		}, properties = { tag=tags[6]}
	},
	{
		rule_any = {
			class = {
				"conky"
			},
		}, properties = { border_width = 0 }
	},
	{
		rule_any = {
			class = {
				"Org.gnome.Nautilus"
			}
		}, properties = { tag=tags[7] }
	}

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },
}
