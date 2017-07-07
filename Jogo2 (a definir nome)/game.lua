local game = {}

local pl = require'player'
local back = require'background'
local en = require'enemy'

local timer

local width,height

function game.load()
  pl.load()
  back.load()
  en.load()
  timer = 0
  width,height = love.graphics.getDimensions()
end

function game.update(dt)
  timer = timer+dt
  local isAlive = pl.update(dt)
  back.update(dt)
  en.update(dt)
  if isAlive == false then --se jogador morreu
    timer = 0
  end
end

function game.keypressed(key)
  if key == 'space' then
    pl.jump()
  end
end

function game.mousepressed(x,y)
end

function game.draw()
  back.draw()
  pl.draw()
  en.draw()
  love.graphics.printf('Time:\n'..math.floor(timer),0,0,width,'center')
end

return game