local LEVEL <const> = "Level"
local SLOT <const> = 1

function Utilities.setLevel(nextLevel)
	return Noble.GameData.set(LEVEL, nextLevel, SLOT)
end


function Utilities.getLevel()
	return Noble.GameData.get(LEVEL, SLOT)
end
