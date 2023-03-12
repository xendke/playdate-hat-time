Utilities.WEST = "west"
Utilities.EAST = "east"
Utilities.DEFAULT_DIRECTION = Utilities.EAST

local LEVEL <const> = "Level"
local DIRECTION <const> = "EntranceDirection"
local GEM_COUNT <const> = "GemCount"
local SLOT <const> = 1

function Utilities.setLevel(nextLevel)
	return Noble.GameData.set(LEVEL, nextLevel, SLOT)
end


function Utilities.getLevel()
	return Noble.GameData.get(LEVEL, SLOT)
end


function Utilities.setEntranceDirection(direction)
	return Noble.GameData.set(DIRECTION, direction, SLOT)
end


function Utilities.getEntranceDirection()
	return Noble.GameData.get(DIRECTION, SLOT)
end
function Utilities.increaseGemCount()
	local current = Noble.GameData.get(GEM_COUNT, SLOT)
	return Noble.GameData.set(GEM_COUNT, current + 1, SLOT)
end

function Utilities.getGemCount()
	return Noble.GameData.get(GEM_COUNT, SLOT)
end

function Utilities.approach(value,target,step)
	if value==target then
		return value, true
	end

	local d = target-value
	if d>0 then
		value = value + step
		if value >= target then
			return target, true
		else
			return value, false
		end
	elseif d<0 then
		value = value - step
		if value <= target then
			return target, true
		else
			return value, false
		end
	else
		return value, true
	end
end
