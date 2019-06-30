Class=require 'class'

math.randomseed(os.time())
SPRITES_VERSION=2

require 'Bird'
require 'Pipes'
require 'Pipepair'

push=require 'push'

WINDOW_WIDTH=720
WINDOW_HEIGHT=405

VIRTUAL_WIDTH=512
VIRTUAL_HEIGHT=288

BACKGROUND=love.graphics.newImage("Assets/Images/v"..SPRITES_VERSION.."/background.png")
GROUND=love.graphics.newImage("Assets/Images/v"..SPRITES_VERSION.."/ground.png")

BACKGROUND_SPEED=30
GROUND_SPEED=60

SMALL_FONT = love.graphics.newFont('Assets/Fonts/font.ttf', 8)
MED_FONT = love.graphics.newFont('Assets/Fonts/flappy.ttf', 14)
SCORE_FONT = love.graphics.newFont('Assets/Fonts/flappy.ttf', 28)
LARGE_FONT = love.graphics.newFont('Assets/Fonts/flappy.ttf', 56)

start=true


BACKGROUND_LOOPING_POINT=SPRITES_VERSION==1 and 413 or 568

background_scroll=0
ground_scroll=0

--what key was pressed in the last frame
love.keyboard.lastKeyPressed=''

require 'StateMachine'
require 'States/BaseState'
require 'States/TitleScreenState'
require 'States/PlayState'
require 'States/ScoreState'
require 'States/CountDownState'


gSounds={
    ['music']=love.audio.newSource('Assets/Music/marios_way.mp3','static'),
    ['score']=love.audio.newSource('Assets/Music/score.wav','static'),
    ['pause']=love.audio.newSource('Assets/Music/hurt.wav','static'),
    ['hurt']=love.audio.newSource('Assets/Music/explosion.wav','static'),
    ['jump']=love.audio.newSource('Assets/Music/jump.wav','static'),
    ['count']=love.audio.newSource('Assets/Music/count.wav','static'),
    ['blip']=love.audio.newSource('Assets/Music/blip.wav','static'),
    ['go']=love.audio.newSource('Assets/Music/airhorn.ogg','static')
}

function love.load()
    gSounds.music:play()
    gSounds.music:setLooping(true)
    push:setupScreen(VIRTUAL_WIDTH,VIRTUAL_HEIGHT,WINDOW_WIDTH,WINDOW_HEIGHT,{
        resizeable=true,
        vsync=true,
        fullscreen=false
    });
    love.window.setTitle("Flappy Bird");
    gStateMachine = StateMachine({
        ['main']=function() return TitleScreenState() end,
        ['play']=function() return PlayState() end,
        ['count']=function() return CountDownState() end,
        ['score']=function() return ScoreState() end
    })
     gStateMachine:change('main')
    -- gStateMachine:change('score', {
    --     score = 40
    -- })
end
function love.draw()
    push:start();
    love.graphics.draw(BACKGROUND,-background_scroll,0)    
    gStateMachine:render()
    love.graphics.draw(GROUND,-ground_scroll,VIRTUAL_HEIGHT-16)
    push:finish();
end

function love.update(dt)
    if not paused then
        background_scroll=(background_scroll+BACKGROUND_SPEED*dt)%BACKGROUND_LOOPING_POINT;
        ground_scroll=(ground_scroll-GROUND_SPEED*dt)% VIRTUAL_WIDTH
        gStateMachine:update(dt)
        love.keyboard.lastKeyPressed=''
    end
end
 
function love.resize(w,h)
    push:resize(w,h)
end

function love.keypressed(key)
    
    love.keyboard.lastKeyPressed=key
    if key=='p' and paused then
        love.keyboard.lastKeyPressed=nil
        print('this is working')
        paused=false
    end
    if key=='escape' then
        love.event.quit();
    elseif key=='space' then
    end

end
