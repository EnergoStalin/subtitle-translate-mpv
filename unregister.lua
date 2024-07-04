local mp = require 'mp'
local logger = require 'logger' ('unregister')

---@param translate Translator
---@param overlay OverlayWrapper
---@param o ScriptOptions
return function (translate, overlay, o)
	return function ()
		if not o.running then return end

		mp.unobserve_property(translate.onSubChanged)
		mp.set_property('sub-visibility', 'yes')
		mp.set_property('sub-delay', o.userDelay)

		logger.debug('Restoring userDelay', o.userDelay)

		overlay:remove()

		if o.disabledManually then
			translate.resetTicker(o.defaultDelay)
		end

		o.running = false
		logger.info('Disabled')
	end
end
