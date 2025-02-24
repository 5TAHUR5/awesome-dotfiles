local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local dpi = require("beautiful").xresources.apply_dpi

-- calendar ------------------------

local styles = {}

styles.month = {
	bg_color = beautiful.background,
}

styles.normal = {
	bg_color = beautiful.background,
	fg_color = beautiful.foreground,
}

styles.focus = {
	fg_color = beautiful.background,
	bg_color = beautiful.accent,
}

styles.weekday = {
	fg_color = beautiful.foreground,
}

local button_back = wibox.widget({
	widget = wibox.container.background,
	bg = beautiful.background,
	{
		widget = wibox.container.margin,
		forced_height = dpi(28),
		forced_width = dpi(28),
		{
			widget = wibox.widget.imagebox,
			image = gears.color.recolor_image(beautiful.icon_float_left, beautiful.foreground),
			valign = "center",
			halign = "center",
			resize = true
		}
	},
})

local button_next = wibox.widget({
	widget = wibox.container.background,
	bg = beautiful.background,
	{
		widget = wibox.container.margin,
		forced_height = dpi(28),
		forced_width = dpi(28),
		{
			widget = wibox.widget.imagebox,
			image = gears.color.recolor_image(beautiful.icon_float_right, beautiful.foreground),
			valign = "center",
			halign = "center",
			resize = true
		}
	},
})

local function decorate_cell(widget, flag, date)
	local cur_date = os.date("*t")
	if (cur_date.year ~= date.year or cur_date.month ~= date.month) and flag == "focus" then
		flag = "normal"
	end
	if flag == "header" then
		return wibox.widget({
			widget = wibox.container.margin,
			margins = {
				top = dpi(5)
			},
			{
				layout = wibox.layout.align.horizontal,
				button_back,
				widget,
				button_next,				
			}

		})
	end
	if flag == "monthheader" and not styles.monthheader then
		flag = "header"
	end
	if flag == "normal" or flag == "focus" then
		widget.text = tostring(tonumber(widget.text))
	end
	-- Change bg color for weekends ------------------

	local d = {
		year = date.year,
		month = (date.month or 1),
		day = (date.day or 1),
	}
	local weekday = tonumber(os.date("%w", os.time(d)))
	local default_bg = (weekday == 0 or weekday == 6) and beautiful.background_urgent or beautiful.background_alt

	local props = styles[flag] or {}

	widget.align = "center"

	local ret = wibox.widget({
		shape = props.shape,
		fg = props.fg_color,
		bg = props.bg_color or default_bg,
		widget = wibox.container.background({
			margins = {
				left = dpi(12),
				right = dpi(12),
				top = dpi(0),
				bottom = dpi(0),
			},
			widget = wibox.container.margin,
			widget,
		}),
	})

	return ret
end

local calendar = wibox.widget({
	date = os.date("*t"),
	font = beautiful.font,
	spacing = dpi(1),
	fn_embed = decorate_cell,
	widget = wibox.widget.calendar.month,
})

local function mounth_back()
	local date = calendar:get_date()
	date.month = date.month - 1
	calendar:set_date(nil)
	calendar:set_date(date)
end

local function mounth_next()
	local date = calendar:get_date()
	date.month = date.month + 1
	calendar:set_date(nil)
	calendar:set_date(date)
end

calendar:buttons({ awful.button({}, 5, mounth_next), awful.button({}, 4, mounth_back) })

button_back:buttons({ awful.button({}, 1, function()
	mounth_back()
end) })

button_next:buttons({ awful.button({}, 1, function()
	mounth_next()
end) })

-- notif center -------
local label = wibox.widget({
	text = "Notifications",
	align = "center",
	widget = wibox.widget.textbox,
})

local notifs_clear = wibox.widget({
	image = gears.color.recolor_image(beautiful.icon_float_trash, beautiful.accent),
	valign = "center",
	halign = "center",
	forced_height = dpi(20),
	forced_width = dpi(20),
	widget = wibox.widget.imagebox,
})

notifs_clear:buttons(gears.table.join(awful.button({}, 1, function()
	_G.notif_center_reset_notifs_container()
end)))

local notifs_empty = wibox.widget({
	forced_height = dpi(300),
	widget = wibox.container.background,
	{
		layout = wibox.layout.flex.vertical,
		{
			markup = "<span foreground='" .. beautiful.background_urgent .. "'>No notifications</span>",
			font = beautiful.font,
			align = "center",
			valign = "center",
			widget = wibox.widget.textbox,
		},
	},
})

local notifs_container = wibox.widget({
	layout = wibox.layout.fixed.vertical,
	spacing = dpi(5),
	spacing_widget = {
		top = dpi(2),
		bottom = dpi(2),
		left = dpi(6),
		right = dpi(6),
		widget = wibox.container.margin,
		{
			widget = wibox.container.background,
		},
	},
})

local remove_notifs_empty = true

notif_center_reset_notifs_container = function()
	notifs_container:reset(notifs_container)
	notifs_container:insert(1, notifs_empty)
	remove_notifs_empty = true
end

notif_center_remove_notif = function(box)
	notifs_container:remove_widgets(box)

	if #notifs_container.children == 0 then
		notifs_container:insert(1, notifs_empty)
		remove_notifs_empty = true
	end
end

