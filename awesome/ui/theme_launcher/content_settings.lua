local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local paths = require("helpers.paths")
local binser = require("modules.binser.binser")
local bling = require("modules.bling")
local dpi = require("beautiful").xresources.apply_dpi
local results, len = binser.readFile(paths.to_file_last_settings)
current_settings = results[1].last_settings

local naughty = require("naughty")

-- binser.writeFile(paths.to_file_last_settings, {
--     last_settings = {
--         setting_opacity = true,
--         setting_floating = false,
--         setting_titlebars_active = true
--     },
-- })

awesome.connect_signal("exit", function()
	binser.writeFile(paths.to_file_last_settings, {
		last_settings = current_settings,
	})
end)

local create_btn_tooltip = function(widget, tooltip_text)
	awful.tooltip({
		objects = { widget },
		timer_function = function()
			return tooltip_text
		end,
		gaps = beautiful.useless_gap,
		align = "top_right",
		margins = dpi(5),
		delay_show = 1.5,
	})
end

local create_shift_image = function(image, tooltip_text)
	local widget = wibox.widget({

		widget = wibox.container.margin,
		margins = {
			left = dpi(6),
			right = dpi(6),
			top = dpi(6),
			bottom = dpi(6)
		},
		forced_height = dpi(50),
		forced_width = dpi(50),
		{
			widget = wibox.widget.imagebox,
			halign = "center",
			valign = "center",
			image = image,
			resize = true
		},
	})
	create_btn_tooltip(widget, tooltip_text)
	return widget
end

local create_shift_image_icon = function(icon, tooltip_text)
	local widget = wibox.widget({
		widget = wibox.container.margin,
		margins = dpi(6),
		{
			widget = wibox.widget.imagebox,
			image = gears.color.recolor_image(icon, beautiful.foreground),
			forced_height = dpi(44),
			forced_width = dpi(44),
		},
	})
	create_btn_tooltip(widget, tooltip_text)
	return widget
end

local create_shift_btn = function(args)
	local ret_shifting_btn = wibox.widget({
		widget = wibox.container.background,
		forced_height = dpi(50),
		forced_width = dpi(50),
		bg = beautiful.background_alt,
		{
			widget = args.shift_list[args.last_shift_number][1],
		},
	})
	if args.autostart then
		args.shift_list[args.last_shift_number][2]()
	end
	local inc_layout = function(num)
		if args.last_shift_number == 1 and num == -1 then
			args.last_shift_number = #args.shift_list
		elseif args.last_shift_number + num == #args.shift_list then
			args.last_shift_number = #args.shift_list
		else
			args.last_shift_number = (args.last_shift_number + num) % #args.shift_list
		end
		ret_shifting_btn.widget = args.shift_list[args.last_shift_number][1]
		args.shift_list[args.last_shift_number][2]()
	end
	ret_shifting_btn:buttons({
		awful.button({}, 1, function()
			inc_layout(1)
		end),
		awful.button({}, 3, function()
			inc_layout(-1)
		end),
		awful.button({}, 4, function()
			inc_layout(1)
		end),
		awful.button({}, 5, function()
			inc_layout(-1)
		end),
	})
	return ret_shifting_btn
end

local set_toggle_btn_state = function(btn, toggle_on)
	if toggle_on == true then
		btn.border_color = beautiful.green
		btn.widget.widget:set_bg(beautiful.green)
		btn.widget.widget.widget.image = gears.color.recolor_image(beautiful.icon_float_yes_small, beautiful.foreground)
		btn.widget.left = dpi(25)
		btn.widget.right = dpi(2)
	else
		btn.border_color = beautiful.red
		btn.widget.widget:set_bg(beautiful.red)
		btn.widget.widget.widget.image = gears.color.recolor_image(beautiful.icon_float_no_small, beautiful.foreground)
		btn.widget.left = dpi(2)
		btn.widget.right = dpi(25)
	end
end

