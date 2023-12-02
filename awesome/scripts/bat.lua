local awful = require("awful")
local gears = require("gears")

local update_interval = 15
local bat_script = [[
	cat /sys/class/power_supply/BAT*/uevent | grep -e 'POWER_SUPPLY_STATUS' -e 'POWER_SUPPLY_CAPACITY' |  awk -F'=' '{print $2}' | tr '\n' '|' | awk -F'|' '{print $1 "|" $2}'
]]

gears.timer {
	timeout   = update_interval,
	call_now  = true,
	autostart = true,
	callback  = function()
		awful.spawn.easy_async({"sh", "-c", bat_script}, function(stdout)
			local state, value = stdout:match("([^|]+)|(.+)")
			awesome.emit_signal("bat::state", state, tonumber(value))
		end)
	end
}
