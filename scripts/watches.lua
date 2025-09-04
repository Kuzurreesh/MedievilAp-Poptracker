function ChaliceCount(section)
    if section then
        if section.FullID:sub(-7) == "Chalice" then
            local obj = Tracker:FindObjectForCode("chalice")
            local val = section.AccessibilityLevel
            if obj then
                if val == 6 or val == 0 then
                    obj.AcquiredCount = obj.AcquiredCount - obj.Increment
                elseif val == 7 then
                    obj.AcquiredCount = obj.AcquiredCount + obj.Increment
                end
            end
        end
    end
end

ScriptHost:AddOnLocationSectionChangedHandler("ChaliceCount", ChaliceCount)
