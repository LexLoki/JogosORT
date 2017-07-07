local player = {}

local alturaMax

local sprites,timer,time,frame,sw,sh

local function loadAnimation()
  sprites = {}
  for i=1,4 do
    sprites[i] = love.graphics.newImage('assets/player/a_spaceShip_'..i..'.png')
  end
  frame = 1
  local iw,ih = sprites[1]:getDimensions()
  sw = player.largura/iw
  sh = player.altura/ih
  timer = 0
  time = 0.2
end

function player.load()
  player.vel = -200
  player.x = 100
  player.y = 350
  player.largura = 100
  player.altura = 100
  alturaMax = love.graphics.getHeight()
  
  player.grav = 500
  loadAnimation()
end

function player.update(dt)
  timer = timer+dt
  if timer>time then
    timer = 0
    frame = frame+1
    if frame>#sprites then
      frame = 1
    end
  end
  player.y = player.y + player.vel*dt -- Aplicando velocidade na posicao
  player.vel = player.vel + player.grav*dt -- Aplicando gravidade na velocidade

  -- Verificando condicao de derrota
  if player.y >= alturaMax-player.altura then
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
  player.vel = -200
end

function player.draw()
  --love.graphics.rectangle('fill',player.x,player.y,player.largura,player.altura)
  love.graphics.draw(sprites[frame],player.x,player.y,0,sw,sh)
end

return player