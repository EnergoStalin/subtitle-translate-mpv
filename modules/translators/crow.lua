local utils = require 'mp.utils'
local auto = require 'modules.translators.encodings.auto'

---@param from string
---@param to string
---@return table
return function (from, to)
    local codepage = auto(to)
	if codepage.to_utf8 == nil then error("must implement codepage.to_utf8") end

	local crow = {}
	---@param value string
	---@return string | nil
	function crow.translate(value)
		local args = {
			"crow",
			"-l", from,
			"-t", to,
			"-b", value
		}

		local data = codepage.to_utf8(utils.subprocess({
			args = args,
			capture_stdout = true,
			playback_only = false
		}).stdout)
		if data == nil then return end

		return string.sub(data, 0, #data - 2)
	end

	return crow
end
