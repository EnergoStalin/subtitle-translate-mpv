---@diagnostic disable: undefined-global
-- Simple polyfill for os detection
return function ()
	if jit and jit.os and jit.arch then
		return jit.os
	end


	local popen_status, _ = pcall(io.popen, '')
	if popen_status then
		return 'linux'
	end

	return 'windows'
end
