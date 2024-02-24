local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local bling = require("modules.bling")
local playerctl = bling.signal.playerctl.lib()
local rubato = require("modules.rubato")
local dpi = require('beautiful').xresources.apply_dpi

require("scripts.init")
require("scripts.control_scripts")

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

local create_arcchart_widget = function(widget, signal, bg, fg, text, icon, measurement_icon, max_value_state)

local widget = wibox.widget {
	widget = wibox.container.background,
	bg = beautiful.background_alt,
	forced_width = dpi(110),
	forced_height = dpi(145),
	{
		widget = wibox.container.margin,
		margins = dpi(10),
		{
			layout = wibox.layout.fixed.vertical,
			spacing = dpi(10),
			{
				layout = wibox.layout.stack,
				{
					widget = wibox.container.arcchart,
					id = "progressbar",
					max_value = 100,
					min_value = 0,
					thickness = dpi(15),
					bg = bg,
					colors = {fg}
				},
				{
					widget = wibox.widget.textbox,
					id = "icon",
					font = beautiful.font .." 15",
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

local anim = rubato.timed {
	duration = 0.3,
	easing = rubato.easing.linear,
	subscribed = function(h)
		widget:get_children_by_id("progressbar")[1].value = h
	end
}

awesome.connect_signal(signal, function (value)
	anim.target = value
	widget:get_children_by_id("text")[1].text = value.. "%"
end)

awesome.connect_signal(signal, function (value)
	anim.target = value
	widget:get_children_by_id('text')[1].text = value .. measurement_icon
end)

return widget
end

local resourses = wibox.widget {
	layout = wibox.layout.fixed.horizontal,
	spacing = 10,
	create_arcchart_widget(cpu, "cpu_forctr::update", beautiful.background_urgent, beautiful.red, "CPU:", "    ", "%"),
	create_arcchart_widget(ram, "ram_forctr::update", beautiful.background_urgent, beautiful.green, "RAM:", "", "%"),
	create_arcchart_widget(disk, "disk_forctr::update", beautiful.background_urgent, beautiful.blue, "DISK:", " ", "%"),
	create_arcchart_widget(cputemp, "cputemp::update", beautiful.background_urgent, beautiful.orange, "TEMP:", "", "t°"),
}

-- profile --------------------------------

local create_fetch_comp = function(icon, text)
	return wibox.widget {
		widget = wibox.container.place,
		halign = "right",
		{
			layout = wibox.layout.fixed.horizontal,
			{
				widget = wibox.widget.textbox,
				text = text,
				halign = "right"
			},
			{
				widget = wibox.widget.textbox,
				forced_width = dpi(30),
				text = icon,
				halign = "center"
			},			
		}
	}
end

local fetch = wibox.widget {
	layout = wibox.layout.flex.vertical,
	forced_width = dpi(340),
	spacing = dpi(5),
	create_fetch_comp("i", "i"), 
	create_fetch_comp("i", "i"),
	create_fetch_comp("i", "i"),
	create_fetch_comp("i", "i"),
}

local set_fetch_comp = function(index, icon, value)
	fetch.children[index].widget.children[1].text = value
	fetch.children[index].widget.children[2].text = icon
end

local uptime_label = wibox.widget {
	widget = wibox.widget.textbox,
	font = "JetBrainsMono Nerd Font Bold Italic 20",
	halign = "center",
	text = "0s"
}

local profile_name = wibox.widget {
	widget = wibox.widget.textbox,
	font = beautiful.font .. " 14",
	halign = "center",
	text = "username"
}

awesome.connect_signal("crutch_fetch::update", function(comps)
	uptime_label.text = comps[1][1] .. "  " .. comps[1][2]
	profile_name.text = comps[2][1] .. "  " .. comps[2][2]
	for i = 3, #comps do
		set_fetch_comp(i-2, comps[i][1], comps[i][2])
	end
end)

local profile = wibox.widget {
	widget = wibox.container.background,
	bg = beautiful.background_alt,
	forced_height = dpi(110),
	{
		widget = wibox.container.margin,
		left = dpi(20),
		right = dpi(10),
		top = dpi(5),
		bottom = dpi(5),
		{
			layout = wibox.layout.align.horizontal,
			forced_width = dpi(460),
			{
				widget = wibox.container.place,
				valign = "center",
				halign = "left",
				{
					layout = wibox.layout.fixed.vertical,
					spacing = 7,
					uptime_label,
					profile_name,					
				}
			},
			{
				widget = wibox.container.place,
				halign = "right",
				fetch
			}
			
		}
	},
}

-- tools_list -------------------------

local create_tool_box = function(icon) 
	return wibox.widget {
		widget = wibox.container.background,
		bg = beautiful.background_alt,
		forced_height = dpi(50),
		forced_width = dpi(50),
		{
			widget = wibox.widget.textbox,
			text = icon,
			valign = 'center',
			halign = 'center',
			font = beautiful.font .. " 15"
		}
	}
end


-- theme launcher boxes
local theme_launcher_tool_list = wibox.widget {
	layout = wibox.layout.fixed.horizontal,
	spacing = 5,
}

local theme_launcher_tool_boxes = {
	["settings"] = create_tool_box("   "),
    ["walls"] = create_tool_box("  "),
    ["color_schemes"] = create_tool_box("󰏘 "),
	["alacritty_themes"] = create_tool_box("   "),
}

for switch, box in pairs(theme_launcher_tool_boxes) do
	box:buttons {awful.button({}, 1, function() awesome.emit_signal("summon::theme_changer", switch) end)}
end

theme_launcher_tool_list:insert(1, theme_launcher_tool_boxes["alacritty_themes"])
theme_launcher_tool_list:insert(1, theme_launcher_tool_boxes["walls"])
theme_launcher_tool_list:insert(1, theme_launcher_tool_boxes["color_schemes"])
theme_launcher_tool_list:insert(1, theme_launcher_tool_boxes["settings"])

awesome.connect_signal("theme_launcher::set_current_switch", function(cur_switch)
	for switch, box in pairs(theme_launcher_tool_boxes) do
		box:set_bg(beautiful.background_alt)
	end
	if cur_switch then
		theme_launcher_tool_boxes[cur_switch]:set_bg(beautiful.background_urgent)
	end
end)

local tools_list = wibox.widget {
	widget = wibox.container.background,
	bg = beautiful.background_alt,
	forced_height = dpi(60),
	{
		widget = wibox.container.place,
		halign = "center",
		valign = "center",
		{
			layout = wibox.layout.fixed.horizontal,
			forced_height = dpi(50),
			spacing = dpi(5),			
			theme_launcher_tool_list,
		}
	}

}

-- network -----------------------

local netspeed = wibox.widget {
	layout = wibox.layout.align.vertical,
	forced_width = dpi(85),
    expand = "outside",
	
	{
		widget = wibox.widget.textbox,
		forced_width = dpi(85),
		id = "transmit",
		halign = "right",
		font = beautiful.font .. " 12",
		text = "0Kb/s"
	},
	{
		widget = wibox.container.background,
		forced_width = dpi(20),
		forced_height = dpi(3)
	},
	{
		widget = wibox.widget.textbox,
		forced_width = dpi(85),
		id = "receive",
		halign = "right",
		font = beautiful.font .. " 12",
		text = "0Kb/s",
	}
}

awesome.connect_signal("netspeed::update", function(receive, transmit)
	netspeed.children[3].text =  receive
	netspeed.children[1].text =  transmit
end)

local create_connection_tab = function()
	return wibox.widget {
		layout = wibox.layout.fixed.horizontal,
		forced_height = dpi(28),
		spacing = dpi(3),
		{
			widget = wibox.widget.textbox,
			halign = "left",
			text = "",
			id = "first",
			font = beautiful.font .. " 14"
		},
		{
			widget = wibox.widget.textbox,
			text = "",
			id = "second",
		},
		{
			widget = wibox.widget.textbox,
			text = "",
			id = "third",
		}
	}
end

local connections = wibox.widget {
	widget = wibox.container.margin,
	top = dpi(10),
	bottom = dpi(10),
	left = dpi(15),
	{
		layout = wibox.layout.grid,
		forced_num_rows = 3,
		homogeneous     = true,
		expand          = true,
		spacing = dpi(6),
		forced_width = dpi(300),
		{widget = create_connection_tab()},
		{widget = create_connection_tab()},
		{widget = create_connection_tab()},
	}
}

awesome.connect_signal("connections::update", function(connections_list)
	for i = 1, 3 do 
		if i <= #connections_list then
			icon = ''
			if connections_list[i].connection_type == "ethernet" then 
				icon = "󰈀  |"
			elseif connections_list[i].connection_type == "wifi" then
				icon = "󰖩  |"
			else
				icon = "󰀂  |"
			end
			connections.widget.children[i].children[1].text = icon
			connections.widget.children[i].children[2].text = connections_list[i].connection_name .. " |"
			connections.widget.children[i].children[3].text = connections_list[i].connection_type
		else 
			connections.widget.children[i].children[1].text = "󰯡  |"
			connections.widget.children[i].children[2].text = "Empty..."
			connections.widget.children[i].children[3].text = ""
		end
	end
end)


local netbtn = wibox.widget {
	widget = wibox.container.background,
	bg = beautiful.background_urgent,
	fg = beautiful.foreground,
	forced_width = dpi(75),
	{
		widget = wibox.container.place,
		valign = "center",
		halign = "center",
		{
			widget = wibox.widget.textbox,
			text = "󰖩 ",
			halign = "center",
			valign = "center",
			font = beautiful.font .. " 35"
		}
		
	}		
}

netbtn:connect_signal("mouse::enter", function()
	netbtn.fg = beautiful.gray
end)
netbtn:connect_signal("mouse::leave", function()
	netbtn.fg = beautiful.foreground
end)

netbtn:buttons {
	awful.button({}, 1, function()
		awesome.emit_signal("summon::wifi_popup")
		netbtn.fg = beautiful.background
		gears.timer {
			
			autostart = true,
			timeout = 0.1,
			callback = function()
				netbtn.fg = beautiful.gray
			end,
			single_shot = true
		}
		
	end),
}


local network = wibox.widget {
	widget = wibox.container.background,
	bg = beautiful.background_alt,
	forced_height = dpi(75),
	forced_width = dpi(470) - beautiful.border_width * 2,
	{
		layout = wibox.layout.align.horizontal,
		netbtn,
		connections,
		{
			widget = wibox.container.margin,
			top = dpi(10),
			bottom = dpi(10),
			right = dpi(10),
			{
				layout = wibox.layout.fixed.horizontal,
				spacing = dpi(4),
				netspeed,
				{
					layout = wibox.layout.align.vertical,
					forced_width = dpi(15),
					expand = "outside",
					{
						widget = wibox.widget.textbox,
						forced_width = dpi(15),
						halign = "right",
						font = beautiful.font .. " 17",
						text = "󰠽"
					},
					{widget = wibox.container.background,},
					{
						widget = wibox.widget.textbox,
						forced_width = dpi(15),
						halign = "right",
						font = beautiful.font .. " 17",
						text = "󰧩",
					}
				}
			}
		}
	},
}

-- music player ---------------------------

local art = wibox.widget {
	image = gears.color.recolor_image(beautiful.no_song, beautiful.foreground),
	valign = "right",
	forced_height = dpi(120),
	forced_width = dpi(200),
	horizontal_fit_policy = "fit",
	vertical_fit_policy = "fit",
	widget = wibox.widget.imagebox
}

local title_widget = wibox.widget {
    markup = "Nothing Playing",
    halign = "left",
    widget = wibox.widget.textbox
}

local artist_widget = wibox.widget {
    halign = "left",
    widget = wibox.widget.textbox
}

local create_music_button = function(text)
	return wibox.widget {
		widget = wibox.container.background,
		bg = beautiful.background_urgent,
		forced_width = dpi(37),
		forced_height = dpi(29),
		{
			widget = wibox.container.margin,
			margins = dpi(5),
			{
				widget = wibox.widget.textbox,
				text = text,
				halign = "center",
				font = beautiful.font.. " 17",
			}
		}
	}
end

local next = create_music_button("󰄾")
next:buttons {
	awful.button({}, 1, function()
		playerctl:next()
	end)
}

local prev = create_music_button("󰄽")
prev:buttons {
	awful.button({}, 1, function()
		playerctl:previous()
	end)
}

local music_button = create_music_button("󰐍 ")
music_button:buttons {
	awful.button({}, 1, function()
		playerctl:play_pause()
	end)
}


playerctl:connect_signal(
	"playback_status", function(_, playing)
		if playing == true then
			music_button.widget.widget.text = "󰏦 "
		else 
			music_button.widget.widget.text = "󰐍 "
		end
	end
)

local media_slider = wibox.widget({
	widget = wibox.widget.slider,
	bar_color = beautiful.background_urgent,
	bar_active_color = beautiful.green,
	minimum = 0,
	maximum = 100,
	value = 0
})

local previous_value = 0
local internal_update = false
local set_position_timer_timeout = 0.4
local set_position_timer_step = 5

local minus_position = create_music_button("")
local minus_timer = gears.timer {
	timeout = set_position_timer_timeout,
	callback = function()
		previous_value = previous_value - set_position_timer_step
		playerctl:set_position(previous_value)
	end,
}
minus_position:connect_signal("button::press", function()
	minus_timer:start()
end)
minus_position:connect_signal("button::release", function()
	minus_timer:stop()
end)


local plus_position = create_music_button("")
local plus_timer = gears.timer {
	timeout = set_position_timer_timeout,
	callback = function()
		previous_value = previous_value + set_position_timer_step
		playerctl:set_position(previous_value)
	end,
}
plus_position:connect_signal("button::press", function()
	plus_timer:start()
end)
plus_position:connect_signal("button::release", function()
	plus_timer:stop()
end)


media_slider:connect_signal("property::value", function(_, new_value)
	if internal_update and new_value ~= previous_value then
		playerctl:set_position(new_value)
		previous_value = new_value
	end
end)

playerctl:connect_signal(
	"position", function(_, interval_sec, length_sec)
		internal_update = true
		previous_value = interval_sec
		media_slider.value = interval_sec
	end
)

awful.spawn.with_line_callback("playerctl -F metadata -f '{{mpris:length}}'", {
	stdout = function(line)
		if line == " " then
			local position = 100
			media_slider.maximum = position
		else
			local position = tonumber(line)
			if position ~= nil then
				media_slider.maximum = position / 1000000 or nil
			end
		end
	end
})

playerctl:connect_signal("metadata", function(_, title, artist, album_path, album, new, player_name)
	art:set_image(gears.surface.load_uncached(album_path))
	title_widget:set_markup_silently(title)
	artist_widget:set_markup_silently(artist)
end)

local music = wibox.widget {
	layout = wibox.container.background,
	bg = beautiful.background_alt,
	{
		layout = wibox.layout.fixed.horizontal,
		{
			widget = wibox.container.margin,
			forced_width = dpi(260),
			forced_height = dpi(140),
			margins = {
				top = dpi(15),
				bottom = dpi(12),
				left = dpi(8),
				right = dpi(8),
			},
			{
				layout = wibox.layout.align.vertical,
				{
					layout = wibox.layout.fixed.vertical,
					spacing = dpi(10),
					forced_width = dpi(200),
					forced_height = dpi(50),

					{
						widget = wibox.container.scroll.horizontal,
						step_function = wibox.container.scroll.step_functions.waiting_nonlinear_back_and_forth,
						speed = 50,
						title_widget,
					},
					artist_widget,
				},
				{widget = wibox.container.background,},
				{
					layout = wibox.layout.fixed.vertical,
					spacing = dpi(12),
					{
						widget = wibox.container.place,
						valign = "center",
						halign = "center",
						{
							layout = wibox.layout.fixed.horizontal,
							spacing = dpi(6),
							prev,
							minus_position,
							music_button,
							plus_position,
							next,
						}
					},
					{
						widget = wibox.container.background,
						bg = beautiful.background,
						forced_width = dpi(6),
						forced_height = dpi(6),
						media_slider,
					},
				}

			}
		},
		{
			widget = wibox.container.margin,
			margins = dpi(10),
			{
				widget = wibox.container.place,
				halign = "right",
				{
					widget = wibox.container.background,
					border_width = beautiful.border_width,
					border_color = beautiful.accent,
					art,
				}
			},
		}
		
		
	}
}

-- crutch top ---------------

local create_state_tab = function(title) 
	local tab = wibox.widget {
		layout = wibox.layout.fixed.vertical,
		fill_space = true,
		{
			id = "switch",
			widget = wibox.container.background,
			bg = beautiful.background_urgent,
			forced_height = dpi(23),
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
			tab:get_children_by_id("switch")[1]:set_bg(beautiful.background_urgent)
		else
			tab:get_children_by_id("line")[1]:set_bg(beautiful.background_accent)
			tab:get_children_by_id("switch")[1]:set_bg(beautiful.background_alt)
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
	bottom = 4,
	{
		layout = wibox.layout.align.horizontal,
		expand = "outside",
		{widget = cpu_tab,},
		{widget = wibox.widget.background,bg = beautiful.background, forced_width = dpi(4)},
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
		forced_height = dpi(30),
		forced_width = dpi(53),
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
kill_text.halign = "center"
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
				spacing = dpi(20),
				{widget = yes_btn,},
				{widget = no_btn,}
			}
			
		}
	}
}

local process_list = wibox.widget {
    layout = wibox.layout.fixed.vertical,
    spacing = dpi(4),
    spacing_widget = {
        widget = wibox.container.margin,
        {widget = wibox.container.background}
    }
}

local create_process_line = function(i)
	local percent = wibox.widget.textbox()
	percent.id = "percent"
	percent.halign = "center"
	percent.text = "0.0"

	local command = wibox.widget.textbox()
	command.id = "command"
	command.halign = "center"
	command.text = "..."

	local kill = wibox.widget {
		widget = wibox.container.background,
		bg = beautiful.foreground,
		fg = beautiful.background_alt,
		forced_width = dpi(22),
		{
			widget = wibox.widget.textbox,
			text = "󰖭",
			halign = "center",
			valign = "center",
			font = beautiful.font .. " 15"
		}
	}
	kill.id = "kill"
	
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
		forced_height = dpi(30),
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
	forced_height = dpi(211),
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
		margins = dpi(10),
		{
			layout = wibox.layout.fixed.vertical,
			spacing = dpi(10),
			profile,
			tools_list,
			network,
			music,
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
	minimum_height = dpi(300),--s.geometry.height / 1.25,
	minimum_width = dpi(490),
	maximum_width = dpi(490),
	placement = function(d)
		awful.placement.right(d)
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

-- hide ----

local first_click = false

local no_first_click = gears.timer {
    timeout = 0.25,
    callback = function()
		first_click = false
	end,
    single_shot = true
}


awesome.connect_signal("summon::close", function()
	control.visible = false
	stop_scripts()
end)

client.connect_signal("button::press", function()
	if control.visible == true then
		if first_click == true then
			control.visible = false
			stop_scripts()
		else
			first_click = true
			no_first_click:start()
		end
	end
end)

awful.mouse.append_global_mousebinding(
	awful.button({ }, 1, function()
		if control.visible == true then
			if first_click == true then
				control.visible = false
				stop_scripts()
			else
				first_click = true
				no_first_click:start()
			end
		end

	end)
)

end)
