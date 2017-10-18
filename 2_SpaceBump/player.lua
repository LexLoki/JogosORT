local player = {}

local alturaMax

local sprites,timer,time,frame,sw,sh

local function loadAnimation()
  sprites = {}
  for i=1,4 do
    sprites[i] = love.graphics.newImage('assets/player/a_spaceShip_'..i..'.png')
  end
  --sprites[5] = sprites[3]
  --sprites[6] = sprites[2]
  frame = 1
  local iw,ih = sprites[1]:getDimensions()
  sw = player.width/iw
  sh = player.height/ih
  timer = 0
  time = 0.2
end

function player.load()
  player.vel = -200
  player.x = 30
  player.y = 350
  player.width = 100
  player.height = 100
  alturaMax = love.graphics.getHeight()
  
  player.grav = 500
  loadAnimation()

  player.height = player.height*0.6
end

function player.update(dt)
  timer = timer+dt
  if timer>time then
    timer = 0
    if player.vel<0 then
      frame = frame+1
      if frame>#sprites then
        frame = #sprites
      end
    else
      frame = frame-1
      if frame<1 then
        frame = 1
      end
    end
  end
  player.y = player.y + player.vel*dt -- Aplicando velocidade na posicao
  player.vel = player.vel + player.grav*dt -- Aplicando gravidade na velocidade

  -- Verificando condicao de derrota
  if player.y >= alturaMax-player.height then
    player.y = 350
    player.jump()
    return false
  end
  -- Verificando colisao com o topo
  if player.y < 0 then
    player.y = 0
    player.vel = 0
  end
  return true
end

function player.jump()
  player.vel = -300
end

function player.draw()
  --love.graphics.rectangle('line',player.x,player.y,player.width,player.height)
  love.graphics.draw(sprites[frame],player.x,player.y,0,sw,sh)
end

return player