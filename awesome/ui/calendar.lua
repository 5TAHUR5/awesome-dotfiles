local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local naughty = require("naughty")
local beautiful = require("beautiful")

-- calendar ------------------------

local styles = {}

styles.month = {
	bg_color = beautiful.background,
}

styles.normal = {
	bg_color = beautiful.background,
	fg_color = beautiful.foreground,
}

styles.focus   = {
	fg_color = beautiful.background,
	bg_color = beautiful.accent,
	shape = gears.shape.circle,
}

styles.weekday = {
	fg_color = beautiful.foreground,
}

local button_back = wibox.widget {
	widget = wibox.container.background,
	bg = beautiful.background_alt,
	{
		widget = wibox.widget.textbox,
		text = "🢀",
		font = beautiful.font .. " 20",
	}
}

local button_next = wibox.widget {
widget = wibox.container.background,
	bg = beautiful.background_alt,
	{
		widget = wibox.widget.textbox,
		text = "🢂",
		font = beautiful.font .. " 20",
		
	}
}

local function decorate_cell(widget, flag, date)
	local cur_date = os.date("*t")
	if (cur_date.year ~= date.year or cur_date.month ~= date.month) and flag == "focus" then
		flag = "normal"
	end
	if flag == "header" then
		return wibox.widget{layout=wibox.layout.align.horizontal, button_back, widget, button_next}
	end
	if flag == "monthheader" and not styles.monthheader then
		flag = "header"
	end
	if flag == "normal" or flag == "focus" then
		widget.align="center"
		widget.text=tostring(tonumber(widget.text))
	end
	-- Change bg color for weekends ------------------

local d = {year=date.year, month=(date.month or 1), day=(date.day or 1)}
local weekday = tonumber(os.date("%w", os.time(d)))
local default_bg = (weekday==0 or weekday==6) and beautiful.background_urgent or beautiful.background_alt

local props = styles[flag] or {}

local ret = wibox.widget {
	shape = props.shape,
	fg = props.fg_color,
	bg = props.bg_color or default_bg,
	widget = wibox.container.background
	{
		margins = {left = 6, right = 6, top = 4, bottom = 4},
		widget  = wibox.container.margin,
		widget,
	},
}

return ret
end

local calendar = wibox.widget {
   date = os.date("*t"),
	font = beautiful.font,
	spacing = 10,
   fn_embed = decorate_cell,
   widget = wibox.widget.calendar.month
}

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

calendar:buttons {
	awful.button({}, 4, mounth_next),
	awful.button({}, 5, mounth_back)
}

button_back:buttons {
	awful.button({}, 1, function()
		mounth_back()
	end),

}

button_next:buttons {
	awful.button({}, 1, function()
		mounth_next()
	end),
}

-- main window -----------------------

local main = wibox.widget {
	widget = wibox.container.place,
	valign = "center",
	halign = "center",
	{
		widget = wibox.container.background,
		bg = beautiful.background,
		{
			widget = wibox.container.margin,
			margins = {top = 20, bottom = 10, right = 13, left = 10},
			{
				layout = wibox.layout.fixed.vertical,
				fill_space = true,
				spacing = 10,
				calendar,
			}
		}
	}
	
}

local calendar_style = function()
	return function(cr)
		gears.shape.infobubble(cr, 310, 400, 0, 15, nil)
	end
end

local calendar_widget = awful.popup {
	visible = false,
	ontop = true,
	border_width = beautiful.border_width,
	border_color = beautiful.border_color_normal,
	minimum_height = 330,
	maximum_height = 420,
	minimum_width = 310,
	maximum_width = 310,
	shape = calendar_style(),
	placement = function(d)
		awful.placement.top(d, {honor_workarea = true, margins = {top = 0}})
	end,
	widget = main
}

-- summon functions --

awesome.connect_signal("summon::calendar_widget", function()
	calendar:set_date(os.date("*t"))
	calendar_widget.visible = not calendar_widget.visible
end)

-- hide on click --

client.connect_signal("button::press", function()
	calendar_widget.visible = false
end)

awful.mouse.append_global_mousebinding(
	awful.button({ }, 1, function()
		calendar_widget.visible = false
	end)
)
