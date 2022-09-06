local mp = require 'mp'
local opt = require 'mp.options'

--- Run guard
local running = false
local o = {
	defaultDelay = -0.5,
	translator = "crow",
	autoEnableTranslator = false,
	translatedOnly = false,
	primaryOriginal = false,
	fromLang = "en",
	toLang = "ru",
}
opt.read_options(o, "subutil")

local translator = require ('modules.translators.' .. o.translator)(o.fromLang, o.toLang)
local overlay = require 'overlay'(o)
local translate = require 'translate'(translator, overlay, o)

local function register()
	if running then return end

	o.defaultDelay = mp.get_property('sub-delay', o.defaultDelay) + o.defaultDelay

	mp.set_property('sub-delay', o.defaultDelay)
	mp.observe_property('sub-text', 'string', translate.on_sub_changed)
	mp.set_property('sub-visibility', 'no')

	running = true
	mp.msg.info('Started')
end
local function unregister()
	if not running then return end

	mp.unobserve_property(translate.on_sub_changed)
	mp.set_property('sub-visibility', 'yes')
	mp.set_property('sub-delay', o.defaultDelay)
	overlay:remove()

	running = false
	mp.msg.info('Stopped')
end
local function autoEnable()
	local track_list = mp.get_property_native("track-list", {})
	local enable = true
	for _,track in ipairs(track_list) do
		if track.type == "sub" then
			if (not track.lang and track.external) or track.lang:find(o.toLang) then
				enable = false
				break
			end
		end
	end
	if enable then register()
	else unregister() end
end

if o.autoEnableTranslator then
	mp.add_hook('on_load', 25, autoEnable)
end

mp.register_script_message("sub-to-clipboard", function () (require 'clipboard').set(mp.get_property('sub-text')) end)
mp.register_script_message("sub-translated-only", function() o.translatedOnly = not o.translatedOnly; mp.osd_message('Translated only ' .. tostring(o.translatedOnly)) end)
mp.register_script_message("sub-primary-original", function() o.primaryOriginal = not o.primaryOriginal; mp.osd_message('Primary original ' .. tostring(o.primaryOriginal)) end)
mp.register_script_message("enable-sub-translator", register)
mp.register_script_message("disable-sub-translator", unregister)