local create_toggle_btn = function(args) --value, setting_name, callback_off, callback_on, autostart
	local ret_toggle_btn = wibox.widget({
		widget = wibox.container.background,
		forced_height = dpi(25),
		forced_width = dpi(50),
		bg = beautiful.background,
		border_width = 1,
		{
			widget = wibox.container.margin,
			top = dpi(2),
			bottom = dpi(2),
			left = dpi(2),
			right = dpi(25),
			{
				widget = wibox.container.background,
				fg = beautiful.foreground,
				{
					widget = wibox.widget.imagebox,
					forced_height = dpi(23),
					forced_width = dpi(23),
					image = gears.color.recolor_image(beautiful.icon_float_no_small, beautiful.foreground),
					resize = true,
					halign = "center",
					valign = "center",
				},
			},
		},
	})
	if args.value == false then
		set_toggle_btn_state(ret_toggle_btn, false)
		if args.autostart then
			args.callback_off()
		end
	else
		set_toggle_btn_state(ret_toggle_btn, true)
		if args.autostart then
			args.callback_on()
		end
	end
	ret_toggle_btn:buttons({
		awful.button({}, 1, function()
			if args.value == true then
				if args.callback_off() == true then
					set_toggle_btn_state(ret_toggle_btn, false)
					args.value = false
				end
			else
				if args.callback_on() == true then
					set_toggle_btn_state(ret_toggle_btn, true)
					args.value = true
				end
			end
		end),
	})
	return ret_toggle_btn
end

local create_setting_wrapper = function(args)
	local ret_setting_wrapper = wibox.widget({
		widget = wibox.container.background,
		bg = beautiful.background_alt,
		forced_height = args.height or 60,
		fill_space = true,
		{
			widget = wibox.container.margin,
			top = dpi(7),
			bottom = dpi(7),
			right = dpi(15),
			left = dpi(20),
			fill_space = true,
			{
				layout = wibox.layout.fixed.horizontal,
				forced_height = dpi((args.height or 50) - 14),
				forced_width = dpi(480 - 14),
				fill_space = true,
				{
					widget = wibox.container.place,
					valign = "center",
					halign = "left",
					{
						widget = wibox.container.margin,
						margins = {
							left = dpi(0),
							right = dpi(20),
						},
						{
							widget = wibox.widget.imagebox,
							image = args.setting_icon,
							valign = "center",
							halign = "center",
							resize = true,		
							forced_height = dpi(30),
							forced_width = dpi(30)	
						}

					},
				},
				{
					widget = wibox.container.place,
					valign = "center",
					halign = "left",
					{
						widget = wibox.widget.textbox,
						text = args.setting_text,
					},
				},
				{
					widget = wibox.container.place,
					valign = "center",
					halign = "right",
					args.setting_btn,
				},
			},
		},
	})
	return ret_setting_wrapper
end

local setting_toggle_opacity = create_setting_wrapper({
	setting_icon = gears.color.recolor_image(beautiful.icon_float_opacity, beautiful.foreground),
	setting_text = "Opacity",
	height = dpi(60),
	setting_btn = create_toggle_btn({
		value = current_settings.setting_opacity or false,
		callback_on = function()
			awful.spawn.with_shell("$HOME/.config/awesome/other/picom/launch.sh --opacity")

			current_settings.setting_opacity = true
			return true
		end,
		callback_off = function()
			awful.spawn.with_shell("$HOME/.config/awesome/other/picom/launch.sh --no-opacity")

			current_settings.setting_opacity = false
			return true
		end,
		autostart = true,
	}),
})

-- local setting_toggle_floating = create_setting_wrapper({
--     setting_icon = "   ",
--     setting_text = "Floating",
--     height = 60,
--     setting_btn = create_toggle_btn({
--         value = current_settings.setting_floating or false,
--         callback_on = function()
--             local tags = awful.screen.focused().tags
--             for _, tag in ipairs(tags) do
-- 				awful.layout.set(awful.layout.suit.floating, tag)
-- 			end

--             current_settings.setting_floating = true
--             return true
--         end,
--         callback_off = function()
--             local tags = awful.screen.focused().tags
--             for _, tag in ipairs(tags) do
-- 				awful.layout.set(awful.layout.suit.tile.left, tag)
-- 			end

--             current_settings.setting_floating = false
--             return true
--         end,
--         autostart = true
--     })
-- })

local reset_titlebars = function(number, pos)
	current_settings.setting_titlebars_position = pos or current_settings.setting_titlebars_position
	current_settings.setting_titlebars_position_number = number or current_settings.setting_titlebars_position_number
	for _, tag in ipairs(awful.screen.focused().tags) do
		for _, c in pairs(tag:clients()) do
			awful.titlebar.hide(c, "left")
			awful.titlebar.hide(c, "right")
			awful.titlebar.hide(c, "top")
			awful.titlebar.hide(c, "bottom")
			if current_settings.setting_titlebars_active == true then
				awful.titlebar.show(c, current_settings.setting_titlebars_position)
			end
		end
	end
end

client.connect_signal("request::manage", function(c)
	awful.titlebar.hide(c, "left")
	awful.titlebar.hide(c, "right")
	awful.titlebar.hide(c, "top")
	awful.titlebar.hide(c, "bottom")
	if current_settings.setting_titlebars_active == true then
		awful.titlebar.show(c, current_settings.setting_titlebars_position)
	end
end)

