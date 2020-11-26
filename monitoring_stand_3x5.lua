MAX_INPUT = 10
SIZE_BUF = 600
SCALE_TICK = 160

function getN(o,s) local x={} for v=o,o+s do x[v]=input.getNumber(v) end;return x end
function getB(o,s) local x={} for v=o,o+s do x[v]=input.getBool(v) end;return x end
function hex2rgb(h) local h = h:gsub("#","") return {tonumber(h:sub(1,2),16), tonumber(h:sub(3,4),16), tonumber(h:sub(5,6),16)} end

sw, sh = 0, 0
scale = { 0, 0 }

tick = 0

function graph(color)
    return {
        data={},
        color=color,
        lastN=0,
        scaleTick=SCALE_TICK,
        add=function(s,tick,n)
            if not n then return end
            if #s.data == 0 then s.lastN = n end
            table.insert( s.data, 1, {tick, s.lastN-n} )
            s.lastN = n
            if #s.data > SIZE_BUF then table.remove(s.data) end
        end,
        draw=function(s,startTick)
            if #s.data < 2 then return end
            local lastV = { startTick, s.lastN }
            screen.setColor(table.unpack(color))
            for _,v in ipairs(s.data) do
                v = {v[1], lastV[2] + v[2]}
                screen.drawLine(
                    sw-(startTick-lastV[1])*scale[1],
                    sh/2-(lastV[2])*scale[2],
                    sw-(startTick-v[1])*scale[1],
                    sh/2-(v[2])*scale[2] )
                lastV = v
                if v[1] < startTick - s.scaleTick then break end
            end
        end
    }
end

rainbow10colors = {'#C04040', '#C08D40','#A6C040','#5AC040','#40C073','#40C0C0','#4073C0','#5A40C0','#A640C0','#C0408D'}
--rainbow5colors = { '#FF0000','#CCFF00','#00FF67','#0066FF','#CC00FF' }
graphs={}
g1 = graph(hex2rgb('#00ff00'))

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
        scale = { sw/SCALE_TICK, sh/2 }
        flag = false
    end

    for _,v in pairs(graphs) do
        v:draw(tick)
    end
end