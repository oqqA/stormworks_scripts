function h2rgb(m1, m2, h)
	if h<0 then h = h+1 end
	if h>1 then h = h-1 end
	if h*6<1 then
		return m1+(m2-m1)*h*6
	elseif h*2<1 then
		return m2
	elseif h*3<2 then
		return m1+(m2-m1)*(2/3-h)*6
	else
		return m1
	end
end

function hsl_to_rgb(h, s, L)
	h = h / 360
	local m2 = L <= .5 and L*(s+1) or L+s-L*s
	local m1 = L*2-m2
	return
		h2rgb(m1, m2, h+1/3),
		h2rgb(m1, m2, h),
		h2rgb(m1, m2, h-1/3)
end

countKeyboard = 5

function getN(a,b) local x={} for v=a,b do table.insert(x, input.getNumber(v))end;return x end

scale = property.getNumber('Scale')
v = {0,0}
colors = {}

for i=1,countKeyboard do
    r,g,b = hsl_to_rgb(360/countKeyboard*i, 0.50, 0.50)
    colors[i] = {r*255, g*255, b*255}
end

function onTick()
    v = getN(1,countKeyboard*2)
end

function onDraw()
	w,h = screen.getWidth(),screen.getHeight()				  -- Get the screen's width and height
    
    cx, cy = v[1], v[2]
    for i=3,#v,2 do
        cx, cy = (cx+v[i])/2, (cy+v[i+1])/2
    end

    screen.drawMap(cx, cy, scale)

    for i=1,#v,2 do
        drawX, drawY = map.mapToScreen(cx, cy, scale, w,h, v[i],v[i+1])
        col = colors[i//2+1]
        screen.setColor(col[1],col[2],col[3])
        screen.drawCircle(drawX, drawY,2)
    end

    screen.setColor(255,255,255)

	-- dx,dy = x-cx,y-cy
	-- r = math.sqrt(dx^2+dy^2)-2
	-- a = math.atan(dy,dx)
	-- nx,ny = r*math.cos(a),r*math.sin(a)
	-- screen.drawLine(cx,cy,cx+nx,cy+ny)
end