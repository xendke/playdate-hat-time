GemTracker = {}

local tracker = {}
local gemCount = 0

function GemTracker.collectGem(level, x, y)
    local levelTracker = tracker[level]
    if levelTracker == nil then
        tracker[level] = {}
    end

    local gemTracker = string.format("%s,%s", math.floor(x), math.floor(y))
    tracker[level][gemTracker] = true
    gemCount += 1
end

function GemTracker.alreadyCollected(level, x, y)
    local levelTracker = tracker[level]
    if levelTracker == nil then return false end

    local gemTracker = string.format("%s,%s", math.floor(x), math.floor(y))
    return tracker[level][gemTracker]
end

function GemTracker.getTracker()
    return tracker
end

function GemTracker.getCount()
    return gemCount
end
