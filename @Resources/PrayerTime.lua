
function Initialize()
    SKIN:Bang('!SetVariable', 'Subuh', '--:--')
    SKIN:Bang('!SetVariable', 'Syuruk', '--:--')
    SKIN:Bang('!SetVariable', 'Zohor', '--:--')
    SKIN:Bang('!SetVariable', 'Asar', '--:--')
    SKIN:Bang('!SetVariable', 'Maghrib', '--:--')
    SKIN:Bang('!SetVariable', 'Isyak', '--:--')
end

function FormatPrayerTime(value)
    if not value or value == '' then
        return '--:--'
    end

    local number = tonumber(value)

    -- Unix timestamp
    if number and number > 1000000000 then
        return os.date('%H:%M', number)
    end

    -- Already formatted HH:MM
    if string.match(value, '^%d%d:%d%d$') then
        return value
    end

    -- API time formatted as HH:MM:SS
    local hours, minutes = string.match(value, '^(%d%d):(%d%d):%d%d$')
    if hours and minutes then
        return hours .. ':' .. minutes
    end

    return '--:--'
end

function Update()
    local prayers = {
        { 'MeasureSubuh', 'Subuh' },
        { 'MeasureSyuruk', 'Syuruk' },
        { 'MeasureZohor', 'Zohor' },
        { 'MeasureAsar', 'Asar' },
        { 'MeasureMaghrib', 'Maghrib' },
        { 'MeasureIsyak', 'Isyak' }
    }

    for _, prayer in ipairs(prayers) do
        local measure = SKIN:GetMeasure(prayer[1])

        if measure then
            local value = measure:GetStringValue()
            local formatted = FormatPrayerTime(value)

            SKIN:Bang(
                '!SetVariable',
                prayer[2],
                formatted
            )
        end
    end

    SKIN:Bang('!UpdateMeterGroup', 'PrayerTime')
    SKIN:Bang('!Redraw')

    return 0
end
