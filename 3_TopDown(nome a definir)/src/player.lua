local pl = {
	x = 0,		--posicao do jogador no eixo x
	y = 0,		--posicao do jogador no eixo y
	angle = 0	--angulo de rotacao do jogador
}

local mov_speed = 200	--velocidade absoluta de movimento
local radius = 40		--raio do circulo
local width,height 		--referencia aos tamanhos de tela
local mouse_x, mouse_y	--Salva as posicoes do mouse

function pl.load()
	width,height = love.graphics.getDimensions()
	mouse_x, mouse_y =  0,0
end

--Atualiza movimento do jogador
local function update_movement(dt)
	local dir = 0
	if love.keyboard.isDown('a') then dir = -1
	elseif love.keyboard.isDown('d') then dir = 1
	end
	pl.x = pl.x + dir*mov_speed*dt
	dir = 0
	if love.keyboard.isDown('w') then dir = -1
	elseif love.keyboard.isDown('s') then dir = 1
	end
	pl.y = pl.y + dir*mov_speed*dt
end

--Atualiza colisão do jogador
local function update_collision(dt)
	--Colisao com as bordas laterais
	if pl.x-radius < 0 then
		pl.x = radius
	elseif pl.x+radius > width then
		pl.x = width - radius
	end
	--Colisao com as bordas inferior/suprerior
	if pl.y-radius < 0 then
		pl.y = radius
	elseif pl.y+radius > height then
		pl.y = height - radius
	end
end

local function update_angle(dt)
	--Atualiza angulo calculando arco tangente da diferença entre o mouse e o jogador
	local x,y = love.mouse.getPosition()
	pl.angle = math.atan2(-pl.y+y,-pl.x+x)
	mouse_x,mouse_y = x,y
end

function pl.update(dt)
	update_movement(dt)
	update_angle(dt)
	update_collision(dt)
end

function pl.draw()
	love.graphics.setColor(60,60,60)
	love.graphics.circle('fill',pl.x,pl.y,radius)
	love.graphics.setLineWidth(8)
	love.graphics.setColor(255,255,255)
	love.graphics.arc('line','open',pl.x,pl.y,radius,pl.angle-0.8,pl.angle+0.8)
	love.graphics.setLineWidth(1)
	love.graphics.line(pl.x,pl.y,mouse_x,mouse_y)
end

return pl