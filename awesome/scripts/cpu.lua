local awful = require("awful")
local naughty = require("naughty")
local beautiful = require("beautiful")

local update_interval = 4
local cpu_idle_script = [[
	sh -c "
	vmstat 1 2 | tail -1 | awk '{printf \"%d\", $15}'
	"]]
local cpu_stream_list_script = [[ps -eo user,pid,ppid,%cpu,%mem,comm --sort=-%cpu | grep $USER | awk '$4!=0{print $0}' | awk '$6!="ps"{print $0}' | awk '{$1="";$3="";$5=""; print $0}' | awk '{print $1 "|" $2 "|" substr($0, index($0,$3))}']]


awful.widget.watch(cpu_idle_script, update_interval, function(widget, stdout)
	local cpu_idle = stdout
	cpu_idle = string.gsub(cpu_idle, '^%s*(.-)%s*$', '%1')
	awesome.emit_signal("signal::cpu", 100 - tonumber(cpu_idle))
end)


