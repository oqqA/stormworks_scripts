-- not ready

function getN(o,s) local x={} for v=o,o+s do table.insert(x, input.getNumber(v))end;return table.unpack(x)end
function outN(o, ...) for i,v in pairs({...}) do output.setNumber(o+i-1,v) end end

MAX_INPUTS = 25


sA = {{0,0}, {0,0}} -- screenAngles
res = {0,0}
function checkResolution()
    -- <> optimize
    newRes = {screen.getWidth(), screen.getHeight()}
    if res ~= newRes then
        res = newRes
        sA = {{0,0},{res[1],0},{0,res[2]},{res[1],res[2]}}
    end
end

function hex2rgb(hex)
    local hex = hex:gsub("#","")
    return tonumber(hex:sub(1,2),16), tonumber(hex:sub(3,4),16), tonumber(hex:sub(5,6),16)
end

-- <>
customSumbl = {
    {"000"},
}

-- str, screen angle, x, y, w, h  
buttons = {
    {"*", 2, -8, 1, 6, 6},
    {"sav", 2, -30, 1, 6, 6},
    {"e", 2, -16, 1, 6, 6},
}

startTick = 0
scaleTick = 500
colors = {[7]="#00ff00"}

d = {} -- structure = { tick, { [N] = value,... } }
lastActivOfChannels, lastValueN = {}, {}

tick = 0

function getData()
    local newD, newLine = getN(1,MAX_INPUTS), {}
    
    for i,v in pairs(newD) do
        if lastValueN[i] ~= v then
            newLine[i] = v
            lastValueN[i] = v
            lastActivOfChannels[i] = tick
        end
    end

    if next(newLine) ~= nil then
        table.insert(d, 1, { tick, newLine })
    end
end

-- draw

function drawButtons() 
    screen.setColor(hex2rgb("#ffffff"))
    
    for _,v in pairs(buttons) do 
        screen.drawText(sA[v[2]][1] + v[3], sA[v[2]][2] + v[4], v[1])
    end
end

function isPointInRectangle(x, y, rectX, rectY, rectW, rectH)
    return x > rectX and y > rectY and x < rectX+rectW and y < rectY+rectH
end

function getDataChannel(n,lastActivTick) -- return { {tick, value}, ... }
    local res, f = {} , 0

    for _,v in ipairs(d) do
        if v[1] < startTick - scaleTick then break end

        if v[1] < startTick and v[1] ~= 0 then
            if v[2][n] ~= nil then
                local a = { v[1], v[2][n] }
                table.insert( res, 1, a )
            end
            
        end
    end

    return res
end

scale = {0,0}

function drawGraph()

    for n,v in pairs(lastActivOfChannels) do
        if v > startTick - scaleTick and v < startTick then
            local graphChannel = getDataChannel(n, v)
            local lastValue = graphChannel[1]

            col = "#ffffff"
            if colors[n] ~= nil then col = colors[n] end
            screen.setColor(hex2rgb(col))

            for _,z in ipairs(graphChannel) do
                print(z)
                screen.drawLine(res[1] - (tick - lastValue[1])*scale[1], res[2]/2 + lastValue[2]*scale[2],res[1] - (tick - z[1])*scale[1], res[2]/2 + z[2]*scale[2]) 
                lastValue = z
            end
        end
    end

end

-- main

function onTick()
    inputX = input.getNumber(29)
    inputY = input.getNumber(30)
    isPressed = input.getBool(31)
    
    isPressingRectangle = isPressed and isPointInRectangle(inputX, inputY, 10, 10, 20, 20)

    --output.setBool(1, isPressingRectangle)

    getData()
end

function onDraw()
    tick = tick + 1
    startTick = tick -- <> mode tick or value

    checkResolution()
    drawButtons()

    drawGraph()

    if isPressingRectangle then
        screen.drawRectF(10, 10, 20, 20)
    else
        --screen.drawRect(10, 10, 20, 20)
    end
end