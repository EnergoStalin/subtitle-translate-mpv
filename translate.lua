local utils = require 'mp.utils'

return function (opts, codepage)
	local translator = {}
	if codepage.from_utf8 == nil then error("must implement codepage.from_utf8") end

	---@param value string
	---@return string | nil
	function translator.translate(value)
		local args = {
			opts.translation_provider,
			opts.from_key, opts.from,
			opts.to_key, opts.to,
			opts.text_key, value
		}

		local data = codepage.from_utf8(utils.subprocess({
			args = args,
			capture_stdout = true,
			playback_only = false
		}).stdout)
		if data == nil then return end

		return string.sub(data, 0, #data - 2)
	end

	return translator
end