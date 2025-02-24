local gears = require("gears")
local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local rnotification = require("ruled.notification")
local paths = require("helpers.paths")
local dpi = require('beautiful').xresources.apply_dpi

local binser = require("modules.binser.binser")
local results, len = binser.readFile(paths.to_file_last_color_scheme)
local color_scheme = require("themes.color_schemes." .. results[1].last_scheme_name)


local theme = {}

theme.font = "DaddyTimeMono Nerd Font 11"

theme.useless_gap = dpi(5)


-- icons ---------------------------------------

theme.lut_mountain = "~/.config/awesome/themes/luts/mountain.png"
theme.awesome_icon = "~/.config/awesome/themes/icons/awesome.png"
theme.notification_icon = "~/.config/awesome/themes/icons/bell.svg"
theme.notification_icon_error = "~/.config/awesome/themes/icons/alert.svg"
theme.notification_icon_scrensht = "~/.config/awesome/themes/icons/camera.svg"
theme.no_song = "~/.config/awesome/themes/icons/no_song.png"

theme.icon_bar_bell = paths.to_dir_theme_bar_icons .. "bell.svg"
theme.icon_bar_bell_slash = paths.to_dir_theme_bar_icons .. "bell_slash.svg"
theme.icon_bar_keyboard = paths.to_dir_theme_bar_icons .. "keyboard.svg"
theme.icon_bar_microphone_mute = paths.to_dir_theme_bar_icons .. "microphone_mute.svg"
theme.icon_bar_microphone = paths.to_dir_theme_bar_icons .. "microphone.svg"
theme.icon_bar_speaker_mute = paths.to_dir_theme_bar_icons .. "speaker_mute.svg"
theme.icon_bar_speaker_low = paths.to_dir_theme_bar_icons .. "speaker_low.svg"
theme.icon_bar_speaker_full = paths.to_dir_theme_bar_icons .. "speaker_full.svg"
theme.icon_bar_calendar = paths.to_dir_theme_bar_icons .. "calendar.svg"
theme.icon_bar_clock = paths.to_dir_theme_bar_icons .. "clock.svg"
theme.icon_bar_battery_charging = paths.to_dir_theme_bar_icons .. "battery_charging.svg"
theme.icon_bar_battery_100 = paths.to_dir_theme_bar_icons .. "battery_100.svg"
theme.icon_bar_battery_75 = paths.to_dir_theme_bar_icons .. "battery_75.svg"
theme.icon_bar_battery_50 = paths.to_dir_theme_bar_icons .. "battery_50.svg"
theme.icon_bar_battery_25 = paths.to_dir_theme_bar_icons .. "battery_25.svg"
theme.icon_bar_arrow_left = paths.to_dir_theme_bar_icons .. "arrow_left.svg"
theme.icon_bar_arrow_right = paths.to_dir_theme_bar_icons .. "arrow_right.svg"
theme.icon_bar_bright = paths.to_dir_theme_bar_icons .. "bright.svg"
theme.icon_bar_num_on = paths.to_dir_theme_bar_icons .. "num_on.svg"
theme.icon_bar_num_off = paths.to_dir_theme_bar_icons .. "num_off.svg"
theme.icon_bar_caps_lock_on = paths.to_dir_theme_bar_icons .. "caps_lock_on.svg"
theme.icon_bar_caps_lock_off = paths.to_dir_theme_bar_icons .. "caps_lock_off.svg"

