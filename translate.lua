local mp = require 'mp'
local avg = require 'modules.average'(-0.5, mp.get_time)

return function (translator, overlay, options)
	if translator.translate == nil then error("must implement transaltor.translate(text)") end
	if overlay.set_translation == nil then error("must implement overlay:set_translation(translated, original)") end
	local m = {}
	function m.on_sub_changed(_, value)
		if value == nil or value == '' then
			overlay:hide()
			return
		end

		local ok, data, err = pcall(translator.translate, value)
		if not ok then
			mp.msg.error(err.status,
						 value,
						 err.stdout,
						 err.error_message,
						 err.stderr
			)
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