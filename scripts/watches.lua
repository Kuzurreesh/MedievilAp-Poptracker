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

function HUDLess()
local k = 2
    if Has("zoom") then
        print("Zoom " .. Maps2[k][1], "16")
        print("Pan " .. Maps2[k][1], Maps2[k][3],"200,500")
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
