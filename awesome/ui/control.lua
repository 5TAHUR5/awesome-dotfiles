local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
--local bling = require("modules.bling")
--local playerctl = bling.signal.playerctl.lib()
require("scripts.init")


local start_scripts = function()
	awesome.emit_signal("control::start_scripts")
end

local stop_scripts = function()
	awesome.emit_signal("control::stop_scripts")
end

screen.connect_signal("request::desktop_decoration", function(s)

local rounded_rect = function (radius)
	return function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, radius)
	end
end

-- arccharts ------------------------------------

local create_arcchart_widget = function(widget, signal, bg, fg, thickness, text, icon)

local widget = wibox.widget {
	widget = wibox.container.background,
	bg = beautiful.background_alt,
	forced_width = 152,
	forced_height = 180,
	{
		widget = wibox.container.margin,
		margins = 10,
		{
			layout = wibox.layout.fixed.vertical,
			spacing = 10,
			{
				layout = wibox.layout.stack,
				{
					widget = wibox.container.arcchart,
					id = "progressbar",
					max_value = 100,
					min_value = 0,
					thickness = thickness,
					rounded_edge = true,
					bg = bg,
					colors = {fg}
				},
				{
					widget = wibox.widget.textbox,
					id = "icon",
					font = beautiful.font .." 20",
					text = icon,
					halign = "center",
					valign = "center",
				},
			},
			{
				layout = wibox.layout.flex.horizontal,
				{
					widget = wibox.widget.textbox,
					text = text
				},
				{
					widget = wibox.container.place,
					halign = "right",
					{
						widget = wibox.widget.textbox,
						id = "text"
					}
				}
			}
		}
	}
}

awesome.connect_signal(signal, function (value)
	widget:get_children_by_id('progressbar')[1].value = value
	widget:get_children_by_id('text')[1].text = value.. "%"
end)

return widget
end

local resourses = wibox.widget {
	layout = wibox.layout.fixed.horizontal,
	spacing = 10,
	create_arcchart_widget(cpu, "signal::cpu", beautiful.background_urgent, beautiful.red, 15, "CPU:", ""),
	create_arcchart_widget(ram, "signal::ram", beautiful.background_urgent, beautiful.yellow, 15, "RAM:", ""),
	create_arcchart_widget(disk, "disk::value", beautiful.background_urgent, beautiful.blue, 15, "DISK:", ""),
}

-- progressbars ---------------------------------

local create_progressbar_widget = function(color, width, icon)
return wibox.widget {
	widget = wibox.container.background,
	bg = beautiful.background_alt,
	forced_height = 20,
		{
		layout = wibox.layout.fixed.horizontal,
		fill_space = true,
		spacing = 10,
		{
			widget = wibox.widget.textbox,
			id = "icon",
			text = icon,
			font = beautiful.font .. " 13",
			halign = "center",
		},
		{
			widget = wibox.container.background,
			forced_width = 36,
			{
				widget = wibox.widget.textbox,
				id = "text",
				halign = "center",
			}
		},
		{
			widget = wibox.widget.progressbar,
			id = "progressbar",
			max_value = 100,
			forced_width = width,
			shape = gears.shape.rounded_bar,
			bar_shape = gears.shape.rounded_bar,
			background_color = beautiful.background_urgent,
			color = color,
		}
	}
}

end

local volume = create_progressbar_widget(beautiful.orange, 370, "")

volume:buttons  {
	awful.button({}, 1, function()
		awesome.emit_signal("volume::set_volume", "toggle")
		updateVolumeSignals()
	end),
	awful.button({}, 4, function()
		awesome.emit_signal("volume::set_volume", "2%+")
     	updateVolumeSignals()
	end),
	awful.button({}, 5, function()
		awesome.emit_signal("volume::set_volume", "2%-")
		updateVolumeSignals()
	end),
}

awesome.connect_signal("volume::get_volume", function(value, icon)
	volume:get_children_by_id('progressbar')[1].value = value
	volume:get_children_by_id('text')[1].text = value
	volume:get_children_by_id('icon')[1].text = icon
end)

local bright = create_progressbar_widget(beautiful.violet, 370, "󰃠  ")

bright:buttons  {
	awful.button({}, 4, function()
		awful.spawn.with_shell("brightnessctl s 5%+")
		update_value_of_bright()
	end),
	awful.button({}, 5, function()
		awful.spawn.with_shell("brightnessctl s 5%-")
  		update_value_of_bright()
	end),
}

