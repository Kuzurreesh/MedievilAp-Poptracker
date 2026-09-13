function ChaliceCount(section)
    local count = 0
    for _, obj in pairs(LOCATION_MAPPING) do
        if obj[1] == "clearedgallows" then

        else
            if Tracker:FindObjectForCode(obj[1]).AccessibilityLevel == AccessibilityLevel.Normal then
                count = count + 1
            end
        end
    end
    Tracker:FindObjectForCode("count").BadgeText = tostring(count)
end

ScriptHost:AddOnLocationSectionChangedHandler("In Logic", ChaliceCount)
ScriptHost:AddWatchForCode("Counting", "*", ChaliceCount)



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

function HUDLess()
    local k = 2
    if Has("zoom") then
        print("Zoom " .. Maps2[k][1], "16")
        print("Pan " .. Maps2[k][1], Maps2[k][3], "200,500")
        Tracker:UiHint("Zoom " .. Maps2[k][1], "16")
        Tracker:UiHint("Pan " .. Maps2[k][1], "200,500")
        -- Tracker:UiHint("Zoom The Graveyard", "5")
        --Tracker:UiHint("Pan The Graveyard", "500,500")

        Tracker:UiHint("ActivateTab", Maps2[k][1])
    else
        Tracker:UiHint("Zoom " .. Maps2[k][1], "1")
        Tracker:UiHint("Pan " .. Maps2[k][1], Maps2[k][2])
    end
end

function Zoom()
    if Has("zoom") then
        Tracker:FindObjectForCode("dark").Active = true
        Tracker:FindObjectForCode("HUDtrap").Active = true
    else
        Tracker:FindObjectForCode("dark").Active = false
        Tracker:FindObjectForCode("HUDtrap").Active = false
        Tracker:FindObjectForCode("HUD").Active = true
    end
end

ScriptHost:AddWatchForCode("Zoom trap", "zoom", Zoom)


ScriptHost:AddWatchForCode("Highlights", "Highlightings", Lighting)
ScriptHost:AddWatchForCode("Highlights1", "progression_option", Lighting)
ScriptHost:AddWatchForCode("Highlights2", "runesanity", Lighting)
