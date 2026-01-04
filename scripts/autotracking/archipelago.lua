-- this is an example/ default implementation for AP autotracking
-- it will use the mappings defined in item_mapping.lua and location_mapping.lua to track items and locations via their ids
-- it will also load the AP slot data in the global SLOT_DATA, keep track of the current index of on_item messages in CUR_INDEX
-- addition it will keep track of what items are local items and which one are remote using the globals LOCAL_ITEMS and GLOBAL_ITEMS
-- this is useful since remote items will not reset but local items might
ScriptHost:LoadScript("scripts/autotracking/item_mapping.lua")
ScriptHost:LoadScript("scripts/autotracking/location_mapping.lua")


CUR_INDEX = -1
SLOT_DATA = nil
LOCAL_ITEMS = {}
GLOBAL_ITEMS = {}



function onClear(slot_data)
    if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("called onClear, slot_data:\n%s", dump(slot_data)))
    end
    SLOT_DATA = slot_data
    CUR_INDEX = -1
    ScriptHost:RemoveOnLocationSectionHandler("ChaliceCount")
    ScriptHost:RemoveWatchForCode("Highlights1")
    ScriptHost:RemoveWatchForCode("Highlights2")
    TeamName = Archipelago:GetPlayerAlias(Archipelago.PlayerNumber)
    TeamNumber = Archipelago.TeamNumber
    NotifyKeys = {
        "Medievil_GPS_Team" .. TeamNumber .. "_" .. TeamName
    }


    -- reset locations
    for _, v in pairs(LOCATION_MAPPING) do
        if v[1] then
            if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
                print(string.format("onClear: clearing location %s", v[1]))
            end
            local obj = Tracker:FindObjectForCode(v[1])
            if obj then
                if v[1]:sub(1, 1) == "@" then
                    obj.AvailableChestCount = obj.ChestCount
                else
                    --hosted_item reset
                    obj.Active = false
                end
            elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
                print(string.format("onClear: could not find object for code %s", v[1]))
            end
        end
    end
    -- reset items
    for _, v in pairs(ITEM_MAPPING) do
        if v[1] and v[2] then
            if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
                print(string.format("onClear: clearing item %s of type %s", v[1], v[2]))
            end
            local obj = Tracker:FindObjectForCode(v[1])
            if obj then
                if v[2] == "toggle" then
                    obj.Active = false
                elseif v[2] == "progressive" then
                    obj.CurrentStage = 0
                    obj.Active = false
                elseif v[2] == "consumable" then
                    obj.AcquiredCount = 0
                elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
                    print(string.format("onClear: unknown item type %s for code %s", v[2], v[1]))
                end
            elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
                print(string.format("onClear: could not find object for code %s", v[1]))
            end
        end
    end

    -- reset local item(s)
    Tracker:FindObjectForCode("Chalice").AcquiredCount = 0

    -- Autotracking options
    if slot_data["options"] then
        local otable = slot_data["options"]
        local counted = 0
        
        Tracker:FindObjectForCode("runesanity").Active = otable["runesanity"]
        Tracker:FindObjectForCode("goal").CurrentStage = otable["goal"]
        Tracker:FindObjectForCode("include_ant_hill_in_checks").Active = otable["include_ant_hill_in_checks"]
        Tracker:FindObjectForCode("include_chalices_in_checks").Active = otable["include_chalices_in_checks"]
        
        if Has("include_chalices_in_checks") then
            local amount = otable["chalice_win_count"]
            if not Has("include_ant_hill_in_checks") then
                if amount > 19 then
                    counted = 19
                else
                    counted = amount
                end
            else
                counted = amount
            end
        end

        Tracker:FindObjectForCode("Chalice").MaxCount = counted
        Tracker:FindObjectForCode("booksanity").Active = otable["booksanity"]
        Tracker:FindObjectForCode("gargoylesanity").Active = otable["gargoylesanity"]
        Tracker:FindObjectForCode("progression_option").Active = otable["progression_option"]
    end

    LOCAL_ITEMS = {}
    GLOBAL_ITEMS = {}
    ScriptHost:AddOnLocationSectionChangedHandler("ChaliceCount", ChaliceCount)
    ScriptHost:AddWatchForCode("Highlights1", "progression_option", Lighting)
    ScriptHost:AddWatchForCode("Highlights2", "runesanity", Lighting)
    Archipelago:SetNotify(NotifyKeys)
end

