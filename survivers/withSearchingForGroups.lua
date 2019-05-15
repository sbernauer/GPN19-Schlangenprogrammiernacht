--- SURVIVER WITH CLUSTER SEARCH!!!
function init()
    self.colors = { 0xFF0000, 0xFF7F00, 0xFFFF0, 0x00FF00, 0x0000FF, 0x4B0082, 0x9400D3 }
    returnValueLastOne = 0
    returnValueSecondOne = 0
    escapeFromCircle = 0
end

function step()
    log(string.format("My segment_radius: %.4f sight_radius: %.4f consume_radius: %.4f", self.segment_radius, self.sight_radius, self.consume_radius))

    if(escapeFromCircle > 0) then
        escapeFromCircle = escapeFromCircle - 1
        return 0
    end

    local food = findFood(self.sight_radius, 0.8)

    local movingX = 0
    local movingY = 0

    for i, item in pairs(food) do

        local distance = item.dist
        local direction = item.d
        local mass = item.v

        movingX = movingX + (math.sin(direction) * (1 / (distance)) * mass)
        movingY = movingY + (math.cos(direction) * (1 / (distance)) * mass)
    end
    local finalRotation = math.atan(movingX, movingY)
    -- Check if finalRotation is 90 degreee to left or right, so it would cause a loop
    -- TODO 
    -- Check if running in circle
    if (returnValueSecondOne == finalRotation and finalRotation ~= 0) then
        escapeFromCircle = 30
        return 0
    end
    
    -- Keep track of the last rotations
    returnValueSecondOne = returnValueLastOne
    returnValueLastOne = finalRotation
    return finalRotation
end
