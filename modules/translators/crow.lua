local mp = require 'mp'
local utils = require 'mp.utils'
local auto = require 'modules.translators.encodings.auto'
local getos = require 'getos'
local tlib = require 'tablelib'

---@param from string
---@param to string
---@return function
return function (from, to)
	local codepage = auto(to)

	---@param value string
	---@return string | nil
	return function (value)
		-- Removing '--' due to stupid crow CLI
		-- Passing value as stdin_data not work on windows
		local escaped = value:gsub('--', '')
		local args = {
			'crow',
			'-l', from,
			'-t', to,
			'-b', escaped
		}

		local result = utils.subprocess({
			args = args,
			capture_stdout = true,
			playback_only = true
		})

		if result.status ~= 0 then error(result) end

		local data = codepage.to_utf8(result.stdout)
		if data == nil then
			mp.msg.warn('[crow] Got empty response ' .. tlib.join(args, ' '))
			return nil
		end

		if getos() == 'linux' then
			return data
		else
			return string.sub(data, 0, #data - 2)
		end                                            -- Trick for windows returning trailing characters
	end
end
