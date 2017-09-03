local pl = {
	x = 0,		--posicao do jogador no eixo x
	y = 0,		--posicao do jogador no eixo y
	angle = 0,	--angulo de rotacao do jogador
	radius = 40 --raio do círculo
}

local mov_speed = 200	--velocidade absoluta de movimento
local width,height 		--referencia aos tamanhos de tela
local mouse_x, mouse_y	--Salva as posicoes do mouse

function pl.load()
	width,height = love.graphics.getDimensions()
	mouse_x, mouse_y =  0,0
end

function pl.reset()
	pl.x = 0
	pl.y = 0
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
	if pl.x-pl.radius < 0 then
		pl.x = pl.radius
	elseif pl.x+pl.radius > width then
		pl.x = width - pl.radius
	end
	--Colisao com as bordas inferior/suprerior
	if pl.y-pl.radius < 0 then
		pl.y = pl.radius
	elseif pl.y+pl.radius > height then
		pl.y = height - pl.radius
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

function pl.getAngleArea(x,y)
	local ang = math.atan2(y-pl.y,x-pl.x)
	local min = pl.angle - math.pi/2
	local max = pl.angle + math.pi/2
	if ang>min and ang<max then
		return 1
	else
		return 2
	end
end

function pl.draw()
	love.graphics.setColor(60,60,60)
	love.graphics.circle('fill',pl.x,pl.y,pl.radius)
	love.graphics.setLineWidth(8)
	love.graphics.setColor(255,0,0)
	love.graphics.arc('line','open',pl.x,pl.y,pl.radius,pl.angle-math.pi/2,pl.angle+math.pi/2)
	--love.graphics.setLineWidth(1)
	--love.graphics.line(pl.x,pl.y,mouse_x,mouse_y)
	local ang = pl.angle + math.pi
	love.graphics.setColor(0,0,255)
	love.graphics.arc('line','open',pl.x,pl.y,pl.radius,ang-math.pi/2,ang+math.pi/2)
end

return pl