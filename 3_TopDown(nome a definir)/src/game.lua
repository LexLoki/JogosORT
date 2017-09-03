local game = {}

local player = require'src/player'
local enemy = require'src/enemy'

function game.load()
  player.load()
  enemy.load(player)
end

function game.update(dt)
  player.update(dt)
  local didEnd = enemy.update(dt)
  if didEnd then
  	player.reset()
  	enemy.reset()
  end
end

function game.draw()
  player.draw()
  enemy.draw()
end

return game