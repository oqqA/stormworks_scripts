MAX_INPUT = 3
SIZE_BUF = 600
SCALE_TICK = 160-21
GAP = 2
RIGHT_INDENT = 21
TOP_INDENT = 12

function getN(o,s) local x={} for v=o,o+s do x[v]=input.getNumber(v) end;return x end
function getB(o,s) local x={} for v=o,o+s do x[v]=input.getBool(v) end;return x end
function hex2rgb(h) local h = h:gsub("#","") return {tonumber(h:sub(1,2),16), tonumber(h:sub(3,4),16), tonumber(h:sub(5,6),16)} end

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
            local lastV = { startTick, s.lastN }
            local gapLastV = lastV
            screen.setColor(table.unpack(color))
            for _,v in ipairs(s.data) do
                v = {v[1], lastV[2] + v[2]}
                
                if ( (scaleTick*scale[1]+1) * v[1] ) % GAP == 0 then 
	                screen.drawLine(
	                    wh[1] - (startTick-gapLastV[1])*scale[1] + offset[1],
	                    wh[2]/2-(gapLastV[2])*scale[2] + offset[2],
	                    wh[1] - (startTick-v[1])*scale[1] + offset[1],
	                    wh[2]/2-(v[2])*scale[2] + offset[2] ) 
	                gapLastV = v
                end
                
                lastV = v
                if v[1] < startTick - (scaleTick + GAP)/scale[1] then break end
            end
        end
    }
end


rainbow10colors = {'#C04040', '#C08D40','#A6C040','#5AC040','#40C073','#40C0C0','#4073C0','#5A40C0','#A640C0','#C0408D'}
--rainbow5colors = { '#FF0000','#CCFF00','#00FF67','#0066FF','#CC00FF' }

wh = { 0, 0 }
scale = { 0, 0 }
indents = { RIGHT_INDENT, TOP_INDENT }
graphs={}
tick = 0

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
        wh = { screen.getWidth(), screen.getHeight() }
        scale = { wh[1]/(wh[1]-indents[1]), wh[2]/2-indents[2] }
        flag = false
    end
    
    screen.setColor(table.unpack(hex2rgb('#FFFFFF')))
	
	screen.drawText(wh[1]-20,1,'3.14')
	screen.drawText(wh[1]-20,7,'kek')
	screen.drawText(wh[1]-20,wh[2]-6,'kek')
	
	screen.drawLine(0,14,wh[1],14)
	screen.drawLine(wh[1]-21,0,wh[1]-21,wh[2])

    for _,v in pairs(graphs) do
        v:draw(tick, (wh[1]-indents[1]), {-indents[1], 3}, scale, wh)
        v:draw(tick, (wh[1]-indents[1]), {-indents[1], 3}, {0.25, 6}, {wh[1], 8})
    end
end