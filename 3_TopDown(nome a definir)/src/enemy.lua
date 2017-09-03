local en = {}

local spawn_timer
local spawn_time = 0.4 --Tempo que leva pra nascer um inimigo

local w,h

local radius = 20
local points = 0

local cont = require'src/contact'

local colors = {
  {255,0,0},
  {0,0,255}
}

function en.load(player)
  w,h = love.graphics.getDimensions()
  en.list = {}
  en.player = player
  spawn_timer = 0
end

function en.reset()
  en.list = {}
  points = 0
end

function en.spawn()
  local e = {
    x = 200,
    y = 100,
    hp = 10,
    dmg = 5,
    speed = 50,
    id = love.math.random(1,2)
  }
  local area = love.math.random(1,4)
  if area == 1 then
    e.x = -w*0.2
    e.y = love.math.random(0,h*1.2)
  elseif area == 2 then
    e.x = love.math.random(-w*0.2,w)
    e.y = -h*0.2
  elseif area == 3 then
    e.x = 1.2*w
    e.y = love.math.random(-0.2*h,h)
  elseif area == 4 then
    e.x = love.math.random(0,1.2*w)
    e.y = 1.2*h
  end
  table.insert(en.list,e)
end

function en.movement(dt)
  local e
  local px = en.player.x
  local py = en.player.y
  local vx,vy
  for i=1,#en.list do
    e = en.list[i]
    --e.x = e.x + (px-e.x)*dt
    --e.y = e.y + (py-e.y)*dt
    e.angle = math.atan2(py-e.y, px-e.x)
    vx = math.cos(e.angle)*e.speed
    vy = math.sin(e.angle)*e.speed
    e.x = e.x + vx*dt
    e.y = e.y + vy*dt
  end
end

function en.contact()
  local e
  local p = en.player
  for i=#en.list,1,-1 do
    e = en.list[i]
    if cont.circle(p.x,p.y,p.radius, e.x, e.y, radius) then
      local area = p.getAngleArea(e.x,e.y)
      if area == e.id then
        points = points+1
        table.remove(en.list,i)
      else
        return true --indica que o jogador errou
      end
    end
  end
  return false --se chega até aqui indica que nao teve contato negativo
end

--Retorna falando se o jogo deve reiniciar
function en.update(dt,player)
  spawn_timer = spawn_timer + dt
  if spawn_timer > spawn_time then
    spawn_timer = 0
    en.spawn()
  end
  en.movement(dt)
  local didLose = en.contact()
  return didLose
end

function en.draw()
  local e
  for i=1,#en.list do
    e = en.list[i]
    love.graphics.setColor(colors[e.id])
    love.graphics.circle('fill',e.x,e.y,radius)
  end
  love.graphics.setColor(255,255,255)
  love.graphics.print(points)
end

return en