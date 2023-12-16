local mp = require 'mp'

return function (translate, o, overlay)
	return function ()
		if not o.running then return end

		mp.unobserve_property(translate.onSubChanged)
		mp.set_property('sub-visibility', 'yes')
		mp.set_property('sub-delay', o.userDelay)

		mp.msg.debug('[unregister] Restoring userDelay', o.userDelay)

		overlay:remove()

		if o.disabledManually then
			translate.resetTicker(o.defaultDelay)
		end

		o.running = false
		mp.msg.info('Disabled')
	end
end
