local awful = require("awful")
local naughty = require("naughty")

local icon = "󰃠 "

function update_value_of_bright()
	awful.spawn.easy_async(
		{ "sh", "-c", "brightnessctl i | grep Current | awk '{print $4}' | tr -d '()%'" },
		function(stdout)
			awesome.emit_signal("bright::get_bright", tonumber(stdout))
		end
	)
end

awesome.connect_signal("bright::set_bright", function(set_bright)
	awful.spawn.easy_async(
		{ "sh", "-c", "brightnessctl s " .. set_bright .. " | grep Current | awk '{print $4}' | tr -d '()%'" },
		function(stdout)
			awesome.emit_signal("bright::get_bright", tonumber(stdout))
		end
	)
end)