awesome.connect_signal("bright::value", function(value, icon)
	bright:get_children_by_id('progressbar')[1].value = value
	bright:get_children_by_id('text')[1].text = value
end)

local info = wibox.widget {
	widget = wibox.container.background,
	bg = beautiful.background_alt,
	forced_height = 80,
	{
		widget = wibox.container.margin,
		margins = 10,
		{
			layout = wibox.layout.fixed.vertical,
			spacing = 20,
			volume,
			bright,
		}
	}
}

-- profile --------------------------------

local create_fetch_comp = function(icon, text)
	return wibox.widget {
		layout = wibox.layout.flex.horizontal,
		{
			widget = wibox.widget.textbox,
			text = icon,
		},
		{
			widget = wibox.widget.textbox,
			text = text,
			halign = "right"
		}
	}
end

local fetch = wibox.widget {
	layout = wibox.layout.flex.vertical,
	forced_width = 322,
	spacing = 10,
	create_fetch_comp("", io.popen([[distro | grep "Name:" | awk '{sub(/^Name: /, ""); print}' | awk '{print $1 " " $2}']]):read("*all")),
	create_fetch_comp("", io.popen([[uname -r]]):read("*all")),
	create_fetch_comp("", io.popen([[xbps-query -l | wc -l]]):read("*all")),
	create_fetch_comp("", "Awesome WM"),
}

local profile_image = wibox.widget {
	widget = wibox.widget.imagebox,
	clip_shape = gears.shape.circle,
	forced_width = 90,
	forced_height = 90,
	image = beautiful.profile_image,
}

local profile_name = wibox.widget {
	widget = wibox.widget.textbox,
	text = "@".. io.popen([[whoami | sed 's/.*/\u&/']]):read("*all")
}

local line = wibox.widget {
	widget = wibox.container.background,
	bg = beautiful.green,
	forced_width = beautiful.border_width * 2,
}

local profile = wibox.widget {
	widget = wibox.container.background,
	bg = beautiful.background_alt,
	forced_height = 140,
	{
		widget = wibox.container.margin,
		margins = 10,
		{
			layout = wibox.layout.fixed.horizontal,
			spacing = 20,
			{
				layout = wibox.layout.fixed.vertical,
				spacing = 10,
				profile_image,
				profile_name,
			},
			fetch,
			line,
		}
	},
}

local create_point = function(color)
	return wibox.widget {
		widget = wibox.container.background,
		bg = color,
		forced_width = 8,
		forced_height = 8,
	}
end

local time = wibox.widget {
	widget = wibox.container.place,
	halign = "center",
	{
		layout = wibox.layout.fixed.horizontal,
		spacing = 20,
		{
			widget = wibox.widget.textclock,
			font = beautiful.font.. " 30",
			format = "%H",
		},
		{
			widget = wibox.container.margin,
			top = 16,
			{
				layout = wibox.layout.fixed.vertical,
				spacing = 8,
				create_point(beautiful.green),
				create_point(beautiful.yellow),
				create_point(beautiful.red),
			},
		},
		{
			widget = wibox.widget.textclock,
			font = beautiful.font.. " 30",
			format = "%M",
		}
	}
}

-- toggles -----------------------------------

local create_toggle_widget = function(bg, fg, icon, name, value)
	return wibox.widget {
	widget = wibox.container.background,
	forced_width = 233,
	forced_height = 80,
	bg = beautiful.background_alt,
	{
		layout = wibox.layout.fixed.horizontal,
		spacing = 20,
		{
			widget = wibox.container.margin,
			left = 10,
			{
				widget = wibox.container.place,
				align = "center",
				{
					widget = wibox.container.background,
					id = "icon_container",
					bg = bg,
					fg = fg,
					shape = gears.shape.circle,
					{
						widget = wibox.container.margin,
						margins = 10,
						{
							widget = wibox.widget.textbox,
							id = "icon",
							text = icon,
							font = beautiful.font.. " 20",
							halign = "center"
						}
					}
				}
			}
		},
		{
			widget = wibox.container.place,
			halign = "center",
			{
				layout = wibox.layout.fixed.vertical,
				{
					widget = wibox.widget.textbox,
					text = name
				},
				{
					widget = wibox.widget.textbox,
					id = "value",
					text = value
				},
			}
		}
	}
}
end

