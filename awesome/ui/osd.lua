local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local rubato = require("modules.rubato")
local dpi = require('beautiful').xresources.apply_dpi

-- osd --

local info = wibox.widget {
	widget = wibox.container.margin,
	margins = dpi(20),
	{
		layout = wibox.layout.fixed.horizontal,
		fill_space = true,
		spacing = dpi(8),
		{
			widget = wibox.widget.imagebox,
			forced_height = dpi(25),
			forced_height = dpi(25),
			halign = "center",
			valign = "center",
			id = "icon",				

		},
		{
			widget = wibox.container.background,
			forced_width = dpi(36),
			{
				widget = wibox.widget.textbox,
				id = "text",
				halign = "center"
			},
		},
		{
			widget = wibox.widget.progressbar,
			id = "progressbar",
			max_value = dpi(100),
			forced_width = dpi(380),
			forced_height = dpi(10),
			background_color = beautiful.background_urgent,
			color = beautiful.accent,
		},
	}
}

local osd = awful.popup {
	visible = false,
	ontop = true,
	border_width = beautiful.border_width,
	border_color = beautiful.border_color_normal,
	minimum_height = dpi(60),
	maximum_height = dpi(60),
	minimum_width = dpi(290),
	maximum_width = dpi(290),
	placement = function(d)
		awful.placement.bottom(d, { margins = dpi(20) + beautiful.border_width * 2 })
	end,
	widget = info,
}

local anim = rubato.timed {
	duration = 0.3,
	easing = rubato.easing.linear,
	subscribed = function(value)
		info:get_children_by_id("progressbar")[1].value = value
	end
}

-- volume --

awesome.connect_signal("volume::get_volume", function(value, muted)
	if muted == "off" then
		info:get_children_by_id("icon")[1].image = gears.color.recolor_image(beautiful.icon_float_speaker_mute, beautiful.accent)
	elseif value > 49 then
		info:get_children_by_id("icon")[1].image = gears.color.recolor_image(beautiful.icon_float_speaker_full, beautiful.accent)
	else
		info:get_children_by_id("icon")[1].image = gears.color.recolor_image(beautiful.icon_float_speaker_low, beautiful.accent)
	end
	anim.target = value
	info:get_children_by_id("text")[1].text = value
end)

-- bright --

awesome.connect_signal("bright::get_bright", function(value)
	anim.target = value
	info:get_children_by_id("text")[1].text = value
	info:get_children_by_id("icon")[1].image = gears.color.recolor_image(beautiful.icon_float_bright, beautiful.accent)
end)

-- function --

local function osd_hide()
	osd.visible = false
	osd_timer:stop()
end

local osd_timer = gears.timer {
	timeout = 4,
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