theme.icon_float_bright = paths.to_dir_theme_float_icons .. "bright.svg"
theme.icon_float_exit = paths.to_dir_theme_float_icons .. "exit.svg"
theme.icon_float_lock = paths.to_dir_theme_float_icons .. "lock.svg"
theme.icon_float_poweroff = paths.to_dir_theme_float_icons .. "poweroff.svg"
theme.icon_float_reboot = paths.to_dir_theme_float_icons .. "reboot.svg"
theme.icon_float_trash = paths.to_dir_theme_float_icons .. "trash.svg"
theme.icon_float_speaker_mute = paths.to_dir_theme_float_icons .. "speaker_mute.svg"
theme.icon_float_speaker_low = paths.to_dir_theme_float_icons .. "speaker_low.svg"
theme.icon_float_speaker_full = paths.to_dir_theme_float_icons .. "speaker_full.svg"
theme.icon_float_opacity = paths.to_dir_theme_float_icons .. "opacity.svg"
theme.icon_float_titlebar = paths.to_dir_theme_float_icons .. "titlebar.svg"
theme.icon_float_border = paths.to_dir_theme_float_icons .. "border.svg"
theme.icon_float_border_top = paths.to_dir_theme_float_icons .. "border_top.svg"
theme.icon_float_border_bottom = paths.to_dir_theme_float_icons .. "border_bottom.svg"
theme.icon_float_border_right = paths.to_dir_theme_float_icons .. "border_right.svg"
theme.icon_float_border_left = paths.to_dir_theme_float_icons .. "border_left.svg"
theme.icon_float_app_launcher = paths.to_dir_theme_float_icons .. "app_launcher.svg"
theme.icon_float_layout = paths.to_dir_theme_float_icons .. "layout.svg"
theme.icon_float_num_0 = paths.to_dir_theme_float_icons .. "num_0.svg"
theme.icon_float_num_1 = paths.to_dir_theme_float_icons .. "num_1.svg"
theme.icon_float_num_2 = paths.to_dir_theme_float_icons .. "num_2.svg"
theme.icon_float_num_3 = paths.to_dir_theme_float_icons .. "num_3.svg"
theme.icon_float_num_4 = paths.to_dir_theme_float_icons .. "num_4.svg"
theme.icon_float_num_5 = paths.to_dir_theme_float_icons .. "num_5.svg"
theme.icon_float_num_6 = paths.to_dir_theme_float_icons .. "num_6.svg"
theme.icon_float_num_7 = paths.to_dir_theme_float_icons .. "num_7.svg"
theme.icon_float_num_8 = paths.to_dir_theme_float_icons .. "num_8.svg"
theme.icon_float_num_9 = paths.to_dir_theme_float_icons .. "num_9.svg"
theme.icon_float_no = paths.to_dir_theme_float_icons .. "no.svg"
theme.icon_float_no_small = paths.to_dir_theme_float_icons .. "no_small.svg"
theme.icon_float_yes = paths.to_dir_theme_float_icons .. "yes.svg"
theme.icon_float_yes_small = paths.to_dir_theme_float_icons .. "yes_small.svg"
theme.icon_float_right = paths.to_dir_theme_float_icons .. "right.svg"
theme.icon_float_left = paths.to_dir_theme_float_icons .. "left.svg"

theme.icon_control_alacritty = paths.to_dir_theme_control_icons .. "alacritty.svg"
theme.icon_control_awesomewm = paths.to_dir_theme_control_icons .. "awesomewm.svg"
theme.icon_control_close = paths.to_dir_theme_control_icons .. "close.svg"
theme.icon_control_download = paths.to_dir_theme_control_icons .. "download.svg"
theme.icon_control_hdd = paths.to_dir_theme_control_icons .. "hdd.svg"
theme.icon_control_image = paths.to_dir_theme_control_icons .. "image.svg"
theme.icon_control_left = paths.to_dir_theme_control_icons .. "left.svg"
theme.icon_control_memory = paths.to_dir_theme_control_icons .. "memory.svg"
theme.icon_control_processor = paths.to_dir_theme_control_icons .. "processor.svg"
theme.icon_control_next = paths.to_dir_theme_control_icons .. "next.svg"
theme.icon_control_package = paths.to_dir_theme_control_icons .. "package.svg"
theme.icon_control_pallete = paths.to_dir_theme_control_icons .. "pallete.svg"
theme.icon_control_pause = paths.to_dir_theme_control_icons .. "pause.svg"
theme.icon_control_play = paths.to_dir_theme_control_icons .. "play.svg"
theme.icon_control_previous = paths.to_dir_theme_control_icons .. "previous.svg"
theme.icon_control_right = paths.to_dir_theme_control_icons .. "right.svg"
theme.icon_control_settings = paths.to_dir_theme_control_icons .. "settings.svg"
theme.icon_control_temperature = paths.to_dir_theme_control_icons .. "temperature.svg"
theme.icon_control_terminal = paths.to_dir_theme_control_icons .. "terminal.svg"
theme.icon_control_timer = paths.to_dir_theme_control_icons .. "timer.svg"
theme.icon_control_upload = paths.to_dir_theme_control_icons .. "upload.svg"
theme.icon_control_user_circle = paths.to_dir_theme_control_icons .. "user_circle.svg"
theme.icon_control_wifi_1 = paths.to_dir_theme_control_icons .. "wifi_1.svg"
theme.icon_control_wifi_2 = paths.to_dir_theme_control_icons .. "wifi_2.svg"
theme.icon_control_internet = paths.to_dir_theme_control_icons .. "internet.svg"


-- colors -------------------------------------

theme.background = color_scheme.background
theme.background_alt = color_scheme.background_alt
theme.background_urgent = color_scheme.background_urgent
theme.background_accent = color_scheme.background_accent
theme.foreground = color_scheme.foreground
theme.fg_normal = color_scheme.foreground

