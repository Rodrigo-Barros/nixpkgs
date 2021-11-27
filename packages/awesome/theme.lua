local beautiful = require("beautiful")
local gears = require("gears")

beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")

-- set wallpapper
beautiful.wallpaper = function()
	return os.getenv("HOME") .. "/Imagens/Wallpapers/breno-machado-in9-n0JwgZ0-unsplash.jpg"
end

-- 
local rounded = function (radius)
	return function(cr ,width, height)
		gears.shape.rounded_rect(cr, width, height, radius)
	end
end

beautiful.border_width = 2
beautiful.border_focus = "#ffffff00"
beautiful.notification_shape = rounded(10)
beautiful.notification_max_width = 300
 beautiful.notification_icon_size = 200
