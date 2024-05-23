local m = {}

---@param list table
---@param pred function
---@return table
function m.filter(list, pred)
	local res = {}
	for _, item in ipairs(list) do
		if pred(item) then table.insert(res, item) end
	end

	return res
end

---@param list table
---@return boolean
function m.isEmpty(list)
	for _ in pairs(list) do
		return false
	end

	return true
end

---@param list table
---@return number
function m.length(list)
	local len = 0
	for _ in pairs(list) do
		len = len + 1
	end

	return len
end

---@param list table
---@param sep string
---@return string
function m.join(list, sep)
	local str = ''
	for _, value in ipairs(list) do
		if string.len(str) ~= 0 then str = str .. sep end
		str = str .. value
	end

	return str
end

return m