theme.gray = color_scheme.gray
theme.green = color_scheme.green
theme.yellow = color_scheme.yellow
theme.blue = color_scheme.blue
theme.red = color_scheme.red
theme.orange = color_scheme.orange
theme.violet = color_scheme.violet
theme.accent = color_scheme.accent

-- tray ----------------------------------------

theme.bg_systray = theme.background_alt
theme.systray_icon_spacing = dpi(6)

-- titlebar --

theme.titlebar_bg_normal = theme.background_alt
theme.titlebar_fg_normal = theme.foreground
theme.titlebar_bg_focus = theme.background_alt
theme.titlebar_fg_focus = theme.foreground
theme.titlebar_bg_urgent = theme.background_alt
theme.titlebar_fg_urgent = theme.foreground

theme.titlebar_close_button_normal = gears.color.recolor_image(paths.to_dir_theme_titlebar_icons.."kill.svg", theme.red)
theme.titlebar_close_button_normal_hover = gears.color.recolor_image(paths.to_dir_theme_titlebar_icons.."kill.svg", theme.red)
theme.titlebar_close_button_normal_press = gears.color.recolor_image(paths.to_dir_theme_titlebar_icons.."kill.svg", theme.red)
theme.titlebar_close_button_focus = gears.color.recolor_image(paths.to_dir_theme_titlebar_icons.."kill.svg", theme.red)
theme.titlebar_close_button_focus_hover = gears.color.recolor_image(paths.to_dir_theme_titlebar_icons.."kill.svg", theme.red)
theme.titlebar_close_button_focus_press = gears.color.recolor_image(paths.to_dir_theme_titlebar_icons.."kill.svg", theme.red)

theme.titlebar_minimize_button_normal = gears.color.recolor_image(paths.to_dir_theme_titlebar_icons.."collapse.svg", theme.yellow)
theme.titlebar_minimize_button_normal_hover = gears.color.recolor_image(paths.to_dir_theme_titlebar_icons.."collapse.svg", theme.yellow)
theme.titlebar_minimize_button_normal_press = gears.color.recolor_image(paths.to_dir_theme_titlebar_icons.."collapse.svg", theme.yellow)
theme.titlebar_minimize_button_focus = gears.color.recolor_image(paths.to_dir_theme_titlebar_icons.."collapse.svg", theme.yellow)
theme.titlebar_minimize_button_focus_hover = gears.color.recolor_image(paths.to_dir_theme_titlebar_icons.."collapse.svg", theme.yellow)
theme.titlebar_minimize_button_focus_press = gears.color.recolor_image(paths.to_dir_theme_titlebar_icons.."collapse.svg", theme.yellow)

theme.titlebar_floating_button_normal = gears.color.recolor_image(paths.to_dir_theme_titlebar_icons.."floating.svg", theme.orange)
theme.titlebar_floating_button_normal_active = gears.color.recolor_image(paths.to_dir_theme_titlebar_icons.."floating_off.svg", theme.orange)
theme.titlebar_floating_button_normal_active_hover = gears.color.recolor_image(paths.to_dir_theme_titlebar_icons.."floating_off.svg", theme.orange)
theme.titlebar_floating_button_normal_active_press =  gears.color.recolor_image(paths.to_dir_theme_titlebar_icons.."floating_off.svg", theme.orange)
theme.titlebar_floating_button_focus_active = gears.color.recolor_image(paths.to_dir_theme_titlebar_icons.."floating_off.svg", theme.orange)
theme.titlebar_floating_button_focus_active_hover = gears.color.recolor_image(paths.to_dir_theme_titlebar_icons.."floating_off.svg", theme.orange)
theme.titlebar_floating_button_focus_active_press = gears.color.recolor_image(paths.to_dir_theme_titlebar_icons.."floating_off.svg", theme.orange)
theme.titlebar_floating_button_normal_inactive = gears.color.recolor_image(paths.to_dir_theme_titlebar_icons.."floating.svg", theme.orange)
theme.titlebar_floating_button_normal_inactive_hover = gears.color.recolor_image(paths.to_dir_theme_titlebar_icons.."floating.svg", theme.orange)
theme.titlebar_floating_button_normal_inactive_press = gears.color.recolor_image(paths.to_dir_theme_titlebar_icons.."floating.svg", theme.orange)
theme.titlebar_floating_button_focus_inactive = gears.color.recolor_image(paths.to_dir_theme_titlebar_icons.."floating.svg", theme.orange)
theme.titlebar_floating_button_focus_inactive_hover = gears.color.recolor_image(paths.to_dir_theme_titlebar_icons.."floating.svg", theme.orange)
theme.titlebar_floating_button_focus_inactive_press = gears.color.recolor_image(paths.to_dir_theme_titlebar_icons.."floating.svg", theme.orange)

