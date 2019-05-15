--- SURVIVER WITH CLUSTER SEARCH!!!
function init()
    self.colors = { 0xFFFF00 }
end

function step()
    local own_radius = self.segment_radius

    local food = findFood(50000, 0.8)

    local movingX = 0
    local movingY = 0

    for i, item in pairs(food) do

        local distance = item.dist
        local direction = item.d
        local mass = item.v

        movingX = movingX + (math.sin(direction) * (1 / distance) * mass)
        movingY = movingY + (math.cos(direction) * (1 / distance) * mass)
    end
    local finalRotation = math.atan(movingX, movingY)
    return finalRotation
end
