local mp = require 'mp'
local opt = require 'mp.options'

--- Run guard
local running = false
local o = {
	defaultDelay = -0.5,
	translator = "crow",
	autoEnableTranslator = false,
	fromLang = "en",
	toLang = "ru",
}
opt.read_options(o, "subutil")

local translator = require ('modules.translators.' .. o.translator)(o.fromLang, o.toLang)
local overlay = require 'overlay'()
local translate = require 'translate'(translator, overlay)

local function register()
	if running then return end

	mp.set_property('sub-delay', o.defaultDelay)
	mp.observe_property('sub-text', 'string', translate.on_sub_changed)
	mp.set_property('sub-visibility', 'no')

	running = true
end
local function unregister()
	if not running then return end

	mp.unobserve_property(translate.on_sub_changed)
	mp.set_property('sub-visibility', 'yes')
	overlay:remove()

	running = false
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


mp.register_script_message("copy-sub-to-clipboard", function () (require 'clipboard').set(mp.get_property('sub-text')) end)

if o.autoEnableTranslator then
	mp.add_hook('on_preloaded', 25, autoEnable)
end

mp.register_script_message("enable-sub-translator", register)
mp.register_script_message("disable-sub-translator", unregister)
