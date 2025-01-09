local awful = require("awful")
local gears = require("gears")

-- Microphone ------------------------------------------

-- Microphone update value ----
function update_microphone()
	awful.spawn.easy_async({ "sh", "-c", "amixer -D pipewire sget Capture" }, function(stdout)
		local value = string.match(stdout, "(%d?%d?%d)%%")
		local toggle = string.match(stdout, "%[(o%D%D?)%]")
		value = tonumber(value)
		local icon = ""
		if toggle == "off" then
			icon = "󰍭 "
		else
			icon = " 󰍬 "
		end
		awesome.emit_signal("capture::get_capture", value, icon, toggle)
	end)
end

-- Microphone set value -----------
awesome.connect_signal("capture::set_capture", function(set_capture)
	awful.spawn.easy_async({ "sh", "-c", "amixer -D pipewire sset Capture " .. set_capture }, function()
		update_microphone()
	end)
end)
