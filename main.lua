local mp = require 'mp'
local clip = require 'clipboard'
local events = require 'events'

local running = false

mp.set_property('sub-delay', 0.5)

local overlay = mp.create_osd_overlay('ass-events')
events.display(overlay)

mp.register_script_message("enable-sub-translator", function ()
	if running then return end

	mp.observe_property('sub-text', 'string', events.on_sub_changed)
	mp.set_property('sub-visibility', 'no')
	running = true
end)

mp.register_script_message("disable-sub-translator", function ()
	mp.unobserve_property(events.on_sub_changed)
	mp.set_property('sub-visibility', 'yes')
	overlay:remove()
	running = false
end)

mp.register_script_message("copy-sub-to-clipboard", function ()
	clip.set(mp.get_property('sub-text'))
end)