local setting_toggle_titlebars = create_setting_wrapper({
	setting_icon = gears.color.recolor_image(beautiful.icon_float_titlebar, beautiful.foreground),
	setting_text = "Titlebar",
	height = dpi(60),
	setting_btn = create_toggle_btn({
		value = current_settings.setting_titlebars_active or false,
		callback_on = function()
			current_settings.setting_titlebars_active = true
			reset_titlebars()
			return true
		end,
		callback_off = function()
			current_settings.setting_titlebars_active = false
			reset_titlebars()
			return true
		end,
		autostart = true,
	}),
})

local setting_shift_titlebars = create_setting_wrapper({
	setting_icon = gears.color.recolor_image(beautiful.icon_float_border, beautiful.foreground),
	setting_text = "Titlebar position",
	height = dpi(80),
	setting_btn = create_shift_btn({
		last_shift_number = current_settings.setting_titlebars_position_number or 1,
		shift_list = {
			{
				create_shift_image(gears.color.recolor_image(beautiful.icon_float_border_top, beautiful.foreground), "Top"),
				function()
					reset_titlebars(1, "top")
				end,
			},
			{
				create_shift_image(gears.color.recolor_image(beautiful.icon_float_border_right, beautiful.foreground), "Right"),
				function()
					reset_titlebars(2, "right")
				end,
			},
			{
				create_shift_image(gears.color.recolor_image(beautiful.icon_float_border_bottom, beautiful.foreground), "Bottom"),
				function()
					reset_titlebars(3, "bottom")
				end,
			},
			{
				create_shift_image(gears.color.recolor_image(beautiful.icon_float_border_left, beautiful.foreground), "Left"),
				function()
					reset_titlebars(4, "left")
				end,
			},
		},
		autostart = false,
	}),
})

local set_rofi_style = function(style)
	current_settings.setting_rofi_style_position_number = style
	awful.spawn.easy_async_with_shell(
		[[sed -i -e "s/type[0-9]*/type]] .. style .. [[/g"  ~/.config/awesome/other/rofi/configs/launcher.rasi]]
	)
end

local setting_shift_rofi_style = create_setting_wrapper({
	setting_icon = gears.color.recolor_image(beautiful.icon_float_app_launcher, beautiful.foreground),
	setting_text = "App launcher style",
	height = dpi(80),
	setting_btn = create_shift_btn({
		last_shift_number = current_settings.setting_rofi_style_position_number or 1,
		shift_list = {
			{
				create_shift_image(gears.color.recolor_image(beautiful.icon_float_num_1, beautiful.foreground), "Minimal"),
				function()
					set_rofi_style(1)
				end,
			},
			{
				create_shift_image(gears.color.recolor_image(beautiful.icon_float_num_2, beautiful.foreground), "Minimal with icon"),
				function()
					set_rofi_style(2)
				end,
			},
			{
				create_shift_image(gears.color.recolor_image(beautiful.icon_float_num_3, beautiful.foreground), "Middle"),
				function()
					set_rofi_style(3)
				end,
			},
			{
				create_shift_image(gears.color.recolor_image(beautiful.icon_float_num_4, beautiful.foreground), "Fullscreen"),
				function()
					set_rofi_style(4)
				end,
			},
			{
				create_shift_image(gears.color.recolor_image(beautiful.icon_float_num_5, beautiful.foreground), "Like windows"),
				function()
					set_rofi_style(5)
				end,
			},
		},
		autostart = false,
	}),
})

local set_layout = function(selected_layout, pos)
	current_settings.setting_layouts_position_number = pos
	local tags = awful.screen.focused().tags
	for _, tag in ipairs(tags) do
		awful.layout.set(selected_layout, tag)
	end
end

