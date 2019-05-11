NeutralBomb = Class{}

function NeutralBomb:init(x, y, angle, map, up, right, players, camX)
    self.x = x
    self.y = y

    self.angle = angle
    self.players = players
    self.velocity = 50
    self.gravityy = 20
    self.gravityx = 0
    self.map = map
    self.width = 16
    self.height = 16
    self.ttl = 6
    self.done = false
    self.on_floor = false
    self.camX = camX

    if up > 0 then
        self.up = true
    else
        self.up = false
    end

    if right > 0 then
        self.right = false
    else
        self.right = true
    end

    if self.up and self.right then
        self.vely = -self.velocity*math.sin(angle)
        self.velx = self.velocity*math.cos(angle)
    elseif not self.up and self.right then
        self.vely = self.velocity*math.sin(angle)
        self.velx = self.velocity*math.cos(angle)
    elseif self.up and not self.right then
        self.vely = -self.velocity*math.cos(angle)
        self.velx = -self.velocity*math.sin(angle)
    else
        self.vely = self.velocity*math.cos(angle)
        self.velx = -self.velocity*math.sin(angle)
    end
end

function NeutralBomb:update(dt)
    if self.ttl > 0 then

        if not self.on_floor then
            self.vely = self.vely + self.gravityy*dt
        end

        if self.vely ~= 0 and not self.on_floor then
            self.y = self.y + self.vely*dt
        end

        if self.velx ~= 0 then
            self.x = self.x + self.velx*dt
            self.velx = self.velx - self.gravityx*dt
        end
        
        if self.y > 0 and self.x > 0 then
            local tileBottomLeft = self.map:pointToTile(self.x + self.camX + 1, self.y + self.height)
            local tileBottomRight = self.map:pointToTile(self.x + self.camX + self.width - 1, self.y + self.height)

            -- if we get a collision beneath us, go into either walking or idle
            if (tileBottomLeft and tileBottomRight) and (tileBottomLeft:collidable() or tileBottomRight:collidable()) then
                self.vely = 0
                self.on_floor = true

            elseif (tileBottomLeft and tileBottomRight) and not (tileBottomLeft:collidable() or tileBottomRight:collidable()) then
                self.on_floor = false
            end
        end
        

        self:checkRightCollisions(dt)
        self:checkLeftCollisions(dt)

        self.ttl = self.ttl - dt
        if self.ttl <= 0 then
            self:explode(dt)
        end
    end
end

function NeutralBomb:checkRightCollisions(dt)
    if self.y < 0 or self.x < 0 then
        return
    end
    local tileTopRight = self.map:pointToTile(self.x + self.camX + self.width - 1, self.y + 1)
    local tileBottomRight = self.map:pointToTile(self.x + self.camX + self.width - 1, self.y + self.height - 1)
    if (tileTopRight and tileBottomRight) and (tileTopRight:collidable() or tileBottomRight:collidable()) then
        if self.velx > 0 then
            self.velx = 0
        end
    end
end

function NeutralBomb:checkLeftCollisions(dt)
    if self.y < 0 or self.x < 1 then
        return
    end
    local tileTopLeft = self.map:pointToTile(self.x + self.camX - 1, self.y + 1)
    local tileBottomLeft = self.map:pointToTile(self.x + self.camX - 1, self.y + self.height - 1)
    if (tileTopLeft and tileBottomLeft) and (tileTopLeft:collidable() or tileBottomLeft:collidable()) then
        if self.velx < 0 then
            self.velx = 0
        end
    end
end

function NeutralBomb:render()
    if self.ttl > 0  then
        love.graphics.draw(gTextures["bombs"], gFrames["bombs"][4], self.x, self.y)
    end
end

function NeutralBomb:explode()
    for i= 1,#self.players do
        if self.players[i].x < self.camX + self.x + self.width + 15 and self.players[i].x > self.camX + self.x - 15 and self.players[i].y < self.y + 50 and self.players[i].y > self.y - 50 then
            self.players[i].hp = self.players[i].hp - 150
        end
    end
end