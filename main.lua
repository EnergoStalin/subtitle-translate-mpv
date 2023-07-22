local mp = require 'mp'
local opt = require 'mp.options'

local o = {
	defaultDelay = -0.5,
	translator = 'crow',
	autoEnableTranslator = false,
	translatedOnly = false,
	primaryOriginal = false,
	fromLang = 'en',
	toLang = 'ru',
	osdFont = 'Arial',

	-- Mega Cringe
	running = false,
	disabledManually = false
}
opt.read_options(o, 'subtitle-translate-mpv')

local overlay = require 'overlay' (o)
local translator = require 'translate' (
	require('modules.translators.' .. o.translator)(o.fromLang, o.toLang),
	overlay,
	o
)

local register = require 'register' (translator, o)
local unregister = require 'unregister' (translator, o, overlay)
local autoEnable = require 'autoEnable' (register, unregister, o)

local function updateEvents()
	if o.autoEnableTranslator and not o.disabledManually then
		mp.register_event('file-loaded', autoEnable)
	else
		mp.unregister_event(autoEnable)
	end
end

updateEvents()

mp.register_script_message('sub-translated-only', function ()
	o.translatedOnly = not o.translatedOnly; mp.osd_message('Translated only ' .. tostring(o.translatedOnly))
end)
mp.register_script_message('sub-primary-original',
	function ()
		o.primaryOriginal = not o.primaryOriginal; mp.osd_message('Primary original ' .. tostring(o.primaryOriginal))
	end)
mp.register_script_message('enable-sub-translator', function ()
	o.disabledManually = false; updateEvents(); register()
end)
mp.register_script_message('disable-sub-translator',
	function ()
		o.disabledManually = true; updateEvents(); unregister()
	end)
