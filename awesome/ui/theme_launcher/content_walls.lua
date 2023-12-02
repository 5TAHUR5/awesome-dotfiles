local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local binser = require("modules.binser.binser")
local paths = require("helpers.paths")
local dpi = require('beautiful').xresources.apply_dpi

local results, len = binser.readFile(paths.to_file_last_wall)
local last_wall = results[1].last_wall
local last_lut = results[1].last_lut

-- binser.writeFile(paths.to_file_last_wall, {
--     last_wall = "29.jpg",
--     last_lut = "mountain.png"
-- })

-- scripts --
updateWalls = function()
    awful.spawn.easy_async({"sh", "-c", "ls -1 -F --indicator-style=none " .. paths.to_dir_lite_walls .. " | tr '\n' '|'"}, function(stdout)
        walls = {}
        for wall in stdout:gmatch("[^|]+") do table.insert(walls, wall) end
        table.remove(walls)
        awesome.emit_signal("theme_changer::update_walls", walls, paths.to_dir_lite_walls, last_wall)
    end)
end

updateLuts = function()
    awful.spawn.easy_async({"sh", "-c", "ls " .. paths.to_dir_luts .. " | grep .png | tr '\n' '|'"}, function(stdout)
        luts = {}
        for lut in stdout:gmatch("[^|]+") do table.insert(luts, lut) end
        table.remove(luts)
        awesome.emit_signal("theme_changer::update_luts", luts, paths.to_dir_luts, last_lut)
    end)
end

updateLiteWalls = function()
    awful.spawn.easy_async({"sh", "-c", "rm -rf " .. paths.to_dir_lite_walls .. "* && magick mogrify -resize 160x100 -path " .. paths.to_dir_lite_walls .. " " .. paths.to_dir_walls .. "*"}, function()
        updateWalls()
    end)
end

setWallpaper = function(wall_name, lut_name)
    binser.writeFile(paths.to_file_last_wall, {
        last_wall = wall_name,
        last_lut = lut_name
    })  
    if lut_name == "lut_how_system" then
        local results, len = binser.readFile(paths.to_file_last_color_scheme)
        lut_name = results[1].last_scheme_name .. ".png"
    end
    awful.spawn.with_shell("sh "..paths.to_script_set_wallpaper.." "..paths.to_bin_lutgen.." "..paths.to_dir_walls.." "..paths.to_dir_luts.." ".. wall_name.." "..lut_name, function()
        updateWalls()
    end)
end

setWallpaper(last_wall, last_lut)


local selectable_wall = ""
local selectable_lut = ""

-- templates ----
local create_walls_btn = function(text)
    return wibox.widget {
        widget = wibox.widget.background,
        bg = beautiful.background_urgent,
        {
            widget = wibox.container.margin,
            margins = dpi(5),
            {
                widget = wibox.widget.textbox,
                align = "center",
                text = text
            }
        }
    }
end

-- walls ---------------------


-- luts --
local off_lutgen_btn = create_walls_btn("  Off lutgen")
local lut_how_sys_btn = create_walls_btn("  Awesome theme")

local luts_wrapper_one_height = 38 -- lut_box.forced_height + spacing
local luts_wrapper =  wibox.widget {
    layout = wibox.layout.fixed.vertical,
    forced_height = luts_wrapper_one_height,
    spacing = dpi(3),
}

