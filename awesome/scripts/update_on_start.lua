local gears = require("gears")

gears.timer({
	autostart = true,
	timeout = 2,
	callback = function()
		update_volume()
		update_microphone()
		update_value_of_bright()
		awesome.emit_signal("numlock::toggle")
		awesome.emit_signal("capslock::toggle")
	end,
	single_shot = true, -- one do callback and off
})
