function ChaliceCount(section)
    ScriptHost:RemoveWatchForCode("Counting")
    local list = {
        hohicon = 0,
        crypticon = 0,
        graveicon = 0,
        hillicon = 0,
        mausoleumicon = 0,
        rtgicon = 0,
        scareicon = 0,
        gorgeicon = 0,
        serpenticon = 0,
        sleepicon = 0,
        groundsicon = 0,
        asylumicon = 0,
        enchanticon = 0,
        anticon = 0,
        padicon = 0,
        lakeicon = 0,
        crystalicon = 0,
        gallowsicon = 0,
        ruinsicon = 0,
        shipicon = 0,
        hallicon = 0,
        deviceicon = 0,
        zarokicon = 0,
    }
    local count = 0
    for _, obj in pairs(LOCATION_MAPPING) do
        if obj[1] == "clearedgallows" then
            if Tracker:FindObjectForCode(obj[1]).Active == false then
                if Tracker:FindObjectForCode("@The Gallows Gauntlet/Clear[1]").AccessibilityLevel == AccessibilityLevel.Normal then
                    list["gallowsicon"] = list["gallowsicon"] + 1
                end
            end
        else
            if Tracker:FindObjectForCode(obj[1]).AccessibilityLevel == AccessibilityLevel.Normal then
                local which = Where2[obj[1]:sub(1, 10)]
                list[which] = list[which] + 1
                --print(which, list[which])
                -- if Tracker:FindObjectForCode(obj[1]).AccessibilityLevel == AccessibilityLevel.Normal then
                --     count = count + 1
                -- end
            else
            end
        end
    end
    for key, value in pairs(list) do
        if value ~= 0 then
            Tracker:FindObjectForCode(key).BadgeText = tostring(value)
            -- print(list[key])
        else
            Tracker:FindObjectForCode(key).BadgeText = ""
        end
        count = count + value
    end
    Tracker:FindObjectForCode("countering").BadgeText = tostring(count)
    ScriptHost:AddWatchForCode("Counting", "*", ChaliceCount)
end

ScriptHost:AddOnLocationSectionChangedHandler("In Logic", ChaliceCount)
ScriptHost:AddWatchForCode("Counting", "*", ChaliceCount)



function Lighting(code)
    ScriptHost:RemoveOnLocationSectionHandler("In Logic")
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
    ScriptHost:AddOnLocationSectionChangedHandler("In Logic", ChaliceCount)

    Archipelago:Get(NotifyHints)
end

function HUDLess()
    local k = 2
    if Has("zoom") then
        -- print("Zoom " .. Maps2[k][1], "16")
        -- print("Pan " .. Maps2[k][1], Maps2[k][3], "200,500")
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