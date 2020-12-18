function getN(o,s) local x={} for v=o,o+s do table.insert(x, input.getNumber(v))end;return table.unpack(x)end

isPressingRectangle, isPressed = false, false
moveX, moveY = 0, 0

function onTick()
	moveX, moveY = getN(7, 2)
	isPressed = input.getBool(1)

	isPressingRectangle = isPressed and isPointInRectangle(moveX, moveY, 10, 10, 20, 20)
end

function isPointInRectangle(x, y, rectX, rectY, rectW, rectH)
	return x > rectX and y > rectY and x < rectX+rectW and y < rectY+rectH
end

function onDraw()
	if isPressingRectangle then
        screen.drawRectF(10, 10, 20, 20)
	else
		screen.drawRect(10, 10, 20, 20)
    end
    
    if isPressed then
        screen.drawCircle(moveX, moveY, 2) 
    end

end