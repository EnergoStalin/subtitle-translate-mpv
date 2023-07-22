---Constructor for average value generator
---@param initial number
---@return table
return function (initial, measure, sensitivity)
	local average = {
		avg = initial,
		count = 1,
		last = 0,
		measure = measure,
		sensitivity = sensitivity,
	}

	function average:reset(avg, measure)
		self.count = 1
		self.avg = avg
		self.measure = measure or self.measure
	end

	function average:tick()
		if self.measure == nil then return end

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
