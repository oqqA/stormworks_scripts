MAX = 5
siz = 0.5



function getN(o,s) local x={} for v=o,o+s do x[v]=input.getNumber(v) end;return x end
function hex2rgb(h) local h = h:gsub("#","") return {tonumber(h:sub(1,2),16), tonumber(h:sub(3,4),16), tonumber(h:sub(5,6),16)} end
function rotatePoint(r, d, x0, y0) return x0 + d * math.sin(r), y0 - d * math.cos(r) end
--function drawPixel(x,y) screen.drawCircle(X1 + x, Y1 + y, siz) end
function drawPixel(x,y) screen.drawText(x-1,y-4,".") end

function drawCircle(X1,Y1,radius)
    local x, y = 0, radius
    local delta, error = 1 - 2 * radius, 0

    while (y >= 0) do
        (function()
            drawPixel(X1 + x, Y1 + y)
            drawPixel(X1 + x, Y1 - y)
            drawPixel(X1 - x, Y1 + y)
            drawPixel(X1 - x, Y1 - y)
            error = 2 * (delta + y) - 1
        
            if (delta < 0) and (error <= 0) then
                x = x + 1
                delta = delta + 2 * x + 1
                return
            end
            if ((delta > 0) and (error > 0)) then
                y = y - 1
                delta = delta - 2 * y + 1
                return
            end
        

            x = x + 1
            y = y - 1
            delta = delta + 2 * (x - y)
        end)()
    end
end

sw, sh = 0, 0
cr = 0
c = { '#FF0000','#CCFF00','#00FF67','#0066FF','#CC00FF' }

data = {}

function onTick()
	data = getN(1,5)
    speed = input.getNumber(1)
end

flag = true
function onDraw()
    if flag then
        sw, sh = screen.getWidth(), screen.getHeight()
        cr = sw/2-5
        flag = false
    end
	
	screen.setColor(255,255,255, 100)
	drawCircle(sw/2, sh/2, cr)
	drawCircle(sw/2, sh/2, cr/2)
	
	
    local lx, ly = sw/2, sh/2
    for i=0, MAX do
    	r = i/MAX*math.pi*2
    	x,y = rotatePoint(r, cr*(data[i%MAX+1]+1)/2 , sw/2, sh/2)
        
        screen.setColor(255,255,255, 120)
        screen.drawTriangleF(sw/2, sh/2, x,y, lx,ly)
        screen.setColor(255,255,255, 160)
        screen.drawLine(lx,ly,x,y)
        lx, ly = x,y
    end
    
    for i=1,MAX do
    	r = (i-1)/MAX*math.pi*2
    	
        x, y = rotatePoint(r, cr, sw/2, sh/2)
        
        screen.setColor(table.unpack(hex2rgb(c[i])))
        screen.drawLine(sw/2, sh/2, x, y)
    end
    
    screen.setColor(255,255,255)
    for i=1, MAX do
    	r = i/MAX*math.pi*2
    	x,y = rotatePoint(r, cr*(data[i%MAX+1]+1)/2 , sw/2, sh/2)
        
        screen.drawCircleF(x, y, 1)
    end
    
end