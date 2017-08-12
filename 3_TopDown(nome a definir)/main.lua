local game = require'src/game'
local menu = require'src/menu'

local state = game

function love.load()
	state.load()
end

function love.update(dt)
	state.update(dt)
end

function love.draw()
	state.draw()
end