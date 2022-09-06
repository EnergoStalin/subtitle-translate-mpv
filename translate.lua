local mp = require 'mp'
local avg = require 'modules.average'(mp.get_property('sub-delay', -0.5), mp.get_time)

return function (translator, overlay)
	if translator.translate == nil then error("must implement transaltor.translate(text)") end
	if overlay.set_translation == nil then error("must implement overlay:set_translation(translated, original)") end
	local m = {}
	function m.on_sub_changed(_, value)
		if value == nil or value == '' then
			overlay:hide()
			return
		end

		value = value:gsub('\n', ' ')
		local data = translator.translate(value)

		avg:tick()
		overlay:set_translation(data, value)
		mp.set_property('sub-delay', avg:tick())

		overlay:reveal()
	end

	function m.reset()
		avg:reset(mp.get_property('sub-delay', -0.5))
	end

	return m
end