local gears = require("gears")
local awful = require("awful")

local update_interval = 4

local updateRam = function()
    awful.spawn.easy_async({"sh", "-c", "free -m | grep 'Mem:' | awk '{print $7, $2}'"}, function(stdout)
        ram_states = {}
        for index in stdout:gmatch("%S+") do table.insert(ram_states, index) end
        local value =  math.floor(((tonumber(ram_states[2]) - tonumber(ram_states[1])) / tonumber(ram_states[2])) * 100)
        awesome.emit_signal("ram_forctr::update", value)
    end)
end

local ram_timer = gears.timer {
    call_now = true,
    autostart = false,
    timeout = update_interval,
    callback = updateRam,
    single_shot = false
}

awesome.connect_signal("control::start_scripts", function() 
    updateRam()
    ram_timer:start() 
end)

awesome.connect_signal("control::stop_scripts", function() ram_timer:stop() end)