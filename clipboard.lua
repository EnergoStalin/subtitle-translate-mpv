if Clipboard then return end
Clipboard = {}

local utils = require 'mp.utils'

---comment
---@param value string
function Clipboard.set(value)
	utils.subprocess({
		args = {
			'powershell', '-NoProfile', '-Command', 'Set-Clipboard', '"' .. value:gsub('"', '`"') .. '"'
		},
		playback_only = false,
	})
end

return Clipboard