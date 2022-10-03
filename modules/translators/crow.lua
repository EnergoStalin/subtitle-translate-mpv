local utils = require 'mp.utils'
local auto = require 'modules.translators.encodings.auto'

---@param from string
---@param to string
---@return table
return function (from, to)
	local codepage = auto(to)

	local crow = {}
	---@param value string
	---@return string | nil
	function crow.translate(value)
		-- Removing '--' due to stupid crow CLI
		-- Passing value as stdin_data not work on windows
		local escaped = value:gsub('--', '')
		local args = {
			"crow",
			"-l", from,
			"-t", to,
			"-b", escaped
		}

		local result = utils.subprocess({
			args = args,
			capture_stdout = true,
			playback_only = true
		})

		if result.status ~= 0 then error(result) end

		local data = codepage.to_utf8(result.stdout)
		if data == nil then return nil end

		return string.sub(data, 0, #data - 2)
	end

	return crow
end
