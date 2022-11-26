local mp = require 'mp'


return function(options)
	local overlay = mp.create_osd_overlay('ass-events')
    local wrap = {
		font = options.osdFont
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
	local function wrap_line(line, text)
		return text .. line .. text
	end

	---@param line string
	---@param font string
	---@return string
	local function wrap_font(line, font)
		return wrap_line(line, '{\\fn' .. font .. '}')
	end

	---@param primary string
	---@param original string
    function wrap:set_translation(primary, original)
		overlay.data = ''

		if options.primaryOriginal then
			primary, original = original, primary
		end
		if not options.translatedOnly then
			overlay.data = '{\\fscx50\\fscy50}' .. original .. '\n'
        end

		overlay.data = wrap_font(wrap_line(overlay.data .. primary, '{\\a2}'), wrap.font)
		overlay:update()
	end

	return wrap
end
