Tile = Class{}

function Tile:init(x, y, id, tileset)
    self.x = x
    self.y = y

    self.width = 16
    self.height = 16

    self.id = id
    self.tileset = tileset
end

--[[
    Checks to see whether this ID is whitelisted as collidable in a global constants table.
]]
function Tile:collidable(target)
    for k, v in pairs(COLLIDABLE_TILES) do
        if v == self.id then
            return true
        end
    end

    return false
end

function Tile:render()
    love.graphics.draw(gTextures['tiles'], gFrames['tilesets'][self.tileset][self.id],
        (self.x - 1) * 16, (self.y - 1) * 16)
end