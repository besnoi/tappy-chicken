TitleScreenState=Class{__includes=BaseState}

local PLAY_BTN_HOVER=love.graphics.newImage("Assets/Images/btn_play_hover.png")
local PLAY_BTN=love.graphics.newImage("Assets/Images/btn_play.png")
local HIGHSCORE_BTN=love.graphics.newImage("Assets/Images/btn_highscore.png")
local HIGHSCORE_BTN_HOVER=love.graphics.newImage("Assets/Images/btn_highscore_hover.png")
local BACKGROUND=love.graphics.newImage("Assets/Images/back.png")
local selected=1
function TitleScreenState:update(dt)
    if love.keyboard.lastKeyPressed=='enter' or love.keyboard.lastKeyPressed=='return' then
        if selected==1 then
            gStateMachine:change('count')
        else
            print("LOL HIGHSCORE SYSTEM NOT IMPLEMENTED YET")
        end
    end
    if love.keyboard.lastKeyPressed=='left' or love.keyboard.lastKeyPressed=='right' then
        gSounds.blip:play()
        selected=selected==1 and 2 or 1
    end
end


function TitleScreenState:render()
    
    love.graphics.setFont(MED_FONT)
    love.graphics.printf("Made By Neer",100,VIRTUAL_HEIGHT/2-20,VIRTUAL_WIDTH,'center')
    love.graphics.setColor(1,0.,0)
    
    --love.graphics.rectangle('fill',180,180,150,80)
    --love.graphics.printf("Hit enter to Play",0,VIRTUAL_HEIGHT/2,VIRTUAL_WIDTH,'center')    
    love.graphics.setFont(LARGE_FONT)
    love.graphics.setColor(1,1,1)
    if selected==1 then
        love.graphics.draw(PLAY_BTN_HOVER,190,190,0,0.3,0.3)
        love.graphics.draw(HIGHSCORE_BTN,270,190,0,0.3,0.3)
    else
        love.graphics.draw(PLAY_BTN,190,190,0,0.3,0.3)
        love.graphics.draw(HIGHSCORE_BTN_HOVER,270,190,0,0.3,0.3)
    end
    love.graphics.setColor(1,1,1)
    --love.graphics.draw(BACKGROUND,160,170,0,1.2,1.4)
    
    
    love.graphics.printf("Tappy",0,15,VIRTUAL_WIDTH,'center')    
    love.graphics.printf("Chicken",0,VIRTUAL_HEIGHT/4,VIRTUAL_WIDTH,'center')
end