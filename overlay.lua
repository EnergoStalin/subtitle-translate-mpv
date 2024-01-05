local mp = require 'mp'


return function (options)
	local overlay = mp.create_osd_overlay('ass-events')
	local wrap = {
		font = options.osdFont,
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
	---@param font string
	---@return string
	local function wrapFont(line, font)
		return wrapText(line, '{\\fn' .. font .. '}')
	end

	---@param line string
	local function wrapLine(line)
		return wrapFont(wrapText(line, '{\\a2}'), wrap.font)
	end

	---@param translated string
	---@param original string
	function wrap:setTranslation(translated, original)
		overlay.data = ''

		if options.primaryOriginal then
			translated, original = original, translated
		end
		if not options.translatedOnly then
			overlay.data = '\\N\\N' .. wrapLine('{\\fscx50\\fscy50}' .. original)
		end

		overlay.data = wrapLine(translated) .. overlay.data
		mp.msg.debug('[overlay] ', overlay.data)
		overlay:update()
	end

	return wrap
end
