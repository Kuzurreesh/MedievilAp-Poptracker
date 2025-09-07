function Has(item)
	return Tracker:FindObjectForCode(item).Active
end

function Can(location)
	if Tracker:FindObjectForCode(location).AccessibilityLevel > 5 then
		return true
	else
		return false
	end
end

-- Graveyard
function GraveEarth()
	if (Has("runesanity") and Has("earthgrave") or not Has("runesanity")) then
		return true
	else
		return false
	end
end

function GraveChaos()
	if (Has("runesanity") and Has("chaosgrave") or not Has("runesanity")) then
		return true
	else
		return false
	end
end

-- Hilltop Mausoleum
function HillChaos()
	if (Has("runesanity") and Has("chaoshill") or not Has("runesanity")) then
		return true
	else
		return false
	end
end

function HillEarth()
	if (Has("runesanity") and Has("earthhill") or not Has("runesanity")) then
		return true
	else
		return false
	end
end

function HillMoon()
	if (Has("runesanity") and Has("moonhill") or not Has("runesanity")) then
		return true
	else
		return false
	end
end

-- Return to the Graveyard
function ReturnStar()
	if (Has("runesanity") and Has("starreturn") or not Has("runesanity")) then
		return true
	else
		return false
	end
end

-- Scarecrow Fields
function ScareMoon()
	if (Has("runesanity") and Has("moonscare") or not Has("runesanity")) then
		return true
	else
		return false
	end
end

function ScareChaos()
	if (Has("runesanity") and Has("chaosscare") or not Has("runesanity")) then
		return true
	else
		return false
	end
end

function ScareEarth()
	if (Has("runesanity") and Has("earthscare") or not Has("runesanity")) then
		return true
	else
		return false
	end
end

-- Pumpkin Gorge
function GorgeMoon()
	if (Has("runesanity") and Has("moongorge") or not Has("runesanity")) then
		return true
	else
		return false
	end
end

function GorgeChaos()
	if (Has("runesanity") and Has("chaosgorge") or not Has("runesanity")) then
		return true
	else
		return false
	end
end

function GorgeEarth()
	if (Has("runesanity") and Has("earthgorge") or not Has("runesanity")) then
		return true
	else
		return false
	end
end

function GorgeStar()
	if (Has("runesanity") and Has("stargorge") or not Has("runesanity")) then
		return true
	else
		return false
	end
end

function GorgeTime()
	if (Has("runesanity") and Has("timegorge") or not Has("runesanity")) then
		return true
	else
		return false
	end
end

-- Sleeping Village
function SleepMoon()
	if (Has("runesanity") and Has("moonsleep") or not Has("runesanity")) then
		return true
	else
		return false
	end
end

function SleepChaos()
	if (Has("runesanity") and Has("chaossleep") or not Has("runesanity")) then
		return true
	else
		return false
	end
end

function SleepEarth()
	if (Has("runesanity") and Has("earthsleep") or not Has("runesanity")) then
		return true
	else
		return false
	end
end

-- Asylum Grounds
function GroundsChaos()
	if (Has("runesanity") and Has("chaosgrounds") or not Has("runesanity")) then
		return true
	else
		return false
	end
end

-- Inside the Asylum
function AsylumEarth()
	if (Has("runesanity") and Has("earthasylum") or not Has("runesanity")) then
		return true
	else
		return false
	end
end

-- Enchanted Earth
function EnchantEarth()
	if (Has("runesanity") and Has("earthenchant") or not Has("runesanity")) then
		return true
	else
		return false
	end
end

function EnchantStar()
	if (Has("runesanity") and Has("starenchant") or not Has("runesanity")) then
		return true
	else
		return false
	end
end

-- Pools of the Ancient Dead
function PADChaos()
	if (Has("runesanity") and Has("chaospools") or not Has("runesanity")) then
		return true
	else
		return false
	end
end

-- The Lake
function LakeChaos()
	if (Has("runesanity") and Has("chaoslake") or not Has("runesanity")) then
		return true
	else
		return false
	end
end

function LakeEarth()
	if (Has("runesanity") and Has("earthlake") or not Has("runesanity")) then
		return true
	else
		return false
	end
end

function LakeStar()
	if (Has("runesanity") and Has("starlake") or not Has("runesanity")) then
		return true
	else
		return false
	end
end

function LakeTime()
	if (Has("runesanity") and Has("timelake") or not Has("runesanity")) then
		return true
	else
		return false
	end
end

-- Crystal Caves
function CrystalEarth()
	if (Has("runesanity") and Has("earthcrystal") or not Has("runesanity")) then
		return true
	else
		return false
	end
end

function CrystalStar()
	if (Has("runesanity") and Has("starcrystal") or not Has("runesanity")) then
		return true
	else
		return false
	end
end

-- Gallows Gauntlet
function GallowStar()
	if (Has("runesanity") and Has("stargallow") or (not Has("runesanity") and Has("dragonarmour"))) then
		return true
	else
		return false
	end
