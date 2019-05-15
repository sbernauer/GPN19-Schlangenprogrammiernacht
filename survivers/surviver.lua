--- SURVIVER !!!
function init()
    self.colors = { 0x00FF00 }
end

-- a negative angle means turn left and a positive angle means turn right.
function step()
    local result = 0

    local own_radius = self.segment_radius

    local food = findFood(100, 0.8)
    -- ordered by food value (largest to lowest)

    for i, item in pairs(food) do

        -- distance of the food item, relative to the center of your head
        local distance = item.dist

        -- direction to the food item, in radians (-math.pi .. +math.pi)
        -- 0 means "straight ahead", math.pi means "right behind you"
        local direction = item.d

        -- mass of the food item. you will grow this amount if you eat it.
        -- realistic values are 0 - 4
        local value = item.v
        return direction

    end

    local segments = findSegments(100, false)

    for i, item in pairs(segments) do

        -- id of the bot the segment belongs to
        -- (you can compare this to self.id)
        local bot = item.bot

        -- distance to the center of the segment
        local distance = item.dist

        -- direction to the segment, in radians (-math.pi .. +math.pi)
        local direction = item.d

        -- radius of the segment
        local radius = item.r

        if distance<10 then
            -- you can send some log output to the web IDE, but it's rate limited.
            log(string.format("oh no, i'm going to die. distance: %.4f!", distance))
        end
    end

    return 0
end