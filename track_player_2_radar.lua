-- not ready
-- bug: detect legs, torso, head

function getN(o,s) local x={} for v=o,o+s do table.insert(x, input.getNumber(v))end;return table.unpack(x)end
function outN(o,...) for i,v in ipairs({...}) do output.setNumber(o+i-1,v) end end

delayTick = 4
rP = { {3,0}, {0,0} } -- radarsPoz
d = math.sqrt( (rP[2][1]-rP[1][1])^2 + (rP[2][2]-rP[1][2])^2 )

STEP, mode, tick = 0.01, 1, 0
aL, aR, altL, altR, dL, dR = 0, 0, 0, 0, 0, 0
minL, minR = {-0.5, 3000, 0}, {-0.5, 3000, 0}
x, y, z = 0, 0, 0

function find()
    ang = -0.5+tick*STEP
    aL, aR = ang, ang

    if dL and altL and dL ~= 0 and dL < minL[2] then
        minL = {-0.5+(tick-delayTick)*STEP, dL, altL}
    end

    if dR and altR and dR ~= 0 and dR < minR[2] then
        minR = {-0.5+(tick-delayTick)*STEP, dR, altR}
    end

    if ang > 0.5+delayTick*STEP then
        mode, tick = 2, 0
        return
    end

    tick = tick + 1
end

function track()

    -- if minL[2] < 1 then minL[3] = minL[3]-1 end --<> +1 or -1 ?
    -- if minR[2] < 1 then minR[3] = minR[3]-1 end

    ddL = minL[2] * math.cos(minL[3]*2*math.pi)
    ddR = minR[2] * math.cos(minR[3]*2*math.pi)

    a = ( ddL^2 - ddR^2 + d^2 ) / ( 2 * d )
    h = math.sqrt( ddR^2 - a^2 )
    
    x,y,z = ddL*4, ddR*4, minR[3]

    x2 = rP[2][1] + a * ( rP[2][1] - rP[1][1] ) / d
    y2 = rP[2][2] + a * ( rP[2][2] - rP[1][2] ) / d

    --x = x2 + h * ( rP[2][2] - rP[1][2] ) / d
    --y = y2 - h * ( rP[2][1] - rP[1][1] ) / d
    --x, y = x*4, y*4

        --x = minL[2] * math.cos(minL[3]*2*math.pi) * 4
        --y = minR[2] * math.cos(minR[3]*2*math.pi) * 4
    z = ddR * math.sin(minR[3]*2*math.pi) * 4

    minL, minR = {-0.5, 3000, 0}, {-0.5, 3000, 0}
    mode = 1

    --aL = math.atan2(y - rP[1][2], x - rP[1][1]) --<> test this 
    --aR = math.atan2(y - rP[2][2], x - rP[2][1]) 
end

modes = { find, track }

function onTick()
    dL, dR, altL, altR = getN(1,4)

    modes[mode]()

    outN(1, x, y, z)
    outN(10, aL, aR)
end