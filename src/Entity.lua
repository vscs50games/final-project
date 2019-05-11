Entity = Class{}

function Entity:init(def)
    self.x = def.x
    self.y = def.y
    self.dx = 0
    self.dy = 0
    self.map = def.map
    self.level = def.level
    self.width = def.width
    self.height = def.height
    self.texture = def.texture
    self.direction = 'left'
end

function Entity:render()
    love.graphics.draw(gTextures[self.texture], gFrames[self.texture][1],
        math.floor(self.x) + 8, math.floor(self.y) + 10, 0, self.direction == 'right' and 1 or -1, 1, 8, 10)
end