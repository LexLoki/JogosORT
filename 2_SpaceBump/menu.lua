local menu = {}

local play = {}
local imgBg,imgW,scale
local timer = 0

local function isClick(x,y,but)
  if x>but.x and x<but.x+but.w and y>but.y and y<but.y+but.h then
    return true
  else
    return false
  end
end

function menu.load()
  local W,H = love.graphics.getDimensions()
  play.w = 200
  play.h = 100
  play.x = W/2 - play.w/2
  play.y = H/2 - play.h/2
  play.img1 = love.graphics.newImage('assets/bt_play_1.png')
  play.img2 = love.graphics.newImage('assets/bt_play_2.png')
  play.img = play.img1
  play.scale = play.w/play.img:getWidth()
  imgBg = love.graphics.newImage('assets/Bg_Space.png')
  local imgH = imgBg:getHeight()
  scale = H/imgH
  imgW = imgBg:getWidth()*scale
end

function menu.update(dt)
  timer = timer+dt
  if timer>0.3 then
    timer = 0
    if play.img == play.img1 then
      play.img = play.img2
    else
      play.img = play.img1
    end
  end
  --[[
  local x,y = love.mouse.getPosition()
  if isClick(x,y,play)==true then
    play.img = play.img2
  else
    play.img = play.img1
  end]]
end


function menu.mousepressed(x,y)
  if isClick(x,y,play) == true then
    love.changeToGame()
  end
end

function menu.keypressed(key)
  if key == 'return' then
    love.changeToGame()
  end
end

function menu.draw()
  love.graphics.draw(imgBg,0,0,0,scale)
  love.graphics.draw(imgBg,imgW,0,0,scale)
  love.graphics.draw(play.img,play.x,play.y,0,play.scale)
end

return menu