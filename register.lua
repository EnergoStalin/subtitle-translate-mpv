local mp = require 'mp'

return function (translate, o, overlay)
	return function ()
		if o.running then return end

		-- Need when user has custom subtitle offset
		o.userDelay = mp.get_property_number('sub-delay', 0)
		mp.msg.trace('[register] Picking up userDelay', o.userDelay)

		o.actualDelay = o.userDelay + (o.defaultDelay)
		mp.set_property('sub-delay', o.actualDelay)
		mp.observe_property('sub-start', 'string', translate.onSubChanged)
		mp.set_property('sub-visibility', 'no')

		overlay:reload()

		o.running = true
		mp.msg.info('Enabled')
	end
end
