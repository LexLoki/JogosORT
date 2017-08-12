local game = {}

local pl = require'src/player'

function game.load()
	pl.load()
end

function game.update(dt)
	pl.update(dt)
end

function game.draw()
	pl.draw()
end

return game