-- called when an item gets collected
function onItem(index, item_id, item_name, player_number)
    if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("called onItem: %s, %s, %s, %s, %s", index, item_id, item_name, player_number, CUR_INDEX))
    end
    if not AUTOTRACKER_ENABLE_ITEM_TRACKING then
        return
    end
    if index <= CUR_INDEX then
        return
    end
    local is_local = player_number == Archipelago.PlayerNumber
    CUR_INDEX = index;
    local v = ITEM_MAPPING[item_id]
    if not v then
        if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
            print(string.format("onItem: could not find item mapping for id %s", item_id))
        end
        return
    end
    if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("onItem: code: %s, type %s", v[1], v[2]))
    end
    if not v[1] then
        return
    end
    local obj = Tracker:FindObjectForCode(v[1])
    if obj then
        if v[2] == "toggle" then
            obj.Active = true
        elseif v[2] == "progressive" then
            if obj.Active then
                obj.CurrentStage = obj.CurrentStage + 1
            else
                obj.Active = true
            end
        elseif v[2] == "consumable" then
            obj.AcquiredCount = obj.AcquiredCount + obj.Increment
        elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
            print(string.format("onItem: unknown item type %s for code %s", v[2], v[1]))
        end
    elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("onItem: could not find object for code %s", v[1]))
    end
    -- track local items via snes interface
    if is_local then
        if LOCAL_ITEMS[v[1]] then
            LOCAL_ITEMS[v[1]] = LOCAL_ITEMS[v[1]] + 1
        else
            LOCAL_ITEMS[v[1]] = 1
        end
    else
        if GLOBAL_ITEMS[v[1]] then
            GLOBAL_ITEMS[v[1]] = GLOBAL_ITEMS[v[1]] + 1
        else
            GLOBAL_ITEMS[v[1]] = 1
        end
    end
    if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("local items: %s", dump(LOCAL_ITEMS)))
        print(string.format("global items: %s", dump(GLOBAL_ITEMS)))
    end
end

-- called when a location gets cleared
function onLocation(location_id, location_name)
    --  print(string.format("called onLocation: %s, %s", location_id, location_name))

    if not AUTOTRACKER_ENABLE_LOCATION_TRACKING then
        return
    end
    local v = LOCATION_MAPPING[location_id]

    if not v and AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("onLocation: could not find location mapping for id %s", location_id))
    end
    if not v[1] then
        return
    end
    local obj = Tracker:FindObjectForCode(v[1])
    if obj then
        if v[1]:sub(1, 1) == "@" then
            obj.AvailableChestCount = obj.AvailableChestCount - 1
        else
            obj.Active = true
        end
        if v[2] then
            Tracker:FindObjectForCode(v[2]).AvailableChestCount = Tracker:FindObjectForCode(v[2]).AvailableChestCount - 1
        end
    elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("onLocation: could not find object for code %s", v[1]))
    end

    -- MacGuyver Autotab
    if Has("autotab") then
        if v[1].find(v[1], "/Cleared:", 8) then
            Tracker:UiHint("ActivateTab", "World Map")
        else
            local v2 = v[1]:sub(1, 10)
            local v3 = Where[v2]
            if v3 then
                Tracker:UiHint("ActivateTab", v3)
            end
        end
    end
end

-- called when a bounce message is received
function onBounce(json)
    print(string.format("called onBounce: %s", dump(json)))
    --[[   local data = json["data"]
    if data then
        if data["type"] == "MapUpdate" then

        end
    end
    -- your code goes here
]]
end

function onDataStorageUpdate(key, value, oldValue)
    -- print("called datastrorage: ", key, value, oldValue)
    if Has("autotab") then
        if key.find(key, "GPS") then
            local r = value["MapId"]
            if r >= 0 and r < 24 then
                -- print("mapID: ", r)
                local Map = Maps[r]
                -- print("Map: ", Map)
                if Map then
                    Tracker:UiHint("ActivateTab", Map)
                end
            else
                print("ERROR; Other map: ", r, value["MapName"])
            end
        else
            return
        end
    end
end

-- add AP callbacks
-- un-/comment as needed
Archipelago:AddClearHandler("clear handler", onClear)
if AUTOTRACKER_ENABLE_ITEM_TRACKING then
    Archipelago:AddItemHandler("item handler", onItem)
end

if AUTOTRACKER_ENABLE_LOCATION_TRACKING then
    Archipelago:AddLocationHandler("location handler", onLocation)
end
Archipelago:AddBouncedHandler("bounce handler", onBounce)
Archipelago:AddRetrievedHandler("retrieved handler", onDataStorageUpdate)
Archipelago:AddSetReplyHandler("set reply handler", onDataStorageUpdate)
