require 'src/Dependencies'

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest', 1)
    love.window.setTitle('Player Tanks')
    
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = true
    })

    love.keyboard.keysPressed = {}
    love.mouse.keysPressed = {}
    love.mouse.keysReleased = {}

    math.randomseed(os.time())

    gStateMachine = 
    StateMachine {
        ['begin'] = function() return StartState() end,
        ['play'] = function() return PlayState() end,
        ['end'] = function() return EndState() end
    }

    gStateMachine:change('begin')

end

function love.resize(w, h)
    push:resize(w, h)
end

function love.mousepressed(x, y, key)
    love.mouse.keysPressed[key] = true
end

function love.mousereleased(x, y, key)
    love.mouse.keysReleased[key] = true 
end

function love.keypressed(key)
    if key == 'q' or key == 'escape' then
        love.event.quit()
    end

    love.keyboard.keysPressed[key] = true
end

function love.mouse.wasReleased(key)
    return love.mouse.keysReleased[key]
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.mouse.wasPressed(key)
    return love.mouse.keysPressed[key]
end

function love.update(dt)
    gStateMachine:update(dt)
    love.keyboard.keysPressed = {}
    love.mouse.keysPressed = {}
    love.mouse.keysReleased = {}
end

function love.draw()
    push:start()
    gStateMachine:render()
    push:finish()
end