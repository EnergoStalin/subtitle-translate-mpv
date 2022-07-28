local mp = require 'mp'
local clip = require 'clipboard'
local events = require 'events'

mp.set_property('sub-delay', 0.5)

local overlay = mp.create_osd_overlay('ass-events')
events.display(overlay)

mp.register_script_message("enable-sub-translator", function ()
	mp.observe_property('sub-text', 'string', events.on_sub_changed)
	mp.set_property('sub-visibility', 'no')
end)

mp.register_script_message("disable-sub-translator", function ()
	mp.unobserve_property(on_sub_changed)
	mp.set_property('sub-visibility', 'yes')
	overlay:remove()
end)

mp.register_script_message("copy-sub-to-clipboard", function ()
	clip.set(mp.get_property('sub-text'))
end)
