function getN(o,s) local x={} for v=o,o+s do table.insert(x, input.getNumber(v))end;return table.unpack(x)end
function outN(o, ...) for i,v in ipairs({...}) do output.setNumber(o+i-1,v) end end
function loop(n,maxN) return (n-maxN) % (maxN*2) - maxN end

steps = 50
constSteps = math.pi/steps

azimut, tick, size = 0, 1, 4
x,y,z = 0,0,0
min,max = 0,0
detect = false
mode = 1
distance = 0
lastActivDistance = 0

function f(u) return math.floor( (math.sqrt(u*4-1)-1)/2 )*2+2 end

function kek() tick = tick + 1 if tick > 120-5 then azimut=-0.5 end if tick > 120 then mode,tick = 1,1 end end

function find2() -- попробывать отрисовать
    if detect then tick = tick - 5 end
    size = f(tick)%50
    azimut = -math.pi+(tick%(size*2))*(math.pi/size)+math.pi/size
    tick = tick + 1
    if detect then 
        mode, tick = 2, 1
        return true
    end
end

function find()
    if detect then tick = tick - 5 end

    azimut = -math.pi+(tick % (steps*2))*(math.pi/steps)
    tick = tick + 1

    if detect then
        mode, tick, lastActivDistance = 2, 1, distance
		min, max = azimut, azimut
    end
end

function findMin()
    if detect then
        min = min - constSteps
    else
        min = min + constSteps
        tick = 1
        mode = 3
    end
    azimut = min
end

function reFindMin()
    if detect then
        mode = 4
    else
        if min > max then
            mode = 1
            return true
        end

        min = min + constSteps
        azimut = min
    end
end

function findMax()
    if detect then
        max = max + constSteps
        azimut = max
    else
        max = max - constSteps*4
        mode = 5
    end
end

function reFindMax()
    if detect then
        mode = 2
    else
        if max < min then
            mode = 1
            return true
        end
        max = max - constSteps
        azimut = max
    end
end

modes = { find, findMin, kek, reFindMin, findMax, reFindMax }

function onTick()
    alt, distance, strength = getN(1,3)
    detect = input.getBool(1)
    
    while modes[mode]() do end

    outN(1, min, max, 0 )
    outN(10, azimut/(2*math.pi))
end

-- alt = alt*2*math.pi
-- x = distance * math.sin(alt) * math.cos(azimut)
-- y = distance * math.sin(alt) * math.sin(azimut)
-- z = distance * math.cos(alt)