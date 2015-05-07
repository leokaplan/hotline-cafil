local cron = require 'lib/cron'
HC = require 'lib/HardonCollider'
require "lib/postshader"
require "lib/light"
require "lib/audio"

map = require 'src/map'
player = require 'src/player'
Enemy = require 'src/enemy'



function love.load()
    -- globais
    tilesize = 15
    numenemies = 1
    enemies = {}

    --loads 
    map.load()
    player.load()
    player.x,player.y = map.safe() 

    --luz
    lightWorld = love.light.newWorld()
    map.light(lightWorld)
    player.light(lightWorld)    
    

    spawner = cron.every(1,function() if #enemies < numenemies then table.insert(enemies,Enemy:new()) end end)

    love.audio.play( "sounds/music.mp3","stream",true )

    -- debug
    if false then
        love.keyboard.setKeyRepeat( true )
        lightWorld.setAmbientColor(15, 15, 31) -- optional
    end
    
    -- variaveis de estado    
    T = {}
    T["blocked"] = 0
    timer = {}
    timer["blocked"] = 0.1
    blocked = false
    started = false
    
    
    instructions = "find the exit, don't die.\n'a' to move your left leg, 'd' to move your right leg.\nmouse moves your direction\nRemember: you can't see the enemy, just its shadow"
    
    exit = {}
    exit.x,exit.y = map.safeR()
    
    --[[
    exit.shadow = lightWorld.newRectangle((exit.x+0.5)*tilesize,(exit.y+0.5)*tilesize, tilesize, tilesize)
    exit.shadow.setGlowStrength(1.0)
    exit.shadow.setAlpha(0.5)
    exit.shadow.setGlowColor(0,255,0)
    --]]
end
function love.update(dt)
    love.audio.update(dt)
    player.update(dt)
    spawner:update(dt)
    for k,v in pairs(enemies) do
        if v.alive then
            v:update(dt)
            if v.x == player.x and v.y == player.y then
                love.load()
                print("perdeu")
                love.audio.play( "sounds/win.wav" )
            end
        end
    end
    if player.x == exit.x and player.y == exit.y then
        love.load()
        love.audio.play( "sounds/lose.wav" )
        print("ganhou")
    end
    if T["blocked"] >= timer["blocked"] then
        T["blocked"] = 0
        blocked = false
    end
    local x = love.mouse.getX()-(player.x+0.5)*tilesize
    local y = love.mouse.getY()-(player.y+0.5)*tilesize
    if y == 0 then y = 1 end
    local degrees = math.atan2(-x,-y)
    lightMouse.setDirection(degrees)--math.cos(love.mouse.getX())+math.sin(love.mouse.getY())) -- optional
    T["blocked"] = T["blocked"]+dt
    
end
function love.keypressed(key)
    started = true
    if not blocked then
        player.keypressed(key)
        blocked = true
    end
end
function love.draw()
    love.graphics.setColor(255, 255, 255)
    love.graphics.rectangle("fill", 0, 0, love.window.getWidth(), love.window.getHeight())
    lightWorld.update()
    --map.draw()
    for k,v in pairs(enemies) do
        if v.alive then
            v:draw(dt)
        end
    end
    love.graphics.setColor(0, 255, 0)
    love.graphics.rectangle("fill", exit.x*tilesize, exit.y*tilesize, tilesize, tilesize)
    lightWorld.drawShadow()
    player.draw()
    lightWorld.drawShine()
	lightWorld.drawGlow()
    if not started then 
        love.graphics.print(instructions,love.window.getWidth()/2,love.window.getHeight()/2)
    end
end
