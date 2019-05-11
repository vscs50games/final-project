Player = Class{__includes = Entity}

function Player:init(def)
    Entity.init(self, def)
    self.hp = 250
    self.lastTile = def.lastTile or 0
    self.spell_selected = nil
    self.active = def.active or false
    self.player_num = def.player_num
    self.gravity = 10
    self.jump_vel = -250
    self.walk_speed = 50
end

function Player:update(dt, camX)
    local tileBottomLeft
    local tileBottomRight
    if self.y < 0 then
        tileBottomLeft = nil
        tileBottomRight = nil
    else
        tileBottomLeft = self.map:pointToTile(self.x + 1, self.y + self.height)
        tileBottomRight = self.map:pointToTile(self.x  + self.width - 1, self.y + self.height)
    end
    
    if (tileBottomLeft and tileBottomRight) and (tileBottomLeft:collidable() or tileBottomRight:collidable()) then
        self.dy = 0
        self.y = (tileBottomLeft.y - 1) * 16 - self.height
    else
        self.dy = self.dy + self.gravity
    end

    if self.active then
        if love.keyboard.isDown('left') then
            self.dx = -self.walk_speed
            self:checkLeftCollisions(dt, camX)
            self.direction = "left"
        elseif love.keyboard.isDown('right') then
            self.dx = self.walk_speed
            self:checkRightCollisions(dt, camX)
            self.direction = "right"
        end
        if love.keyboard.wasPressed('space') and self.dy == 0 then
            self.dy = self.jump_vel
        end
    end

    self.x = self.x + self.dx*dt
    self.y = self.y + (self.dy*dt)
    self.dx = 0
end

function Player:render(camX)
    Entity.render(self)
    if self.spell_selected then
        mx, my = push:toGame(love.mouse.getPosition())
        player_world_x = self.x - camX
        dx = player_world_x - mx
        dy = self.y - my
        angle = 0
        if dx < 0 and dy < 0 then
            dx = -dx
            dy = -dy
            angle = -1 * math.abs(math.atan2(dx, dy)) - math.pi/2
        elseif dx < 0 then
            dx = -dx
            angle = math.abs(math.atan2(dx, dy)) + math.pi/2
        elseif dy > 0 and dx > 0 then
            angle = math.abs(math.atan2(dy, dx))
        else
            dy = -dy
            angle = -1 * math.abs(math.atan2(dy, dx))
        end
        love.graphics.draw(gTextures["arrow"], self.x + 5, self.y + 10, math.pi+angle, 0.05, 0.05)
    end
    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.print("P" .. self.player_num, self.x, self.y + 20)
    love.graphics.setColor(255, 255, 255, 255)
end

function Player:checkLeftCollisions(dt, camX)
    if self.y < 0 or self.x < 1 then
        return
    end
    local tileTopLeft = self.map:pointToTile(self.x + 1, self.y + 1)
    local tileBottomLeft = self.map:pointToTile(self.x + 1, self.y + self.height - 1)
    if (tileTopLeft and tileBottomLeft) and (tileTopLeft:collidable() or tileBottomLeft:collidable()) then
        self.x = (tileTopLeft.x - 1) * 16 + tileTopLeft.width - 1
    end
end

function Player:checkRightCollisions(dt, camX)
    if self.y < 0 or self.x < 1 then
        return
    end
    local tileTopRight = self.map:pointToTile(self.x + self.width - 1, self.y + 1)
    local tileBottomRight = self.map:pointToTile(self.x + self.width - 1, self.y + self.height - 1)
    if (tileTopRight and tileBottomRight) and (tileTopRight:collidable() or tileBottomRight:collidable()) then
        self.x = (tileTopRight.x - 1) * 16 - self.width
    end
end