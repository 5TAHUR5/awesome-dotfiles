local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local naughty = require("naughty")
local beautiful = require("beautiful")
require("scripts.init")

local popup_window_style = {
    border_width = beautiful.border_width,
    border_color = beautiful.border_color_normal,
    forced_height = 375,
    minimum_width = 330,
    maximum_width = 330,
    shape = function(cr)
        return gears.shape.infobubble(cr, 330, 380, 0, 15, 10)
    end
}

local process_list = function(title, summon_signal, state_signal, state_script)

    

    local list_title = wibox.widget {
        widget = wibox.container.background,
        forced_height = 30,
        bg = beautiful.background_alt,
        {
            widget = wibox.widget.textbox,
            text = title .. " process list",
            halign = "center"
        }
    }

    local new_process = function(index)
        local process = wibox.widget {
            widget = wibox.container.background,
            forced_height = 40,
            bg = beautiful.background_alt,
            id = "process" .. index,
            {
                widget = wibox.container.margin,
                margins = {left = 7, right = 7},
                {
                    layout = wibox.layout.align.horizontal,
                    {
                        widget = wibox.widget.textbox,
                        id = "percent",
                        text = "29.0"
                    },
                    {
                        widget = wibox.widget.textbox,
                        id = "command",
                        align = "center",
                        text = "firefox"
                    },
                    {widget = wibox.widget.textbox, id = "kill", text = index}
                }
            }
        }
        return process
    end

    local processes_list = wibox.widget {
        forced_height = 225,
        layout = wibox.layout.fixed.vertical,
        spacing = 7,
        spacing_widget = {
            widget = wibox.container.margin,
            {widget = wibox.container.background}
        }
    }

    for i = 1, 5 do
        processes_list:insert(#processes_list.children + 1,
                              new_process(tostring(i)))
    end

    local main = wibox.widget {
        widget = wibox.container.background,
        bg = beautiful.background,
        {
            widget = wibox.container.margin,
            margins = {top = 20, bottom = 10, right = 10, left = 5},
            {
                layout = wibox.layout.fixed.vertical,
                fill_space = true,
                spacing = 7,
                list_title,
                processes_list
            }
        }
    }

    local process_list_popup = awful.popup {
        visible = false,
        ontop = true,
        border_width = popup_window_style.border_width,
        border_color = popup_window_style.border_color,
        forced_height = popup_window_style.forced_height,
        minimum_width = popup_window_style.minimum_width,
        maximum_width = popup_window_style.maximum_width,
        shape = popup_window_style.shape,
        placement = function(d)
            awful.placement.top_left(d, {
                honor_workarea = true,
                margins = {top = 0, left = 455}
            })
        end,
        widget = main
    }

    awesome.connect_signal(state_signal, function(value)
        naughty.notification {
            urgency = "critical",
            title = type(value),
            message = value,
            icon = beautiful.notification_icon_error
        }
    end)


    local get_state_script = function()
        
        naughty.notification {
            urgency = "critical",
            title = "ewrt",
            message = "qwe",
            icon = beautiful.notification_icon_error
        }
        
    end

    local update_timer = gears.timer {
        timeout = 3, 
        call_now  = false,
        autostart = false,
        callback  = function()
            awful.spawn.easy_async(
            {"sh", "-c", state_script},
            function(out)
                naughty.notification {
                    urgency = "critical",
                    title = "ewrt",
                    message = out,
                    icon = beautiful.notification_icon_error
                }
            end
        )
        end,
        single_shot = false,
    }

    -- summon functions --
    
    awesome.connect_signal(summon_signal, function()
        process_list_popup.x = mouse.coords().x - 25
        process_list_popup.visible = not process_list_popup.visible
        if process_list_popup.visible then
            update_timer:start()
        else 
            update_timer:stop()
        end
        -- co = coroutine.create(get_state_script(process_list_popup.visible))
        -- coroutine.resume(co)
    end)

    -- hide on click --

    client.connect_signal("button::press",
                          function() 
                            process_list_popup.visible = false 
                            update_timer:stop()
                        end)

    awful.mouse.append_global_mousebinding(
        awful.button({}, 1, function() 
            process_list_popup.visible = false 
            update_timer:stop()
        end))

end

cpu_script = [[ps -eo user,pid,ppid,%cpu,%mem,comm --sort=-%cpu | grep $USER | awk '$4!=0{print $0}' | awk '$6!="ps"{print $0}' | awk '{$1="";$3="";$5=""; print $0}' | awk '{print $2 "|" substr($0, index($0,$3))}']]

process_list("CPU", "summon::cpu_list", "signal::cpu_list", cpu_script) -- cpu
process_list("RAM", "summon::ram_list", "signal::ram_list", 'echo "popa"') -- ram

