local utils = require 'mp.utils'

---@param from string
---@param to string
return function (from, to)
	local m = {}

	---@param value string
	---@return string | nil
	function m.translate(value)
		local lines = ''

		for l in string.gmatch(value, '[^\r\n]+') do
			local result = utils.subprocess({
				args = {
					'pwsh',
					'-NoProfile',
					'-Command',
					string.format(
						'Import-Module Console-Translate; Get-Translate -Text "%s" -LanguageSource %s -LanguageTarget %s',
						l,
						from,
						to
					)
				},
				capture_stdout = true
			})

			if result.status ~= 0 then error(result) end

			lines = string.format('%s%s\n', lines, result.stdout)
		end

		return lines
	end

	function m.get_error(err)
		return err
	end

	return m
end
