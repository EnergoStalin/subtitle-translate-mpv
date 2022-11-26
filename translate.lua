local mp = require 'mp'
local avg = require 'modules.average'(-0.5, mp.get_time)

local function print_error(err, value)
	if err ~= nil then
		mp.msg.error(err.status,
					value,
					err.stdout,
					err.error_message,
					err.stderr
        )
    else
		mp.msg.error(err)
	end
end

return function (translator, overlay, options)
	local m = {}
	function m.on_sub_changed()
		local value = mp.get_property('sub-text-ass')
		if value == nil or value == '' then
			overlay:hide()
			return
		end

		value = value:gsub('\\N', ' \\N '):gsub('\\n', ' \\n ')
		local ok, data, err = pcall(translator, value)
		if not ok then
			print_error(err, value)
			return
		end

		avg:tick()
		overlay:set_translation(data, value)
		mp.set_property('sub-delay', options.defaultDelay - avg:tick())

		overlay:reveal()
	end

	function m.reset()
		avg:reset(mp.get_property('sub-delay', -0.5))
	end

	return m
end
