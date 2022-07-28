local opts = require 'options'
local cp1251 = require 'modules.encodings.cp1251'
local utils = require 'mp.utils'
local mp = require 'mp'

---@param value string
---@return string | nil
local function get_translation(value)
	local args = {
		opts.translation_provider,
		opts.from_key, opts.from,
		opts.to_key, opts.to,
		opts.text_key, value
	}

	mp.msg.debug(table.concat(args, ' '))
	local data = cp1251.cp1251_utf8(utils.subprocess({
		args = args,
		capture_stdout = true,
		playback_only = false
	}).stdout)
	if data == nil then return end
	mp.msg.debug('src:len(' .. value:len() .. ') data:len('.. data:len() .. ')')

	return string.sub(data, 0, #data - 2)
end

return get_translation