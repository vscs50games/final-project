Class = require 'lib/class'
push = require 'lib/push'

require 'src/constants'
require 'src/StateMachine'
require 'src/Util'
require 'src/Level'
require 'src/Tile'
require 'src/TileMap'
require 'src/Entity'
require 'src/NeutralBomb'
require 'src/Player'
require 'src/states/BaseState'
require 'src/states/game/PlayState'
require 'src/states/game/StartState'
require 'src/states/game/EndState'

gTextures = {
    ['tiles'] = love.graphics.newImage('graphics/tiles.png'),
    ['background'] = love.graphics.newImage('graphics/background.jpg'),
    ['fat_mario'] = love.graphics.newImage('graphics/fat_mario_thing.png'),
    ['mage'] = love.graphics.newImage('graphics/mage.png'),
    ['bombs'] = love.graphics.newImage('graphics/coins_and_bombs.png'),
    ['arrow'] = love.graphics.newImage('graphics/arrow.png')
}

gFrames = {
    ['tiles'] = GenerateQuads(gTextures['tiles'], 16, 16),
    ['background'] = GenerateQuads(gTextures['background'], 3840, 2160),
    ['fat_mario'] = GenerateQuads(gTextures['fat_mario'], 16, 18),
    ['mage'] = GenerateQuads(gTextures['mage'], 16, 18),
    ['bombs'] = GenerateQuads(gTextures['bombs'], 16, 16), 
}

gFrames['tilesets'] = GenerateTileSets(gFrames['tiles'], 
    TILE_SETS_WIDE, TILE_SETS_TALL, TILE_SET_WIDTH, TILE_SET_HEIGHT)