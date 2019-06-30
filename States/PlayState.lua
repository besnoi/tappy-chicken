PlayState=Class{__includes=BaseState}

function PlayState:init()
self.bird=Bird(SPRITES_VERSION)
--a collection of pipes
self.bird.freemove=false
self.pipepairs={}
self.timer=0
--what was the last y position of the last element of the self.pipepairs table
self.lastY=math.random(20,100)-VIRTUAL_HEIGHT
self.destroyTimer=0
self.score=0
self.aimode=false
self.aitimer=0
end
function PlayState:update(dt,ai)
    if love.keyboard.lastKeyPressed=='p' then
        gSounds.pause:play()
        paused=true
    elseif love.keyboard.lastKeyPressed=='a' then
        self.aimode=self.aimode==false and true or false
    end
    if self.timer>1.3 then
        --the minimum value of y is -VIRTUAL_HEIGHT/PIPE_HEIGHT+20, so that the top pipe has atleast 20 pixel height (visible to the gamer). not that VIRTUAL_HEIGHT happens to be equal to PIPE_HEIGHT
        --the maximum value of y is -160/-PIPE_HEIGHT+128
        
        local pipeY=math.max(-PIPE_HEIGHT+20,math.min(self.lastY+math.random(-20,20)),-PIPE_HEIGHT+100)
        if pipeY>-130 then pipeY=-130 end
        self.pipepairs[#self.pipepairs+1]=PipePair(pipeY)
        --what i did earlier was 
        --self.pipepairs[#pairpairs+1]=PipePair(math.random(-270,-160))
        -- but that would be too haphazard and 
        --we want it clean not just like first extreme down then extreme up,
        --that will not just increase the entropy but add to negative experience of the gamer
        self.timer=0
        self.lastY=pipeY     
    end
    self.timer=self.timer+dt    
    
    if self.aimode then
        love.keyboard.lastKeyPressed=nil
        self:birdjump(dt,5,self:getPairIndex())
    end
    self.bird:update(dt,self.bird.freemove)
    
    for i,pipe in ipairs(self.pipepairs) do
        --try using ipairs here, well you just cant cause ipairs work on integral indexes, pairs work on keys
        --collision detection
        pipe.top:update(dt)
        pipe.bottom:update(dt)
        if self.bird.x>pipe.top.x+PIPE_WIDTH and (not pipe.top.scored) and (not self.bird.pause) then
            pipe.top.scored=true
            gSounds.score:play()
            self.score=self.score+1
        end
        if self.bird:collidesPipe(pipe.top) then
            if not (self.bird.pause or self.bird.freemove) then gSounds.hurt:play() end
            self.aimode=false            
            --this is to remove that weird behaviour when bird moves through the pipe for a no of frames
            if self.bird:collides(pipe.top.x+5,pipe.top.y+PIPE_HEIGHT,PIPE_WIDTH-5,3) then
                self.bird.y=pipe.top.y+PIPE_HEIGHT
                self.bird.dy=0.5
                self.bird.pause=true
                self.bird.freemove=true
            else
                self.bird.freemove=true            
            end
        elseif self.bird:collidesPipe(pipe.bottom) then
            if not (self.bird.pause or self.bird.freemove) then gSounds.hurt:play() end
            self.aimode=false            
            if self.bird:collides(pipe.bottom.x+3,pipe.bottom.y,PIPE_WIDTH-3,2) then
                self.bird.pause=true 
                self.dy=0               
                self.bird.y=pipe.bottom.y-self.bird.height
            else
                self.bird.freemove=true                
            end
            self.bird.GRAVITY=0
            self.destroyTimer=self.destroyTimer+dt
            if self.destroyTimer>2 then
                gStateMachine:change('score', {
                    score = self.score
                })
                self.destroyTimer=0
            end
        end
        if pipe.top.x+PIPE_WIDTH<0 then
            pipe.remove=true
        end
    end
    for k, pair in ipairs(self.pipepairs) do
        if pair.remove==true then
            table.remove(self.pipepairs, k)
        end
    end
    if self.bird.y>=VIRTUAL_HEIGHT-GROUND:getHeight()-self.bird.height then
        if not (self.bird.pause or self.bird.freemove) then gSounds.hurt:play() end
        self.bird.pause=true
        self.bird.y=VIRTUAL_HEIGHT-GROUND:getHeight()-self.bird.height
    end
end
function PlayState:render()
    for i,pipe in ipairs(self.pipepairs) do
        pipe:render()
    end
    self.bird:render()  
    --draw score
    love.graphics.setFont(SCORE_FONT)
    love.graphics.printf("Score: "..self.score,10,10,VIRTUAL_WIDTH,'left')
    if paused then drawPaused() end
end

function PlayState:birdjump(dt,jump_height,index)
    
    self.aitimer=self.aitimer+dt    
    if self.aitimer>0.3 and index==0 or (self.pipepairs[index] and self.bird.y-jump_height>100 and
    ((self.bird.y-jump_height-40>self.pipepairs[index].y+PIPE_HEIGHT and math.abs(self.bird.x-self.pipepairs[index].top.x)<60)
    or (math.abs(self.bird.x-self.pipepairs[index].top.x)>70))) then
        -- if not self.bird.freemove and not self.bird.pause then print(index) end
        -- if not self.bird.freemove and not self.bird.pause and self.pipepairs[index] then print((self.bird.y-jump_height-40>self.pipepairs[index].y+PIPE_HEIGHT and math.abs(self.bird.x-self.pipepairs[index].top.x)<20)) end
        love.keyboard.lastKeyPressed='space'
        self.aitimer=0
    end
end

function PlayState:getPairIndex()
    for k, pair in ipairs(self.pipepairs) do
        if not pair.top.scored  then return k end
    end
    return 0
end

function drawPaused()
    love.graphics.setColor(1,1,1,0.9)
    love.graphics.setFont(LARGE_FONT)
    love.graphics.printf('PauseD',0,VIRTUAL_HEIGHT/2-28,VIRTUAL_WIDTH,'center')
    love.graphics.setColor(1,1,1) 
end