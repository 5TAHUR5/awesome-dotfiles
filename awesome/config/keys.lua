local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")
local helpers = require("helpers")
local bling = require("modules.bling")
local paths = require("helpers.paths")
local playerctl = bling.signal.playerctl.lib()
require("scripts")

mod = "Mod4"
alt = "Mod1"
ctrl = "Control"
shift = "Shift"
terminal = "alacritty"

awful.keyboard.append_global_keybindings({
	-- launch programms --

	awful.key({ mod }, "Return", function()
		awful.spawn(terminal)
	end),
	awful.key({}, "Print", function()
		awful.spawn("flameshot gui")
	end),
	awful.key({ mod }, "t", function()
		awful.spawn("ayugram-desktop")
	end),
	--awful.key({}, "Print", function() awful.spawn.easy_async_with_shell("sleep 3 && flameshot gui") end),
	awful.key({ mod }, "m", function()
		awesome.emit_signal("capture::set_capture", "toggle")
	end),

	awful.key({}, "Num_Lock", function()
		awesome.emit_signal("numlock::toggle")
	end),

	awful.key({}, "Caps_Lock", function()
		awesome.emit_signal("capslock::toggle")
	end),

	-- rofi --

	awful.key({ mod }, "d", function()
		awful.spawn("rofi -show drun -config .config/awesome/other/rofi/configs/launcher.rasi")
	end),
	awful.key({ mod }, "v", function()
		awful.spawn(
			"rofi -modi 'clipboard:"
				.. paths.to_bin_greenclip
				.. " print' -show clipboard -config  .config/awesome/other/rofi/configs/greenclip.rasi"
		)
	end),

	-- volume up/down/mute --

	awful.key({}, "XF86AudioRaiseVolume", function()
		awesome.emit_signal("volume::set_volume", "2%+")
		awesome.emit_signal("summon::osd")
	end),
	awful.key({}, "XF86AudioLowerVolume", function()
		awesome.emit_signal("volume::set_volume", "2%-")
		awesome.emit_signal("summon::osd")
	end),
	awful.key({}, "XF86AudioMute", function()
		awesome.emit_signal("volume::set_volume", "toggle")
		awesome.emit_signal("summon::osd")
	end),

	-- playerctl stop/play/next/previous

	awful.key({}, "XF86AudioPause", function()
		playerctl:play_pause()
	end),
	awful.key({}, "XF86AudioPlay", function()
		playerctl:play_pause()
	end),

	awful.key({}, "XF86AudioPrev", function()
		awesome.emit_signal("player::set_position", -5)
	end),
	awful.key({}, "XF86AudioNext", function()
		awesome.emit_signal("player::set_position", 5)
	end),

	--awful.key({}, "XF86AudioPrev", function()
	--	playerctl:previous()
	--end),
	--awful.key({}, "XF86AudioNext", function()
	--	playerctl:next()
	--end),

	-- brightness up/down --

	awful.key({}, "XF86MonBrightnessUp", function()
		awesome.emit_signal("bright::set_bright", "5%+")
		awesome.emit_signal("summon::osd")
	end),
	awful.key({}, "XF86MonBrightnessDown", function()
		awesome.emit_signal("bright::set_bright", "5%-")
		awesome.emit_signal("summon::osd")
	end),

	-- binds to widgets --

	awful.key({ mod }, "c", function()
		awesome.emit_signal("summon::calendar_widget")
	end),
	awful.key({ mod }, "w", function()
		awesome.emit_signal("summon::control")
	end),
	awful.key({ mod, shift }, "b", function()
		awesome.emit_signal("hide::bar")
	end),
	awful.key({ mod }, "x", function()
		awesome.emit_signal("summon::powermenu")
	end),

	-- switching a focus client --

	awful.key({ mod }, "l", function()
		awful.client.focus.byidx(1)
	end),
	awful.key({ mod }, "h", function()
		awful.client.focus.byidx(-1)
	end),
	awful.key({ mod }, "Right", function()
		awful.client.focus.byidx(1)
	end),
	awful.key({ mod }, "Left", function()
		awful.client.focus.byidx(-1)
	end),

	-- focus to tag --

	awful.key({
		modifiers = { mod },
		keygroup = "numrow",
		on_press = function(index)
			local screen = awful.screen.focused()
			local tag = screen.tags[index]
			if tag then
				tag:view_only()
			end
		end,
	}),

	-- move focused client to tag --

	awful.key({
		modifiers = { mod, shift },
		keygroup = "numrow",
		on_press = function(index)
			if client.focus then
				local tag = client.focus.screen.tags[index]
				if tag then
					client.focus:move_to_tag(tag)
				end
			end
		end,
	}),

	-- restart wm --

	awful.key({ mod, shift }, "r", awesome.restart),

	-- resize client --

	awful.key({ mod, ctrl }, "k", function(c)
		helpers.client.resize_client(client.focus, "up")
	end),
	awful.key({ mod, ctrl }, "j", function(c)
		helpers.client.resize_client(client.focus, "down")
	end),
	awful.key({ mod, ctrl }, "h", function(c)
		helpers.client.resize_client(client.focus, "left")
	end),
	awful.key({ mod, ctrl }, "l", function(c)
		helpers.client.resize_client(client.focus, "right")
	end),

	awful.key({ mod, ctrl }, "Up", function(c)
		helpers.client.resize_client(client.focus, "up")
	end),
	awful.key({ mod, ctrl }, "Down", function(c)
		helpers.client.resize_client(client.focus, "down")
	end),
	awful.key({ mod, ctrl }, "Left", function(c)
		helpers.client.resize_client(client.focus, "left")
	end),
	awful.key({ mod, ctrl }, "Right", function(c)
		helpers.client.resize_client(client.focus, "right")
	end),

	-- change padding tag on fly --

	awful.key({ mod, shift }, "=", function()
		helpers.client.resize_padding(beautiful.useless_gap)
	end),
	awful.key({ mod, shift }, "-", function()
		helpers.client.resize_padding(-beautiful.useless_gap)
	end),

	-- change useless gap on fly --

	awful.key({ mod }, "=", function()
		helpers.client.resize_gaps(beautiful.useless_gap)
	end),
	awful.key({ mod }, "-", function()
		helpers.client.resize_gaps(-beautiful.useless_gap)
	end),
})