end

-- Haunted Ruins
function RuinsChaos()
	if (Has("runesanity") and Has("chaosruins") or not Has("runesanity")) then
		return true
	else
		return false
	end
end

function RuinsEarth()
	if (Has("runesanity") and Has("earthruins") or (not Has("runesanity") and Has("crown") and (Has("dragonarmour") or Has("dash")))) then
		return true
	else
		return false
	end
end

-- The Ghost Ship
function ShipChaos()
	if (Has("runesanity") and Has("chaosship") or not Has("runesanity")) then
		return true
	else
		return false
	end
end

function ShipMoon()
	if (Has("runesanity") and Has("moonship") or not Has("runesanity")) then
		return true
	else
		return false
	end
end

function ShipStar()
	if (Has("runesanity") and Has("starship") or not Has("runesanity")) then
		return true
	else
		return false
	end
end

-- The Time Device
function DeviceMoon()
	if (Has("runesanity") and Has("moondevice") or not Has("runesanity")) then
		return true
	else
		return false
	end
end

function DeviceChaos()
	if (Has("runesanity") and Has("chaosdevice") or not Has("runesanity")) then
		return true
	else
		return false
	end
end

function DeviceEarth()
	if (Has("runesanity") and Has("earthdevice") or not Has("runesanity")) then
		return true
	else
		return false
	end
end

function DeviceTime()
	if (Has("runesanity") and Has("timedevice") or not Has("runesanity")) then
		return true
	else
		return false
	end
end

function Chalices(number)
	local count = 0
	number = tonumber(number)
	if not Has("include_chalices_in_checks") then
		return 0
	end
	if Can("@The Graveyard/Spinning Statue/Chalice") then
		count = count + 1
		if count >= number then
			return true
		end
	end
	if Can("@Cemetery Hill/Arena[1]/Chalice") then
		count = count + 1
		if count >= number then
			return true
		end
	end
	if Can("@Hilltop Mausoleum/Secret Alcove/Chalice") and Can("@Hilltop Mausoleum/Clear/Cleared: Hilltop Mausoleum") then
		count = count + 1
		if count >= number then
			return true
		end
	end
	if Can("@Return to the Graveyard/Undertakers/Chalice") then
		count = count + 1
		if count >= number then
			return true
		end
	end
	if Can("@Scarecrow Fields/Harvested Path[1]/Chalice") then
		count = count + 1
		if count >= number then
			return true
		end
	end
	if Can("@Pumpkin Gorge/Behind Wall/Chalice") then
		count = count + 1
		if count >= number then
			return true
		end
	end
	if Can("@Pumpkin Serpent/Down the Well[1]/Chalice") then
		count = count + 1
		if count >= number then
			return true
		end
	end
	if Can("@Sleeping Village/Ledge at Mayor's House/Chalice") then
		count = count + 1
		if count >= number then
			return true
		end
	end
	if Can("@Asylum Grounds/Elephant/Chalice") then
		count = count + 1
		if count >= number then
			return true
		end
	end
	if Can("@Inside the Asylum/Prison/Chalice") then
		count = count + 1
		if count >= number then
			return true
		end
	end
	if Can("@Enchanted Earth/Shadow Cave[1]/Chalice") and Can("@Enchanted Earth/Clear/Cleared: Enchanted Earth") then
		count = count + 1
		if count >= number then
			return true
		end
	end
	if Can("@Ant Caves/Clear/Chalice") and Has("include_ant_hill_in_checks") then
		count = count + 1
		if count >= number then
			return true
		end
	end
	if Can("@Pools of the Ancient Dead/West Side[3]/Chalice") and Can("@Pools of the Ancient Dead/Clear/Cleared: Pools of the Ancient Dead") then
		count = count + 1
		if count >= number then
			return true
		end
	end
	if Can("@The Lake/Past Tunnel[3]/Chalice") and Can("@The Lake/Clear/Cleared: The Lake") then
		count = count + 1
		if count >= number then
			return true
		end
	end
	if Can("@The Crystal Caves/Start/Chalice") then
		count = count + 1
		if count >= number then
			return true
		end
	end
	if Can("@The Gallows Gauntlet/Chalice Gate/Chalice") then
		count = count + 1
		if count >= number then
			return true
		end
	end
	if Can("@The Haunted Ruins/Outer Wall West[2]/Chalice") and Can("@The Haunted Ruins/Clear/Cleared: The Haunted Ruins") then
		count = count + 1
		if count >= number then
			return true
		end
	end
	if Can("@The Ghost Ship/Up the Lift/Chalice") then
		count = count + 1
		if count >= number then
			return true
		end
	end
	if Can("@The Entrance Hall/Zarok's Library[2]/Chalice") then
		count = count + 1
		if count >= number then
			return true
		end
	end
	if Can("@The Time Device/Lasers/Chalice") then
		count = count + 1
		if count >= number then
			return true
		end
	end
	return count >= number
end