luts_wrapper:buttons(gears.table.join(
	awful.button({}, 4, nil, function()
            if #luts_wrapper.children <= 5 then
            return
            end
        luts_wrapper:insert(1, luts_wrapper.children[#luts_wrapper.children])
        luts_wrapper:remove(#luts_wrapper.children)
    end),

    awful.button({}, 5, nil, function()
        if #luts_wrapper.children <= 5 then
            return
        end
        luts_wrapper:insert(#luts_wrapper.children + 1, luts_wrapper.children[1])
        luts_wrapper:remove(1)
    end)
))

local set_selectable_lut = function(lut_name)
    if lut_name == "" or lut_name == "lut_how_system" then
        selectable_lut = lut_name
        if selectable_lut == "" then 
            off_lutgen_btn:set_bg(beautiful.background_accent)
            lut_how_sys_btn:set_bg(beautiful.background_urgent)
        else 
            off_lutgen_btn:set_bg(beautiful.background_urgent)
            lut_how_sys_btn:set_bg(beautiful.background_accent)
        end
        for i = 1, #luts_wrapper.children do
            luts_wrapper.children[i]:set_bg(beautiful.background_alt)
        end
    else
        lut_how_sys_btn:set_bg(beautiful.background_urgent)
        off_lutgen_btn:set_bg(beautiful.background_urgent)
        for i = 1, #luts_wrapper.children do
            if luts_wrapper.children[i].widget.widget.widget.children[2].text == lut_name then
                selectable_lut = lut_name
                luts_wrapper.children[i]:set_bg(beautiful.background_accent)
            else
                luts_wrapper.children[i]:set_bg(beautiful.background_alt)
            end
        end
    end
    
end

lut_how_sys_btn:buttons {
    awful.button({ }, 1, function()
        set_selectable_lut("lut_how_system")
    end)
}

off_lutgen_btn:buttons {
    awful.button({ }, 1, function()
        set_selectable_lut("")
	end)
}

local create_lut_box = function(lut_name, luts_path)
    local ret_lut_box = wibox.widget {
        widget = wibox.container.background,
        bg = beautiful.background_alt,
        forced_height = dpi(35),
        {
            widget = wibox.container.place,
            valign = "center",
            halign = "left",
            {
                widget = wibox.container.margin,
                margins = dpi(7),
                {
                    layout = wibox.layout.fixed.horizontal,
                    spacing = dpi(10),
                    {
                        widget = wibox.widget.imagebox,
                        image = luts_path .. lut_name,
                        forced_height = dpi(20),
                        forced_width = dpi(20),
                    },
                    {
                        widget = wibox.widget.textbox,
                        text = lut_name,
                    }

                }
                
            }
        }
    }
    ret_lut_box:buttons {awful.button({ }, 1, function() set_selectable_lut(lut_name) end)}
    return ret_lut_box
end

awesome.connect_signal("theme_changer::update_luts", function(luts, luts_path, current_lut)
    luts_wrapper.forced_height = luts_wrapper_one_height * math.min(5, #luts)
    for _, lut in ipairs(luts) do
        luts_wrapper:insert(1, create_lut_box(lut, luts_path))
    end
    set_selectable_lut(current_lut)
end)

-- walls ------------------------------
local walls_wrapper_one_height = dpi(108)
local walls_wrapper =  wibox.widget {
    layout = wibox.layout.fixed.vertical,
    spacing = dpi(4),
    forced_height = walls_wrapper_one_height,
}

walls_wrapper:buttons(gears.table.join(
	awful.button({}, 4, nil, function()
        if #walls_wrapper.children <= 5 then
        return
        end
        walls_wrapper:insert(1, walls_wrapper.children[#walls_wrapper.children])
        walls_wrapper:remove(#walls_wrapper.children)
    end),

    awful.button({}, 5, nil, function()
        if #walls_wrapper.children <= 5 then
            return
        end
        walls_wrapper:insert(#walls_wrapper.children + 1, walls_wrapper.children[1])
        walls_wrapper:remove(1)
    end)
))

local set_selectable_wall = function(wall_name)
    for i = 1, #walls_wrapper.children do
        for j = 1, 3 do
            if walls_wrapper.children[i].children[j].widget then
                if walls_wrapper.children[i].children[j].widget.widget.children[2].text == wall_name then
                    selectable_wall = wall_name
                    walls_wrapper.children[i].children[j].border_color = beautiful.accent
                else
                    walls_wrapper.children[i].children[j].border_color = beautiful.background_accent
                end
            end
            
        end
    end
end

local create_wall_box = function(wall_name, walls_path)
    if wall_name then
        local ret_wall_box = wibox.widget {
            widget = wibox.container.background,
            border_width = dpi(3),
            forced_height = dpi(100),
            forced_width = dpi(160),
            border_color = beautiful.background_accent,
            {
                widget = wibox.container.place,
                valign = "center",
                halign = "center",
                {
                    layout = wibox.layout.fixed.vertical,
                    {
                        widget = wibox.widget.imagebox,
                        image = gears.surface.load_uncached_silently(walls_path .. wall_name),     
                    },
                    {
                        widget = wibox.widget.textbox,
                        text = wall_name,
                        visible = false
                    }
                }
                
            }
            
        }
        ret_wall_box:buttons {awful.button({ }, 1, function() set_selectable_wall(wall_name) end)}
        return ret_wall_box
    else 
        return wibox.widget {
            widget = wibox.container.background,
            bg = beautiful.background,
            forced_height = dpi(104),
            forced_width = dpi(160),
        }
    end
end

local create_walls_row = function(first_wall, second_wall, third_wall, walls_path)
    return wibox.widget {
        layout = wibox.layout.fixed.horizontal,
        forced_width = dpi(480),
        forced_height = dpi(104),
        spacing = dpi(4),
        create_wall_box(first_wall, walls_path),
        create_wall_box(second_wall, walls_path),
        create_wall_box(third_wall, walls_path),
    }
end
awesome.connect_signal("theme_changer::update_walls", function(walls, walls_path, current_wall)
    for walls_row in pairs(walls_wrapper.children) do
        walls_wrapper.children[walls_row] = nil
    end
    if #walls ~= 0 then 
        
        walls_wrapper.forced_height = walls_wrapper_one_height * math.min(5, math.ceil(#walls / 3))
        for i = 1, #walls, 3 do
            walls_wrapper:insert(#walls_wrapper.children + 1, create_walls_row(walls[i], walls[i+1], walls[i+2], walls_path))
        end
        set_selectable_wall(current_wall)
    else
        walls_wrapper:insert(1, wibox.widget{
            widget = wibox.container.margin,
            bottom = dpi(4),
            {
                widget = wibox.container.background,
                border_width = beautiful.border_width,
                border_color = beautiful.red,
                forced_height = walls_wrapper_one_height,
                fg = beautiful.red,--.foreground .. "dd",
                forced_width = dpi(480),
                {
                    widget = wibox.container.place,
                    valign = "center",
                    halign = "center",
                    {
                        widget = wibox.widget.textbox,
                        text = "Wallpapers in '~/.config/awesome/other/lite_walls' not found. Put your wallpapers in '~/.walls' and press to '  Reset wallpapers'!!!"
                    }                
                } 
            }

        })
    end
end)

local apply_walls_btn = create_walls_btn("  Apply")
local update_lite_walls = create_walls_btn("  Reset wallpapers")

apply_walls_btn:buttons {
    awful.button({ }, 1, function()
        setWallpaper(selectable_wall, selectable_lut)
	end)
}

update_lite_walls:buttons {
    awful.button({ }, 1, function()

        for walls_row in pairs(walls_wrapper.children) do
            walls_wrapper.children[walls_row] = nil
        end
        walls_wrapper:insert(1, wibox.widget {
            widget = wibox.widget.textbox,
            text = "Wallpapers updates",
            align = "center",
            forced_height = dpi(520),
            forced_width = dpi(480),
        })
        updateLiteWalls()
	end)
}

content_walls = wibox.widget {
    widget = wibox.container.margin,
    visible = false,
    margins = dpi(5),
    fill_space = true,
    forced_width = dpi(490),
    {
        layout = wibox.layout.fixed.vertical,
        {
            layout =  wibox.layout.fixed.vertical,
            spacing = dpi(4),
            {
                widget = wibox.container.background,
                forced_height = dpi(35),
                bg = beautiful.background_alt,
                {
                    layout = wibox.layout.align.horizontal,
                    {
                        widget = wibox.widget.textbox,
                        text = " Lutgen themes",
                    },
                    {widget = wibox.container.background},
                    {
                        layout = wibox.layout.fixed.horizontal,
                        spacing = dpi(5),
                        lut_how_sys_btn,
                        off_lutgen_btn,
                    }
                    
                }
            },
            luts_wrapper,
        },
        walls_wrapper,
        {
            widget = wibox.container.place,
            valign = "bottom",
            halign = "right",
            
            {
                layout = wibox.layout.fixed.horizontal,
                spacing = dpi(10),
                update_lite_walls,
                apply_walls_btn,
            }
        },
    }
}



updateLuts()
updateWalls()