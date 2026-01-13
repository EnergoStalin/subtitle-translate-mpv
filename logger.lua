local msg = require('mp.msg')
local tablelib = require('tablelib')
local mp = require('mp')

local level = string.gmatch(mp.get_property('msg-level'), mp.get_script_name() .. '=(%w+)')()

---@param module string
return function (module)
	local header = '[' .. module .. ']'

	local function unwrap(f)
		local v = f
		if type(f) == 'function' then
			v = f()
		end

		return v
	end

	local write = function (channel, head, bang, ...)
		channel(head, bang, ...)
	end

	return {
		debug = function (...)
			write(msg.debug, header, '', ...)
		end,
		info = function (...)
			write(msg.info, header, '', ...)
		end,
		trace = function (...)
			if level == 'trace' then
				write(msg.trace, header, '', unpack(tablelib.map({ ... },  unwrap)))
			end
		end,
		translator_input = function (...)
			write(msg.debug, header, '->', ...)
		end,
		translator_output = function (...)
			write(msg.debug, header, '<-', ...)
		end,
		error = function (...)
			write(msg.error, header, '!!!', ...)
		end,
		warning = function (...)
			write(msg.warning, header, '!', ...)
		end,
	}
end
