local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = require('beautiful').xresources.apply_dpi

-- titlebars --

local set_icon_for_btn = function(btn, value, icon_set_to_on, icon_set_to_off)
	if value == false then 
		btn.widget.text = icon_set_to_on
	else
		btn.widget.text = icon_set_to_off
	end
end


local create_button = function(color, name, icon)
	local widget =  wibox.widget {
		widget = wibox.container.background,
		forced_width = dpi(22),
		forced_height = dpi(22),
		bg = color,
		fg = beautiful.background_accent,
		-- buttons = {
		-- 	awful.button({}, 1, function()
		-- 		func()
		-- 	end)
		-- },
		{
			widget = wibox.widget.textbox,
			text = icon,
			font = beautiful.font .. " 13",
			halign = "center",
    		valign = "center",
		}
	}
	local popup = awful.tooltip {
		objects = { widget },
		timer_function = function()
			return name
		end,
		gaps = beautiful.useless_gap,
		margins_leftright = dpi(10),
		margins_topbottom = dpi(10),
		delay_show = 1.5
	}
	return widget
end

client.connect_signal("request::titlebars", function(c)
	local minimize = create_button(beautiful.yellow, "Minimize", "—")
	minimize:buttons {
		awful.button({}, 1, function()
			gears.timer.delayed_call(function()
					c.minimized = not c.minimized
				end)
		end)
	}

	local maximize = create_button(beautiful.green, "Maximize", " 󰊓 ")
	set_icon_for_btn(maximize, c.maximized, " 󰊓 ", " 󰊔 ")
	maximize:buttons {
		awful.button({}, 1, function()
			c.maximized = not c.maximized
			set_icon_for_btn(maximize, c.maximized, " 󰊓 ", " 󰊔 ")
		end)
	}

	local ontop = create_button(beautiful.violet, "OnTop", "󰸇")
	set_icon_for_btn(ontop, c.ontop, "󰸇", "󰇭 ")
	ontop:buttons {
		awful.button({}, 1, function()
			c.ontop = not c.ontop
			set_icon_for_btn(ontop, c.ontop, "󰸇", "󰇭 ")
		end)
	}

	local sticky = create_button(beautiful.blue, "Sticky", "󰤱")
	set_icon_for_btn(sticky, c.sticky, "󰤱", "󰤰 ")

	sticky:buttons {
		awful.button({}, 1, function()
			c.sticky = not c.sticky
			set_icon_for_btn(sticky, c.sticky, "󰤱", "󰤰 ")
		end)
	}

	local floating = create_button(beautiful.orange, "FloatingOn", "󰪏 ")
	set_icon_for_btn(floating, c.floating, "󰪏 ", " ")
	floating:buttons {
		awful.button({}, 1, function()
			c.floating = not c.floating
			set_icon_for_btn(floating, c.floating, "󰪏 ", " ")
		end)
	}

	
	local close = create_button(beautiful.red, "Kill", "󰖭")
	close:buttons {
		awful.button({ }, 1, function()
			c:kill()
		end)
	}


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
					close,
					maximize,
					minimize,
					ontop,
					floating,
					sticky
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
					sticky,
					floating,
					ontop,
					minimize,
					maximize,
					close,
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
					sticky,
					floating,
					ontop,
					minimize,
					maximize,
					close,
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
					close,
					maximize,
					minimize,
					ontop,
					floating,
					sticky
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


