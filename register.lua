local mp = require 'mp'
local logger = require 'logger' ('register')

---@param translate Translator
---@param o ScriptOptions
---@param overlay OverlayWrapper
return function (translate, o, overlay)
	return function ()
		if o.running then return end

		-- Need when user has custom subtitle offset
		o.userDelay = mp.get_property_number('sub-delay', 0)
		logger.trace('Picking up userDelay', o.userDelay)

		o.actualDelay = o.userDelay + (o.defaultDelay)
		mp.set_property('sub-delay', o.actualDelay)
		mp.observe_property('sub-start', 'string', translate.onSubChanged)
		mp.set_property('sub-visibility', 'no')

		overlay:reload()

		o.running = true
		logger.info('Enabled')
	end
end
