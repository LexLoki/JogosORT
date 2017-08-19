local en = {}

local spawn_timer
local spawn_time = 3

local w,h

function en.load(player)
  w,h = love.graphics.getDimensions()
  en.list = {}
  en.player = player
  spawn_timer = 0
end

function en.spawn()
  local e = {
    x = 200,
    y = 100,
    hp = 10,
    dmg = 5,
    speed = 50
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

function en.update(dt)
  spawn_timer = spawn_timer + dt
  if spawn_timer > spawn_time then
    spawn_timer = 0
    en.spawn()
  end
  en.movement(dt)
end

function en.draw()
  local e
  for i=1,#en.list do
    e = en.list[i]
    love.graphics.circle('fill',e.x,e.y,20)
  end
end

return en