local toggle_change = function(x, widget, icon)
	if x == "off" then
		widget:get_children_by_id('value')[1].text = "Off"
		widget:get_children_by_id('icon')[1].text = icon
		widget:get_children_by_id('icon_container')[1]:set_bg(beautiful.background_urgent)
		widget:get_children_by_id('icon_container')[1]:set_fg(beautiful.foreground)
		widget:get_children_by_id('icon_container')[1]:set_shape(rounded_rect(10))
	else
		widget:get_children_by_id('value')[1].text = "On"
		widget:get_children_by_id('icon')[1].text = icon
		widget:get_children_by_id('icon_container')[1]:set_bg(beautiful.accent)
		widget:get_children_by_id('icon_container')[1]:set_fg(beautiful.background)
		widget:get_children_by_id('icon_container')[1]:set_shape(gears.shape.circle)
	end
end

local wifi = create_toggle_widget(beautiful.accent, beautiful.background_urgent, "", "Wifi", "On")
local wifi_default = true

wifi:buttons {
	awful.button({}, 1, function()
		wifi_default = not wifi_default
		if not wifi_default then
			toggle_change("off", wifi, "")
			awful.spawn.with_shell("nmcli radio wifi off")
		else
			toggle_change("on", wifi, "")
			awful.spawn.with_shell("nmcli radio wifi on")
		end
	end),
}

local micro = create_toggle_widget(beautiful.accent, beautiful.background_urgent, "", "Microphone", "On")

awesome.connect_signal("capture_muted::value", function(value)
	if value == "off" then
		toggle_change("off", micro, "")
	else
		toggle_change("on", micro, "")
	end
end)

micro:buttons {
	awful.button({}, 1, function()
		awful.spawn.with_shell("amixer -D pipewire sset Capture toggle")
		updateVolumeSignals()
	end),
}

local float = create_toggle_widget(beautiful.background_urgent, beautiful.foreground, "", "Floating", "Off")
float:get_children_by_id('icon_container')[1]:set_shape(rounded_rect(10))

local float_value_default = false

float:buttons {
	awful.button({}, 1, function()
		float_value_default = not float_value_default
		local tags = awful.screen.focused().tags
		if not float_value_default then
			toggle_change("off", float, "")
			for _, tag in ipairs(tags) do
				awful.layout.set(awful.layout.suit.tile.left, tag)
			end
		else
			toggle_change("on", float, "")
			for _, tag in ipairs(tags) do
				awful.layout.set(awful.layout.suit.floating, tag)
			end
		end
	end),
}

local opacity = create_toggle_widget(beautiful.accent, beautiful.background_urgent, "", "Opacity", "On")

local opacity_value_default = true

opacity:buttons {
	awful.button({}, 1, function()
		opacity_value_default = not opacity_value_default
		if not opacity_value_default then
			toggle_change("off", opacity, "")
			awful.spawn.with_shell("$HOME/.config/awesome/other/picom/launch.sh --no-opacity")
		else
			toggle_change("on", opacity, "")
			awful.spawn.with_shell("$HOME/.config/awesome/other/picom/launch.sh --opacity")
		end
	end),
}


local toggles = wibox.widget {
	layout = wibox.layout.grid,
	spacing = 10,
	forced_num_cols = 2,
	wifi,
	micro,
	float,
	opacity,
}

-- music player ---------------------------

-- local art = wibox.widget {
-- 	image = "default_image.png",
-- 	clip_shape = gears.shape.circle,
-- 	valign = "center",
-- 	forced_height = 160,
-- 	forced_width = 220,
-- 	widget = wibox.widget.imagebox
-- }

-- local title_widget = wibox.widget {
--     markup = "Nothing Playing",
--     align = "left",
--     widget = wibox.widget.textbox
-- }

-- local artist_widget = wibox.widget {
--     align = "left",
--     widget = wibox.widget.textbox
-- }

-- local create_music_button = function(text)
-- 	return wibox.widget {
-- 		widget = wibox.container.background,
-- 		bg = beautiful.background_urgent,
-- 		shape = rounded_rect(10),
-- 		{
-- 			widget = wibox.container.margin,
-- 			margins = 5,
-- 			{
-- 				widget = wibox.widget.textbox,
-- 				text = text,
-- 				font = beautiful.font.. " 16",
-- 			}
-- 		}
-- 	}
-- end

-- local next = create_music_button("")
-- next:buttons {
-- 	awful.button({}, 1, function()
-- 		playerctl:next()
-- 	end)
-- }

