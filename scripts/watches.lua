function ChaliceCount(section)
    
    if section.FullID:sub(-7) == "Chalice" then
        local obj = Tracker:FindObjectForCode("chalice")
        local count = 0
        for index, value in pairs(Chal) do
            if value then
                local get = Tracker:FindObjectForCode(value)
                if get then
                    if get.AccessibilityLevel == 7 then
                        count = count + 1
                    end
                end
            end
        end
        obj.AcquiredCount = count
    end
end

-- ScriptHost:AddOnLocationSectionChangedHandler("ChaliceCount", ChaliceCount)



function Lighting(code)
   -- ScriptHost:RemoveOnLocationSectionHandler("ChaliceCount")
    if Has("Highlightings") and Has("progression_option") then
        Highlighting(Always)
        Highlighting(RuneH)
        if Has("runesanity") then
            Unlighting(RuneH)
        end
    else
        Unlighting(Always)
        Unlighting(RuneH)
    end
  --  ScriptHost:AddOnLocationSectionChangedHandler("ChaliceCount", ChaliceCount)
  Archipelago:Get(NotifyHints)
end

ScriptHost:AddWatchForCode("Highlights", "Highlightings", Lighting)
ScriptHost:AddWatchForCode("Highlights1", "progression_option", Lighting)
ScriptHost:AddWatchForCode("Highlights2", "runesanity", Lighting)