theme.titlebar_maximized_button_normal = gears.color.recolor_image(paths.to_dir_theme_titlebar_icons.."fullscreen_off.svg", theme.green)
theme.titlebar_maximized_button_normal_active = gears.color.recolor_image(paths.to_dir_theme_titlebar_icons.."fullscreen_off.svg", theme.green)
theme.titlebar_maximized_button_normal_active_hover = gears.color.recolor_image(paths.to_dir_theme_titlebar_icons.."fullscreen_off.svg", theme.green)
theme.titlebar_maximized_button_normal_active_press = gears.color.recolor_image(paths.to_dir_theme_titlebar_icons.."fullscreen_off.svg", theme.green)
theme.titlebar_maximized_button_focus_active = gears.color.recolor_image(paths.to_dir_theme_titlebar_icons.."fullscreen_off.svg", theme.green)
theme.titlebar_maximized_button_focus_active_hover = gears.color.recolor_image(paths.to_dir_theme_titlebar_icons.."fullscreen_off.svg", theme.green)
theme.titlebar_maximized_button_focus_active_press = gears.color.recolor_image(paths.to_dir_theme_titlebar_icons.."fullscreen_off.svg", theme.green)
theme.titlebar_maximized_button_normal_inactive = gears.color.recolor_image(paths.to_dir_theme_titlebar_icons.."fullscreen.svg", theme.green)
theme.titlebar_maximized_button_normal_inactive_hover = gears.color.recolor_image(paths.to_dir_theme_titlebar_icons.."fullscreen.svg", theme.green)
theme.titlebar_maximized_button_normal_inactive_press = gears.color.recolor_image(paths.to_dir_theme_titlebar_icons.."fullscreen.svg", theme.green)
theme.titlebar_maximized_button_focus_inactive = gears.color.recolor_image(paths.to_dir_theme_titlebar_icons.."fullscreen.svg", theme.green)
theme.titlebar_maximized_button_focus_inactive_hover = gears.color.recolor_image(paths.to_dir_theme_titlebar_icons.."fullscreen.svg", theme.green)
theme.titlebar_maximized_button_focus_inactive_press = gears.color.recolor_image(paths.to_dir_theme_titlebar_icons.."fullscreen.svg", theme.green)

theme.titlebar_sticky_button_normal = gears.color.recolor_image(paths.to_dir_theme_titlebar_icons.."pin_off.svg", theme.blue)
theme.titlebar_sticky_button_normal_active = gears.color.recolor_image(paths.to_dir_theme_titlebar_icons.."pin_off.svg", theme.blue)
theme.titlebar_sticky_button_normal_active_hover = gears.color.recolor_image(paths.to_dir_theme_titlebar_icons.."pin_off.svg", theme.blue)
theme.titlebar_sticky_button_normal_active_press = gears.color.recolor_image(paths.to_dir_theme_titlebar_icons.."pin_off.svg", theme.blue)
theme.titlebar_sticky_button_focus_active = gears.color.recolor_image(paths.to_dir_theme_titlebar_icons.."pin_off.svg", theme.blue)
theme.titlebar_sticky_button_focus_active_hover = gears.color.recolor_image(paths.to_dir_theme_titlebar_icons.."pin_off.svg", theme.blue)
theme.titlebar_sticky_button_focus_active_press = gears.color.recolor_image(paths.to_dir_theme_titlebar_icons.."pin_off.svg", theme.blue)
theme.titlebar_sticky_button_normal_inactive = gears.color.recolor_image(paths.to_dir_theme_titlebar_icons.."pin.svg", theme.blue)
theme.titlebar_sticky_button_normal_inactive_hover = gears.color.recolor_image(paths.to_dir_theme_titlebar_icons.."pin.svg", theme.blue)
theme.titlebar_sticky_button_normal_inactive_press = gears.color.recolor_image(paths.to_dir_theme_titlebar_icons.."pin.svg", theme.blue)
theme.titlebar_sticky_button_focus_inactive = gears.color.recolor_image(paths.to_dir_theme_titlebar_icons.."pin.svg", theme.blue)
theme.titlebar_sticky_button_focus_inactive_hover = gears.color.recolor_image(paths.to_dir_theme_titlebar_icons.."pin.svg", theme.blue)
theme.titlebar_sticky_button_focus_inactive_press = gears.color.recolor_image(paths.to_dir_theme_titlebar_icons.."pin.svg", theme.blue)

