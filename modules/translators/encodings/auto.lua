local path = (...):match('(.-)[^%.]+$')
local os = require('getos')():lower()

---@class Utf8Converter
---@field to_utf8 fun(value: string): string # Convert arbitraty encoding to utf-8

---@param to string
---@return Utf8Converter
return function (to)
	if os:find('linux') then
		return require(path .. 'pass')
	end

	if to:find('ru') then
		return require(path .. 'cp1251')
	else
		return require(path .. 'pass')
	end
end
