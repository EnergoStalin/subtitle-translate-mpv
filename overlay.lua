local mp = require 'mp'


return function (options)
	local overlay = mp.create_osd_overlay('ass-events')
	local wrap = {
		font = options.osdFont,
		fontSize = options.osdFontSize,
	}

	function wrap:remove()
		overlay:remove()
	end

	function wrap:hide()
		overlay.hidden = true
		overlay:update()
	end

	function wrap:reveal()
		overlay.hidden = false
		overlay:update()
	end

	---@param line string
	---@param text string
	---@return string
	local function wrapText(line, text)
		return text .. line .. text
	end

	---@param line string
	local function wrapLine(line)
		if options.overrideFonts then
			line, _ = string.gsub(line, '\\fn[%a%w%s]+', '')
		end

		local text = wrapText(line, '{\\fn' .. wrap.font .. '\\fs' .. wrap.fontSize .. '}')
		if not text:match('\\pos') then
			text = wrapText(text, '{\\a2}')
		end

		return text
	end

	---@param translated string
	---@param original string
	function wrap:setTranslation(translated, original)
		overlay.data = ''

		if options.primaryOriginal then
			translated, original = original, translated
		end

		-- Process text line by line
		local formattedTranslated = ''
		for s in translated:gmatch("[^\r\n]+") do
			formattedTranslated = formattedTranslated .. wrapLine(s)
		end

		if not options.translatedOnly then
			-- Process text line by line
			local formattedOriginal = ''
			for s in original:gmatch("[^\r\n]+") do
				formattedOriginal = wrapText(formattedOriginal .. wrapLine(s), '{\\fscx50\\fscy50}')
			end

			overlay.data = '\\N\\N' .. formattedOriginal
		end

		overlay.data = formattedTranslated .. overlay.data
		mp.msg.trace('[overlay] ', overlay.data)
		overlay:update()
	end

	return wrap
end
