-- to require: local paths = require("helpers.paths")


local paths = {}

paths.home_dir = os.getenv("HOME")
paths.to_dir_awesome = paths.home_dir .. "/.config/awesome"

paths.to_script_autostart = paths.to_dir_awesome .. "/autostart.sh"
paths.to_file_beautiful_theme = paths.to_dir_awesome .. "/themes/theme.lua"

-- other
paths.to_bin_greenclip = paths.to_dir_awesome .. "/other/bin/greenclip"

-- walls 
paths.to_dir_walls = paths.home_dir .. "/.walls/"
paths.to_dir_lite_walls = paths.to_dir_awesome .. "/other/lite_walls/"
paths.to_script_set_wallpaper = paths.to_dir_awesome .. "/other/bin/set_wallpaper"
paths.to_bin_lutgen = paths.to_dir_awesome .. "/other/bin/lutgen"

-- lutgens
paths.to_bin_lutgen = paths.to_dir_awesome .. "/other/bin/lutgen"
paths.to_dir_luts = paths.to_dir_awesome .. "/themes/luts/"
paths.to_dir_lut_palettes = paths.to_dir_luts .. "palettes/"
paths.to_script_generate_lut = paths.to_dir_lut_palettes .. "generate_lut.sh"

-- picom
paths.to_dir_picom = paths.to_dir_awesome .. "/other/picom/"
paths.to_script_picom_launch = paths.to_dir_picom .. "launch.sh"

-- color schemes for awesome
paths.to_dir_color_schemes = paths.to_dir_awesome .. "/themes/color_schemes/"
paths.to_dir_theme_layouts_icons = paths.to_dir_awesome .. "/themes/icons/layouts/min/"

-- last changes
paths.to_dir_last_changes = paths.to_dir_awesome .. "/themes/last_changes/"
paths.to_file_last_wall = paths.to_dir_last_changes .. "last_wall"
paths.to_file_last_color_scheme = paths.to_dir_last_changes .. "last_color_scheme"
paths.to_file_last_settings = paths.to_dir_last_changes .. "last_settings"

-- control
paths.to_script_crutch_fetch = paths.to_dir_awesome .. "/other/bin/crutch_fetch"


return paths