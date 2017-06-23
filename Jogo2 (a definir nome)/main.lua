local game = require'game'
--local menu = require'menu'
local state

function love.load()
  game.load()
  --menu.load()
  state = game
end

function love.update(dt)
  state.update(dt)
end

function love.keypressed(key)
  state.keypressed(key)
end

function love.changeToGame()
  state = game
end



function love.draw()
  state.draw()
end