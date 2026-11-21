List = {}
function ChaliceCount(section)
    ScriptHost:RemoveWatchForCode("Counting")
    List = {
        hohicon = { 0, 0 },
        crypticon = { 0, 0 },
        graveicon = { 0, 0 },
        hillicon = { 0, 0 },
        mausoleumicon = { 0, 0 },
        rtgicon = { 0, 0 },
        scareicon = { 0, 0 },
        gorgeicon = { 0, 0 },
        serpenticon = { 0, 0 },
        sleepicon = { 0, 0 },
        groundsicon = { 0, 0 },
        asylumicon = { 0, 0 },
        enchanticon = { 0, 0 },
        anticon = { 0, 0 },
        padicon = { 0, 0 },
        lakeicon = { 0, 0 },
        crystalicon = { 0, 0 },
        gallowsicon = { 0, 0 },
        ruinsicon = { 0, 0 },
        shipicon = { 0, 0 },
        hallicon = { 0, 0 },
        deviceicon = { 0, 0 },
        zarokicon = { 0, 0 },
    }
    local count = 0
    local countshop = 0
    for _, obj in pairs(LOCATION_MAPPING2) do
        if obj[1] == "clearedgallows" then
            if Tracker:FindObjectForCode(obj[1]).Active == false then
                if Tracker:FindObjectForCode("@The Gallows Gauntlet/Clear[1]").AccessibilityLevel == AccessibilityLevel.Normal then
                    List["gallowsicon"][1] = List["gallowsicon"][1] + 1
                end
            end
        elseif Tracker:ProviderCountForCode("shopsanity") > 0 and obj[1]:sub(obj[1]:len() - 4) == "Items" then
           -- print("------------Shop items", obj[1])
            if Tracker:FindObjectForCode(obj[1]).AccessibilityLevel == AccessibilityLevel.Normal then
                local which = Where2[obj[1]:sub(1, 10)]
                List[which][2] = List[which][2] + Tracker:FindObjectForCode(obj[1]).AvailableChestCount
                --print(which, List[which])
                -- if Tracker:FindObjectForCode(obj[1]).AccessibilityLevel == AccessibilityLevel.Normal then
                --     count = count + 1
                -- end
            end
        else
            if Tracker:FindObjectForCode(obj[1]).AccessibilityLevel == AccessibilityLevel.Normal then
                local which = Where2[obj[1]:sub(1, 10)]
                List[which][1] = List[which][1] + Tracker:FindObjectForCode(obj[1]).AvailableChestCount
                --print(which, List[which])
                -- if Tracker:FindObjectForCode(obj[1]).AccessibilityLevel == AccessibilityLevel.Normal then
                --     count = count + 1
                -- end
            end
        end
    end
    local textshop = ""
    for key, value in pairs(List) do
        local text = ""
        textshop = ""
        if value[1] ~= 0 then
            
           text = tostring(value[1])
            -- print(List[key])
            -- else
            --     Tracker:FindObjectForCode(key).BadgeText = ""           
        end
        if Tracker:ProviderCountForCode("shopsanity") > 0 then
            if value[2] ~= 0 then
                textshop = "+" .. tostring(value[2])
            end
        end
        Tracker:FindObjectForCode(key).BadgeText = text .. textshop
        count = count + value[1]
        countshop = countshop + value[2]
    end
    if Tracker:ProviderCountForCode("shopsanity") > 0 then
        textshop = "+"..tostring(countshop)
    end
    Tracker:FindObjectForCode("countering").BadgeText = tostring(count) .. textshop
    ScriptHost:AddWatchForCode("Counting", "*", ChaliceCount)
end

ScriptHost:AddOnLocationSectionChangedHandler("In Logic", ChaliceCount)
ScriptHost:AddWatchForCode("Counting", "*", ChaliceCount)


function Progression(code)
    local item = code:sub(5, code:len())
    local count = Tracker:FindObjectForCode(code).AcquiredCount
    for i = 1, count, 1 do
        Tracker:FindObjectForCode(item .. i).Active = true
    end
end

ScriptHost:AddWatchForCode("progsword", "progsword", Progression)
ScriptHost:AddWatchForCode("progshield", "progshield", Progression)
ScriptHost:AddWatchForCode("progbow", "progbow", Progression)


function AllKnights()
    if Tracker:FindObjectForCode("knight").AcquiredCount >= Tracker:FindObjectForCode("knights_to_find").AcquiredCount then
        Tracker:FindObjectForCode("knight").BadgeTextColor = "#00FF00"
    else
        Tracker:FindObjectForCode("knight").BadgeTextColor = "#FFFFFF"
    end
end

ScriptHost:AddWatchForCode("AllKnights", "knight", AllKnights)


function Shopping()
    for index, value in ipairs(SHOP) do
        Tracker:FindObjectForCode(value).AvailableChestCount = Tracker:FindObjectForCode("shopsanity")
            .AcquiredCount
    end
end

ScriptHost:AddWatchForCode("Shops", "shopsanity", Shopping)


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
