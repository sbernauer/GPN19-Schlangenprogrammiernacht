--- SURVIVER WITH CLUSTER SEARCH!!!
function init()
    self.colors = { 0xFF0000, 0xFF7F00, 0xFFFF0, 0x00FF00, 0x0000FF, 0x4B0082, 0x9400D3 }
    maxFoodSeen = 0
end

function step()
    -- log(string.format("My segment_radius: %.4f sight_radius: %.4f consume_radius: %.4f", self.segment_radius, self.sight_radius, self.consume_radius))

    local food = findFood(self.sight_radius, 0.8)

    local movingX = 0
    local movingY = 0

    -- log(string.format("Found %d food with sight %f. max: %f", #food, self.sight_radius, maxFoodSeen))
    -- If there is not enoguh food go where else
    maxFoodSeen = math.max(maxFoodSeen, #food)
    -- if((#food < 10 and #food <= (0.4 * maxFoodSeen - 1)) or (maxFoodSeen < 10 and #food <= 1)) then
    if (#findFood(60, 0.8) <= 1)
        log(string.format("Runnaway when seen %d food, maxfood: %d", #food, maxFoodSeen))
        return 0
    end

    for i, item in pairs(food) do
        local distance = item.dist
        local direction = item.d
        local mass = item.v

        local directionCost = math.abs(direction)
        local distanceCost = 1 / distance

        -- log(string.format("distancecost %f direction %f", distanceCost, directionCost))

        local totalCost = mass * distanceCost * directionCost

        movingX = movingX + (math.sin(direction) * totalCost)
        movingY = movingY + (math.cos(direction) * totalCost)
    end
    local finalRotation = math.atan(movingX, movingY)

    return finalRotation
end
