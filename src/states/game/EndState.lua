EndState = Class{__includes = BaseState}

function EndState:init()
    self.background = 1
    self.player_won = "0"
end

function EndState:enter(params)
    self.player_won = params.player_won
end

function EndState:render()
    love.graphics.draw(gTextures['background'], gFrames['background'][self.background], 0, 0, 0, 0.06666, 0.06666)

    love.graphics.setFont(love.graphics.newFont('fonts/Adelle_light.otf', 32))
    love.graphics.setColor(0, 0, 0, 255)
    if self.player_won ~= nil then
        love.graphics.printf('Game Over! Player ' .. self.player_won .. ' wins!', 1, VIRTUAL_HEIGHT / 2 - 40 + 1, VIRTUAL_WIDTH, 'center')
    end
    love.graphics.setColor(255, 255, 255, 255)

end