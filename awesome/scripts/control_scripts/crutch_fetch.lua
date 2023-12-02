local gears = require("gears")
local awful = require("awful")
local paths = require("helpers.paths")

local update_interval = 40

local update_fetch = function()
    awful.spawn.easy_async({"sh", paths.to_script_crutch_fetch}, function(stdout)
        local comps = {}
        for fetch_state in stdout:gmatch("[^|]+") do
            if fetch_state ~= "\n" then
                local comp_icon, comp_value = fetch_state:match("([^:]+):(.+)")
                table.insert(comps, {comp_icon, comp_value})
            end
        end
        awesome.emit_signal("crutch_fetch::update", comps)
    end)
end

local fetch_list_timer = gears.timer {
    call_now = true,
    autostart = false,
    timeout = update_interval,
    callback = update_fetch,
    single_shot = false
}

awesome.connect_signal("control::start_scripts", function() 
    update_fetch()
    fetch_list_timer:start() 
end)

awesome.connect_signal("control::stop_scripts", function() fetch_list_timer:stop() end)