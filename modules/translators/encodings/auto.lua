local path = (...):match('(.-)[^%.]+$')
local os = require ('getos')():lower()

---@param to string
return function (to)
	if os:find('linux') then
		return require (path .. 'pass')
	end

	if to:find("ru") then
		return require (path .. 'cp1251')
	else
		return require (path .. 'pass')
	end
end