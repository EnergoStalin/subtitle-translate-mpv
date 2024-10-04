local mp = require 'mp'
local logger = require 'logger' ('translate')

---@class TranslationProvider
---@field translate fun(value: string): string | nil
---@field get_error fun(data: any): string

---@param provider TranslationProvider
---@param overlay table
---@param options table
return function (provider, overlay, options)
	local avg = require 'modules.average' (options.defaultDelay, mp.get_time, options.sensitivity)

	---@class Translator
	local m = {}

	function m.onSubChanged()
		local value = mp.get_property('sub-text/ass')
		if value == nil or value == '' then
			overlay:hide()
			return
		end

		avg:tick()
		value = value:gsub('\\N', ' \\N '):gsub('\\n', ' \\n ')
		logger.translator_input(value)

		local ok, data = pcall(provider.translate, value)
		if not ok then
			return logger.error(provider.get_error(data))
		end

		if not data then
			return logger.warning('Got empty response')
		end

		-- Remove occasional commas which is mostly wrong
		data, _ = string.gsub(data, '[ \\Nn]+,', '')
		-- Return dot on it's place.
		data, _ = string.gsub(data, '[ \\Nn]+%.', '.')

		local delay = options.actualDelay - avg:tick()

		logger.debug('Applying sub-delay', -delay)
		mp.set_property('sub-delay', -delay)

		overlay:setTranslation(data, value)
		logger.debug('Applying sub-delay', -delay)
		logger.translator_output(data)
	end

	---@param delay number
	function m.resetTicker(delay)
		logger.debug('Resetting ticker to', delay)
		avg:reset(delay)
	end

	return m
end
