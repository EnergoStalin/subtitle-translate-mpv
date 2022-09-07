local mp = require 'mp'

return function(translate, o, overlay)
	return function()
	if not o.running then return end

		mp.unobserve_property(translate.on_sub_changed)
		mp.set_property('sub-visibility', 'yes')
		mp.set_property('sub-delay', o.defaultDelay)
		overlay:remove()

		o.running = false
		mp.msg.info('Stopped')
	end
end