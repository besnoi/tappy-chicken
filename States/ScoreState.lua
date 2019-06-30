ScoreState=Class{__includes=BaseState}

local stars,medals,timer,petoc={},{},0,true
local background=love.graphics.newImage("Assets/Images/highscore.png")
medals[1]=love.graphics.newImage("Assets/Images/bronze medal.png")
medals[2]=love.graphics.newImage("Assets/Images/silver medal.png")
medals[3]=love.graphics.newImage("Assets/Images/gold medal.png")
for i=1,4 do
    stars[i]=love.graphics.newImage("Assets/Images/"..(i-1).." stars.png")
end
local function scoreToStars(score)
    if score<10 then
        return 1
    elseif score<20 then
        return 2
    elseif score<50 then
        return 3
    else return 4
    end
end
local function scoreToMedal(score)
    if score<10 then
        return 1
    elseif score<50 then
        return 2
    else return 3
    end
end
function ScoreState:enter(params)
    self.score = params.score
    self.stars=scoreToStars(self.score)
    self.medals=scoreToMedal(self.score)
end

function ScoreState:update(dt)
    timer=timer+dt
    if timer>0.5 then
        petoc=petoc==false and true or false
        timer=0
    end
    if love.keyboard.lastKeyPressed=='enter' or love.keyboard.lastKeyPressed=='return' then
        gStateMachine:change('main')
    end
end

function ScoreState:render()
love.graphics.setFont(SCORE_FONT)
love.graphics.draw(background,VIRTUAL_WIDTH/2-125,VIRTUAL_HEIGHT/2-135,0,1,1.3)
love.graphics.draw(stars[self.stars],VIRTUAL_WIDTH/2-90,VIRTUAL_HEIGHT/2-25)
love.graphics.draw(medals[self.medals],VIRTUAL_WIDTH/2-40,VIRTUAL_HEIGHT/2-115)
love.graphics.setColor(1,0.4,0)
love.graphics.printf("You scored "..self.score.."!",0,VIRTUAL_HEIGHT/2+80,VIRTUAL_WIDTH,'center')
love.graphics.setColor(1,1,1)
love.graphics.setFont(MED_FONT)
if petoc then
    love.graphics.printf("Hit Enter to Continue ",0,VIRTUAL_HEIGHT/2+110,VIRTUAL_WIDTH,'center')
end

end


