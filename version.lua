local mp = require 'mp'
local m = {}

function m.split(version)
	local major, minor, patch = version:match("^(%d+)%.(%d+)%.(%d+)$")
	return tonumber(major), tonumber(minor), tonumber(patch)
end

function m.is_greater(v2)
	local major1, minor1, patch1 = m.split(mp.get_property('mpv-version'):match("v(%d+%.%d+%.%d+)$"))
	local major2, minor2, patch2 = m.split(v2)

	if major1 ~= major2 then
		return major1 > major2
	elseif minor1 ~= minor2 then
		return minor1 > minor2
	else
		return patch1 > patch2
	end
end

return m
