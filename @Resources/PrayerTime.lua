local prayers = {
    { measure = "MeasureSubuh", color = "SubuhColor" },
    { measure = "MeasureSyuruk", color = "SyurukColor" },
    { measure = "MeasureZohor", color = "ZohorColor" },
    { measure = "MeasureAsar", color = "AsarColor" },
    { measure = "MeasureMaghrib", color = "MaghribColor" },
    { measure = "MeasureIsyak", color = "IsyakColor" }
}

function Update()
    local now = os.date("*t")
    local currentMinutes = now.hour * 60 + now.min
    local nearestPrayer
    local nearestDifference = 24 * 60

    for _, prayer in ipairs(prayers) do
        local value = SKIN:GetMeasure(prayer.measure):GetStringValue()
        local hours, minutes = value:match("^(%d%d):(%d%d)$")

        if hours and minutes then
            local prayerMinutes = tonumber(hours) * 60 + tonumber(minutes)
            if prayerMinutes < 24 * 60 then
                local difference = (prayerMinutes - currentMinutes) % (24 * 60)
                if difference < nearestDifference then
                    nearestDifference = difference
                    nearestPrayer = prayer
                end
            end
        end
    end

    local accentColor = SKIN:GetVariable("AccentColor")
    local mutedColor = SKIN:GetVariable("MutedColor")

    for _, prayer in ipairs(prayers) do
        local color = prayer == nearestPrayer and accentColor or mutedColor
        SKIN:Bang("!SetVariable", prayer.color, color)
    end

    return 0
end