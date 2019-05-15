--- SURVIVER WITH CLUSTER SEARCH!!!
function init()
    self.colors = { 0xFF0000, 0xFF7F00, 0xFFFF0, 0x00FF00, 0x0000FF, 0x4B0082, 0x9400D3 }
    rightAngleCounter = 0
    circleEscaperSteps = 0
end

function step()

    if (circleEscaperSteps > 0) then
        circleEscaperSteps = circleEscaperSteps - 1
        return 0
    end

    local food = findFood(self.sight_radius, 0.8)

    local movingX = 0
    local movingY = 0

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
    local finalRotation = math.atan(movingX, movingY)

    
    -- If running in circle
    if (math.abs(finalRotation) >= 1.6) then
        -- log(string.format("finalRotation: %f", finalRotation))
        rightAngleCounter = rightAngleCounter + 1
        if (rightAngleCounter >= 20) then
            log("Loop detected")
            circleEscaperSteps = 50
        end
    else
        rightAngleCounter = 0
    end

    return finalRotation
end
