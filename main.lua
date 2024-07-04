local mp = require 'mp'

local o = require 'options'

---@type OverlayWrapper
local overlay = require 'overlay' (o)

---@type TranslationProvider
local provider = require('modules.translators.' .. o.translator)

---@type Translator
local translator = require 'translate' (
	provider(o.fromLang, o.toLang),
	overlay,
	o
)

local register = require 'register' (translator, overlay, o)
local unregister = require 'unregister' (translator, overlay, o)
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

mp.register_script_message('benchmark-sub-translator',
	require 'benchmark' (provider('en', 'ru')))
