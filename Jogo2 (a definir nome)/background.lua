local back = {}

local image,scale
local imgW

function back.load()
  back.vel = 150
  back.x = 0
  image = love.graphics.newImage('background2.png')
  local imgH = image:getHeight()
  local H = love.graphics.getHeight()
  scale = H/imgH
  imgW = image:getWidth()*scale
end

function back.update(dt)
  back.x = back.x - back.vel*dt
  if back.x < -imgW then
    back.x = 0
  end
end

function back.draw()
  love.graphics.draw(image,back.x,0,0,scale)
  love.graphics.draw(image,back.x+imgW,0,0,scale)
end

return back