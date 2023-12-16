local mp = require 'mp'
local tablelib = require 'tablelib'

return function (register, unregister, options)
	return function ()
		local tracks = mp.get_property_native('track-list', {})
		mp.msg.debug('[autoEnable] tracks', tablelib.toJson(tracks))
		local subs = tablelib.filter(tracks, function (track)
			return track.type == 'sub'
		end)
		if #tablelib.filter(subs, function (track)
					return track.lang ~= nil and track.lang:find(options.toLang)
				end) == 0 and #subs ~= 0 then
			register()
		else
			unregister()
		end
	end
end
