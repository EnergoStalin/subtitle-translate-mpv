local utils = require 'mp.utils'

---@param from string
---@param to string
return function (from, to)
	local m = {}

	---@param value string
	---@return string | nil
	function m.translate(value)
		local result = utils.subprocess({
			args = {
				'pwsh',
				'-NoProfile',
				'-NonInteractive',
				'-Command',
				string.format(
					'Import-Module Console-Translate; Get-Translate -Text "%s" -LanguageSource %s -LanguageTarget %s',
					string.gsub(value, '[\r\n]', '\\n'),
					from,
					to
				)
			},
			capture_stdout = true
		})

		local s, _ = string.gsub(result.stdout, '\\n', '\n')
		return s
	end

	function m.get_error(err)
		return err
	end

	return m
end
