MAX_INPUT = 5
SIZE_BUF = 600
GAP = 2
RIGHT_INDENT = 23
TOP_INDENT = 12

function getN(o,s) local x={} for v=o,o+s do x[v]=input.getNumber(v) end;return x end
function getB(o,s) local x={} for v=o,o+s do x[v]=input.getBool(v) end;return x end
function hex2rgb(h) local h = h:gsub("#","") return {tonumber(h:sub(1,2),16), tonumber(h:sub(3,4),16), tonumber(h:sub(5,6),16)} end
function p(x,y) return {x=x,y=y} end

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
        draw=function(s,startTick, scaleTick, offset, scale, wh)
            if #s.data < 2 then return end
            local lastV = p(startTick, s.lastN)
            local gapLastV = lastV
            screen.setColor(table.unpack(color))
            for _,v in ipairs(s.data) do
                v = p(v[1], lastV.y + v[2])
                
                if ( (scaleTick*scale.x+1) * v.x ) % GAP == 0 then 
	                screen.drawLine(
                        offset.x + wh.x - scale.x*(startTick-gapLastV.x),
	                    offset.y + wh.y/2-scale.y*(gapLastV.y),
	                    offset.x + wh.x - scale.x*(startTick-v.x),
	                    offset.y + wh.y/2-scale.y*(v.y) ) 
	                gapLastV = v
                end
                
                lastV = v
                if v.x < startTick - (scaleTick + GAP)/scale.x then break end
            end
        end
    }
end


--rainbow10colors = {'#C04040', '#C08D40','#A6C040','#5AC040','#40C073','#40C0C0','#4073C0','#5A40C0','#A640C0','#C0408D'}
rainbow5colors = { '#FF0000','#CCFF00','#00FF67','#0066FF','#CC00FF' }

wh = p(0, 0)
scale = p(0, 0)
indents = p(RIGHT_INDENT, TOP_INDENT)
graphs={}
tick = 0

function onTick()
    data = getN(1,MAX_INPUT-1)
    for k,v in pairs(data) do
        if not graphs[k] then graphs[k] = graph(hex2rgb(rainbow5colors[k])) end
        graphs[k]:add(tick, v)
    end
    tick = tick + 1
end

flag = true
function onDraw()
    if flag then
        wh = p(screen.getWidth(), screen.getHeight())
        scale = p(wh.x/(wh.x-indents.x), wh.y/2-indents.y)
        flag = false
    end
    
    screen.setColor(table.unpack(hex2rgb('#FFFFFF')))
	
	screen.drawText(wh.x-20,1,'3.14')
	screen.drawText(wh.x-20,7,'kek')
	screen.drawText(wh.x-20,wh.y-6,'kek')
	
	screen.drawLine(0,14,wh.x,14)
	screen.drawLine(wh.x-indents.x+1,0,wh.x-indents.x+1,wh.y)

    for _,v in pairs(graphs) do
        v:draw(tick, wh.x-indents.x, p(-indents.x, 3), scale, wh)
        v:draw(tick, wh.x-indents.x, p(-indents.x, 3), p(0.25, 6), p(wh.x, 8))
    end
end