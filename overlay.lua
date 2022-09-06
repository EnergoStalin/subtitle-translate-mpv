local mp = require 'mp'


return function(options)
	local overlay = mp.create_osd_overlay('ass-events')
	local wrap = {}

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

	function wrap:set_translation(primary, original)
		overlay.data = '{\\a2}'
		
		if options.primaryOriginal then
			primary, original = original, primary
		end
		if not options.translatedOnly then
			overlay.data = overlay.data .. '{\\fscx50\\fscy50}' .. original .. '\n'
		end

		overlay.data = overlay.data .. primary .. '{\\a2}'
		overlay:update()
	end

	return wrap
end