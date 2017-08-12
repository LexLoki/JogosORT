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

local function hasContact(p,e)
  if p.x < e.x + e.width and p.x+p.width > e.x
    and p.y < e.y + e.height and p.y+p.height > e.y then
      return true
  else
    return false
  end
end

function game.over()
  timer = 0
  pl.y = 350
  en.start()
end

function game.update_contact()
  local list = en.list
  local e
  for i=1,#list do
    e = list[i]
    if hasContact(pl,e) then
      game.over()
      break
    end
  end
end

function game.update(dt)
  timer = timer+dt
  local isAlive = pl.update(dt)
  back.update(dt)
  en.update(dt,timer)
  if isAlive == false then --se jogador morreu
    timer = 0
  end
  game.update_contact()
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