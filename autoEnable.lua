local mp = require 'mp'
local tablelib = require 'tablelib'

return function(register, unregister, options)
	return function()
		local subs = tablelib.filter(mp.get_property_native('track-list', {}), function (track)
			return track.type == 'sub'
		end)
		if #tablelib.filter(subs, function (track)
			local val = track.lang ~= nil and track.lang:find(options.toLang)
			return val
		end) == 0 and #subs ~= 0 then register()
		else unregister() end
	end
end
