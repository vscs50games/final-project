StartState = Class{__includes = BaseState}

function StartState:init()
    self.background = 1
end

function StartState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('play', {
            width = 100,
            height = 10
        })
    end
end

function StartState:render()
    love.graphics.draw(gTextures['background'], gFrames['background'][self.background], 0, 0, 0, 0.06666, 0.06666)

    love.graphics.setFont(love.graphics.newFont('fonts/Adelle_light.otf', 32))
    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.printf('Player Tanks', 1, VIRTUAL_HEIGHT / 2 - 39, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(love.graphics.newFont('fonts/Adelle_light.otf', 16))
    love.graphics.printf('Press Enter', 1, VIRTUAL_HEIGHT / 2 + 17, VIRTUAL_WIDTH, 'center')
    love.graphics.setColor(255, 255, 255, 255)
end