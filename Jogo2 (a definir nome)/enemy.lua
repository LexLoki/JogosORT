local enemy = {
  list = {},
  width = 300,
  height = 100
}

local colors = {
  {255,0,0},
  {0,255,0},
  {0,0,255}
}

local timer

function enemy.load()
  timer = 0
end

function enemy.spawn()
  local en = {
    x = love.graphics.getWidth(),
    y = love.math.random(0,love.graphics.getHeight()),
    vel = 300,
    id = love.math.random(1,3)
  }
  table.insert(enemy.list,en)
end

function enemy.update(dt)
  timer = timer+dt
  if timer>2 then
    timer = 0
    enemy.spawn()
  end
  local en
  for i=1,#enemy.list do
    en = enemy.list[i]
    en.x = en.x - en.vel*dt
  end
end

function enemy.draw()
  local en
  love.graphics.setColor(255,0,0)
  for i=1,#enemy.list do
    en = enemy.list[i]
    love.graphics.rectangle('fill',en.x,en.y,enemy.width,enemy.height)
  end
  love.graphics.setColor(255,255,255)
end

return enemy