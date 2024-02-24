local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
require("ui.lock")

local elements = {
	{"suspend", command = "awesome-client 'lockscreen()'", icon = ""},
	{"exit", command = "awesome-client 'awesome.quit()'", icon = "󰗼 "},
	{"reboot", command = "reboot", icon = " "},
	{"poweroff", command = "shutdown now", icon = "󰤆 "},
}

local elements_container = wibox.widget {
	homogeneous = false,
	expand = true,
	forced_num_cols = 2,
	forced_num_rows = 2,
	spacing = 10,
	layout = wibox.layout.fixed.horizontal
}

local prompt = wibox.widget {
	widget = wibox.widget.textbox,
	visible = false
}

local main = wibox.widget{
	widget = wibox.container.margin,
	margins = 10,
	{
		layout = wibox.layout.fixed.vertical,
		prompt,
		elements_container
	}
}

local powermenu = awful.popup {
	visible = false,
	ontop = true,
	bg = beautiful.bg,
	border_color = beautiful.border_color_normal,
	border_width = beautiful.border_width,
	placement = function(d)
		awful.placement.centered(d)
	end,
	widget = main
}

local function next()
	if index_element == 4 then
		index_element = 1
	else
		index_element = index_element + 1
	end
end

local function back()
	if index_element == 1 then
		index_element = 4
	else
		index_element = index_element - 1
	end
end

local function add_elements()

	elements_container:reset()

	for i, element in ipairs(elements) do

		local element_widget = wibox.widget {
			widget = wibox.container.background,
			bg = beautiful.bg,
			forced_width = 100,
			forced_height = 100,
			buttons = {
				awful.button({}, 1, function()
					if index_element == i then
						awful.spawn(elements[index_element].command)
					else
						index_element = i
						add_elements()
					end
				end)
			},
			{
				widget = wibox.widget.textbox,
				fg = beautiful.fg,
				align = "center",
				font = beautiful.font.." 38",
				markup = element.icon
			}
		}

		elements_container:add(element_widget)

		if i == index_element then
			element_widget.bg = beautiful.accent
			element_widget.fg = beautiful.background
		end

	end

end

local function open()

	powermenu.visible = true
	index_element = 1
	add_elements()

	awful.prompt.run {
		textbox = prompt,
		exe_callback = function()
			awful.spawn(elements[index_element].command)
		end,
		keypressed_callback = function(_, key)
			if key == "Right" or key == "l" or key == "д" then
				next()
				add_elements()
			elseif key == "Left" or key == "h" or key == "р" then
				back()
				add_elements()
			-- elseif key == "x" or key == "ч" then
			-- 	powermenu.visible = false

			-- 	awful.spawn(elements[index_element].command)
			-- 	--awful.client.focus.byidx(1)
			end
		end,
		done_callback = function()
			powermenu.visible = false
		end
	}

end

local function close()
	awful.keygrabber.stop()
	powermenu.visible = false
end

-- summon functions --
awesome.connect_signal("summon::powermenu", function()
	if not powermenu.visible then
		open()
	else
		close()
	end
end)

-- hide on click --
client.connect_signal("button::press", function()
	close()
end)

awful.mouse.append_global_mousebinding(
	awful.button({ }, 1, function()
		close()
	end)
)
