local avg = {
    avg = -0.5,
    count = 1,
    last = 0,
    measure = nil
}

function avg.tick()
    if avg.measure == nil then return end

    if avg.last ~= 0 then
        avg.avg = avg.avg + avg.last - avg.measure()
        avg.count = avg.count + 1
        avg.last = 0
    else
        avg.last = avg.measure()
    end

    return avg.avg / avg.count
end

return avg
