local gears = require("gears")
local awful    = require("awful")

local update_interval = 4

-- This is the wrong way to find out the CPU temperature, 
-- I just don't have a GPU temperature indicator, 
-- so the correct calculation would be too difficult for me
local updateCputemp = function()
    awful.spawn.easy_async({"sh", "-c", "cat /sys/class/thermal/thermal_zone0/temp"}, function(stdout)
        awesome.emit_signal("cputemp::update", (math.ceil(tonumber(stdout) / 1000)))
    end)
end

local cputemp_timer = gears.timer {
    call_now = true,
    autostart = false,
    timeout = update_interval,
    callback = updateCputemp,
    single_shot = false
}

awesome.connect_signal("control::start_scripts", function() 
    updateCputemp()
    cputemp_timer:start() 
end)

awesome.connect_signal("control::stop_scripts", function() cputemp_timer:stop() end)


