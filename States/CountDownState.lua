CountDownState=Class{__includes=BaseState}

function CountDownState:init()
    self.timer=0
    self.printgo=false
    self.countdown=3
    self.increment=0.75
    gSounds.count:play()
end
function CountDownState:update(dt)
    self.timer=self.timer + dt
    if self.countdown==0 then
        self.printgo=true
        if self.timer>self.increment then
            gSounds.go:stop()
            gStateMachine:change('play')
        end
    end
    if self.timer>self.increment then
        self.timer=self.timer%self.increment
        self.countdown=self.countdown-1
        if self.countdown~=0 then gSounds.count:play() 
        else gSounds.go:play()
        end
    end
    
end

function CountDownState:render()
    if self.printgo then
        love.graphics.printf("Go!!!",0,VIRTUAL_HEIGHT/5,VIRTUAL_WIDTH,'center')
    else
        love.graphics.printf(self.countdown,0,VIRTUAL_HEIGHT/5,VIRTUAL_WIDTH,'center')        
    end
end
