---Constructor for average value generator
---@param initial number
---@return table
return function (initial)
    local average = {
        avg = initial,
        count = 1,
        last = 0,
        measure = nil
    }

    function average:tick()
        if self.measure == nil then return end

        if self.last ~= 0 then
            self.avg = self.avg + self.last - self.measure()
            self.count = self.count + 1
            self.last = 0
        else
            self.last = self.measure()
        end

        return self.avg / self.count
    end

    return average
end
