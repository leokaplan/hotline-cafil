local astray = require 'lib/astray'
map = {}
function map.load(tilesize)
	local symbols = {Wall=0, Empty=255, DoorN=120, DoorS=120, DoorE=120, DoorW=120}

	local generator = astray.Astray:new( 20, 10, 15, 70, 80, astray.RoomGenerator:new(4, 2, 6, 2, 6) )
	
	local dungeon = generator:GenerateDungeon()
	generator:GenerateSparsifyMaze(dungeon)
	generator:GenerateRemoveDeadEnds(dungeon)
	generator:GeneratePlaceRooms(dungeon)
	generator:GeneratePlaceDoors(dungeon)
	map.grid = generator:CellToTiles(dungeon, symbols )
end

function map.alpha(i,j,x,y,r)
    local nx = i-x
    local ny = j-y
    local n = math.sqrt(math.pow(nx,2)+math.pow(ny,2))
    if r>n then 
        return 255*(r-n)/r
    else 
        return 0
    end
end
function map.draw()
    for i=1,#map.grid do
        for j=1,#map.grid[1] do
            love.graphics.push()
            love.graphics.translate(i,j)
            --love.graphics.setColor(0,map.grid[i][j],0,120)
            --love.graphics.polygon("fill",0,0,0,1,1,1,1,0) 
            --love.graphics.setColor(map.grid[i][j],0,0,map.alpha(i,j,player.x,player.y,player.visionR))
            --love.graphics.polygon("fill",0,0,0,1,1,1,1,0) 
            love.graphics.pop()
        end
    end
end
function map.safe()
    for i=1,#map.grid do
        for j=1,#map.grid[1] do
            if map.grid[i][j] ~= 0 then
                return i,j
            end
        end
    end
end
function map.safeR()
    for i=#map.grid,1,-1 do
        for j=#map.grid[1],1,-1 do
            if map.grid[i][j] ~= 0 then
                return i,j
            end
        end
    end
end
function map.safeRand()
    local times = math.random(0,#map.grid)
    for i=#map.grid,1,-1 do
        for j=#map.grid[1],1,-1 do
            if map.grid[i][j] ~= 0 then
                times = times - 1
                if times == 0 then
                    return i,j
                end
            end
        end
    end
end
function map.light(lightWorld)
    for i=1,#map.grid do
        for j=1,#map.grid[1] do
            if map.grid[i][j] == 0 then
                lightWorld.newRectangle((i+0.5)*tilesize,(j+0.5)*tilesize, tilesize, tilesize)
            end
        end
    end
end
return map
