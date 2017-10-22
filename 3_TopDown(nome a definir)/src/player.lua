local player = {
  x = 100,
  y = 100,
  radius = 50,
  speed = 200,
  angle = 0
}

local scale

local timer
local imgs = {}
local frame = 1
local pivotx,pivoty

local rot_angle = 0
local rot_speed = 2*math.pi
local rot_dir = 1

local img
local img_body
local img_sword

function player.load()
  --[[
  for i=1,5 do
    imgs[i] = love.graphics.newImage('assets/g_'..i..'.png')
  end
  for i=#imgs-1, 2, -1 do
    table.insert(imgs,imgs[i])
  end]]
  img = love.graphics.newImage('assets/char.png')
  --img_body = love.graphics.newImage('assets/body.png')
  --img_sword = love.graphics.newImage('assets/sword.png')
  local iw,ih = img:getDimensions()
  scale = 2*math.min(player.radius/iw,player.radius/ih)
  pivotx,pivoty = iw/2, ih/2
  timer = 0
end

function player.reset()
  player.x = 100
  player.y = 100
  timer = 0
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
  if love.keyboard.isDown('a') or love.keyboard.isDown('left') then dir = -1
  elseif love.keyboard.isDown('d') or love.keyboard.isDown('right') then dir = 1
  end
  player.x = player.x + dir*player.speed*dt
  --Movimento eixo y
  dir = 0
  if love.keyboard.isDown('w') or love.keyboard.isDown('up') then dir = -1
  elseif love.keyboard.isDown('s') or love.keyboard.isDown('down') then dir = 1
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

local function update_animation(dt)
  timer = timer+dt
  if timer > 0.08 then
    timer = 0
    frame = frame+1
    if frame+1>#imgs then
      frame = 1
    end
  end
end

local function update_rotation(dt)
  rot_angle = rot_angle + rot_speed*rot_dir*dt
  if rot_angle > math.pi then
    rot_angle = math.pi
    rot_dir = -1
  elseif rot_angle < 0 then
    rot_angle = 0
    rot_dir = 1
  end
end

function player.update(dt)
  update_animation(dt)
  update_movement(dt)
  update_angle(dt)
  update_collision(dt)
  update_rotation(dt)
end

function player.draw()
  love.graphics.setColor(255,255,255)
  --love.graphics.circle('fill',player.x,player.y,player.radius)
  love.graphics.setColor(255,0,0,120)
  love.graphics.setLineWidth(3)--6)
  --love.graphics.arc('line','open',player.x,player.y,player.radius,player.angle-math.pi/2,player.angle+math.pi/2)
  local b = player.angle + math.pi
  love.graphics.setColor(0,255,0,120)
  --love.graphics.arc('line','open',player.x,player.y,player.radius,b-math.pi/2,b+math.pi/2)
  love.graphics.setColor(255,255,255)
  --love.graphics.draw(imgs[frame], player.x, player.y, player.angle-math.pi/2, scale, scale, pivotx, pivoty)

  love.graphics.draw(img,player.x,player.y,player.angle,scale,scale,pivotx,pivoty)
  --love.graphics.draw(img_body,player.x,player.y,player.angle+rot_angle,scale,scale,pivotx,pivoty)
  --love.graphics.draw(img_sword,player.x,player.y,player.angle+rot_angle,scale,scale,pivotx,pivoty)
  --love.graphics.line(mx,my,player.x,player.y)
  --love.graphics.setColor(255,255,255)
  --love.graphics.print(mx..'\n'..my)
end

return player