local contact = {}

function contact.circle(x1,y1,r1,x2,y2,r2)
	local dx = x1-x2
	local dy = y1-y2
	local hip = math.sqrt(dx*dx + dy*dy)
	if hip<r1+r2 then
		return true
	else
		return false
	end
end

return contact