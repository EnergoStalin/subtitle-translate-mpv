local avg = require 'modules.average'
local translator = require 'translate'

local overlay = nil
local module = {}

avg.measure = mp.get_time

function module.on_sub_changed(_, value)
    if overlay == nil then return end

	if value == nil or value == '' then
		overlay.hidden = true
		overlay:update()
		return
	end
	overlay.hidden = false
	value = value:gsub('\n', ' ')

	avg:tick()
	local translation = translator(value)
	local tick = avg:tick()

	mp.set_property('sub-delay', tick)

	overlay.data = '{\\a2}{\\fscx50\\fscy50}' .. value .. '\n{\\a2}' .. translation
	overlay:update()
end

function module.display(over) overlay = over end

return module