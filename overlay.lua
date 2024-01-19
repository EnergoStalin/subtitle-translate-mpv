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

		return wrapText(line, '{\\fn' .. wrap.font .. '\\a2\\fs' .. wrap.fontSize .. '}')
	end

	---@param translated string
	---@param original string
	function wrap:setTranslation(translated, original)
		overlay.data = ''

		if options.primaryOriginal then
			translated, original = original, translated
		end
		if not options.translatedOnly then
			overlay.data = '\\N\\N' .. '{\\fscx50\\fscy50}' .. original
		end

		overlay.data = wrapLine(translated .. overlay.data)
		mp.msg.trace('[overlay] ', overlay.data)
		overlay:update()
	end

	return wrap
end
