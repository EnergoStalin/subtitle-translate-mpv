local mp = require 'mp'
local tablelib = require 'tablelib'

return function(register, unregister, options)
	return function()
		if #tablelib.filter(mp.get_property_native("track-list", {}), function (track)
			return track.type == 'sub' and ((track.lang ~= nil and not track.lang:find(options.toLang)) or track.external)
		end) ~= 0 then register()
		else unregister() end
	end
end