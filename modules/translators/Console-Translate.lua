local mp = require('mp')
local logger = require('logger')('Console-Translate')

local function escape(str)
	local s, _ = string.gsub(str, '\'', '\'\'')
	s, _ = string.gsub(s, '’', '’’')
	return s
end

---@param from string
---@param to string
return function (from, to)
	---@type TranslationProvider
	return {
		translate = function (value)
			local command = string.format(
				"Import-Module Console-Translate; Get-Translate -Text '%s' -LanguageSource %s -LanguageTarget %s",
				escape(string.gsub(value, '[\r\n]', '\\n')),
				from,
				to
			)

			logger.debug(command)

			local result = mp.command_native({
				name = 'subprocess',
				args = {
					'pwsh',
					'-NoProfile',
					'-NonInteractive',
					'-OutputFormat', 'Text',
					'-Command',
					command,
				},
				capture_stdout = true,
			})

			local s, _ = string.gsub(result.stdout, '\\n', '\n')
			s, _ = string.gsub(s, '&quot;', '"')
			s, _ = string.gsub(s, '&amp;', '&')
			s, _ = string.gsub(s, '&#39;', '\'')
			s, _ = string.gsub(s, '\\%s', '\\')

			return s
		end,
		get_error = function (err) return err end,
	}
end
