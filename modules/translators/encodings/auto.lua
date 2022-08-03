local path = (...):match("(.-)[^%.]+$")

---@param to string
return function (to)
	if to:find("ru") then
		return require (path .. 'cp1251')
	else
		return require (path .. 'pass')
	end
end