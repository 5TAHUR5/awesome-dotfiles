local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
require("scripts.init")


local widget_icontext = function(icon)
    return  wibox.widget {
        widget = wibox.container.background,
        bg = beautiful.accent,
        fg = beautiful.background_alt,
        border_width = 1,
        border_color = beautiful.accent,
        {
            widget = wibox.container.margin,
            margins = {left = 8, right = 8},
            {widget = wibox.widget.textbox, font = "15", text = icon}
        }
    }
end

screen.connect_signal("request::desktop_decoration", function(s)

    local profile_default = false

    awesome.connect_signal("profile::control", function()
        profile_default = not profile_default
        if not profile_default then
            -- profile:get_children_by_id('line')[1]:set_bg(beautiful.background_alt)
            awesome.emit_signal("summon::control")
        else
            -- profile:get_children_by_id('line')[1]:set_bg(beautiful.accent)
            awesome.emit_signal("summon::control")
        end
    end)

    awesome.connect_signal("show::tray", function() print("qwe") end)

    local dnd = true

    awesome.connect_signal("signal::dnd", function()
        dnd = not dnd
        if not dnd then
            -- dnd_button:get_children_by_id('icon')[1].text = ""
            naughty.suspend()
        else
            -- dnd_button:get_children_by_id('icon')[1].text = ""
            naughty.resume()
        end
    end)

    local notif_center_default = false

    awesome.connect_signal("notif_center::open", function()
        notif_center_default = not notif_center_default
        if not notif_center_default then
            -- dnd_button:get_children_by_id('line')[1]:set_bg(beautiful.background_alt)
            awesome.emit_signal("summon::notif_center")
        else
            -- dnd_button:get_children_by_id('line')[1]:set_bg(beautiful.accent)
            awesome.emit_signal("summon::notif_center")
        end
    end)

    -- clock -----------------------------

    local time = wibox.widget {
        layout = wibox.layout.fixed.horizontal,
        fill_space = true,
        {
            widget = widget_icontext(" ")
        },
        {
            widget = wibox.container.background,
            bg = beautiful.background_alt,
            fg = beautiful.accent,
            border_width = 1,
            border_color = beautiful.accent,
            id = 'clock',
            {
                widget = wibox.container.margin,
                margins = {right = 8, left = 8},
                {
                    widget = wibox.widget.textclock,
                    format = "%d %b %Y | Time %H:%M",
                    refresh = 20
                }
            }
        },
        {
            widget = widget_icontext(" ")
        },
    }

    local time_default = false

    awesome.connect_signal("time::calendar", function()
        time_default = not time_default
        if not time_default then

            awesome.emit_signal("summon::calendar_widget")
        else
            awesome.emit_signal("summon::calendar_widget")
        end
    end)

    time:buttons{
        awful.button({}, 1, function()
            awesome.emit_signal("time::calendar")
        end)
    }

    -- battery ------------------------------

    local bat_perc = wibox.widget.textbox()
    local bat_icon = wibox.widget.textbox()
    bat_icon.font = "15"

    awesome.connect_signal("bat::value", function(value)
        bat_perc.text = value
        if value == 100 then
            bat_icon.text = "󰁹"
        elseif value > 90 then
            bat_icon.text = "󰂂"
        elseif value > 70 then
            bat_icon.text = "󰂀"
        elseif value > 50 then
            bat_icon.text = "󰁾"
        elseif value > 30 then
            bat_icon.text = "󰁽"
        else
            bat_icon.text = "󰁻"
        end
    end)

    awesome.connect_signal("bat::state", function(value)
        if value ~= "Discharging" then bat_icon.text = "󰂄" end
    end)

    local bat = wibox.widget {
        layout = wibox.layout.fixed.horizontal,
        {
            widget = wibox.container.background,
            bg = beautiful.accent,
            fg = beautiful.background,
            {widget = wibox.container.margin, left = 8, right = 8, bat_icon}
        },
        {
            widget = wibox.container.background,
            bg = beautiful.background_alt,
            fg = beautiful.accent,
            border_width = 1,
            border_color = beautiful.accent,
            {widget = wibox.container.margin, left = 8, right = 8, bat_perc}
        }
    }

    -- keyboard layout --------------------------

    mykeyboard = awful.widget.keyboardlayout()
    mykeyboard.widget.text = string.upper(mykeyboard.widget.text)

    mykeyboard.widget:connect_signal("widget::redraw_needed", function(wid)
        wid.text = string.upper(wid.text)
    end)

    local keyboard = wibox.widget {
        layout = wibox.layout.fixed.horizontal,
        {widget = widget_icontext("󰌌 ")},
        {
            widget = wibox.container.background,
            bg = beautiful.background_alt,
            fg = beautiful.accent,
            border_width = 1,
            border_color = beautiful.accent,
            {widget = wibox.container.margin, left = -3, right = -3, mykeyboard}
        }
    }

    -- volume ------------------------------

    local volume_perc = wibox.widget.textbox()
    local volume_icon = wibox.widget.textbox()
    volume_perc.aligh = "center"
    volume_icon.aligh = "center"
    volume_icon.font = "13"
    
    awesome.connect_signal("volume::get_volume", function(value, icon)
        volume_perc.text = value
        volume_icon.text = icon
    end)

    local volume = wibox.widget {
        layout = wibox.layout.fixed.horizontal,
        buttons = {
            awful.button({}, 1, function()
                awesome.emit_signal("volume::set_volume", "toggle")
            end),
            awful.button({}, 4, function()
                awesome.emit_signal("volume::set_volume", "2%+")
            end),
            awful.button({}, 5, function()
                awesome.emit_signal("volume::set_volume", "2%-")
            end),
        },
        {
            widget = wibox.container.background,
            bg = beautiful.accent,
            fg = beautiful.background,
            {
                widget = wibox.container.margin,
                margins = {left = 8, right = 6,},
                {
                    widget = volume_icon,
                }
                
            },
        },
        {
            widget = wibox.container.background,
            bg = beautiful.background_alt,
            fg = beautiful.accent,
            border_width = 1,
            border_color = beautiful.accent,
            {
                widget = wibox.container.margin,
                margins = {left = 8, right = 8,},
                {
                    widget = volume_perc,
                }
                
            },
        }
    }

    -- brightness ----------------------------

    local bright_perc = wibox.widget.textbox()

    awesome.connect_signal("bright::value", function(value)
        bright_perc.text = value
    end)

    local bright = wibox.widget {
        layout = wibox.layout.fixed.horizontal,
        buttons = {
            awful.button({}, 4, function()
                awful.spawn.with_shell("brightnessctl s 5%+")
                update_value_of_bright()
            end),
            awful.button({}, 5, function()
                awful.spawn.with_shell("brightnessctl s 5%-")
                update_value_of_bright()
            end),
        },
        {widget = widget_icontext("󰃠 ")},
        {
            widget = wibox.container.background,
            bg = beautiful.background_alt,
            fg = beautiful.accent,
            border_width = 1,
            border_color = beautiful.accent,
            {
                widget = wibox.container.margin,
                left = 8,
                right = 8,
                bright_perc,
            },
        }
    }

    -- cpu ----------------------------

    local cpu_perc = wibox.widget.textbox()
    awesome.connect_signal("signal::cpu",
                           function(value) cpu_perc.text = value end)

    local cpu = wibox.widget {
        layout = wibox.layout.fixed.horizontal,
        {
            widget = wibox.container.background,
            bg = beautiful.accent,
            fg = beautiful.background,
            {
                widget = wibox.container.margin,
                left = 8,
                right = 8,
                {widget = wibox.widget.textbox, font = "15", text = " "}
            }
        },
        {
            widget = wibox.container.background,
            bg = beautiful.background_alt,
            fg = beautiful.accent,
            border_width = 1,
            border_color = beautiful.accent,
            {widget = wibox.container.margin, left = 8, right = 8, cpu_perc}
        }
    }

    cpu:buttons{
        awful.button({}, 1,
                     function() awesome.emit_signal("summon::cpu_list") end)
    }

    -- ram ------------------------------

    local ram_perc = wibox.widget.textbox()

    awesome.connect_signal("signal::ram", function(value)
        ram_perc.text = value
    end)

    local ram = wibox.widget {
        layout = wibox.layout.fixed.horizontal,
        {
            widget = wibox.container.background,
            bg = beautiful.accent,
            fg = beautiful.background,
            {
                widget = wibox.container.margin,
                left = 8,
                right = 8,
                {widget = wibox.widget.textbox, font = "15", text = ""}
            }
        },
        {
            widget = wibox.container.background,
            bg = beautiful.background_alt,
            fg = beautiful.accent,
            border_width = 1,
            border_color = beautiful.accent,
            {widget = wibox.container.margin, left = 8, right = 8, ram_perc}
        }
    }

    ram:buttons{
        awful.button({}, 1,
                     function() awesome.emit_signal("summon::ram_list") end)
    }

    -- taglist -----------------------------------

    local taglist = awful.widget.taglist {
        screen = s,
        filter = awful.widget.taglist.filter.all,
        buttons = {
            awful.button({}, 1, function(t) t:view_only() end),
            awful.button({}, 4, function(t)
                awful.tag.viewprev(t.screen)
            end),
            awful.button({}, 5, function(t)
                awful.tag.viewnext(t.screen)
            end)
        },
        layout = {spacing = 6, layout = wibox.layout.fixed.horizontal},
        widget_template = {
            {
                id = "text_role",
                halign = "center",
                valign = "center",
                widget = wibox.widget.textbox
            },
            id = "background_role",
            widget = wibox.container.background,
            forced_width = 42
        }
    }


    -- tray --------------------------------

    local tray_visible = false

    local tray = wibox.widget {
        widget = wibox.container.background,
        forced_width = 30,
        bg = beautiful.accent,
        fg = beautiful.background_alt,
        border_width = 1,
        border_color = beautiful.accent,
        {
            widget = wibox.container.margin,
            margins = {left = 8, right = 8},
            {widget = wibox.widget.textbox, id = "icon", font = "12", text = ""}
        }
    }

    awesome.connect_signal("summon::systray", function(value)
        if value ~= nil then
            tray_visible = value
        else 
            tray_visible = not tray_visible
        end
        
        if tray_visible then
            tray:get_children_by_id("icon")[1].text = ""
        else
            tray:get_children_by_id("icon")[1].text = ""
        end
    end)

    tray:buttons{
        awful.button({}, 1,
                     function() awesome.emit_signal("summon::systray", not tray_visible) end)
    }


    -- bar -------------------------------

    bar = awful.wibar {
        screen = s,
        position = 'top',
        height = 40,
        width = s.geometry.width - beautiful.border_width * 3,
        bg = beautiful.background,
        border_width = beautiful.border_width,
        border_color = beautiful.border_color_normal,
        margins = {top = beautiful.border_width},
        ontop = false,
        widget = {
            layout = wibox.layout.flex.horizontal,
            {
                widget = wibox.container.place,
                halign = "left",
                content_fill_vertical = true,
                {
                    widget = wibox.container.margin,
                    margins = {top = 5, bottom = 5, left = 10},
                    {
                        layout = wibox.layout.fixed.horizontal,
                        spacing = 15,
                        taglist
                    }
                }
            },
            {
                widget = wibox.container.place,
                halign = "center",
                content_fill_vertical = true,
                {
                    widget = wibox.container.margin,
                    margins = {bottom = 5, top = 5},
                    {layout = wibox.layout.fixed.horizontal, time}
                }
            },
            {
                widget = wibox.container.place,
                halign = "right",
                content_fill_vertical = true,
                {
                    widget = wibox.container.margin,
                    margins = {bottom = 5, top = 5, right = 10},
                    {
                        layout = wibox.layout.fixed.horizontal,
                        spacing = 10,
                        
                        keyboard,
                        --cpu,
                        --ram,
                        bright,
                        volume,
                        bat,
                        tray,
                    }
                }
            }
        }
    }
    
end)

awesome.connect_signal("hide::bar", function() bar.visible = not bar.visible end)
