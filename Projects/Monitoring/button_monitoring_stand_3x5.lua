MAX_INPUT = 3
SIZE_BUF = 600
GAP = 2
RIGHT_INDENT = 23
TOP_INDENT = 12

function getN(o,s) local x={} for v=o,o+s do table.insert(x, input.getNumber(v)) end;return x end
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

function handlerF()
    return {
        buntons={},
        lastChangeT=0,
        lastBool=false,
        add=function(s,x,y,w,h,fun)
            table.insert( buttons, {x=x, y=y, w=w, h=h, fun=fun} )
        end,
        draw=function(s,bool, xy)
            lastChangeT = lastChangeT + 1
            if bool ~= lastBool then
                lastBool = bool
                lastChangeT = 0
            end
            
            for _,v in ipairs(s.buntons) do
                v.fun(x,bool, lastChangeTick)
            end
        end
    }
end

function button()
    return {
        x,y,w,h,flag,
        draw = function() 
        
        end
        onClick = function(lastChangeTick)
            flag = true
        end
    }
end

--rainbow10colors = {'#C04040', '#C08D40','#A6C040','#5AC040','#40C073','#40C0C0','#4073C0','#5A40C0','#A640C0','#C0408D'}
rainbow5colors = { '#FF0000','#CCFF00','#00FF67','#0066FF','#CC00FF' }

wh, scale, indents = p(0, 0), p(0, 0), p(RIGHT_INDENT, TOP_INDENT)
isPush, pushXY = false, {0,0}
graphs={}
tick = 0

handler = handlerF()
handler:add(1,1,10,10,onButtonKek)

function onTick()
    data = getN(5,MAX_INPUT-1)
    for k,v in pairs(data) do
        if not graphs[k] then graphs[k] = graph(hex2rgb(rainbow5colors[k])) end
        graphs[k]:add(tick, v)
    end
    tick = tick + 1

    isPush = getB(2,1)
    pushXY = getN(3,2)
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
	
	range = 0.2
    rangeL = (wh.x-(indents.x-1)*2)*range -- magic
	
	screen.setColor(255,255,255,50)
	screen.drawRectF(wh.x-indents.x-rangeL,1,rangeL,11)
	
    for _,v in pairs(graphs) do
        v:draw(tick, wh.x-indents.x, p(-indents.x, 3), scale, wh)
        v:draw(tick, wh.x-indents.x, p(-indents.x, 3), p(range, 6), p(wh.x, 8))
    end
    
    handler.draw(isPush, pushXY, tick)
    
end