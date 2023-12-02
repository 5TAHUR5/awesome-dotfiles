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

theme.font = "JetBrainsMono Nerd Font 11"

theme.useless_gap = dpi(5)


-- icons ---------------------------------------

theme.lut_mountain = "~/.config/awesome/themes/luts/mountain.png"
theme.awesome_icon = "~/.config/awesome/themes/icons/awesome.png"
theme.notification_icon = "~/.config/awesome/themes/icons/bell.svg"
theme.notification_icon_error = "~/.config/awesome/themes/icons/alert.svg"
theme.notification_icon_scrensht = "~/.config/awesome/themes/icons/camera.svg"
theme.no_song = "~/.config/awesome/themes/icons/no_song.png"

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

