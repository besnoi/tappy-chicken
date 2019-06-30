Bird=Class{}


function Bird:init(version)
    --local self=setmetatable({},Bird)
    self.img=love.graphics.newImage("Assets/Images/v"..tostring(version).."/bird.png")
    self.width=38
    self.height=24
    self.GRAVITY=20
    self.x=(VIRTUAL_WIDTH-self.width)/2
    self.y=(VIRTUAL_HEIGHT-self.height)/2
    --pressing space wont do anything
    self.freemove=false
    self.pause=false
    self.rt=0
    if version==1 then
        self.offsetx1=3
        self.offsetx2=-3
        self.offsety1=4
        self.offsety2=-2
    else
        self.offsetx1=3
        self.offsetx2=-4
        self.offsety1=4
        self.offsety2=-4
    end
    self.dy=0
end

function Bird:update(dt,freemove)
    if not self.pause or self.freemove then
        self.dy=self.dy+self.GRAVITY*dt
    end
    if love.keyboard.lastKeyPressed=='space' and (not self.freemove) and (not self.pause) then
        gSounds.jump:play()
        self.dy=-5
        self.rt=math.pi/math.random(6,8)
    end
    if self.rt~=0 then
        self.rt=self.rt-dt
    end
    if self.rt<0 then
        self.rt=0
    end
    if self.freemove then
        self.x=self.x-100*dt
    end
    
    self.y=self.y+self.dy
    
end

function Bird:collidesPipe(pipe)
    return self:collides(pipe.x,pipe.y,PIPE_WIDTH,PIPE_HEIGHT)
end

function Bird:collides(pipeX,pipeY,pipeWidth,pipeHeight) 
    --if self.x>pipeX+PIPE_WIDTH or self.y>pipeY+PIPE_HEIGHT or pipeY>self.y+self.height or pipeX>self.x+self.width then
    if self.x+self.offsetx1>pipeX+pipeWidth or self.y+self.offsety1>pipeY+pipeHeight
     or pipeX>self.x+self.width+self.offsetx2 or pipeY>self.y+self.height+self.offsety2 then
        return false
    else return true
    end
end

function Bird:render()
    if self.pause then
        love.graphics.draw(self.img,self.x,self.y+self.height,0,1,-1)
    else
        love.graphics.draw(self.img,self.x,self.y,-self.rt)
    end
    --[[]
    love.graphics.setColor(0,0,1)
    love.graphics.rectangle('fill',self.x,self.y,self.width,self.height)
    love.graphics.setColor(1,1,1)
    --]]
end