theme.titlebar_ontop_button_normal = gears.color.recolor_image(paths.to_dir_theme_titlebar_icons.."ontop_off.svg", theme.violet)
theme.titlebar_ontop_button_normal_active = gears.color.recolor_image(paths.to_dir_theme_titlebar_icons.."ontop_off.svg", theme.violet)
theme.titlebar_ontop_button_normal_active_hover = gears.color.recolor_image(paths.to_dir_theme_titlebar_icons.."ontop_off.svg", theme.violet)
theme.titlebar_ontop_button_normal_active_press = gears.color.recolor_image(paths.to_dir_theme_titlebar_icons.."ontop_off.svg", theme.violet)
theme.titlebar_ontop_button_focus_active = gears.color.recolor_image(paths.to_dir_theme_titlebar_icons.."ontop_off.svg", theme.violet)
theme.titlebar_ontop_button_focus_active_hover = gears.color.recolor_image(paths.to_dir_theme_titlebar_icons.."ontop_off.svg", theme.violet)
theme.titlebar_ontop_button_focus_active_press = gears.color.recolor_image(paths.to_dir_theme_titlebar_icons.."ontop_off.svg", theme.violet)
theme.titlebar_ontop_button_normal_inactive = gears.color.recolor_image(paths.to_dir_theme_titlebar_icons.."ontop.svg", theme.violet)
theme.titlebar_ontop_button_normal_inactive_hover = gears.color.recolor_image(paths.to_dir_theme_titlebar_icons.."ontop.svg", theme.violet)
theme.titlebar_ontop_button_normal_inactive_press = gears.color.recolor_image(paths.to_dir_theme_titlebar_icons.."ontop.svg", theme.violet)
theme.titlebar_ontop_button_focus_inactive = gears.color.recolor_image(paths.to_dir_theme_titlebar_icons.."ontop.svg", theme.violet)
theme.titlebar_ontop_button_focus_inactive_hover = gears.color.recolor_image(paths.to_dir_theme_titlebar_icons.."ontop.svg", theme.violet)
theme.titlebar_ontop_button_focus_inactive_press = gears.color.recolor_image(paths.to_dir_theme_titlebar_icons.."ontop.svg", theme.violet)

-- borders -------------------------------------

theme.border_width = dpi(2)
theme.border_color_normal = theme.background_urgent
theme.border_color_active = theme.accent

-- default vars --------------------------------

theme.bg_normal = theme.background
theme.fg_normal = theme.foreground

-- notification --------------------------------

theme.notification_spacing = dpi(10) + theme.border_width * 2

-- tasklist --

theme.tasklist_bg_normal = theme.accent .. "88"
theme.tasklist_bg_focus = theme.accent
theme.tasklist_bg_urgent = theme.foreground
theme.tasklist_bg_minimize = theme.background_accent


-- taglist -------------------------------------

theme.taglist_shape_border_width = theme.border_width
theme.taglist_shape_border_color = theme.background_accent
theme.taglist_bg_focus = theme.background_accent
theme.taglist_fg_focus = theme.foreground
theme.taglist_shape_border_color_focus = theme.accent
theme.taglist_bg_urgent = theme.accent .. "cc"
theme.taglist_fg_urgent = theme.background
theme.taglist_shape_border_color_urgent = theme.accent
theme.taglist_bg_occupied = theme.background_alt
theme.taglist_fg_occupied = theme.foreground
theme.taglist_bg_empty = theme.background
theme.taglist_fg_empty = theme.foreground
theme.taglist_bg_volatile = theme.background_alt
theme.taglist_fg_volatile = theme.foreground


theme.awesome_dock_size = 80
theme.awesome_dock_pinned = {
	{"thunar"},
	{"kitty"}
}
theme.awesome_dock_color_active = theme.accent
theme.awesome_dock_color_inactive = theme.background_alt
theme.awesome_dock_color_minimized = theme.yellow
theme.awesome_dock_color_hover = theme.background_urgent
theme.awesome_dock_color_bg = theme.background
theme.awesome_dock_disabled = false
theme.awesome_dock_spacing = dpi(10)
theme.awesome_dock_timeout = 1.2

-- bling ----------------------------------------

theme.playerctl_player  = {"%any"}
theme.playerctl_update_on_activity = true
theme.playerctl_position_update_interval = 1

-- tooltips -------------------------------------

theme.tooltip_bg = theme.background
theme.tooltip_fg = theme.foreground
theme.tooltip_border_width = theme.border_width

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = Breeze

return theme

