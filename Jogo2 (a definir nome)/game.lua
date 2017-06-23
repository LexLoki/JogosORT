local game = {}

local pl = require'player'
--local en = require'enemy'
--local back = require'background'

local timer

local width,height

function game.load()
  pl.load()
  timer = 0
  width,height = love.graphics.getDimensions()
end

function game.update(dt)
  timer = timer+dt
  local isAlive = pl.update(dt)
  if isAlive == false then --se jogador morreu
    timer = 0
  end
end

function game.keypressed(key)
  if key == 'space' then
    pl.jump()
  end
end

function game.draw()
  pl.draw()
  love.graphics.printf('Time:\n'..math.floor(timer),0,0,width,'center')
end

return game