local setting_shift_layouts = create_setting_wrapper({
	setting_icon = gears.color.recolor_image(beautiful.icon_float_layout, beautiful.foreground),
	setting_text = "Current layout",
	height = dpi(80),
	setting_btn = create_shift_btn({
		last_shift_number = current_settings.setting_layouts_position_number or 1,
		shift_list = {
			{
				create_shift_image_icon(paths.to_dir_theme_layouts_icons .. "floating.png", "Floating"),
				function()
					set_layout(awful.layout.suit.floating, 1)
				end,
			},
			{
				create_shift_image_icon(paths.to_dir_theme_layouts_icons .. "tile.png", "Tile right"),
				function()
					set_layout(awful.layout.suit.tile, 2)
				end,
			},
			{
				create_shift_image_icon(paths.to_dir_theme_layouts_icons .. "tileleft.png", "Tile left"),
				function()
					set_layout(awful.layout.suit.tile.left, 3)
				end,
			},
			{
				create_shift_image_icon(paths.to_dir_theme_layouts_icons .. "tilebottom.png", "Tile bottom"),
				function()
					set_layout(awful.layout.suit.tile.bottom, 4)
				end,
			},
			{
				create_shift_image_icon(paths.to_dir_theme_layouts_icons .. "tiletop.png", "Tile top"),
				function()
					set_layout(awful.layout.suit.tile.top, 5)
				end,
			},
			{
				create_shift_image_icon(paths.to_dir_theme_layouts_icons .. "fairv.png", "Fair vertical"),
				function()
					set_layout(awful.layout.suit.fair, 6)
				end,
			},
			{
				create_shift_image_icon(paths.to_dir_theme_layouts_icons .. "fairh.png", "Fair horizontal"),
				function()
					set_layout(awful.layout.suit.fair.horizontal, 7)
				end,
			},
			{
				create_shift_image_icon(paths.to_dir_theme_layouts_icons .. "spiral.png", "Spiral"),
				function()
					set_layout(awful.layout.suit.spiral, 8)
				end,
			},
			{
				create_shift_image_icon(paths.to_dir_theme_layouts_icons .. "dwindle.png", "Dwindle"),
				function()
					set_layout(awful.layout.suit.spiral.dwindle, 9)
				end,
			},
			{
				create_shift_image_icon(paths.to_dir_theme_layouts_icons .. "max.png", "Max"),
				function()
					set_layout(awful.layout.suit.max, 10)
				end,
			},
			{
				create_shift_image_icon(paths.to_dir_theme_layouts_icons .. "fullscreen.png", "Fullscreen"),
				function()
					set_layout(awful.layout.suit.max.fullscreen, 11)
				end,
			},
			{
				create_shift_image_icon(paths.to_dir_theme_layouts_icons .. "magnifier.png", "Magnifier"),
				function()
					set_layout(awful.layout.suit.magnifier, 12)
				end,
			},
			{
				create_shift_image_icon(paths.to_dir_theme_layouts_icons .. "cornernw.png", "Corner north west"),
				function()
					set_layout(awful.layout.suit.corner.nw, 13)
				end,
			},
			{
				create_shift_image_icon(paths.to_dir_theme_layouts_icons .. "cornerne.png", "Corner north east"),
				function()
					set_layout(awful.layout.suit.corner.ne, 14)
				end,
			},
			{
				create_shift_image_icon(paths.to_dir_theme_layouts_icons .. "cornersw.png", "Corner south west"),
				function()
					set_layout(awful.layout.suit.corner.sw, 15)
				end,
			},
			{
				create_shift_image_icon(paths.to_dir_theme_layouts_icons .. "cornerse.png", "Corner south east"),
				function()
					set_layout(awful.layout.suit.corner.se, 16)
				end,
			},
			{
				create_shift_image_icon(paths.to_dir_theme_layouts_icons .. "centered.png", "Centered"),
				function()
					set_layout(bling.layout.centered, 17)
				end,
			},
			{
				create_shift_image_icon(paths.to_dir_theme_layouts_icons .. "vertical.png", "Vertical"),
				function()
					set_layout(bling.layout.vertical, 18)
				end,
			},
			{
				create_shift_image_icon(paths.to_dir_theme_layouts_icons .. "horizontal.png", "Horizontal"),
				function()
					set_layout(bling.layout.horizontal, 19)
				end,
			},
			{
				create_shift_image_icon(paths.to_dir_theme_layouts_icons .. "equalarea.png", "Equalarea"),
				function()
					set_layout(bling.layout.equalarea, 20)
				end,
			},
			{
				create_shift_image_icon(paths.to_dir_theme_layouts_icons .. "deck.png", "Deck"),
				function()
					set_layout(bling.layout.deck, 21)
				end,
			},
		},
		autostart = true,
	}),
})

content_settings = wibox.widget({
	widget = wibox.container.margin,
	visible = false,
	margins = dpi(5),
	fill_space = true,
	forced_width = dpi(490),
	{
		layout = wibox.layout.fixed.vertical,
		spacing = 1,
		setting_toggle_opacity,
		--setting_toggle_floating,
		setting_toggle_titlebars,
		setting_shift_titlebars,
		setting_shift_rofi_style,
		setting_shift_layouts,
	},
})
