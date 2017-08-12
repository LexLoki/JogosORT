local game = require'game'
local menu = require'menu'
local state

function love.load()
  love.graphics.setDefaultFilter('nearest','nearest',1)
  game.load()
  menu.load()
  state = menu
end

function love.update(dt)
  state.update(dt)
end

function love.keypressed(key)
  state.keypressed(key)
end

function love.mousepressed(x,y)
  state.mousepressed(x,y)
end

function love.changeToGame()
  state = game
end



function love.draw()
  state.draw()
end