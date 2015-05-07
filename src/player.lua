
local cron = require'lib/cron'
local player = {}
player.visionR = 5
player.x = 1
player.y = 1
player.hearingR = 5

function player.load()
    player.visionR = 10
    player.x = 1
    player.y = 1
    player.hearingR = 5
end
function player.light(lightWorld)
    lightMouse = lightWorld.newLight((player.x+0.5)*tilesize, (player.y+0.5)*tilesize, 70, 50, 10, player.visionR*tilesize)
    lightMouse.setGlowStrength(0) 
    lightMouse.setGlowSize(0)
end
function player.draw() 
    love.graphics.setColor(255,255,255)
    love.graphics.rectangle("fill",player.x*tilesize,player.y*tilesize,tilesize,tilesize) 
end
function player.keypressed(key)
    local x,y = player.x,player.y
    if key == "w" then
        y = player.y - 1
    elseif key == "a" then
        x = player.x - 1
    elseif key == "s" then
        y = player.y + 1
    elseif key == "d" then
        x = player.x + 1
    end
    if (x ~= player.x or y ~= player.y) and x > 0 and x < #map.grid and y > 0 and y < #map.grid[1] and map.grid[x][y] ~= 0 then
        player.x,player.y = x,y
        lightMouse.setPosition((x+0.5)*tilesize,(y+0.5)*tilesize)
        love.audio.play( "sounds/step.wav" )
    end
end

function player.update(dt)
end
return player
