
local cron = require'lib/cron'
local player = {}
player.visionR = 10
player.x = 1
player.y = 1
player.hearingR = 5
player.lstep = false
player.rstep = false
player.standby = cron.every(1,function() player.lstep,player.rstep = false,false end)

function player.load()
    player.visionR = 10
    player.x = 1
    player.y = 1
    player.hearingR = 5
    player.lstep = false
    player.rstep = false
    player.standby = cron.every(1,function() player.lstep,player.rstep = false,false end)
end
function player.light(lightWorld)
    lightMouse = lightWorld.newLight((player.x+0.5)*tilesize, (player.y+0.5)*tilesize, 255, 250, 250, player.visionR*tilesize)
    --lightMouse.setGlowStrength(0.5) 
    --lightMouse.setGlowSize(0.5)
    lightMouse.setAngle(3.14/4.0) -- 45o
end
function player.draw() 
    love.graphics.setColor(255,255,255)
    love.graphics.rectangle("fill",player.x*tilesize,player.y*tilesize,tilesize,tilesize) 
end
function player.keypressed(key)
    local x,y = player.x,player.y
    --[[
    if key == "w" then
        y = player.y - 1
    elseif key == "a" then
        x = player.x - 1
    elseif key == "s" then
        y = player.y + 1
    elseif key == "d" then
        x = player.x + 1
    end
    if key == "a" then
        if not player.lstep then 
            player.lstep = true
            player.rstep = not player.lstep
            if love.mouse.getX() < player.x*map.tilesize then
                x = player.x - 1
            elseif love.mouse.getX() > (player.x+1)*map.tilesize then
                x = player.x + 1
            elseif love.mouse.getY() < player.y*map.tilesize then
                y = player.y - 1
            elseif love.mouse.getY() > (player.y+1)*map.tilesize then
                y = player.y + 1
            end
        end
    elseif key == "d" then
        if not player.rstep then 
            player.lstep = false
            player.rstep = not player.lstep
            if love.mouse.getX() < player.x*map.tilesize then
                x = player.x - 1
            elseif love.mouse.getX() > (player.x+1)*map.tilesize then
                x = player.x + 1
            elseif love.mouse.getY() < player.y*map.tilesize then
                y = player.y - 1
            elseif love.mouse.getY() > (player.y+1)*map.tilesize then
                y = player.y + 1
            end
        end
    end
    --]]
    if key == "a" then
        if not player.lstep then 
            player.lstep = true
            player.rstep = not player.lstep
            local dx = player.x*tilesize - love.mouse.getX()
            local dy = player.y*tilesize - love.mouse.getY()
            if math.abs(dy) < math.abs(dx) then
                x = player.x - dx/math.abs(dx)
            else
                y = player.y - dy/math.abs(dy)
            end
        end
    elseif key == "d" then
        if not player.rstep then 
            player.lstep = false
            player.rstep = not player.lstep
            local dx = player.x*tilesize - love.mouse.getX()
            local dy = player.y*tilesize - love.mouse.getY()
            if math.abs(dy) < math.abs(dx) then
                x = player.x - dx/math.abs(dx)
            else
                y = player.y - dy/math.abs(dy)
            end
        end
    end
    if (x ~= player.x or y ~= player.y) and x > 0 and x < #map.grid and y > 0 and y < #map.grid[1] and map.grid[x][y] ~= 0 then
        player.x,player.y = x,y
        lightMouse.setPosition((x+0.5)*tilesize,(y+0.5)*tilesize)
        love.audio.play( "sounds/step.wav" )
    end
end

function player.update(dt)
    player.standby:update(dt)
end
return player
