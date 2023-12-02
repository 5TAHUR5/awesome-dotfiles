local gears = require("gears")
local awful = require("awful")

local update_interval = 3
local update_step = (1024 * update_interval)
last_rx = 0
last_tx = 0


local updateNetspeed = function(say_netspeed)
    awful.spawn.easy_async({"sh", "-c", [[nmcli device | grep -w 'connected' | awk '{$3=""; print $0}' | awk '{print $1 "|" $2 "|" substr($0, index($0,$3))}']]}, function(devices)
        device_string = ' | grep '
        connections = {}
        for device in devices:gmatch("[^\n]+") do 
            line = {}
            for tabl in device:gmatch("[^|]+") do table.insert(line, tabl) end
            table.insert(connections, {
                connection_name = line[3],
                connection_type = line[2]
            })
            device_string = device_string .. " -e " .. line[1] 
        end
        awesome.emit_signal("connections::update", connections)
        awful.spawn.easy_async({"sh", "-c", "cat /proc/net/dev" .. device_string}, function(lines_state)
            local current_rx = 0
            local current_tx = 0
            local lines = {}
            for ln in lines_state:gmatch("[^\n]+") do table.insert(lines, ln) end
            for _, line in ipairs(lines) do
                current_bytes = {}
                for part in line:gmatch("%S+") do table.insert(current_bytes, part) end
                current_rx = current_rx + tonumber(current_bytes[2])
                current_tx = current_tx + tonumber(current_bytes[10])
            end
            current_speed_r = tonumber(math.floor(((current_rx - last_rx) / update_step) + 0.5))
            current_speed_t = tonumber(math.floor(((current_tx - last_tx) / update_step) + 0.5))
            last_rx = current_rx
            last_tx = current_tx
            if say_netspeed ~= false and current_speed_r >= 0 and current_speed_t >= 0 then
                awesome.emit_signal("netspeed::update", tostring(current_speed_r) .. "Kb/s", tostring(current_speed_t) .. "Kb/s")
            end
        end)
    end)
end

local netspeed_timer = gears.timer {
    call_now = false,
    autostart = false,
    timeout = update_interval,
    callback = updateNetspeed,
    single_shot = false
}

awesome.connect_signal("control::start_scripts", function() 
    updateNetspeed(false)
    netspeed_timer:start() 
end)

awesome.connect_signal("control::stop_scripts", function() netspeed_timer:stop() end)


