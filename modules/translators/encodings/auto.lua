---@param to string
return function (to)
    if to:find("ru") then
        return require 'modules.translators.encodings.cp1251'
    else
        local aboba = {}
        function aboba.to_utf8(value)
            return value
        end
        return aboba
    end
end