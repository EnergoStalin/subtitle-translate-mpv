local mp = require 'mp'
local options = require 'options'
local average = require 'modules.average'(-0.5)
local translator = require ('modules.translators.' .. options.translator)(options.from, options.to)

local m = {
	overlay = nil
}

average.measure = mp.get_time

---Callback for subtitle change
---@param _ any
---@param value string
function m.on_sub_changed(_, value)
    if m.overlay == nil then return end

	if value == nil or value == '' then
		m.overlay.hidden = true
		m.overlay:update()
		return
	end
	m.overlay.hidden = false
	value = value:gsub('\n', ' ')

	average:tick()
	local translation = translator.translate(value)
	local tick = average:tick()

	mp.set_property('sub-delay', tick)

	m.overlay.data = '{\\a2}{\\fscx50\\fscy50}' .. value .. '\n{\\a2}' .. translation
	m.overlay:update()
end

function m.display(over) m.overlay = over end

return m