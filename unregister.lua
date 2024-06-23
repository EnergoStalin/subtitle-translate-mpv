local mp = require 'mp'
local logger = require 'logger' ('unregister')

---@param translate Translator
---@param o ScriptOptions
---@param overlay OverlayWrapper
return function (translate, o, overlay)
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
