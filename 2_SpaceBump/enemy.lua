local enemy = {
  list = {},
  width = 200,
  height = 66.66
}

local sprites = {}
local scale

local timer

local time_spawn_i = 3.4
local time_spawn = time_spawn_i

local vel_i = 150
local vel = vel_i


local id_max = 1

local function loadAnimation()
  for i=1,3 do
    sprites[i] = {}
    for j=1,4 do
      sprites[i][j] = love.graphics.newImage('assets/enemies/h_'..i..'_spaceship_'..j..'.png')
      sprites[i][5] = sprites[i][3]
      sprites[i][6] = sprites[i][2]
    end
  end
  local iw,ih = sprites[1][1]:getDimensions()
  local sw = enemy.width/iw
  local sh = enemy.height/ih
  scale = math.min(sw,sh)
  enemy.width = iw*scale
  enemy.height = ih*scale
end

function enemy.load()
  timer = 0
  loadAnimation()
end

function enemy.start()
  enemy.list = {}
  timer = 0
  time_spawn = time_spawn_i
  id_max = 1
  vel = vel_i
end

function enemy.spawn()
  local en = {
    x = love.graphics.getWidth(),
    y = love.math.random(0,love.graphics.getHeight()),
    width = enemy.width,
    height = enemy.height,
    vel = vel,
    id = love.math.random(1,id_max),
    frame = 1,
    timer = 0
  }
  if en.id == 3 then
    en.y = en.y - love.graphics.getHeight()/2
  end
  table.insert(enemy.list,en)
end

function enemy.update_progression(tim)
  -- Variando quantos inimigos diferentes nascem
  if tim > 20 then
    id_max = 3
  elseif tim > 10 then
    id_max = 2
  else
    id_max = 1
  end
  -- Variando velocidade dos inimigos
  vel = vel_i + tim*8
  if vel > 500 then
    vel = 500
  end
  -- Variando spawn dos inimigos
  time_spawn = time_spawn_i - tim*0.04
  if time_spawn < 1 then
    time_spawn = 1
  end
end

function enemy.update(dt,tim)
  timer = timer+dt
  enemy.update_progression(tim)
  if timer>time_spawn then
    timer = 0
    enemy.spawn()
  end
  local en
  for i=1,#enemy.list do
    en = enemy.list[i]
    --Tempo de animacao
    en.timer = en.timer + dt
    if en.timer > 0.2 then
      en.timer = 0
      en.frame = en.frame + 1
      if en.frame > #sprites[en.id] then
        en.frame = 1
      end
    end
    --Move Inimigo
    en.x = en.x - en.vel*dt --Move todos
    if en.id == 2 then --Move duas vezes o tipo 2
      en.x = en.x - en.vel*dt
    elseif en.id == 3 then --Move no eixo y o tipo 3
      en.y = en.y + en.vel/2*dt
    end
  end
end

function enemy.draw()
  local en
  --love.graphics.setColor(255,0,0)
  for i=1,#enemy.list do
    en = enemy.list[i]
    --love.graphics.rectangle('line',en.x,en.y,enemy.width,enemy.height)
    love.graphics.draw(sprites[en.id][en.frame],en.x,en.y,0,scale)
  end
  --love.graphics.setColor(255,255,255)
end

return enemy