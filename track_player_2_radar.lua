-- not tested

function getN(o,s) local x={} for v=o,o+s do table.insert(x, input.getNumber(v))end;return table.unpack(x)end
function outN(o,...) for i,v in ipairs({...}) do output.setNumber(o+i-1,v) end end

delayTick = 8 --<> test this
rP = { {0,0}, {-3,0} } -- radarsPoz
d = math.sqrt( (rP[2][1]-rP[1][1])^2 + (rP[2][2]-rP[1][2])^2 )

STEP, mode, tick = 0.01, 1, 0
aL, aR, alt, dL, dR = 0, 0, 0, 0, 0
minL, minR = {-0.5, 3000}, {-0.5, 3000}
x, y, z = 0, 0, 0

function find()
    ang = -0.5+tick*STEP
    aL, aR = ang, ang

    if dL ~= 0 and dL < minL[2] then
        minL = {-0.5+(tick-delayTick)*STEP, dL, alt} --<> [3]
    end

    if dR ~= 0 and dR < minR[2] then
        minR = {-0.5+(tick-delayTick)*STEP, dR, alt} --<> [3]
    end

    if ang > 0.5+delayTick*STEP then
        mode = 2
        return
    end

    tick = tick + 1
end

function track()
    a = ( minR[2]^2 - minR[1]^2 + d^2 ) / ( 2 * d )
    h = math.sqrt( minR[2]^2 - a^2 )

    x2 = rP[2][1] + a * ( rP[2][1] - rP[1][1] ) / d
    y2 = rP[2][2] + a * ( rP[2][2] - rP[1][2] ) / d

    x = x2 + h * ( rP[2][2] - rP[1][2] ) / d
    y = y2 - h * ( rP[2][1] - rP[1][1] ) / d
    z = minR[2] * math.cos(minR[3]*2*math.pi) --<> minR or minL ?

    --aL = math.atan2(y - rP[1][2], x - rP[1][1]) --<> test this 
    --aR = math.atan2(y - rP[2][2], x - rP[2][1]) 
end

modes = { find, track }

function onTick()
    dL, dR, alt = getN(1,2) --<> add altLR?

    modes[mode]()

    outN(1, x, y, z)
    outN(10, aL, aR)
end