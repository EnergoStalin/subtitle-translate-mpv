local mp = require 'mp'
local utils = require 'mp.utils'
local auto = require 'modules.translators.encodings.auto'
local tlib = require 'tablelib'

---Removes 2 bytes from the end of string
---@param data string
local normalize = function (data)
	return string.sub(data, 0, #data - 2)
end

---Handle provider invocation on windows
---@param commonArgs table<number, string>
---@param value string
local windowsInkove = function (commonArgs, value)
	-- Removing '--' due to stupid crow CLI
	-- Passing value as stdin_data not work on windows
	local escaped = value:gsub('--', '')

	table.insert(commonArgs, escaped)

	local result = mp.command_native({
		name = 'subprocess',
		args = commonArgs,
		capture_stdout = true,
	})

	return result
end

---Handle provider invocation on linux
---@param commonArgs table<number, string>
---@param value string
local linuxInvoke = function (commonArgs, value)
	table.insert(commonArgs, '-i')

	local result = mp.command_native({
		name = 'subprocess',
		args = commonArgs,
		capture_stdout = true,
		stdin_data = value,
	})

	return result
end

local isUnix = mp.get_property_native('platform') == 'linux'

local invoke = isUnix and linuxInvoke or windowsInkove
local postprocess = isUnix
	and function (data) return data end
	---@param data string
	or function (data)
		return (normalize(data):gsub('\\ N', '\\N'))
	end

---@param from string
---@param to string
return function (from, to)
	local codepage = auto(to)

	---@type TranslationProvider
	return {
		translate = function (value)
			local commonArgs = {
				'crow',
				'-l', from,
				'-t', to,
				'-b',
			}

			local result = invoke(commonArgs, value)

			if result.status ~= 0 then error(result) end

			local data = codepage.to_utf8(result.stdout)

			if data == nil then
				mp.msg.warn('[crow] Got empty response ' .. tlib.join(commonArgs, ' '))
				return nil
			end

			return postprocess(data)
		end,
		get_error = function (err)
			if err.status ~= nil and err.status == -3 then
				return 'crow not reachable in path'
			else
				return utils.format_json(err)
			end
		end,
	}
end
