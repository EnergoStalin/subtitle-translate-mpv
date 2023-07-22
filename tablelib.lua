local m = {}

function m.filter(list, pred)
	local res = {}
	for _, item in ipairs(list) do
		if pred(item) then table.insert(res, item) end
	end

	return res
end

function m.toString(map)
	local str = ''
	for key, value in pairs(map) do
		if string.len(str) ~= 0 then str = str .. ', ' end
		str = str .. key .. '=' .. tostring(value)
	end

	return str
end

function m.join(list, sep)
	local str = ''
	for _, value in ipairs(list) do
		if string.len(str) ~= 0 then str = str .. sep end
		str = str .. value
	end

	return str
end

return m