-- local prev = create_music_button("")
-- prev:buttons {
-- 	awful.button({}, 1, function()
-- 		playerctl:previous()
-- 	end)
-- }

-- local music_button = create_music_button("")
-- music_button:buttons {
-- 	awful.button({}, 1, function()
-- 		playerctl:play_pause()
-- 	end)
-- }



-- local position = wibox.widget {
--   forced_height      = 4,
--   color              = beautiful.accent,
--   background_color   = beautiful.foreground,
--   forced_width       = 50,
--   widget             = wibox.widget.progressbar,
-- }

-- local music = wibox.widget {
-- 	layout = wibox.container.background,
-- 	bg = beautiful.background_alt,
-- 	{
-- 		layout = wibox.layout.flex.horizontal,
-- 		spacing = 10,
-- 		{
-- 			widget = wibox.container.margin,
-- 			margins = {left = 10, top = 10},
-- 			{
-- 				layout = wibox.layout.flex.vertical,
-- 				{
-- 					layout = wibox.layout.fixed.vertical,
-- 					spacing = 10,
-- 					forced_width = 200,
-- 					{
-- 						widget = wibox.container.scroll.horizontal,
-- 						step_function = wibox.container.scroll.step_functions.waiting_nonlinear_back_and_forth,
-- 						speed = 50,
-- 						title_widget,
-- 					},
-- 					artist_widget,
-- 				},
-- 				{
-- 					widget = wibox.container.margin,
-- 					bottom = 10,
-- 					{
-- 						widget = wibox.container.place,
-- 						valign = "bottom",
-- 						halign = "left",
-- 						{
-- 							layout = wibox.layout.fixed.horizontal,
-- 							spacing = 15,
-- 							prev,
-- 							music_button,
-- 							next,
-- 						}
-- 					}
-- 				},
-- 			}
-- 		},
-- 		{
-- 			widget = wibox.container.margin,
-- 			right = -30,
-- 			{
-- 				widget = wibox.container.place,
-- 				halign = "right",
-- 				art,
-- 			}
-- 		}
-- 	}
-- }

-- playerctl:connect_signal("metadata", function(_, title, artist, album_path, album, new, player_name)
-- 	art:set_image(gears.surface.load_uncached(album_path))
-- 	title_widget:set_markup_silently(title)
-- 	artist_widget:set_markup_silently(artist)
-- end)

-- playerctl:connect_signal("position", function (_, a, b, _)
--   position.value = a
--   position.max_value = b
-- end)


-- process list ---------------

local create_state_tab = function(title) 
	local tab = wibox.widget {
		layout = wibox.layout.fixed.vertical,
		fill_space = true,
		{
			widget = wibox.container.background,
			bg = beautiful.background_alt,
			forced_height = 23,
			{
				widget = wibox.widget.textbox,
				text = title,
				halign = "center",
			},
		},
		{
			widget = wibox.container.background,
			id = "line",
			forced_height = beautiful.border_width,
			bg = beautiful.background_alt,
		}
	}

	awesome.connect_signal("crutch_top::set_state", function(value)
		if value == title then
			tab:get_children_by_id("line")[1]:set_bg(beautiful.accent)
		else
			tab:get_children_by_id("line")[1]:set_bg(beautiful.background_alt)
		end
	end)

	tab:buttons {
		awful.button({}, 1, function()
			awesome.emit_signal("crutch_top::set_state", title)
		end)
	}

	return tab
end

local cpu_tab = create_state_tab("CPU")
local ram_tab = create_state_tab("RAM")
awesome.emit_signal("crutch_top::set_state", "CPU")

local state_switch = wibox.widget {
	widget = wibox.container.margin,
	bottom = 7,
	{
		layout = wibox.layout.align.horizontal,
		expand = "outside",
		{widget = cpu_tab,},
		{widget = wibox.widget.textbox,text = "|"},
		{widget = ram_tab,},
	}
}

state_switch:buttons{
	awful.button({}, 4, function() awesome.emit_signal("crutch_top::set_state", "CPU") end),
	awful.button({}, 5, function() awesome.emit_signal("crutch_top::set_state", "RAM") end)
}

local que_kill_btn = function(title)
	return wibox.widget {
		widget = wibox.container.background,
	    bg = beautiful.background_alt,
		border_width = beautiful.border_width,
		border_color = beautiful.accent,
		forced_height = 30,
		forced_width = 53,
		{
			widget = wibox.widget.textbox,
			align = "center",
			text = title,
		}
	}
end

