local game = {
  score = 0
}

local player = require'src/player'
local enemy = require'src/enemy'

local isPaused = false

local bg
local bg_scale
local w,h

offsetx, offsety = 0, 0
arena_width, arena_height = 0,0

local music
local scoreImage

function game.load()
  player.load()
  enemy.load(player)
  bg = love.graphics.newImage('assets/arena.png')
  w,h = love.graphics.getDimensions()
  arena_width = 1.5*w
  bg_scale = arena_width / bg:getWidth()
  arena_height = bg:getHeight()*bg_scale
  music = love.audio.newSource('assets/musicaZombie.mp3')
  music:setVolume(0.14)
  music:setLooping(true)
  music:play()
  local font = love.graphics.newFont('assets/pixeled.ttf', 38)
  love.graphics.setFont(font)
  scoreImage = love.graphics.newImage('assets/score.png')
end

local function update_camera()
  offsetx = player.x-w/2
  offsety = player.y-h/2
  if offsetx<0 then
    offsetx = 0
  elseif offsetx+w > arena_width then
    offsetx = arena_width - w
  end
  if offsety<0 then
    offsety = 0
  elseif offsety+h > arena_height then
    offsety = arena_height - h
  end
end

function game.update(dt)
  if isPaused == false then
    player.update(dt)
    local didEnd = enemy.update(dt,game)
    if didEnd then
      enemy.reset()
      player.reset()
      game.score = 0
    end
  end
  update_camera()
end

function game.keypressed(key)
  if key == 'escape' then
    isPaused = not isPaused
  end
end

function game.draw()
  love.graphics.translate(-offsetx,-offsety)
  love.graphics.setColor(255,255,255)
  love.graphics.draw(bg,0,0,0,bg_scale)
  player.draw()
  enemy.draw()
  love.graphics.setColor(255,255,255)
  love.graphics.printf(game.score, offsetx , offsety, w-20, 'right')
  --love.graphics.print(game.score, offsetx, offsety)
  love.graphics.draw(scoreImage, offsetx + w - 260, offsety+40, 0, 2.4)
end

return game