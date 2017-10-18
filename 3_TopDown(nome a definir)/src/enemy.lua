local en = {}

local spawn_timer
local spawn_time = 1

local w,h
local radius = 30

local contact = require'src/contact'

local colors = {
    {255,0,0}, --colors[1]
    {0,255,0}  --colors[2]
}
local images = {}
local pivot = {}
local scale = {}

local anim_time = 0.4

function en.load(player)
  w,h = love.graphics.getDimensions()
  en.list = {}
  en.player = player
  spawn_timer = 0
  images[1] = love.graphics.newImage('assets/r_z_1.png')
  images[2] = love.graphics.newImage('assets/r_z_2.png')
  local iw,ih = images[1]:getDimensions()
  pivot.x = iw/2
  pivot.y = ih/2
  scale.x = radius*2.1/iw
  scale.y = radius*2.1/ih
end

function en.spawn()
  local e = {
    x = 200,
    y = 100,
    hp = 10,
    dmg = 5,
    factor = 1,
    speed = 140,
    timer = 0,
    frame = 1,
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
  e.x = e.x + offsetx
  e.y = e.y + offsety
  table.insert(en.list,e)
end

function en.reset()
  en.list = {}
  en.factor = 1
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

function en.animation(dt)
  local e
  for i=1,#en.list do
    e = en.list[i]
    e.timer = e.timer + dt
    if e.timer > anim_time then
      e.timer = 0
      e.frame = e.frame+1
      if e.frame > #images then
        e.frame = 1
      end
    end
  end
end

-- Verifica se tem contato, se tiver
--retorna verdadeiro. Se nao, falso.
function en.contact(game)
  local e
  local p = en.player
  local area
  for i=#en.list,1,-1 do
    e = en.list[i]
    if contact.circle(e.x,e.y,radius,p.x,p.y,p.radius) == true then
      area = p.getArea(e.x,e.y)
      if area == e.id then
        --mata inimigo
        game.score = game.score+1
        table.remove(en.list,i)
      else
        --reseta jogo (gameover)
        return true
      end
    end
  end
  return false
end

function en.update(dt,game)
  spawn_timer = spawn_timer + dt
  if spawn_timer > spawn_time then
    spawn_timer = 0
    en.spawn()
  end
  en.movement(dt)
  en.animation(dt)
  local didEnd = en.contact(game)
  return didEnd
end

function en.draw()
  local e
  for i=1,#en.list do
    e = en.list[i]
    love.graphics.setColor(colors[e.id])
    --love.graphics.circle('fill',e.x,e.y,radius)
    love.graphics.draw(images[e.frame],e.x,e.y,e.angle,scale.x,scale.y,pivot.x,pivot.y)
  end
end

return en