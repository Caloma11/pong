Ball = Class{}

function Ball:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height

    self.dx = math.random(2) == 1 and -100 or 100  -- Delta X (velocity)
    self.dy = math.random(-50, 50) -- Delta Y (velocity)
end

-- Checks if it collides with a 'box' (paddle)

function Ball:collides(box)
    if self.x > box.x + box.width or self.x + self.width < box.x then
        return false
    end

    if self.y > box.y + box.height or self.y + self.height < box.y then
        return false
    end

    return true
end

-- Applies velocity to position scaled  by dt

function Ball:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

-- Places ball in the middle with random x and y velocities

function Ball:reset()
    self.x = VIRTUAL_WIDTH / 2 - 2
    self.y = VIRTUAL_HEIGHT / 2 - 2

    self.dx = math.random(2) == 1 and -100 or 100  -- Delta X (velocity)
    self.dy = math.random(-50, 50) -- Delta Y (velocity)
end

-- Sets the 'ball' in the middle

function Ball:render()
    love.graphics.rectangle('fill', self.x, self.y, 4 , 4)
end


