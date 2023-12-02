local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local ruled = require("ruled")
local dpi = require('beautiful').xresources.apply_dpi


-- notifications -------------------------------------------------------------

naughty.connect_signal("request::display_error", function(message, startup)
	naughty.notification {
		urgency = "critical",
		title   = "Oops, an error happened"..(startup and " during startup!" or "!"),
		message = message,
		icon = beautiful.notification_icon_error,
	}
end)

ruled.notification.connect_signal('request::rules', function()

ruled.notification.append_rule {
	rule = { urgency = "normal" },
	properties = {
		screen = awful.screen.preferred,
		implicit_timeout = 4,
		position = "top_middle",
		spacing = dpi(4),
		bg = beautiful.background,
		fg = beautiful.foreground,
		border_width = beautiful.border_width,
		border_color = beautiful.border_color_normal,
	}
}

ruled.notification.append_rule {
	rule = { urgency = "critical" },
	properties = {
		screen = awful.screen.preferred,
		implicit_timeout = 4,
		position = "top_middle",
		spacing = dpi(4),
		bg = beautiful.background,
		fg = beautiful.foreground,
		border_width = beautiful.border_width,
		border_color = beautiful.border_color_normal,
		icon = beautiful.notification_error,
	}
}

end)

naughty.connect_signal("request::display", function(n)
	if not n.app_icon then
		n.app_icon = beautiful.notification_icon
	end

naughty.layout.box {
	notification = n,
	maximum_width = dpi(900),
	maximum_height = dpi(120),
	widget_template = {
		widget = wibox.container.constraint,
		strategy = "max",
		{
			widget = naughty.container.background,
			id = "background_role",
			{
				widget = wibox.container.margin,
				margins = {
					top = dpi(5),
					bottom = dpi(5),
					left = dpi(7),
					right = dpi(15),
				},
				{
					layout = wibox.layout.fixed.horizontal,
					spacing = dpi(10),
					fill_space = true,
					{
						widget = wibox.container.margin,
						margins = {bottom = dpi(5), top = dpi(5)},
						{
							widget = wibox.container.background,
							naughty.widget.icon,
						},
					},
					{
						layout = wibox.layout.fixed.vertical,
						spacing = dpi(2),
						naughty.widget.title,
						naughty.widget.message,
					}
				}
			}
		}
	}
}

end)
