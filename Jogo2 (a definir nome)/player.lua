local player = {}

local alturaMax

function player.load()
  player.vel = -200
  player.x = 100
  player.y = 350
  player.largura = 100
  player.altura = 100
  alturaMax = love.graphics.getHeight()
  
  player.grav = 500
end

function player.update(dt)

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
  love.graphics.rectangle('fill',player.x,player.y,player.largura,player.altura)
end

return player