local mp = require 'mp'
local opt = require 'mp.options'

---@class ObserveGetter
---@field hook fun(): nil
---@field get fun(): string

---@param property string
---@return ObserveGetter
local function observe(property)
	local prop = mp.get_property(property)
	local function fn(value) prop = value end

	return {
		hook = function ()
			mp.observe_property(property, nil, fn)
		end,
		get = function () return prop end,
	}
end

local defineOptions = function (o)
	local handlers = setmetatable({ ['function'] = function (fn) return fn() end, }, {
		__index = function ()
			return function (value)
				return value
			end
		end,
	})

	local options = setmetatable(o, {
		__index = function (self, index)
			local value = self[index]
			return handlers[type(value)](value)
		end,
	})


	opt.read_options(options, mp.get_script_name())

	-- Call hook on observable props if value not overriden from read_options
	for k, v in pairs(o) do
		if type(v) == 'table' and v.hook ~= nil and v.get ~= nil then
			v.hook()
			o[k] = v.get
		end
	end

	return options
end

---@class (exact) ScriptOptions
---@field defaultDelay number
---@field translator string
---@field autoEnableTranslator boolean
---@field translatedOnly boolean
---@field primaryOriginal boolean
---@field fromLang string
---@field toLang string
---@field osdFont string
---@field osdFontSize number
---@field osdOriginalFontScale number
---@field overrideFonts boolean
---@field sensitivity number
---@field running boolean
---@field disabledManually boolean
---@field userDelay number
---@field actualDelay number
return defineOptions({
	defaultDelay = -0.5,
	translator = 'Console-Translate',
	autoEnableTranslator = false,
	translatedOnly = false,
	primaryOriginal = false,
	fromLang = 'en',
	toLang = 'ru',
	osdFont = observe('osd-font'),
	osdFontSize = observe('osd-font-size'),
	osdOriginalFontScale = 50,
	overrideFonts = true,
	sensitivity = 8,

	-- Mega Cringe
	running = false,
	disabledManually = false,
	userDelay = 0,
	actualDelay = 0,
})
