local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

-- titlebars --

client.connect_signal("request::titlebars", function(c)

local titlebar = awful.titlebar(c, {
	position = "top",
	size = 36,
})

local buttons = gears.table.join(
	awful.button({ }, 1, function()
		client.focus = c
		c:raise()
		awful.mouse.client.move(c)
	end),
	awful.button({ }, 3, function()
		client.focus = c
		c:raise()
		awful.mouse.client.resize(c)
	end)
)

titlebar.widget = {
	layout = wibox.layout.flex.horizontal,
	{
		widget = wibox.container.background,
		buttons = buttons,
		{
			widget = wibox.container.margin,
			left = 10,
			{
				widget = wibox.container.constraint,
				width = 100,
				{
					halign = "left",
         	   widget = awful.titlebar.widget.titlewidget(c)
				},
			},
		},
	},
	{
		widget = wibox.container.place,
		halign = "right",
		{
			widget = wibox.container.margin,
			margins = {right = 10, top = 8, bottom = 8},
			{
				layout = wibox.layout.fixed.horizontal,
				spacing = 8,
				awful.titlebar.widget.maximizedbutton(c),
				awful.titlebar.widget.minimizebutton(c),
				awful.titlebar.widget.closebutton(c)
			}
		}
	}
}

end)
