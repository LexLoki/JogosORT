local exp = {
	duration = 1.2
}

local images
local list = {}
local pivotx, pivoty

function exp.load(colors)
	exp.colors = colors
	images = {}
	for i=1,10 do
		images[i] = love.graphics.newImage('assets/explosao/zRosa'..i..'.png')
	end
	pivotx,pivoty = images[1]:getDimensions()
	pivotx,pivoty = pivotx/2, pivoty/2
end

function exp.add(x,y,angle,id,sx,sy)
	local e = {
		x = x,
		y = y,
		sx = sx,
		sy = sy,
		id = id,
		timer = 0,
		frame = 1,
		angle = angle
	}
	table.insert(list,e)
end

function exp.update(dt)
	local e
	for i=#list,1,-1 do
		e = list[i]
		e.timer = e.timer + dt
		if e.timer > exp.duration/#images then
			e.timer = 0
			e.frame = e.frame+1
			if e.frame > #images then
				table.remove(list,i)
			end
		end
	end
end

function exp.draw()
	local e
	for i=1,#list do
		e = list[i]
		love.graphics.setColor(exp.colors[e.id])
		love.graphics.draw(images[e.frame],e.x,e.y,e.angle,e.sx,e.sy,pivotx,pivoty)
	end
end

return exp