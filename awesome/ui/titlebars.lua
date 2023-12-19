local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = require('beautiful').xresources.apply_dpi

-- titlebars --

client.connect_signal("request::titlebars", function(c)

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

	local left_titlebar = awful.titlebar(c, {
		size = dpi(30),
		position = "left"
	})
	left_titlebar.widget =  {
		layout = wibox.layout.align.vertical,
		{
			widget = wibox.container.place,
			valign = "top",
			{
				widget = wibox.container.margin,
				margins = {right = dpi(4), left = dpi(4), top = dpi(8)},
				{
					layout = wibox.layout.fixed.vertical,
					spacing = dpi(6),
					awful.titlebar.widget.closebutton(c),
					awful.titlebar.widget.maximizedbutton(c),
					awful.titlebar.widget.minimizebutton(c),
					awful.titlebar.widget.ontopbutton(c),
					awful.titlebar.widget.floatingbutton(c),
					awful.titlebar.widget.stickybutton(c),
				}
			}
		},
		{
			widget = wibox.container.background,
			buttons = buttons,
		},
		{
			widget = wibox.container.background,
			buttons = buttons
		}
	}


	local right_titlebar = awful.titlebar(c, {
		size = dpi(30),
		position = "right"
	})
	right_titlebar.widget =  {
		layout = wibox.layout.align.vertical,
		{
			widget = wibox.container.background,
			buttons = buttons,
		},
		{
			widget = wibox.container.background,
			buttons = buttons
		},
		{
			widget = wibox.container.place,
			valign = "bottom",
			{
				widget = wibox.container.margin,
				margins = {right = dpi(4), left = dpi(4), bottom = dpi(8)},
				{
					layout = wibox.layout.fixed.vertical,
					spacing = dpi(6),
					awful.titlebar.widget.stickybutton(c),
					awful.titlebar.widget.floatingbutton(c),
					awful.titlebar.widget.ontopbutton(c),
					awful.titlebar.widget.minimizebutton(c),
					awful.titlebar.widget.maximizedbutton(c),
					awful.titlebar.widget.closebutton(c),
				}
			}
		},
	}


	local top_titlebar = awful.titlebar(c, {
		size = dpi(30),
		position = "top"
	})
	top_titlebar.widget =  {
		layout = wibox.layout.align.horizontal,
		{
			widget = wibox.container.background,
			forced_width = dpi(108),
			buttons = buttons
		},
		{
			halign = "center",
			widget = awful.titlebar.widget.titlewidget(c)
		},
		{
			widget = wibox.container.place,
			valign = "right",
			{
				widget = wibox.container.margin,
				margins = {top = dpi(4), bottom = dpi(4), right = dpi(8)},
				{
					layout = wibox.layout.fixed.horizontal,
					spacing = dpi(6),
					awful.titlebar.widget.stickybutton(c),
					awful.titlebar.widget.floatingbutton(c),
					awful.titlebar.widget.ontopbutton(c),
					awful.titlebar.widget.minimizebutton(c),
					awful.titlebar.widget.maximizedbutton(c),
					awful.titlebar.widget.closebutton(c),
				}
			}
		}
	}

	local bottom_titlebar = awful.titlebar(c, {
		size = dpi(30),
		position = "bottom"
	})
	bottom_titlebar.widget =  {
		layout = wibox.layout.align.horizontal,
		{
			widget = wibox.container.place,
			valign = "right",
			{
				widget = wibox.container.margin,
				margins = {top = dpi(4), bottom = dpi(4), left = dpi(8)},
				{
					layout = wibox.layout.fixed.horizontal,
					spacing = dpi(6),
					awful.titlebar.widget.closebutton(c),
					awful.titlebar.widget.maximizedbutton(c),
					awful.titlebar.widget.minimizebutton(c),
					awful.titlebar.widget.ontopbutton(c),
					awful.titlebar.widget.floatingbutton(c),
					awful.titlebar.widget.stickybutton(c),
				}
			}
		},
		{
			halign = "center",
			widget = awful.titlebar.widget.titlewidget(c)
		},
		{
			widget = wibox.container.background,
			forced_width = dpi(108),
			buttons = buttons,
		},
	}
end)


