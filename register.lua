local mp = require 'mp'

return function(translate, o)
	return function ()
		if o.running then return end

		-- Enshure sync only once
		local delay = mp.get_property_number('sub-delay', 0)
		if delay ~= 0 and delay ~= o.defaultDelay then
			o.defaultDelay = delay
		end

		mp.set_property('sub-delay', o.defaultDelay - 0.5)
		mp.observe_property('sub-start', 'string', function()
			translate.on_sub_changed(nil, mp.get_property('sub-text-ass'))
		end)
		mp.set_property('sub-visibility', 'no')

		o.running = true
		mp.msg.info('Started')
	end
end