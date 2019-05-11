Level = Class{}

function Level.generate(width, height)
    local tiles = {}

    local tileset = math.random(20)

    for x = 1, height do
        table.insert(tiles, {})
    end
    
    for x = 1, width do
        local tileID = TILE_ID_EMPTY
        
        for y = 1, 6 do
            table.insert(tiles[y],
                Tile(x, y, tileID, tileset))
        end

        tileID = TILE_ID_GROUND

        for y = 7, height do
            table.insert(tiles[y],
                Tile(x, y, tileID, tileset))
        end

        if math.random(2) == 1 then
            local pillar_height = height - math.random(6)
            for pillar_y = 6, pillar_height, -1 do
                tiles[pillar_y][x] = Tile(x, pillar_y, tileID, tileset)
            end
        end
        
    end

    local map = TileMap(width, height)
    map.tiles = tiles
    
    return map
end