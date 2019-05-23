--- SURVIVER WITH CLUSTER SEARCH!!!
function init()
    self.colors = { 0xFF0000, 0xFF7F00, 0xFFFF0, 0x00FF00, 0x0000FF, 0x4B0082, 0x9400D3 }
    rightAngleCounter = 0
    circleEscaperSteps = 0

    logCounter = 0

    ENEMY_FACTOR = 1000
end

function step()

    if (circleEscaperSteps > 0) then
        circleEscaperSteps = circleEscaperSteps - 1
        return 0
    end

    local movingX = 0
    local movingY = 0

    local food = findFood(self.sight_radius, 0)

    -- if (#food <= 1) then
    --     log(string.format("Runnaway, found only %d food", #food))
    --     return -food[1].d -- Array starts at 1 :(
    -- end

    for i, item in pairs(food) do
        local distance = item.dist
        local direction = item.d
        local mass = item.v

        movingX = movingX + (math.sin(direction) * (1 / distance) * mass)
        movingY = movingY + (math.cos(direction) * (1 / distance) * mass)
    end

    local segments = findSegments(self.sight_radius, false)

    -- If there are enemies nearby dont look for food
    -- if(#segments > 0) then
        -- movingX = 0
        -- movingY = 0
    -- end

    for i, item in pairs(segments) do
        -- log_frequent(string.format("Segment: distance: %f direction: %f name: %s", item.dist, item.d, item.bot_name))
        local distance = item.dist
        local direction = item.d
        local mass = item.r
        local name = item.bot_name

        -- if (name NOT UNSERE_EIGENEN_SCHLANGEN)
        movingX = movingX - ENEMY_FACTOR * (math.sin(direction) * (1 / (distance * distance)) * mass)
        movingY = movingY - ENEMY_FACTOR * (math.cos(direction) * (1 / (distance * distance)) * mass)
    end
    log_frequent(string.format("Anzahl: %d", #segments))
    local finalRotation = math.atan(movingX, movingY)
    
    -- If running in circle
    if (math.abs(finalRotation) >= 1.55) then
        -- log(string.format("finalRotation: %f", finalRotation))
        rightAngleCounter = rightAngleCounter + 1
        if (rightAngleCounter >= 25) then
            log("Loop detected")
            circleEscaperSteps = 40
        end
    else
        rightAngleCounter = 0
    end

    return finalRotation
end

function log_frequent(message)
    logCounter = logCounter + 1
    if (logCounter >= 10) then
        logCounter = 0
        log(message)
    end
end