local create_notif = function(icon, n, width)
	local time = os.date("%H:%M:%S")

	local icon_widget = wibox.widget({
		widget = wibox.container.constraint,
		{
			widget = wibox.container.margin,
			margins = dpi(10),
			{
				widget = wibox.widget.imagebox,
				image = icon,
				forced_width = dpi(56),
				forced_height = dpi(56),
				halign = "center",
				valign = "center",
			},
		},
	})

	local title_widget = wibox.widget({
		widget = wibox.container.scroll.horizontal,
		step_function = wibox.container.scroll.step_functions.waiting_nonlinear_back_and_forth,
		speed = dpi(50),
		forced_width = dpi(200),
		{
			widget = wibox.widget.textbox,
			text = n.title,

			align = "left",
			forced_width = dpi(200),
		},
	})

	local time_widget = wibox.widget({
		widget = wibox.container.background,
		bg = beautiful.accent,
		fg = beautiful.background,
		{
			widget = wibox.container.margin,
			margins = {
				left = dpi(4),
				right = dpi(4),
				top = dpi(2),
				bottom = dpi(2),
			},
			{
				widget = wibox.widget.textbox,
				text = time,
				font = beautiful.font .. " 9",
				align = "right",
				valign = "bottom",
			},
		},
	})

	local text_notif = wibox.widget({
		markup = n.message,
		font = beautiful.font .. " 10",
		align = "left",
		forced_width = dpi(165),
		widget = wibox.widget.textbox,
	})

	local box = wibox.widget({
		widget = wibox.container.background,
		forced_height = dpi(76),
		bg = beautiful.background_alt,
		{
			layout = wibox.layout.align.horizontal,
			icon_widget,
			{
				widget = wibox.container.margin,
				margins = dpi(4),
				{
					layout = wibox.layout.align.vertical,
					expand = "none",
					{
						layout = wibox.layout.fixed.vertical,
						spacing = dpi(3),
						{
							layout = wibox.layout.align.horizontal,
							expand = "none",
							title_widget,
							nil,
							time_widget,
						},
						text_notif,
					},
				},
			},
		},
	})

	box:buttons(gears.table.join(awful.button({}, 1, function()
		_G.notif_center_remove_notif(box)
	end)))

	return box
end

notifs_container:buttons(gears.table.join(
	awful.button({}, 4, nil, function()
		if #notifs_container.children == 1 then
			return
		end
		notifs_container:insert(1, notifs_container.children[#notifs_container.children])
		notifs_container:remove(#notifs_container.children)
	end),
	awful.button({}, 5, nil, function()
		if #notifs_container.children == 1 then
			return
		end
		notifs_container:insert(#notifs_container.children + 1, notifs_container.children[1])
		notifs_container:remove(1)
	end)
))

notifs_container:insert(1, notifs_empty)

naughty.connect_signal("request::display", function(n)
	if #notifs_container.children == 1 and remove_notifs_empty then
		notifs_container:reset(notifs_container)
		remove_notifs_empty = false
	end

	local appicon = n.icon or n.app_icon
	if not appicon then
		appicon = beautiful.notification_icon
	end

	notifs_container:insert(1, create_notif(appicon, n, width))
end)

local notifs = wibox.widget({
	spacing = 5,
	layout = wibox.layout.fixed.vertical,
	{
		widget = wibox.container.margin,
		margins = 0,
		{
			layout = wibox.layout.align.horizontal,
			label,
			nil,
			notifs_clear,
		},
	},
	notifs_container,
})

-- main windows ----

local main_notif = wibox.widget({
	widget = wibox.container.background,
	bg = beautiful.background,
	forced_width = dpi(400),
	{
		widget = wibox.container.margin,
		margins = dpi(7),
		{
			layout = wibox.layout.fixed.vertical,
			fill_space = true,
			spacing = dpi(10),
			notifs,
		},
	},
})

local main_calendar = wibox.widget({
	widget = wibox.container.background,
	bg = beautiful.background,
	forced_height = dpi(365),
	border_width = beautiful.border_width,
	border_color = beautiful.accent,
	{
		widget = wibox.container.margin,
		margins = dpi(1),
		{
			layout = wibox.layout.fixed.vertical,
			fill_space = true,
			spacing = 0,
			calendar,
		},
	},
})

-- main window -----------------------

local main = wibox.widget({
	layout = wibox.layout.fixed.horizontal,
	main_notif,
	main_calendar,
})

local calendar_widget = awful.popup({
	visible = false,
	ontop = true,
	border_width = beautiful.border_width,
	border_color = beautiful.border_color_normal,
	minimum_height = dpi(440),
	maximum_height = dpi(440),
	minimum_width = dpi(310),
	placement = function(d)
		awful.placement.top(d, {
			honor_workarea = true,
			margins = {
				top = 0,
			},
		})
	end,
	widget = main,
})

-- summon functions --

awesome.connect_signal("summon::calendar_widget", function()
	calendar:set_date(os.date("*t"))
	calendar_widget.visible = not calendar_widget.visible
end)

-- hide  --

awesome.connect_signal("summon::close", function()
	calendar_widget.visible = false
end)

client.connect_signal("button::press", function()
	calendar_widget.visible = false
end)

awful.mouse.append_global_mousebinding(awful.button({}, 1, function()
	calendar_widget.visible = false
end))
