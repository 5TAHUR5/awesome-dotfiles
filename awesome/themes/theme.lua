local gears = require("gears")
local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local rnotification = require("ruled.notification")

local theme = {}

theme.font = "JetBrainsMono Nerd Font 11"

theme.useless_gap = 5


-- icons ---------------------------------------

theme.awesome_icon = "~/.config/awesome/themes/icons/awesome.png"
theme.profile_image = "~/.config/awesome/themes/icons/profile_img.svg"
theme.notification_icon = "~/.config/awesome/themes/icons/bell.svg"
theme.notification_icon_error = "~/.config/awesome/themes/icons/alert.svg"
theme.notification_icon_scrensht = "~/.config/awesome/themes/icons/camera.svg"

-- colors -------------------------------------

theme.background = "#191919"
theme.background_alt = "#292929"
theme.background_urgent = "#393939"
theme.background_accent = "#454545"
theme.foreground = "#f0f0f0"

theme.green = "#9ec49f"

theme.yellow = "#c4c19e"
theme.blue = "#a5b4cb"
theme.red = "#c49ea0"
theme.orange = "#ceb188"
theme.violet = "#c49ec4"
theme.accent = theme.red

-- tray ----------------------------------------

theme.bg_systray = theme.background_alt
theme.systray_icon_spacing = 6

-- titlebar ------------------------------------

theme.titlebar_bg_normal = theme.background_alt
theme.titlebar_fg_normal = theme.foreground
theme.titlebar_bg_focus = theme.background_alt
theme.titlebar_fg_focus = theme.foreground
theme.titlebar_bg_urgent = theme.background_alt
theme.titlebar_fg_urgent = theme.foreground

theme.titlebar_close_button_normal = "~/.config/awesome/themes/icons/inactive_button.svg"
theme.titlebar_close_button_focus = "~/.config/awesome/themes/icons/close_button.svg"

theme.titlebar_minimize_button_normal = "~/.config/awesome/themes/icons/inactive_button.svg"
theme.titlebar_minimize_button_focus = "~/.config/awesome/themes/icons/minimize_button.svg"

theme.titlebar_maximized_button_normal_inactive = "~/.config/awesome/themes/icons/inactive_button.svg"
theme.titlebar_maximized_button_focus_inactive = "~/.config/awesome/themes/icons/maximize_button.svg"
theme.titlebar_maximized_button_normal_active = "~/.config/awesome/themes/icons/inactive_button.svg"
theme.titlebar_maximized_button_focus_active = "~/.config/awesome/themes/icons/maximize_button.svg"


-- borders -------------------------------------

theme.border_width = 2
theme.border_color_normal = theme.background_urgent
theme.border_color_active = theme.accent

-- default vars --------------------------------

theme.bg_normal = theme.background
theme.fg_normal = theme.foreground

-- notification --------------------------------

theme.notification_spacing = 20 + theme.border_width * 2

-- taglist -------------------------------------

theme.taglist_shape_border_width = theme.border_width
theme.taglist_shape_border_color = theme.background_accent
theme.taglist_bg_focus = theme.background_accent
theme.taglist_fg_focus = theme.foreground
theme.taglist_shape_border_color_focus = theme.accent
theme.taglist_bg_urgent = theme.accent
theme.taglist_fg_urgent = theme.foreground
theme.taglist_shape_border_color_urgent = theme.background_accent
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
theme.awesome_dock_spacing = 10
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
theme.icon_theme = Papirus

return theme

