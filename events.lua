local mp = require 'mp'
local options = require 'options'
local average = require 'modules.average'(-0.5)
local translator = require ('modules.translators.' .. options.translator)(options.from, options.to)

local module = {
	overlay = nil
}

average.measure = mp.get_time

---Callback for subtitle change
---@param _ any
---@param value string
function module.on_sub_changed(_, value)
    if module.overlay == nil then return end

	if value == nil or value == '' then
		module.overlay.hidden = true
		module.overlay:update()
		return
	end
	module.overlay.hidden = false
	value = value:gsub('\n', ' ')

	average:tick()
	local translation = translator.translate(value)
	local tick = average:tick()

	mp.set_property('sub-delay', tick)

	module.overlay.data = '{\\a2}{\\fscx50\\fscy50}' .. value .. '\n{\\a2}' .. translation
	module.overlay:update()
end

function module.display(over) module.overlay = over end

return module