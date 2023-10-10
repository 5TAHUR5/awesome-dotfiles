local awful = require("awful")
local gears = require("gears")

function upd_volume(stdout)
	local value = string.match(stdout, "(%d?%d?%d)%%")
	local muted = string.match(stdout, "%[(o%D%D?)%]")
	value = tonumber(value)
	local icon = ""
	if muted == "off" then
		icon = "󰖁 "
	elseif value <= 50 then
		icon = " "
	elseif value <= 100 then
		icon = "󰕾 "
	end
	
	awesome.emit_signal("volume::get_volume", value, icon)
end

function update_value_of_volume()
	awful.spawn.easy_async_with_shell("amixer -D pipewire sget Master", function (stdout)
		upd_volume(stdout)
	end)
end

awesome.connect_signal("volume::set_volume", function(set_volume)
	awful.spawn.easy_async_with_shell("amixer -D pipewire sset Master " .. set_volume, function(stdout)
		upd_volume(stdout)
	end)
end)



function update_value_of_capture()
	awful.spawn.easy_async_with_shell("amixer sget Capture toggle | tail -n 1 | awk '{print $4}' | tr -d []%", function (stdout)
		local value =  string.gsub(stdout, '^%s*(.-)%s*$', '%1')
		value = tonumber(value)
		awesome.emit_signal("capture::value", value)
	end)
end

function update_value_of_capture_muted()
	awful.spawn.easy_async_with_shell("amixer sget Capture toggle | tail -n 1 | awk '{print $5}' | tr -d '[]'", function (stdout)
		local value =  string.gsub(stdout, '^%s*(.-)%s*$', '%1')
		awesome.emit_signal("capture_muted::value", value)
	end)
end

update_value_of_volume()
update_value_of_capture()
update_value_of_capture_muted()

function updateVolumeSignals()
	update_value_of_volume()
	update_value_of_capture()
	update_value_of_capture_muted()
end

updateVolumeSignals()


gears.timer {
    call_now = true,
    autostart = true,
    timeout = 2,
    callback = updateVolumeSignals,
    single_shot = true
}
