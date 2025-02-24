local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local helpers = require("helpers")
local beautiful = require("beautiful")
local dpi = require("beautiful").xresources.apply_dpi
require("ui.theme_launcher.content_settings")

screen.connect_signal("request::desktop_decoration", function(s)
	-- variables --

	local characters_entered = 0

	-- widgets --

	local username = wibox.widget.textbox()
	username.halign = "center"
	username.font = beautiful.font .. " 17"

	awful.spawn.easy_async({ "sh", "-c", [[whoami | sed 's/.*/\u&/']] }, function(stdout)
		username.text = "@" .. stdout
	end)

	local prompt = wibox.widget({
		widget = wibox.widget.textbox,
		markup = helpers.ui.colorizeText("enter password...", beautiful.background_accent),
		align = "center",
	})

	local main = wibox({
		width = s.geometry.width,
		height = s.geometry.height,
		bg = beautiful.background_alt,
		ontop = true,
		visible = false,
	})

	main:setup({
		widget = wibox.container.place,
		valign = "center",
		halign = "center",
		{
			widget = wibox.container.background,
			bg = beautiful.background,
			fg = beautiful.foreground,
			-- border_width = beautiful.border_width,
			-- border_color = beautiful.accent,
			{
				widget = wibox.container.margin,
				top = dpi(90),
				bottom = dpi(90),
				left = dpi(140),
				right = dpi(140),
				{
					layout = wibox.layout.fixed.vertical,
					spacing = dpi(20),
					{
						widget = wibox.widget.textclock,
						format = "Time %H:%M",
						refresh = dpi(20),
						font = beautiful.font .. " 38",
						halign = "center",
						valign = "center",
					},
					{
						widget = wibox.widget.textclock,
						format = "%d %B %Y",
						refresh = dpi(20),
						font = beautiful.font .. " 23",
						halign = "center",
						valign = "center",
					},
					{
						widget = wibox.container.background,
						bg = beautiful.background,
						forced_height = dpi(35),
					},
					{
						layout = wibox.layout.fixed.vertical,
						username,
						{
							widget = wibox.container.background,
							bg = beautiful.background_alt,
							-- border_width = beautiful.border_width,
							-- border_color = beautiful.accent,
							{
								widget = wibox.container.margin,
								margins = dpi(13),
								{
									widget = wibox.container.background,
									forced_width = dpi(240),
									prompt,
								},
							},
						},
					},
				},
			},
		},
	})

	-- Reset

	local function reset()
		characters_entered = 0
		prompt.markup = helpers.ui.colorizeText("enter password...", beautiful.background_accent)
	end

	-- Fail

	local function fail()
		characters_entered = 0
		prompt.markup = helpers.ui.colorizeText("try again...", beautiful.background_accent)
	end

	-- Try password
	local function try_password(pass)
		awful.spawn.easy_async({ "sh", "-c", "echo " .. pass .. " | sudo -S echo testing_password" }, function(stdout)
			if string.find(stdout, "testing_password") then
				naughty.notification({
					urgency = "critical",
					title = "correct",
					message = "passord",
				})
			else
				naughty.notification({
					urgency = "critical",
					title = "incorrect",
					message = "dont passord",
				})
			end
		end)
	end

	-- Input

	local function grabpassword()
		awful.spawn.with_shell("$HOME/.config/awesome/other/picom/launch.sh --no-opacity")
		awful.prompt.run({
			hooks = {
				{
					{},
					"Escape",
					function(_)
						reset()
						grabpassword()
					end,
				},
			},
			keypressed_callback = function(_, key)
				-- if key == "s" then
				-- 	awful.spawn("flameshot gui")

				if #key == 1 then
					characters_entered = characters_entered + 1
					prompt.markup = helpers.ui.colorizeText(string.rep("*", characters_entered), "")
				elseif key == "BackSpace" then
					if characters_entered > 1 then
						characters_entered = characters_entered - 1
						prompt.markup = helpers.ui.colorizeText(string.rep("*", characters_entered), "")
					else
						characters_entered = 0
						prompt.markup = helpers.ui.colorizeText("enter password...", beautiful.background_accent)
					end
				end
			end,
			exe_callback = function(input)
				awful.spawn.easy_async(
					{ "sh", "-c", "echo " .. input .. " | sudo -S echo testing_password" },
					function(stdout)
						if string.find(stdout, "testing_password") then
							reset()
							if current_settings.setting_opacity == true then
								awful.spawn.with_shell("$HOME/.config/awesome/other/picom/launch.sh --opacity")
							else
								awful.spawn.with_shell("$HOME/.config/awesome/other/picom/launch.sh --no-opacity")
							end
							main.visible = false
						else
							fail()
							grabpassword()
						end
					end
				)
			end,
			textbox = wibox.widget.textbox(),
		})
	end

	-- Lock --

	function lockscreen()
		main.visible = true
		grabpassword()
	end
end)
