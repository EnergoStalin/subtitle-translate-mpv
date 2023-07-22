local mp = require 'mp'
local tlib = require 'tablelib'

local function print_error(err, value, data)
	if err ~= nil then
		mp.msg.error(tlib.toString(err), value, data)
	else
		mp.msg.error(data)
	end
end

return function (translator, overlay, options)
	local m = {}
	local avg = require 'modules.average' (options.defaultDelay, mp.get_time, options.sensitivity)
	function m.on_sub_changed()
		local value = mp.get_property('sub-text-ass')
		if value == nil or value == '' then
			overlay:hide()
			return
		end

		avg:tick()
		value = value:gsub('\\N', ' \\N '):gsub('\\n', ' \\n ')
		local ok, data, err = pcall(translator, value)
		if not ok then
			print_error(err, value, data)
			return
		end

		overlay:setTranslation(data, value)

		local delay = options.actualDelay - avg:tick()
		mp.msg.debug('[translate] Applying sub-delay', delay)
		mp.set_property('sub-delay', delay)

		overlay:reveal()
	end

	function m.resetTicker(delay)
		mp.msg.debug('[translate] Resetting ticker to', delay)
		avg:reset(delay)
	end

	return m
end
