Chal = {
    [1] = "@The Graveyard/Spinning Statue/Chalice",
    [2] = "@Cemetery Hill/Arena[1]/Chalice",
    [3] = "@Hilltop Mausoleum/Secret Alcove/Chalice",
    [4] = "@Return to the Graveyard/Undertakers/Chalice",
    [5] = "@Scarecrow Fields/Harvested Path[1]/Chalice",
    [6] = "@Pumpkin Gorge/Behind Wall/Chalice",
    [7] = "@Pumpkin Serpent/Down the Well[1]/Chalice",
    [8] = "@Sleeping Village/Ledge at Mayor's House/Chalice",
    [9] = "@Asylum Grounds/Elephant/Chalice",
    [10] = "@Inside the Asylum/Prison/Chalice",
    [11] = "@Enchanted Earth/Shadow Cave[1]/Chalice",
    [12] = "@Ant Caves/Clear/Chalice",
    [13] = "@Pools of the Ancient Dead/West Side[3]/Chalice",
    [14] = "@The Lake/Past Tunnel[3]/Chalice",
    [15] = "@The Crystal Caves/Start/Chalice",
    [16] = "@The Gallows Gauntlet/Chalice Gate/Chalice",
    [17] = "@The Haunted Ruins/Outer Wall West[2]/Chalice",
    [18] = "@The Ghost Ship/Up the Lift/Chalice",
    [19] = "@The Entrance Hall/Zarok's Library[2]/Chalice",
    [20] = "@The Time Device/Lasers/Chalice"
}

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

ScriptHost:AddOnLocationSectionChangedHandler("ChaliceCount", ChaliceCount)
