local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")


local spawm_x = 10

local dnd_button = wibox.widget {
    widget = wibox.container.place,
    haligh = "center",
    valign = "center",
    forced_height = 30,
    forced_width = 30,
    
    {
        widget = wibox.widget.textbox,
        aligh = "center",
        font = "13",
        text = " ",
    },
    
  }

local dnd = true

awesome.connect_signal("signal::dnd", function()
    dnd = not dnd
    if not dnd then
        dnd_button.widget.text = " "
        naughty.suspend()
    else
        dnd_button.widget.text = " "
        naughty.resume()
    end
  end)

dnd_button:buttons {
  awful.button({}, 1, function()
    dnd = not dnd
    if not dnd then
      dnd_button.widget.text = " "
      naughty.suspend()
   else
      dnd_button.widget.text = " "
      naughty.resume()
    end
  end),
}



local main = wibox.widget {
    widget = wibox.container.background,
	bg = beautiful.background_alt,
	
    {
        widget = wibox.container.place,
        halign = "center",
        {
            widget = wibox.container.margin,
            margins = { top = 4, bottom = 8 },
            id = "tray",
            visible = true,
            {
                layout = wibox.layout.fixed.vertical,
                {
                    widget = dnd_button,
                },
                {
                    widget = wibox.widget.systray,
                    horizontal = false,
                    base_size = 30,
                }
            }
            
        }
    }
	
}

local systray_popup = awful.popup {
    visible = false,
	ontop = true,
	border_width = beautiful.border_width,
	border_color = beautiful.border_color_normal,
	minimum_height = 30 + beautiful.border_width * 2,
	maximum_height = 300,
	minimum_width = 30 + beautiful.border_width * 2,
	maximum_width = 30 + beautiful.border_width * 2,
    placement = function(d)
		awful.placement.top_right(d, {honor_workarea = true, margins = {top = -4,right = (spawm_x - beautiful.border_width)}})
	end,
	widget = main
}

awesome.connect_signal("summon::systray", function(value)
    if value ~= nil then
        systray_popup.visible = value
    else 
        systray_popup.visible = not systray_popup.visible
    end
end)

client.connect_signal("button::press", function()
	awesome.emit_signal("summon::systray", false)
end)

awful.mouse.append_global_mousebinding(
	awful.button({ }, 1, function()
		awesome.emit_signal("summon::systray", false)
	end)
)
