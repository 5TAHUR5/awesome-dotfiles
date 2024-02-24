local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local paths = require("helpers.paths")
local binser = require("modules.binser.binser")
local dpi = require('beautiful').xresources.apply_dpi


local string_for_require_schemes  = "themes.color_schemes."
local results, len = binser.readFile(paths.to_file_last_alacritty_theme)
local last_alacritty_theme = results[1].last_alacritty_theme

-- binser.writeFile(paths.to_file_last_alacritty_theme, {
--     last_alacritty_theme = 'nord'
-- })

-- scripts --
-- updateColorSchemes = function()
--     awful.spawn.easy_async({"sh", "-c", 'ls ' .. paths.to_dir_color_schemes .. [[ | awk -F"." '{print $1}' | tr '\n' '|']]}, function(stdout)
--         schemes = {}
--         for scheme in stdout:gmatch("[^|]+") do 
--             if scheme ~= "\n" then
--                 local schem = require(string_for_require_schemes .. scheme)
--                 schemes[scheme] = schem
                
--             end
--         end
--         awesome.emit_signal("theme_changer::update_color_schemes", schemes, last_scheme_name)
--     end)
-- end

setAlacrittyTheme = function(theme_name)
    binser.writeFile(paths.to_file_last_alacritty_theme, {
        last_alacritty_theme = theme_name,
    })  
    if theme_name == "theme_how_system" then
        local results, len = binser.readFile(paths.to_file_last_color_scheme)
        theme_name = results[1].last_scheme_name
    end
    awful.spawn.easy_async_with_shell([[sed -i -e "s/\/themes\/alacritty\/.*.toml/\/themes\/alacritty\/]].. theme_name .. [[.toml/g"  ~/.config/alacritty/alacritty.toml]])
end
setAlacrittyTheme(last_alacritty_theme)
local selectable_theme_name = ""

-- templates ----
local create_color_schemes_btn = function(text)
    return wibox.widget {
        widget = wibox.widget.background,
        forced_width = dpi(150),
        forced_height = dpi(35),
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

local apply_scheme_btn = create_color_schemes_btn("  Apply")
local theme_how_sys_btn = create_color_schemes_btn("  Awesome theme")


-- schemes --
local color_schemes_wrapper_one_height = dpi(55)
local color_schemes_wrapper = wibox.widget {
    layout = wibox.layout.fixed.vertical,
    forced_height = color_schemes_wrapper_one_height,
    spacing = dpi(5),
}

color_schemes_wrapper:buttons(gears.table.join(
	awful.button({}, 4, nil, function()
        if #color_schemes_wrapper.children == 1 then
        return
        end
        color_schemes_wrapper:insert(1, color_schemes_wrapper.children[#color_schemes_wrapper.children])
        color_schemes_wrapper:remove(#color_schemes_wrapper.children)
    end),

    awful.button({}, 5, nil, function()
        if #color_schemes_wrapper.children == 1 then
            return
        end
        color_schemes_wrapper:insert(#color_schemes_wrapper.children + 1, color_schemes_wrapper.children[1])
        color_schemes_wrapper:remove(1)
    end)
))

local set_selectable_scheme = function(theme_name)
    theme_how_sys_btn:set_bg(beautiful.background_urgent)
    selectable_theme_name = theme_name
    for _, scheme in ipairs(color_schemes_wrapper.children) do
        if scheme.widget.widget.children[1].text == theme_name then 
            scheme.border_color = beautiful.background_accent
        else
            scheme.border_color = beautiful.background_urgent
        end
    end
end

set_selectable_scheme(last_alacritty_theme)
if last_alacritty_theme == "theme_how_system" then
    theme_how_sys_btn:set_bg(beautiful.background_accent)
end

local create_color_box = function(color)
    return wibox.widget {
        widget = wibox.widget.background,
        bg = color,
        border_color = "#000000",
        border_width = 1,
        forced_height = dpi(20),
        forced_width = dpi(20),
    }
end

local create_color_scheme_row = function(scheme)
    return wibox.widget {
        widget = wibox.container.margin,
        top = 10,
        bottom = 10,
        right = 0,
        {
            layout = wibox.layout.fixed.horizontal,
            spacing = dpi(10),
            {
                layout = wibox.layout.fixed.horizontal,
                spacing = beautiful.border_width,
                create_color_box(scheme.background_alt),
                create_color_box(scheme.foreground),
            },        
            {
                layout = wibox.layout.fixed.horizontal,
                spacing = beautiful.border_width,
                create_color_box(scheme.red),
                create_color_box(scheme.green),
                create_color_box(scheme.yellow),
                create_color_box(scheme.orange),
                create_color_box(scheme.blue),
                create_color_box(scheme.violet),
                create_color_box(scheme.gray),
            },            
        }
    }
end

local create_scheme_box = function(scheme)
    local ret_scheme_box = wibox.widget {
        widget = wibox.widget.background,
        bg = scheme.background_alt,
        fg = scheme.foreground,
        border_width = 5,
        border_color = beautiful.background_urgent,
        forced_width = dpi(480),
        forced_height = dpi(50),
        {
            widget = wibox.container.margin,
            top = dpi(5),
            left = dpi(15),
            bottom = dpi(5),
            right = dpi(5),
            {
                layout = wibox.layout.flex.horizontal,
                {
                    widget = wibox.widget.textbox,
                    text = scheme.name,
                },
                create_color_scheme_row(scheme)
            }
        }
    }
    ret_scheme_box:buttons {awful.button({ }, 1, function() 
        set_selectable_scheme(scheme.name)
    end)}
    return ret_scheme_box
end

awesome.connect_signal("theme_changer::update_color_schemes", function(schemes, last_scheme)
    local schemes_count = 0
    for scheme_name in pairs(schemes) do
        schemes_count = schemes_count + 1
        color_schemes_wrapper:insert(1, create_scheme_box(schemes[scheme_name]))
    end
    color_schemes_wrapper.forced_height = color_schemes_wrapper_one_height * math.min(7, schemes_count)
    --set_selectable_scheme(last_scheme)
end)


theme_how_sys_btn:buttons {
    awful.button({ }, 1, function()
        set_selectable_scheme("theme_how_system")
        theme_how_sys_btn:set_bg(beautiful.background_accent)
	end)
}

apply_scheme_btn:buttons {
    awful.button({ }, 1, function()
        setAlacrittyTheme(selectable_theme_name)
	end)
}



content_alacritty_themes = wibox.widget {
    widget = wibox.container.margin,
    visible = false,
    margins = dpi(5),
    forced_width = dpi(490),
    fill_space = true,
    {
        layout = wibox.layout.fixed.vertical,
        spacing = 1,
        color_schemes_wrapper,
        {
            layout = wibox.layout.flex.horizontal,
            spacing = dpi(5),
            theme_how_sys_btn,
            apply_scheme_btn,
        }
    }
}


