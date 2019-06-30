Pipe=Class{}

local PIPE_IMG=love.graphics.newImage("Assets/Images/v"..SPRITES_VERSION.."/pipe.png")
PIPE_SCROLL_SPEED=100

PIPE_HEIGHT=288
PIPE_WIDTH=70

--[[
    First things first why do you add PIPE_HEIGHT in the draw function if it is 'top' oriented?
    Ans. Note that we flip the image along the y axis by y-scaling it by -1 and when we do that we
        effectively also shift it by the size of the image along the axis (try flipping your hand if that
        makes sense) The image may be displayed at y-PIPE_HEIGHT cordinate but this doesn't changes the y
        cordinate of the object. Try printing pipe.y and you'll still the same value. And this is also 
        the reason why we do this in draw function and not in the init function.Because the y value of the pipe
        is to be used by other functions like Bird:collides (actually that's the only function) and
        when you add PIPE_HEIGHT to y value during init function it effectively changes its y value resulting
        in buggy behaviiour. So basically we don't want to change the y value of the object yet we want to add
        PIPE_HEIGHT to it in case if its 'top' oriented. So we do it during the time we draw it. Hope that clears the concept
]]

function Pipe:init(orientation,y)
    self.x=VIRTUAL_WIDTH
    self.y=y
    --math.random(VIRTUAL_HEIGHT/4,VIRTUAL_HEIGHT-30)
    self.orientation=orientation
    --mark each pipe for whether player passed over that pipe or not (we will check only the top pipe)
    self.scored=false
end

function Pipe:update(dt)
    self.x=self.x-PIPE_SCROLL_SPEED*dt
end

function Pipe:render()
    if self.orientation=='top' then
        love.graphics.draw(PIPE_IMG, self.x, self.y+PIPE_HEIGHT,0,1,-1)        
    else
        love.graphics.draw(PIPE_IMG, self.x, self.y)
    end
    --[[]
    love.graphics.setColor(1,0,0)
    love.graphics.rectangle('fill',self.x,self.y,PIPE_WIDTH,PIPE_HEIGHT)
    love.graphics.setColor(1,1,1)
    --]]
    
end