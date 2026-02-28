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
Traps = {}

function onClear(slot_data)
    if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("called onClear, slot_data:\n%s", dump(slot_data)))
    end
    SLOT_DATA = slot_data
    CUR_INDEX = -1
    -- ScriptHost:RemoveOnLocationSectionHandler("ChaliceCount")
    ScriptHost:RemoveWatchForCode("Highlights1")
    ScriptHost:RemoveWatchForCode("Highlights2")
    ScriptHost:RemoveWatchForCode("Go-Mode")
    ScriptHost:RemoveWatchForCode("imp weapon")
    ScriptHost:RemoveWatchForCode("Rune")
    TeamName = Archipelago:GetPlayerAlias(Archipelago.PlayerNumber)
    TeamNumber = Archipelago.TeamNumber
    NotifyKeys = {
        "Medievil_GPS_Team" .. TeamNumber .. "_" .. TeamName
    }
    NotifyHints = {
        "_read_hints_" .. TeamNumber .. "_" .. Archipelago.PlayerNumber
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
    Tracker:FindObjectForCode("GO").Active = false

    -- Autotracking options
    if slot_data["options"] then
        local otable = slot_data["options"]
        local amount = 0

        Tracker:FindObjectForCode("runesanity").Active = otable["runesanity"]
        Tracker:FindObjectForCode("goal").CurrentStage = otable["goal"]

        Goal = otable["goal"]
        Tracker:FindObjectForCode("include_ant_hill_in_checks").Active = otable["include_ant_hill_in_checks"]
        Tracker:FindObjectForCode("include_chalices_in_checks").Active = otable["include_chalices_in_checks"]

        if Has("include_chalices_in_checks") then
            amount = otable["chalice_win_count"]
            Tracker:FindObjectForCode("Chalice").MaxCount = amount
        else
            amount = 0
        end
        local tracker = Tracker:FindObjectForCode("chaliceproxy")
        Tracker:FindObjectForCode("chalice_win_count").CurrentStage = amount
        Tracker:FindObjectForCode("chalice").MaxCount = amount
        tracker.BadgeText = "0/" .. tostring(amount)
        tracker.IgnoreUserInput = true
        tracker:SetOverlayFontSize(14)
        Tracker:FindObjectForCode("booksanity").Active = otable["booksanity"]
        Tracker:FindObjectForCode("gargoylesanity").Active = otable["gargoylesanity"]
        Tracker:FindObjectForCode("progression_option").Active = otable["progression_option"]
    end
    
    LOCAL_ITEMS = {}
    GLOBAL_ITEMS = {}
    -- ScriptHost:AddOnLocationSectionChangedHandler("ChaliceCount", ChaliceCount)
    ScriptHost:AddWatchForCode("Highlights1", "progression_option", Lighting)
    ScriptHost:AddWatchForCode("Highlights2", "runesanity", Lighting)
    ScriptHost:AddWatchForCode("Go-Mode", "gocheck", GO)
  --  ScriptHost:AddWatchForCode("chalicechange", "chalice", GO)
   -- ScriptHost:AddWatchForCode("bottle", "bottle", GO)
    ScriptHost:AddWatchForCode("imp weapon", "imp", GO)
    ScriptHost:AddWatchForCode("Rune", "rune", GO)
    Archipelago:Get(NotifyKeys)
    Archipelago:Get(NotifyHints)
    Archipelago:SetNotify(NotifyKeys)
    Archipelago:SetNotify(NotifyHints)
    GO()
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
    -- print("hud: ",json["data"]["HUD"]["Region"],json["data"]["HUD"]["MapName"] )
    local data = json["data"]["trap"]
    if Has("zoom") then
        if data["MapId"] > 0 then
            if data["Region"] == "set" then
                local name = Maps2[data["MapId"]]
                if data["MapName"] == "HUD" and Has("HUDtrap")  then
                    Tracker:FindObjectForCode("HUD").Active = false
                    table.insert(Traps, { data["MapName"], data["MapId"] })
                elseif data["MapName"] == "Dark" and Has("dark") and PopVersion >= "0.34.0" then
                    Tracker:UiHint("Zoom " .. name[1], "16")
                    Tracker:UiHint("Pan " .. name[1], "200,500")
                    table.insert(Traps, { data["MapName"], data["MapId"] })
                else
                    print("No valid trap", data["MapName"])
                end
            elseif data["Region"] == "reset" then

            else
                print("No valid action", data["Region"])
            end
        end
    end
    if data["Region"] == "reset" then
        if Traps[1] then
            if Traps[1][1] == "HUD" then
                Tracker:FindObjectForCode("HUD").Active = true
            elseif Traps[1][1] == "Dark" and PopVersion >= "0.34.0" then
                Tracker:UiHint("Zoom " .. Maps2[Traps[1][2]][1], "1")
                Tracker:UiHint("Pan " .. Maps2[Traps[1][2]][1], Maps2[Traps[1][2]][2])
            else
                print("No valid trap in list", Traps[1][1])
            end
            table.remove(Traps, 1)
        else
            print("Can't reset, empty trap list!")
        end
    elseif data["Region"] == "set" then

    else
        print("No valid action", data["Region"])
    end
end

function onDataStorageUpdate(key, value, oldValue)
    --  print("called datastrorage: ", key, value, oldValue)
    if key == NotifyKeys[1] and value then
        if Has("autotab") then
            --  print("Key: ", key)
            --  print("value: ", value)
            local Map
            local r = Maps[value]
            local x = Maps[value["MapName"]]
            if r then
                Map = r
                --    print("mapname: ", Map)
            elseif x then
                Map = Maps[value["MapName"]]
                --  print("mapid: ", r, Map)
            end
            if Map then
                Tracker:UiHint("ActivateTab", Map)
            else
                --      print("ERROR; Other map: ", r, value["MapName"], Map, "GPS?: ", value["GPS"])
                Tracker:UiHint("ActivateTab", "World Map")
            end
        end
        local count = tonumber(value["Region"])
        -- print("count region: ", count)
        if count then
            local tracker = Tracker:FindObjectForCode("chaliceproxy")
            Tracker:FindObjectForCode("chalice").AcquiredCount = count

            if count > 0 then
                tracker.Active = true
            end
            tracker.BadgeText = tostring(count) ..
                "/" .. tostring(Tracker:FindObjectForCode("chalice_win_count").CurrentStage)
            if count >= Tracker:FindObjectForCode("chalice_win_count").CurrentStage then
                tracker.BadgeTextColor = "00FF00"
            end
        end
    end
    if key == NotifyHints[1] and value then
        for _, hint in ipairs(value) do
            -- we only care about hints in our world
            local hint_status = hint.status
            local hint_item = hint.item
            if hint_status < 40 then
                if hint.finding_player == Archipelago.PlayerNumber then
                    local location_code = LOCATION_MAPPING[hint.location][1]
                    if location_code and location_code:sub(1, 1) == "@" then
                        local hinted_item = ""
                        if Archipelago:GetPlayerGame(hint.receiving_player) == "Medievil" then
                            hinted_item = ITEM_MAPPING[hint_item][1]
                        elseif Archipelago:GetPlayerGame(hint.receiving_player) == "Medievil 2" then
                            hinted_item = Medi_II_Items[hint_item][1]
                        end
                        if hinted_item == "filler" then
                            hint_status = 20
                        elseif hinted_item == "small" or hinted_item == "medium" or hinted_item == "large" then
                            hint_status = 0
                        end
                        Tracker:FindObjectForCode(location_code).Highlight = HIGHLIGHT_STATUS_MAPPING[hint_status]
                    end

                    -- print("itemflag", hint.item_flags)
                    --local x = tonumber(hint.location)
                    -- print("item:", hint.item, ITEM_MAPPING[hint.item][1])
                    -- print("location: ", hint.location, LOCATION_MAPPING[x][1], hint_status)
                    -- print("for", hint.receiving_player, Archipelago:GetPlayerAlias(hint.receiving_player))
                    -- print("----------------------------------------------------------------------------------------")
                end
            end
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
