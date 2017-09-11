local player = {
  x = 100,
  y = 100,
  radius = 50,
  speed = 200,
  angle = 0
}

function player.load()
  
end

function player.reset()
  player.x = 100
  player.y = 100
end

function player.getArea(x,y)
  local dx = x-player.x
  local dy = y-player.y
  local ang = math.atan2(dy,dx)
  local min = player.angle - math.pi/2
  local max = player.angle + math.pi/2
  if ang - player.angle > math.pi then
    ang = ang-math.pi*2
  elseif player.angle - ang > math.pi then
    ang = ang+math.pi*2
  end
  if ang > min and ang < max then
    return 1
  else
    return 2
  end
end

local function update_movement(dt)
  --Movimento eixo x
  local dir = 0
  if love.keyboard.isDown('a') then dir = -1
  elseif love.keyboard.isDown('d') then dir = 1
  end
  player.x = player.x + dir*player.speed*dt
  --Movimento eixo y
  dir = 0
  if love.keyboard.isDown('w') then dir = -1
  elseif love.keyboard.isDown('s') then dir = 1
  end
  player.y = player.y + dir*player.speed*dt
end

local function update_collision()
  if player.x - player.radius < 0 then
    player.x = player.radius
  elseif player.x + player.radius > arena_width then
    player.x = arena_width - player.radius
  end
  if player.y - player.radius < 0 then
    player.y = player.radius
  elseif player.y + player.radius > arena_height then
    player.y = arena_height - player.radius
  end
end

local function update_angle(dt)
  mx,my = love.mouse.getPosition()
  mx = mx+offsetx
  my = my+offsety
  player.angle = math.atan2(my-player.y, mx-player.x)
end

function player.update(dt)
  update_movement(dt)
  update_angle(dt)
  update_collision(dt)
end

function player.draw()
  love.graphics.setColor(255,255,255)
  love.graphics.circle('fill',player.x,player.y,player.radius)
  love.graphics.setColor(255,0,0)
  love.graphics.setLineWidth(6)
  love.graphics.arc('line','open',player.x,player.y,player.radius,player.angle-math.pi/2,player.angle+math.pi/2)
  local b = player.angle + math.pi
  love.graphics.setColor(0,255,0)
  love.graphics.arc('line','open',player.x,player.y,player.radius,b-math.pi/2,b+math.pi/2)
  --love.graphics.line(mx,my,player.x,player.y)
  --love.graphics.setColor(255,255,255)
  --love.graphics.print(mx..'\n'..my)
end

return player