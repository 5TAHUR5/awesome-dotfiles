local gears = require("gears")


local what_state_visible = "CPU"
local cpu_script =
    [[ps -eo user,pid,ppid,%cpu,%mem,comm --sort=-%cpu | awk '$4!=0{print $0}' | awk '$6!="ps"{print $0}' | awk '{$1="";$3="";$5=""; print $0}' | awk '{print $2 "|" substr($0, index($0,$3))}']]
local ram_script = 
    [[ps -eo user,pid,ppid,%mem,%cpu,comm --sort=-%mem | awk '$4!=0{print $0}' | awk '$6!="ps"{print $0}' | awk '{$1="";$3="";$5=""; print $0}' | awk '{print $2 "|" substr($0, index($0,$3))}']]
local list_update_timeout = 2

local get_state_script = function(script)
    returnable_list = {}
    local ph = io.popen(script)
    local str = ph:read("*a")
    ph:close()
    local lines = {}
    for line in str:gmatch("[^\n]+") do table.insert(lines, line) end

    local sums = {}
    for _, line in ipairs(lines) do
        local parts = {}
        for part in line:gmatch("[^|]+") do table.insert(parts, part) end
        local key = parts[2]
        local value = tonumber(parts[1])
        if sums[key] then
            sums[key] = sums[key] + value
        else
            sums[key] = value
        end
    end
    local sorted = {}
    for key, value in pairs(sums) do
        table.insert(sorted, {tostring(value), key})
    end
    table.sort(sorted, function(a, b) return tonumber(a[1]) > tonumber(b[1]) end)
    table.move(sorted, 1, 5, 1, returnable_list)
    return returnable_list
end

local update_list = function()
    if what_state_visible == "CPU" then
        awesome.emit_signal("crutch_top::update", get_state_script(cpu_script))
    elseif what_state_visible == "RAM" then
        awesome.emit_signal("crutch_top::update", get_state_script(ram_script))
    end
end

process_list_timer = gears.timer {
    call_now = false,
    autostart = false,
    timeout = list_update_timeout,
    callback = update_list,
    single_shot = false
}

awesome.connect_signal("crutch_top::set_state", function(value) 
    what_state_visible = value 
    update_list()
end)

awesome.connect_signal("control::start_scripts", function() 
    update_list()
    process_list_timer:start() 
end)

awesome.connect_signal("control::stop_scripts", function() process_list_timer:stop() end)
