PipePair=Class{}

GAP_HEIGHT=90

function PipePair:init(y)
    self.y =y
    self.x=VIRTUAL_WIDTH
    self.top=Pipe('top',self.y)
    self.bottom=Pipe('bottom',self.y+PIPE_HEIGHT+GAP_HEIGHT)
    self.remove=false
end

function PipePair:render()
    self.top:render()
    self.bottom:render()
end