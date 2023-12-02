local gears = require("gears")
local awful = require("awful")

local update_interval = 4

local updateCpu = function()
    awful.spawn.easy_async({"sh", "-c", "vmstat 1 2 | tail -1 | awk '{print $15}'"}, function(stdout)
        awesome.emit_signal("cpu_forctr::update", 100 - tonumber(stdout))
    end)
end

local cpu_timer = gears.timer {
    call_now = true,
    autostart = false,
    timeout = update_interval,
    callback = updateCpu,
    single_shot = false
}

awesome.connect_signal("control::start_scripts", function() 
    updateCpu()
    cpu_timer:start() 
end)

awesome.connect_signal("control::stop_scripts", function() cpu_timer:stop() end)

