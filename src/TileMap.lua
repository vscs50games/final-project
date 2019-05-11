TileMap = Class{}

function TileMap:init(width, height)
    self.width = width
    self.height = height
    self.tiles = {}
end

function TileMap:pointToTile(x, y)   
    
    return self.tiles[math.floor(y / 16) + 1][math.floor(x / 16) + 1]
end

function TileMap:render()
    for x = 1, self.width do
        for y = 1, self.height do
            self.tiles[y][x]:render()
        end
    end
end