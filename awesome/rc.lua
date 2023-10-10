pcall(require, "luarocks.loader")
local awful = require("awful")
require("awful.autofocus")
local beautiful = require("beautiful")

awful.spawn.with_shell("~/.config/awesome/autostart.sh")
beautiful.init("~/.config/awesome/themes/theme.lua")
require("config")
require("ui")

--my