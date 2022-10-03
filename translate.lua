local mp = require 'mp'
local avg = require 'modules.average'(-0.5, mp.get_time)

return function (translator, overlay, options)
	local m = {}
	function m.on_sub_changed()
		local value = mp.get_property('sub-text-ass')
		if value == nil or value == '' then
			overlay:hide()
			return
		end

		value = value:gsub('\\N', ' \\N '):gsub('\\n', ' \\n ')
		local ok, data, err = pcall(translator.translate, value)
		if not ok then
			if err ~= nil then
				mp.msg.error(err.status,
							value,
							err.stdout,
							err.error_message,
							err.stderr
				)
			end

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