local mp = require 'mp'


return function()
	local overlay = mp.create_osd_overlay('ass-events')
	local wrap = {}
	function wrap:hide()
		overlay.hidden = true
		overlay:update()
	end

	function wrap:reveal()
		overlay.hidden = false
		overlay:update()
	end

	function wrap:set_translation(translated, original)
		overlay.data = '{\\a2}{\\fscx50\\fscy50}' .. original .. '\n{\\a2}' .. translated
		overlay:update()
	end

	return wrap
end