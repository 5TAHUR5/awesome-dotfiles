local gears = require("gears")
local awful = require("awful")

local update_interval = 30

local updateDisk = function()
    awful.spawn.easy_async({"sh", "-c", "df -h /home |grep '^/' | awk '{print $5}' | tr -d '%'"}, function(stdout)
        awesome.emit_signal("disk_forctr::update", tonumber(stdout))
    end)
end

local disk_timer = gears.timer {
    call_now = true,
    autostart = false,
    timeout = update_interval,
    callback = updateDisk,
    single_shot = false
}

awesome.connect_signal("control::start_scripts", function() 
    updateDisk()
    disk_timer:start() 
end)

awesome.connect_signal("control::stop_scripts", function() disk_timer:stop() end)

