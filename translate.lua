local mp = require 'mp'
local cache = require 'cache'

---@param provider table
---@param overlay table
---@param options table
---@return table
local function constructor(provider, overlay, options)
	local avg = require 'modules.average' (options.defaultDelay, mp.get_time, options.sensitivity)

	local m = {}

	function m.onSubChanged()
		local value = mp.get_property('sub-text-ass')
		if value == nil or value == '' then
			overlay:hide()
			return
		end

		avg:tick()
		value = value:gsub('\\N', ' \\N '):gsub('\\n', ' \\n ')
		mp.msg.debug('[translate] -> ', value)

		local cached = cache.get(value)
		if cached ~= nil then
			mp.set_property_number('sub-delay', options.userDelay)
			overlay:setTranslation(cached, value)
			mp.msg.debug('[translate] <- (C) ', cached)
			overlay:reveal()
			return
		end

		local ok, data = pcall(provider.translate, value)
		if not ok then
			mp.msg.error('[translate] !!! ' .. provider.get_error(data))
			return
		end

		-- Remove occasional commas which is mostly wrong
		data, _ = string.gsub(data, '[ \\Nn]+,', '')
		-- Return dot on it's place.
		data, _ = string.gsub(data, '[ \\Nn]+%.', '.')

		local delay = options.actualDelay - avg:tick()

		mp.msg.debug('[translate] Applying sub-delay', -delay)
		mp.set_property('sub-delay', -delay)

		cache.set(value, data)
		overlay:setTranslation(data, value)
		mp.msg.debug('[translate] <- ', data)

		overlay:reveal()
	end

	function m.resetTicker(delay)
		mp.msg.debug('[translate] Resetting ticker to', delay)
		avg:reset(delay)
	end

	return m
end

return constructor