-- mouse binds --

client.connect_signal("request::default_mousebindings", function()
	awful.mouse.append_client_mousebindings({
		awful.button({}, 1, function(c)
			c:activate({ context = "mouse_click" })
		end),
		awful.button({ mod }, 1, function(c)
			c:activate({ context = "mouse_click", action = "mouse_move" })
		end),
		awful.button({ mod }, 3, function(c)
			c:activate({ context = "mouse_click", action = "mouse_resize" })
		end),
	})
end)

-- client binds --

client.connect_signal("request::default_keybindings", function()
	awful.keyboard.append_client_keybindings({
		awful.key({ mod }, "f", function(c)
			awesome.emit_signal("summon::close")
			c.fullscreen = not c.fullscreen
			c:raise()
		end),
		awful.key({ mod }, "q", function(c)
			c:kill()
		end),
		awful.key({ mod }, "s", awful.client.floating.toggle),

		-- Move or swap by direction --
		-- letters --
		awful.key({ mod, shift }, "k", function(c)
			helpers.client.move_client(c, "up")
		end),
		awful.key({ mod, shift }, "j", function(c)
			helpers.client.move_client(c, "down")
		end),
		awful.key({ mod, shift }, "h", function(c)
			helpers.client.move_client(c, "left")
		end),
		awful.key({ mod, shift }, "l", function(c)
			helpers.client.move_client(c, "right")
		end),

		-- arrows --
		awful.key({ mod, shift }, "Up", function(c)
			helpers.client.move_client(c, "up")
		end),
		awful.key({ mod, shift }, "Down", function(c)
			helpers.client.move_client(c, "down")
		end),
		awful.key({ mod, shift }, "Left", function(c)
			helpers.client.move_client(c, "left")
		end),
		awful.key({ mod, shift }, "Right", function(c)
			helpers.client.move_client(c, "right")
		end),

		--- Relative move  floating client --

		-- letters --
		awful.key({ mod, shift, ctrl }, "j", function(c)
			c:relative_move(0, 20, 0, 0)
		end),
		awful.key({ mod, shift, ctrl }, "k", function(c)
			c:relative_move(0, -20, 0, 0)
		end),
		awful.key({ mod, shift, ctrl }, "h", function(c)
			c:relative_move(-20, 0, 0, 0)
		end),
		awful.key({ mod, shift, ctrl }, "l", function(c)
			c:relative_move(20, 0, 0, 0)
		end),

		-- arrows --
		awful.key({ mod, shift, ctrl }, "Down", function(c)
			c:relative_move(0, 20, 0, 0)
		end),
		awful.key({ mod, shift, ctrl }, "Up", function(c)
			c:relative_move(0, -20, 0, 0)
		end),
		awful.key({ mod, shift, ctrl }, "Left", function(c)
			c:relative_move(-20, 0, 0, 0)
		end),
		awful.key({ mod, shift, ctrl }, "Right", function(c)
			c:relative_move(20, 0, 0, 0)
		end),
	})
end)
