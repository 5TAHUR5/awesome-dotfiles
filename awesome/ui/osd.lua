local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

-- osd ----------------------------

local slider = wibox.widget {
	widget = wibox.widget.progressbar,
	max_value = 100,
	forced_width = 380,
	forced_height = 10,
	shape = gears.shape.rounded_bar,
	bar_shape = gears.shape.rounded_bar,
	background_color = beautiful.background_urgent,
	color = beautiful.accent,
}

local icon_widget = wibox.widget {
	widget = wibox.widget.textbox,
	font = beautiful.font .. " 14",
}

local text = wibox.widget {
	widget = wibox.widget.textbox,
	halign = "center"
}

local info = wibox.widget {
	layout = wibox.layout.fixed.horizontal,
	{
		widget = wibox.container.margin,
		margins = 20,
		{
			layout = wibox.layout.fixed.horizontal,
			fill_space = true,
			spacing = 8,
			icon_widget,
			{
				widget = wibox.container.background,
				forced_width = 36,
				text,
			},
			slider,
		}
	}
}


local osd = awful.popup {
	visible = false,
	ontop = true,
	border_width = beautiful.border_width,
	border_color = beautiful.border_color_normal,
	minimum_height = 60,
	maximum_height = 60,
	minimum_width = 290,
	maximum_width = 290,
	placement = function(d)
		awful.placement.bottom(d, { margins = 20 + beautiful.border_width * 2 })
	end,
	widget = info,
}

-- volume ---------------------------

awesome.connect_signal("volume::get_volume", function(value, icon)
	slider.value = value
	text.text = value
	icon_widget.text = icon
end)

-- bright ---------------------------

awesome.connect_signal("bright::value", function(value)
	slider.value = value
	text.text = value
	icon_widget.text = "  "
end)

-- function -------------------------

local function osd_hide()
	osd.visible = false
	osd_timer:stop()
end

local osd_timer = gears.timer{
	timeout = 3,
	callback = osd_hide
}

local function osd_toggle()
	if not osd.visible then
		osd.visible = true
		osd_timer:start()
	else
		osd_timer:again()
	end
end

awesome.connect_signal("summon::osd", function()
	osd_toggle()
end)
