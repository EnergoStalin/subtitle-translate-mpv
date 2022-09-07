local mp = require 'mp'

return function(register, unregister, options)
	return function()
		local track_list = mp.get_property_native("track-list", {})
		local enable = #track_list ~= 0
		for _,track in ipairs(track_list) do
			if track.type == "sub" then
				if (not track.lang and track.external) or track.lang:find(options.toLang) then
					enable = false
					break
				end
			end
		end
		if enable then register()
		else unregister() end
	end
end