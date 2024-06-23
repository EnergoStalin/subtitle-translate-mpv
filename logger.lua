local msg = require('mp.msg')

---@param module string
return function (module)
	local header = '[' .. module .. ']'
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
			write(msg.trace, header, '', ...)
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
