MAX_INPUT = 3
SIZE_BUF = 600
SCALE_TICK = 160-21

function getN(o,s) local x={} for v=o,o+s do x[v]=input.getNumber(v) end;return x end
function getB(o,s) local x={} for v=o,o+s do x[v]=input.getBool(v) end;return x end
function hex2rgb(h) local h = h:gsub("#","") return {tonumber(h:sub(1,2),16), tonumber(h:sub(3,4),16), tonumber(h:sub(5,6),16)} end

tick = 0

function graph(color)
    return {
        data={},
        color=color,
        lastN=0,
        add=function(s,tick,n)
            if not n then return end
            if #s.data == 0 then s.lastN = n end
            table.insert( s.data, 1, {tick, s.lastN-n} )
            s.lastN = n
            if #s.data > SIZE_BUF then table.remove(s.data) end
        end,
        draw=function(s,startTick, scaleTick, xOffset, yOffset, xScale, yScale, width, height)
            if #s.data < 2 then return end
            local lastV = { startTick, s.lastN }
            screen.setColor(table.unpack(color))
            for _,v in ipairs(s.data) do
                v = {v[1], lastV[2] + v[2]}
                screen.drawLine(
                    width-(startTick-lastV[1])*xScale + xOffset,
                    height/2-(lastV[2])*yScale + yOffset,
                    width-(startTick-v[1])*xScale + xOffset,
                    height/2-(v[2])*yScale + yOffset ) 
                lastV = v
                if v[1] < startTick - (scaleTick)/xScale then break end
            end
        end
    }
end

rainbow10colors = {'#C04040', '#C08D40','#A6C040','#5AC040','#40C073','#40C0C0','#4073C0','#5A40C0','#A640C0','#C0408D'}
--rainbow5colors = { '#FF0000','#CCFF00','#00FF67','#0066FF','#CC00FF' }
graphs={}
g1 = graph(hex2rgb('#00ff00'))
sw, sh = 0, 0
scale = { 0, 0 }


function onTick()
    data = getN(1,MAX_INPUT-1)
    for k,v in pairs(data) do
        if not graphs[k] then graphs[k] = graph(hex2rgb(rainbow10colors[k])) end
        graphs[k]:add(tick, v)
    end
    tick = tick + 1
end

flag = true
function onDraw()
    if flag then
        sw, sh = screen.getWidth(), screen.getHeight()
        scale = { sw/SCALE_TICK, sh/2-12 }
        flag = false
    end
    
    screen.setColor(table.unpack(hex2rgb('#FFFFFF')))
	
	screen.drawText(sw-20,1,'14.3')
	screen.drawText(sw-20,7,'kek')
	screen.drawText(sw-20,sh-6,'kek')
	
	screen.drawLine(0,14,sw,14)
	screen.drawLine(sw-21,0,sw-21,sh)
	
	
    for _,v in pairs(graphs) do
        v:draw(tick, SCALE_TICK, -21, 3, scale[1], scale[2], sw, sh)
        v:draw(tick, (160-21) , -21, 3, 0.25, 6, sw, 8)
    end
end