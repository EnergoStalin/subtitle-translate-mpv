local mp = require('mp')
local utils = require('mp.utils')
local tlib = require('tablelib')

PATH = nil
LINES = {}
LEN = 0

CACHE_DIR = mp.command_native({
	'expand-path',
	utils.join_path(
		'~~cache/',
		mp.get_script_name()
	),
})

local function ensureCacheDir()
	local info = utils.file_info(CACHE_DIR)
	if info == nil then
		mp.msg.debug(
			'Creating cache dir',
			utils.to_string(
				utils.subprocess({
					playback_only = false,
					args = { 'mkdir', CACHE_DIR, },
				})
			)
		)
	end
end

local function getLoadedFileHash()
	local duration = mp.get_property('duration')
	local size = mp.get_property('file-size')
	local chapters = mp.get_property('chapters')

	return string.format('%s-%s-%s.tlcache', duration, size, chapters)
end

return {
	tryLoadFromDisk = function ()
		PATH = utils.join_path(CACHE_DIR, getLoadedFileHash())

		local fp = io.open(PATH, 'r')
		LINES = fp ~= nil and utils.parse_json(fp:read('*a')) or {}
		LEN = tlib.length(LINES)

		mp.msg.debug('[cache] Loaded ' .. LEN .. ' cached lines from ' .. PATH)

		if fp ~= nil then fp:close() end
	end,

	saveToDisk = function ()
		if LEN == 0 then
			mp.msg.debug('[cache] No cached lines, not writing')
			return
		end

		ensureCacheDir()
		local fp = io.open(PATH, 'w')
		if fp == nil then
			mp.msg.error('[cache] Failed to write ' .. PATH)
			return
		end

		fp:write(utils.format_json(LINES))
		fp:close()
	end,

	lenght = function ()
		return LEN
	end,

	get = function (key)
		return LINES[key]
	end,

	set = function (key, value)
		LINES[key] = value
		LEN = LEN + 1
	end,
}
