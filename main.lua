local mp = require 'mp'
local utils = require 'mp.utils'
local clip = require 'clipboard'
local cp1251 = require 'encodings.cp1251'
local avg = require 'average'


avg.measure = mp.get_time
local overlay = mp.create_osd_overlay('ass-events')

local opts = {
	translation_provider='crow',
	from_key='-l',
	from='en',
	to_key='-t',
	to='ru',
	text_key='-b',
}

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

local function on_sub_changed(_, value)
	if value == nil or value == '' then
		overlay.hidden = true
		overlay:update()
		return
	end
	overlay.hidden = false
	value = value:gsub('\n', ' ')

	avg:tick()
	local translation = get_translation(value)
	local tick = avg:tick()

	mp.set_property('sub-delay', tick)
	mp.msg.info('sub-delay ' .. tick)

	overlay.data = '{\\a2}{\\fscx50\\fscy50}' .. value .. '\n{\\a2}' .. translation
	overlay:update()
end

local function copySubToClipboard()
	clip.set(mp.get_property('sub-text'))
end

mp.register_script_message("copy-sub-to-clipboard", copySubToClipboard)
mp.register_script_message("enable-sub-translator", function ()
	mp.observe_property('sub-text', 'string', on_sub_changed)
	mp.set_property('sub-visibility', 'no')
end)

mp.register_script_message("disable-sub-translator", function ()
	mp.unobserve_property(on_sub_changed)
	mp.set_property('sub-visibility', 'yes')
	overlay:remove()
end)

mp.set_property('sub-delay', 0.5)