local yes_btn = que_kill_btn("Yes")
local no_btn = que_kill_btn("No")
local kill_text = wibox.widget.textbox()
kill_text.align = "center"
local que_kill = wibox.widget {
	widget = wibox.container.place,
	valign  = "center",
	halign  = "center",
	fill_vertical = true,
	visible = false,
	{
		layout = wibox.layout.fixed.vertical,
		spacing = 15,
		{widget = kill_text,},
		{
			widget = wibox.container.place,
			valign  = "center",
			halign  = "center",
			{
				layout = wibox.layout.fixed.horizontal,
				spacing = 20,
				{widget = yes_btn,},
				{widget = no_btn,}
			}
			
		}
	}
}

local process_list = wibox.widget {
    layout = wibox.layout.fixed.vertical,
    spacing = 7,
    spacing_widget = {
        widget = wibox.container.margin,
        {widget = wibox.container.background}
    }
}

local create_process_line = function(i)
	local percent = wibox.widget.textbox()
	percent.id = "percent"
	percent.align = "center"
	percent.text = "0.0"

	local command = wibox.widget.textbox()
	command.id = "command"
	command.align = "center"
	command.text = "..."

	local kill = wibox.widget.textbox()
	kill.id = "kill"
	kill.align = "center"
	kill.text = "  "

	kill:buttons {
		awful.button({}, 1, function()
			kill_text.text = 'Kill process "' .. command.text .. '"?'
			yes_btn:buttons {
				awful.button({}, 1, function()
					io.popen("pkill " .. command.text)
					process_list.visible = true
					state_switch.visible = true
					que_kill.visible = false
				end)
			}
			process_list.visible = false
			state_switch.visible = false
			que_kill.visible = true
		end)
	}

	local process_line = wibox.widget {
        widget = wibox.container.background,
		forced_height = 30,
        bg = beautiful.background_alt,
        id = "process" .. tostring(i),
        {
            widget = wibox.container.margin,
            margins = {
				top = beautiful.border_width *2, 
				bottom = beautiful.border_width *2, 
				left = beautiful.border_width *4,
				right = beautiful.border_width *4,
			},
            {
                layout = wibox.layout.align.horizontal,
                {widget = percent,},
                {widget = command,},
                {widget = kill,},
            },
        },
    }
	return process_line
end

for i = 1, 5 do
    process_list:insert(#process_list.children + 1, create_process_line(i))
end

local crutch_top = wibox.widget {
    widget = wibox.container.background,
    bg = beautiful.background,
	border_width = beautiful.border_width * 2,
	border_color = beautiful.background_alt,
	forced_height = 228,
	{
		widget = wibox.container.margin,
		margins = beautiful.border_width * 4,
		{
			layout = wibox.layout.fixed.vertical,
			fill_space = true,
			que_kill,
			state_switch,
			process_list,
		}
    }
}

no_btn:buttons {
	awful.button({}, 1, function()
		process_list.visible = true
		state_switch.visible = true
		que_kill.visible = false
	end)
}

awesome.connect_signal("crutch_top::update", function(value)
	for i, process in pairs(value) do
		current_process = process_list.children[i].children[1].children[1]
		current_process.children[1].text = process[1]
		current_process.children[2].text = process[2]
	end
end)





-- main window --------------------------------------------------------

local main = wibox.widget {
	widget = wibox.container.background,
	bg = beautiful.background,
	{
		widget = wibox.container.margin,
		margins = 10,
		{
			layout = wibox.layout.fixed.vertical,
			spacing = 10,
			time,
			profile,
			--music,
			toggles,
			info,
			resourses,
			crutch_top
		}
	}
}

local control = awful.popup {
	screen = s,
	visible = false,
	ontop = true,
	border_width = beautiful.border_width,
	border_color = beautiful.border_color_normal,
	minimum_height = 800,--s.geometry.height / 1.25,
	minimum_width = 490,
	placement = function(d)
		awful.placement.right(d,
			{
				
			}
		)
	end,
	widget = main,
}


-- summon functions --

awesome.connect_signal("summon::control", function()
	control.visible = not control.visible
	if control.visible then
		start_scripts()
	else 
		stop_scripts()
	end
end)

-- hide on click --

client.connect_signal("button::press", function()
	control.visible = false
	stop_scripts()
end)

awful.mouse.append_global_mousebinding(
	awful.button({ }, 1, function()
		control.visible = false
		stop_scripts()
	end)
)

end)
