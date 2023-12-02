local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

require("ui.theme_launcher.content_walls")
require("ui.theme_launcher.content_color_schemes")
require("ui.theme_launcher.content_settings")


local current_switch = ""

-- content table ----
local all_content = {
    ["settings"] = content_settings,
    ["walls"] = content_walls,
    ["color_schemes"] = content_color_schemes,
}

local activate_switch = function(cur_switch)
    current_switch = cur_switch
    for switch in pairs(all_content) do
        if switch == cur_switch then
            all_content[switch].visible = true
        else
            all_content[switch].visible = false
        end
    end
    awesome.emit_signal("theme_launcher::set_current_switch", current_switch)
end


local main = wibox.widget {
    widget = wibox.container.background,
	bg = beautiful.background,
    {
        layout = wibox.layout.fixed.vertical,
    }
}

for content in pairs(all_content) do
    main.widget:insert(1, all_content[content])
end


local theme_changer_widget = awful.popup {
	screen = s,
	visible = false,
	ontop = true,
	border_width = beautiful.border_width,
	border_color = beautiful.border_color_normal,
	placement = function(d)
		awful.placement.left(d,
			{honor_workarea = true}
		)
	end,
	widget = main
}





-- summon functions --

awesome.connect_signal("summon::theme_changer", function(switch)
    if current_switch == switch and theme_changer_widget.visible == true then
        theme_changer_widget.visible = false
        awesome.emit_signal("theme_launcher::set_current_switch", nil)
    else
        activate_switch(switch)
        theme_changer_widget.visible = false
        theme_changer_widget.visible = true
    end
end)

-- hide  --
awesome.connect_signal("summon::close", function()
	theme_changer_widget.visible = false
    awesome.emit_signal("theme_launcher::set_current_switch", nil)
end)

client.connect_signal("button::press", function()
	theme_changer_widget.visible = false
    awesome.emit_signal("theme_launcher::set_current_switch", nil)
end)

awful.mouse.append_global_mousebinding(
	awful.button({ }, 1, function()
		theme_changer_widget.visible = false
        awesome.emit_signal("theme_launcher::set_current_switch", nil)
	end)
)

