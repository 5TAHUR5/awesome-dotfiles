local awful = require("awful")
local ruled = require("ruled")

-- Rules ----------------

ruled.client.connect_signal("request::rules", function()

-- global ---------------
ruled.client.append_rule {
	id = "global",
	rule = { },
	properties = {
		focus = awful.client.focus.filter,
		raise = true,
		size_hints_honor = false,
		screen = awful.screen.preferred,
		placement = function(c)
			awful.placement.centered(c, c.transient_for)
			awful.placement.no_overlap(c)
			awful.placement.no_offscreen(c)
		end,
	}
}

ruled.client.append_rule {
	rule_any = { class = { "Engrampa" } },
	properties = { floating = true},
	callback = function(c)
		awful.placement.centered(c, nil)
	end
}

end)

client.connect_signal("mouse::enter", function(c)
    c:activate { context = "mouse_enter", raise = false }
end)

-- Center dialogs over screen ---- 

client.connect_signal('request::manage', function(c)
	if c.transient_for then
		awful.placement.centered(c, c.transient_for)
		awful.placement.no_offscreen(c)
	end
end)
