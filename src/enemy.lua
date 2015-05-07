
local Enemy = {}

function Enemy:IAF()
    local x,y = self.x,self.y
    x = x + math.random(-1,1)
    y = y + math.random(-1,1)
    if x > 0 and x < #map.grid and y > 0 and y < #map.grid[1] and map.grid[x][y] ~= 0 then
        self.x,self.y = x,y
        --print(self,self.x,self.y)
    end
end
function Enemy:new()
    o = {}   -- create object if user does not provide one
    setmetatable(o, self)
    self.__index = self
    o.x,o.y = map.safeRand()
    o.shadow = lightWorld.newRectangle((o.x+0.5)*tilesize,(o.y+0.5)*tilesize, tilesize, tilesize)
    --o.IA = cron.every(1,o.IAF,o)
    o.cont = 0 
    o.alive = true  
    return o
end
function Enemy:draw()
end
function Enemy:update(dt)
    --self.IA:update(dt)
    if self.cont>0.2 then
        self.cont = 0
        self:IAF()
    end
    self.cont = self.cont + dt
    self.shadow.setX((self.x+0.5)*tilesize)
    self.shadow.setY((self.y+0.5)*tilesize)
end
return Enemy
