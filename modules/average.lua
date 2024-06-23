---@alias MeasureFunction fun(): number

---Constructor for average value generator
---@param initial number
---@param measure MeasureFunction
---@param sensitivity number 
return function (initial, measure, sensitivity)
	---@class average
	local average = {
		avg = initial,
		count = 1,
		last = 0,
		measure = measure,
		sensitivity = sensitivity,
	}

	---Reset class with new average value optionally changing measure function
	---@see MeasureFunction
	---@param avg number
	---@param m MeasureFunction?
	---@return nil
	function average:reset(avg, m)
		self.count = 1
		self.avg = avg
		self.measure = m or self.measure
	end

	---@return number # Returns average time between calls
	function average:tick()
		if self.last ~= 0 then
			self.avg = self.avg + self.last - self.measure()
			self.count = self.count + 1
			self.last = 0
		else
			self.last = self.measure()
		end

		if self.count > sensitivity then
			self.count = self.count % sensitivity
			self.avg = self.avg / sensitivity
		end

		return self.avg / self.count
	end

	return average
end
