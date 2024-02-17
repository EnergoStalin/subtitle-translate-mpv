local mp = require 'mp'
local utils = require 'mp.utils'
local tablelib = require 'tablelib'

---Split string into lines array
---@param text string
---@return table
local function splitLines(text)
	local lines = {}
	for l in string.gmatch(text, '[^\r\n]+') do
		table.insert(lines, l)
	end

	return lines
end

return function (options)
	local overlay = mp.create_osd_overlay('ass-events')
	local wrap = {
		font = options.osdFont,
		fontSize = options.osdFontSize,
	}

	---@param line string
	local function wrapLine(line)
		if options.overrideFonts then
			line = string.gsub(line, '?{\\fn[%a%w%s]+}?', '')
		end


		local font = string.format('{\\fn%s\\fs%s}', wrap.font, wrap.fontSize)
		local text = string.format(
			'%s%s%s', font, line, font
		)
		-- Wrap in a2 if not positional
		if not string.match(text, '\\pos') then
			text = string.format('{\\a2}%s{\\a2}', text)
		end

		return text
	end

	function wrap:reload()
		overlay.data = ''

		local styles = mp.get_property('sub-ass-extradata')
		if styles == nil then return end

		-- Grab subtitle resolution and set it to osd of present
		local res_x = tonumber(styles:gmatch('PlayResX: (%d+)')())
		local res_y = tonumber(styles:gmatch('PlayResY: (%d+)')())

		if res_x ~= nil then overlay.res_x = res_x end
		if res_y ~= nil then overlay.res_y = res_y end
	end

	function wrap:remove()
		overlay:remove()
	end

	function wrap:hide()
		overlay.hidden = true
		overlay:update()
	end

	function wrap:reveal()
		overlay.hidden = false
		overlay:update()
	end

	---@param translated string
	---@param original string
	function wrap:setTranslation(translated, original)
		overlay.data = ''

		-- For simplicity just swap before processing
		if options.primaryOriginal then
			translated, original = original, translated
		end

		local translatedLines = splitLines(translated)
		for i, _ in ipairs(translatedLines) do
			translatedLines[i] = string.format('%s%s',
				wrapLine(translatedLines[i]),
				'\n'
			)
		end

		if not options.translatedOnly then
			local originalLines = splitLines(original)
			local mergedLines = {}
			for i, _ in ipairs(originalLines) do
				local l = string.format('%s%s%s%s',
					translatedLines[i],
					'\\N{\\fscx50\\fscy50}', -- 50% size
					wrapLine(
						string.gsub(originalLines[i], '{?\\pos%(.+%)}?', '') -- Strip pos cause already present in translatedLines
					),
					'{\\fscx50\\fscy50}'
				)

				-- Idk where \n appears but let's just remove it here
				l = string.gsub(l, '[\r\n]+', '')
				table.insert(mergedLines, l)
			end

			overlay.data = tablelib.join(mergedLines, '\n')
		else
			overlay.data = string.format('%s%s',
				tablelib.join(translatedLines, '\n'), overlay.data
			)
		end

		mp.msg.trace('[overlay] ', overlay.data)
	end

	return wrap
end
