local game = require'src/game'
local menu = require'src/menu'

local state = game

function love.load()
  love.graphics.setDefaultFilter('nearest','nearest',1)
  state.load()
end

function love.update(dt)
  state.update(dt)
end

function love.keypressed(key)
  state.keypressed(key)
end

function love.draw()
  state.draw()
end