local mp = require 'mp'
local opt = require 'mp.options'

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
local o = {
	defaultDelay = -0.5,
	translator = 'Console-Translate',
	autoEnableTranslator = false,
	translatedOnly = false,
	primaryOriginal = false,
	fromLang = 'en',
	toLang = 'ru',
	osdFont = mp.get_property('osd-font'),
	osdFontSize = mp.get_property('osd-font-size'),
	osdOriginalFontScale = 50,
	overrideFonts = true,
	sensitivity = 8,

	-- Mega Cringe
	running = false,
	disabledManually = false,
	userDelay = 0,
	actualDelay = 0,
}

opt.read_options(o, mp.get_script_name())

return o
