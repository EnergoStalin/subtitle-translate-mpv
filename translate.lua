local mp = require 'mp'

---@param provider table
---@param overlay table
---@param options table
---@return table
local function constructor(provider, overlay, options)
	local m = {}
	local avg = require 'modules.average' (options.defaultDelay, mp.get_time, options.sensitivity)

	function m.onSubChanged()
		local value = mp.get_property('sub-text-ass')
		if value == nil or value == '' then
			overlay:hide()
			return
		end

		avg:tick()
		value = value:gsub('\\N', ' \\N '):gsub('\\n', ' \\n ')
    mp.msg.debug('[translate] request', value)
		local ok, data = pcall(provider.translate, value)
		if not ok then
			mp.msg.error('[translate] Error ' .. provider.get_error(data))
			return
		end

		overlay:setTranslation(data, value)

		local delay = options.actualDelay - avg:tick()
		mp.msg.debug('[translate] Applying sub-delay', delay)
    mp.msg.debug('[translate] response', data)
		mp.set_property('sub-delay', delay)

		overlay:reveal()
	end

	function m.resetTicker(delay)
		mp.msg.debug('[translate] Resetting ticker to', delay)
		avg:reset(delay)
	end

	return m
end

return constructor