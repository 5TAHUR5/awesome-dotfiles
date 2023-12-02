local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local dpi = require('beautiful').xresources.apply_dpi
require("scripts.init")

local create_widget_icontext = function(icon)
    return wibox.widget {
        widget = wibox.container.background,
        bg = beautiful.accent,
        fg = beautiful.background_alt,
        border_width = 1,
        border_color = beautiful.accent,
        {
            widget = wibox.container.margin,
            margins = {
                left = dpi(8),
                right = dpi(8)
            },
            {
                widget = wibox.widget.textbox,
                font = "15",
                text = icon
            }
        }
    }
end

screen.connect_signal("request::desktop_decoration", function(s)

    -- clock -----------------------------

    local time = wibox.widget {
        layout = wibox.layout.fixed.horizontal,
        fill_space = true,
        {
            widget = create_widget_icontext("󰸗 ")
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
                margins = {
                    right = dpi(8),
                    left = dpi(8)
                },
                {
                    widget = wibox.widget.textclock,
                    format = "%d %b %Y | Time %H:%M",
                    refresh = dpi(20)
                }
            }
        },
        {
            widget = create_widget_icontext(" ")
        }
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

    time:buttons{awful.button({}, 1, function()
        awesome.emit_signal("time::calendar")
    end)}

    -- battery ------------------------------

    local bat_perc = wibox.widget.textbox()
    local bat_icon = wibox.widget.textbox()
    bat_icon.font = "15"

    awesome.connect_signal("bat::state", function(state, value)
        bat_perc.text = value
        if state == "Charging" or state == "Full" then
            bat_icon.text = "󰂄"
        elseif value == 100 then
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

    local bat = wibox.widget {
        layout = wibox.layout.fixed.horizontal,
        {
            widget = wibox.container.background,
            bg = beautiful.accent,
            fg = beautiful.background,
            {
                widget = wibox.container.margin,
                left = dpi(8),
                right = dpi(8),
                bat_icon
            }
        },
        {
            widget = wibox.container.background,
            bg = beautiful.background_alt,
            fg = beautiful.accent,
            border_width = 1,
            border_color = beautiful.accent,
            {
                widget = wibox.container.margin,
                left = dpi(8),
                right = dpi(8),
                bat_perc
            }
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
        {
            widget = create_widget_icontext("󰌌 ")
        },
        {
            widget = wibox.container.background,
            bg = beautiful.background_alt,
            fg = beautiful.accent,
            border_width = dpi(1),
            border_color = beautiful.accent,
            {
                widget = wibox.container.margin,
                left = -dpi(3),
                right = -dpi(3),
                mykeyboard
            }
        }
    }

    -- volume ------------------------------

    local volume_perc = wibox.widget.textbox()
    local volume_icon = wibox.widget.textbox()
    volume_perc.halign = "center"
    volume_icon.halign = "center"
    volume_icon.font = beautiful.font .. " 13"

    awesome.connect_signal("volume::get_volume", function(value, icon)
        volume_perc.text = value
        volume_icon.text = icon
    end)

    local volume = wibox.widget {
        layout = wibox.layout.fixed.horizontal,
        buttons = {awful.button({}, 1, function()
            awesome.emit_signal("volume::set_volume", "toggle")
        end), awful.button({}, 4, function()
            awesome.emit_signal("volume::set_volume", "2%+")
        end), awful.button({}, 5, function()
            awesome.emit_signal("volume::set_volume", "2%-")
        end)},
        {
            widget = wibox.container.background,
            bg = beautiful.accent,
            fg = beautiful.background,
            {
                widget = wibox.container.margin,
                margins = {
                    left = dpi(8),
                    right = dpi(6)
                },
                {
                    widget = volume_icon
                }

            }
        },
        {
            widget = wibox.container.background,
            bg = beautiful.background_alt,
            fg = beautiful.accent,
            border_width = dpi(1),
            border_color = beautiful.accent,
            {
                widget = wibox.container.margin,
                margins = {
                    left = dpi(8),
                    right = dpi(8)
                },
                {
                    widget = volume_perc
                }

            }
        }
    }

    -- microphone ------------------------------

    local microphone_perc = wibox.widget.textbox()
    local microphone_icon = wibox.widget.textbox()

    awesome.connect_signal("capture::get_capture", function(value, icon, toggle)
        microphone_perc.text = value
        microphone_icon.text = icon
    end)

    local microphone = wibox.widget {
        layout = wibox.layout.fixed.horizontal,
        buttons = {awful.button({}, 1, function()
            awesome.emit_signal("capture::set_capture", "toggle")
        end), awful.button({}, 4, function()
            awesome.emit_signal("capture::set_capture", "2%+")
        end), awful.button({}, 5, function()
            awesome.emit_signal("capture::set_capture", "2%-")
        end)},
        {
            widget = wibox.container.background,
            bg = beautiful.accent,
            fg = beautiful.background,
            forced_width = dpi(30),
            {
                widget = microphone_icon,
                halign = "center",
                valign = "center",
                forced_width = dpi(15),
                font = beautiful.font .. " 13"
            }
        },
        {
            widget = wibox.container.background,
            bg = beautiful.background_alt,
            fg = beautiful.accent,
            border_width = dpi(1),
            border_color = beautiful.accent,
            {
                widget = wibox.container.margin,
                margins = {
                    left = dpi(8),
                    right = dpi(8)
                },
                {
                    widget = microphone_perc,
                    halign = "center"
                }

            }
        }
    }

    -- brightness ----------------------------

    local bright_perc = wibox.widget.textbox()

    awesome.connect_signal("bright::get_bright", function(value)
        bright_perc.text = value
    end)

    local bright = wibox.widget {
        layout = wibox.layout.fixed.horizontal,
        buttons = {awful.button({}, 4, function()
            awesome.emit_signal("bright::set_bright", "5%+")
        end), awful.button({}, 5, function()
            awesome.emit_signal("bright::set_bright", "5%-")
        end)},
        {
            widget = create_widget_icontext("󰃠 ")
        },
        {
            widget = wibox.container.background,
            bg = beautiful.background_alt,
            fg = beautiful.accent,
            border_width = 1,
            border_color = beautiful.accent,
            {
                widget = wibox.container.margin,
                left = dpi(8),
                right = dpi(8),
                bright_perc
            }
        }
    }
    -- dnd ----------------------------

    local dnd_button = wibox.widget {
        widget = wibox.container.background,
        bg = beautiful.background_alt,
        fg = beautiful.accent,
        forced_width = dpi(35),
        border_width = dpi(1),
        border_color = beautiful.accent,
        {
            widget = wibox.container.place,
            halign = "center",
            valign = "center",
            {
                widget = wibox.widget.textbox,
                forced_width = dpi(17),
                font = "13",
                text = ""
            }
        }
    }

    local dnd = true

    awesome.connect_signal("signal::dnd", function()
        dnd = not dnd
        if not dnd then
            dnd_button.widget.widget.text = ""
            naughty.suspend()
        else
            dnd_button.widget.widget.text = ""
            naughty.resume()
        end
    end)

    dnd_button:buttons{awful.button({}, 1, function()
        awesome.emit_signal("signal::dnd")
    end)}

    -- taglist -----------------------------------

    local taglist = awful.widget.taglist {
        screen = s,
        filter = awful.widget.taglist.filter.all,
        buttons = {awful.button({}, 1, function(t)
            t:view_only()
        end), awful.button({}, 4, function(t)
            awful.tag.viewprev(t.screen)
        end), awful.button({}, 5, function(t)
            awful.tag.viewnext(t.screen)
        end)},
        layout = {
            spacing = dpi(6),
            layout = wibox.layout.fixed.horizontal
        },
        widget_template = {
            {
                id = "text_role",
                halign = "center",
                valign = "center",
                widget = wibox.widget.textbox
            },
            id = "background_role",
            widget = wibox.container.background,
            forced_width = dpi(42)
        }
    }

    -- tasklist --

    local tasklist_widget = awful.widget.tasklist {
        screen = s,
        filter = awful.widget.tasklist.filter.currenttags,
        buttons = {awful.button({}, 1, function(c)
            c:activate{
                context = "tasklist",
                action = "toggle_minimization"
            }
        end), awful.button({}, 2, function(c)
            c:kill{
                context = "tasklist",
                action = "close client"
            }
        end)},
        layout = {
            spacing = dpi(5),
            layout = wibox.layout.fixed.horizontal
        },
        widget_template = {
            nil,
            {

                widget = wibox.container.place,
                halign = "center",
                valign = "center",
                {
                    widget = wibox.container.margin,
                    margins = beautiful.border_width,
                    awful.widget.clienticon
                }
            },
            {
                wibox.widget.base.make_widget(),
                forced_height = beautiful.border_width,
                id = "background_role",
                widget = wibox.container.background
            },

            layout = wibox.layout.align.vertical,
            create_callback = function(self, c, index, objects)
                awful.tooltip({
                    objects = {self},
                    timer_function = function()
                        return c.name
                    end,
                    gaps = dpi(3),
                    margins_leftright = dpi(12),
                    margins_topbottom = dpi(10)
                })
            end
        }
    }

    -- tray --------------------------------

    local tray_widget = wibox.widget {
        widget = wibox.container.background,
        border_width = dpi(1),
        border_color = beautiful.accent,
        forced_height = dpi(30),
        {
            widget = wibox.container.margin,
            right = dpi(4),
            left = dpi(4),
            top = dpi(1),
            bottom = dpi(1),
            {
                widget = wibox.container.place,
                valign = "center",
                {
                    widget = wibox.widget.systray,
                    horizontal = true,
                    base_size = dpi(23)
                }   
            }
         
        }

    }

    local tray = wibox.widget {
        widget = wibox.container.background,
        bg = beautiful.background_alt,
        {
            layout = wibox.layout.fixed.horizontal,
            {
                widget = wibox.container.place,
                halign = "center",
                {
                    layout = wibox.layout.fixed.horizontal,
                    id = "tray"
                }
            },
            {
                widget = wibox.container.background,
                forced_width = dpi(33),
                bg = beautiful.accent,
                fg = beautiful.background_alt,
                {
                    widget = wibox.widget.textbox,
                    id = "button",
                    text = "",
                    font = beautiful.font .. " 21",
                    halign = "center",
                    valign = "center",
                }
            },
            
        }
    }
    local tray_visible = false

    awesome.connect_signal("summon::systray", function()
        if not tray_visible then
            tray:get_children_by_id("button")[1].text = ""
            tray:get_children_by_id("tray")[1]:insert(1, tray_widget)
        else
            tray:get_children_by_id("button")[1].text = ""
            tray:get_children_by_id("tray")[1]:remove(1)
        end
        tray_visible = not tray_visible
    end)

    tray:buttons{awful.button({}, 1, function()
        awesome.emit_signal("summon::systray")
    end)}

    -- bar -------------------------------

    bar = awful.wibar {
        screen = s,
        position = 'top',
        height = dpi(40),
        width = s.geometry.width - beautiful.border_width * 4,
        bg = beautiful.background,
        border_width = beautiful.border_width,
        border_color = beautiful.border_color_normal,
        margins = {
            top = beautiful.border_width,
            bottom = beautiful.border_width,
        },
        ontop = false,
        widget = {
            layout = wibox.layout.flex.horizontal,
            {
                widget = wibox.container.place,
                halign = "left",
                content_fill_vertical = true,
                {
                    widget = wibox.container.margin,
                    margins = {
                        top = dpi(5),
                        bottom = dpi(5),
                        left = dpi(10)
                    },
                    {
                        layout = wibox.layout.fixed.horizontal,
                        spacing = dpi(5),
                        taglist,
                        {
                            widget = wibox.widget.textbox,
                            text = ":",
                            font = beautiful.font .. " 15"
                        },
                        tasklist_widget
                    }
                }
            },
            {
                widget = wibox.container.place,
                halign = "center",
                content_fill_vertical = true,
                {
                    widget = wibox.container.margin,
                    margins = {
                        bottom = dpi(5),
                        top = dpi(5)
                    },
                    {
                        layout = wibox.layout.fixed.horizontal,
                        time
                    }
                }
            },
            {
                widget = wibox.container.place,
                halign = "right",
                content_fill_vertical = true,
                {
                    widget = wibox.container.margin,
                    margins = {
                        bottom = dpi(5),
                        top = dpi(5),
                        right = dpi(10)
                    },
                    {
                        layout = wibox.layout.fixed.horizontal,
                        spacing = dpi(10),
                        tray,
                        keyboard,
                        bright,
                        microphone,
                        volume,
                        bat,
                        dnd_button,
                    }
                }
            }
        }
    }

end)

awesome.connect_signal("hide::bar", function()
    bar.visible = not bar.visible
end)
