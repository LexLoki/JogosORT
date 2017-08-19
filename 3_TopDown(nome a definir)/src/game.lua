local game = {}

local player = require'src/player'
local enemy = require'src/enemy'

function game.load()
  player.load()
  enemy.load(player)
end

function game.update(dt)
  player.update(dt)
  enemy.update(dt)
end

function game.draw()
  player.draw()
  enemy.draw()
end

return game