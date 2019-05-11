PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.camX = 0
    self.camY = 0
    self.backgroundX = 0
    self.background = 1
end

function PlayState:enter(params)
    self.width = math.floor(params.width) or 100
    self.height = 10
    self.tileMap = Level.generate(self.width, self.height)
    self.cast = false
    self.aiming = false
    local initPlayerPositionX
    local initPlayerPositionY

    local earlyreturn
    for i=1, self.width, 1 do
        for j=2, self.height, 1 do
            local currTile = self.tileMap.tiles[j][i]
            if currTile.id == TILE_ID_GROUND then
                initPlayerPositionX = i
                earlyreturn = true
                break
            end
        end
        if earlyreturn then
            break
        end
    end

    local lastTilePositionY

    for j=2, self.height, 1 do
        local currTile = self.tileMap.tiles[j][self.width-2]
        if currTile.id == TILE_ID_GROUND then
            lastTilePositionY = j
            break
        end
    end

    self.player1 = Player({
        x = initPlayerPositionX, y = self.height,
        lastTile = lastTilePositionY,
        width = 16, height = 18,
        texture = 'fat_mario',
        map = self.tileMap,
        active = true,
        player_num = "1"
    })

    self.player2 = Player({
        x = self.width-5, y = self.height,
        lastTile = lastTilePositionY,
        width = 16, height = 18,
        texture = 'mage',
        map = self.tileMap,
        active = false,
        player_num = "2"
    })

    self.players = {self.player1, self.player2}
    self.CURR_PLAYER = 1
end

function PlayState:update(dt)
    if not self.cast then
        for i=1,#self.players do
            self.players[i]:update(dt, self.camX)
        end
    end

    if self.players[self.CURR_PLAYER].x <= 0 then
        self.players[self.CURR_PLAYER].x = 0
    elseif self.players[self.CURR_PLAYER].x > 16 * self.tileMap.width - self.players[self.CURR_PLAYER].width then
        self.players[self.CURR_PLAYER].x = 16 * self.tileMap.width - self.players[self.CURR_PLAYER].width
    end

    if self.players[self.CURR_PLAYER].spell_selected == nil then
        self.aiming = false
    end

    local x, y = push:toGame(love.mouse.getPosition())
    if not self.cast then
        if love.mouse.wasPressed(1) and not self.cast and not self.aiming then
            if x > 10 and x < 26 and y > 120 and y < 136 then -- Checks if the mouse is on the button
                self.players[self.CURR_PLAYER].spell_selected = 'neutral bomb'
                self.aiming = true
                self.released = 0
            end 
            

        elseif self.aiming then
            if love.mouse.wasReleased(1) and self.released < 2 then
                self.released = self.released + 1
            end
            if love.mouse.wasReleased(1) and self.released == 2 then
                self.mx, self.my = push:toGame(love.mouse.getPosition())
                self.cast = true
                player_world_x = self.players[self.CURR_PLAYER].x - self.camX
                dx = player_world_x - mx -- 1
                dy = self.players[self.CURR_PLAYER].y - my -- 1
                angle = 0
                if dx < 0 and dy < 0 then
                    dy = -dy
                    dx = -dx
                    angle = math.abs(math.atan2(dy, dx))
                elseif dx < 0 then
                    dx = -dx
                    angle = math.atan2(dy, dx)
                elseif dy > 0 and dx > 0 then
                    angle = math.atan2(dx, dy)
                else
                    dy = -dy
                    angle = math.abs(math.atan2(dx, dy))
                end
                self.angle = angle
                self.weapon = NeutralBomb(player_world_x, self.players[self.CURR_PLAYER].y, self.angle, self.tileMap, self.players[self.CURR_PLAYER].y - my, player_world_x - mx, self.players, self.camX)
                self.aiming = false
                self.players[self.CURR_PLAYER].spell_selected = false
            end
        end
    end
    
    if self.cast then
        self.weapon:update(dt)
        if self.weapon.ttl < 0 then
            self.cast = false
            if self.CURR_PLAYER == 1 then
                self.CURR_PLAYER = 2
                self.players[1].active = false
                self.players[2].active = true
            else
                self.CURR_PLAYER = 1
                self.players[1].active = true
                self.players[2].active = false
            end
            
            if self.players[1].hp <= 0 then
                gStateMachine:change('end', {
                    player_won = "2"
                })
            elseif self.players[2].hp <= 0 then
                gStateMachine:change('end', {
                    player_won = "1"
                })
            end
        end
    end

    self:updateCamera()
end

function PlayState:render()
    love.graphics.push()
    love.graphics.draw(gTextures['background'], gFrames['background'][self.background], 0, 0, 0, 0.06666, 0.06666)
    
    -- translate the entire view of the scene to emulate a camera
    love.graphics.translate(-math.floor(self.camX), -math.floor(self.camY))
    
    self.tileMap:render()
    for i=1,#self.players do
        self.players[i]:render(self.camX)
    end
    love.graphics.pop()
    
    -- render score
    love.graphics.setFont(love.graphics.newFont('fonts/Adelle_light.otf', 12))
    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.print("Player 1 HP: " .. self.players[1].hp, 5, 5)
    love.graphics.print("Player 2 HP: " .. self.players[2].hp, 5, 20)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(gTextures["bombs"], gFrames["bombs"][4], 10, 120)

    if self.cast then
        self.weapon:render()
    end
end

function PlayState:updateCamera()
    -- clamp movement of the camera's X between 0 and the map bounds - virtual width,
    -- setting it half the screen to the left of the player so they are in the center
    self.camX = math.max(0,
        math.min(self.players[self.CURR_PLAYER].x - (VIRTUAL_WIDTH / 2), 16 * self.tileMap.width - VIRTUAL_WIDTH))
end


