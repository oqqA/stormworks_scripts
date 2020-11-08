-- not ready

function equal(a,b) return math.abs(a-b)<0.1 end
function getN(o,s) local x={} for v=o,o+s do table.insert(x, input.getNumber(v))end;return table.unpack(x)end
function outN(o,...) for i,v in ipairs({...}) do output.setNumber(o+i-1,v) end end

delayTick = 4
rP = { {3,0}, {0,0} } -- radarsPoz
d = math.sqrt( (rP[2][1]-rP[1][1])^2 + (rP[2][2]-rP[1][2])^2 )
radarBelowOrAbove = property.getNumber("radar up or down")

STEP, mode, tick = 0.01, 1, 0
aL, aR, altL, altR, dL, dR, stL, stR = 0, 0, 0, 0, 0, 0, 0, 0
minL, minR = {-0.5, 3000, 0}, {-0.5, 3000, 0}
x, y, z = 0, 0, 0

function find()
    ang = -0.5+tick*STEP
    aL, aR = ang, ang

    if dL and altL and dL ~= 0 and dL < minL[2] then
        minL = {-0.5+(tick-delayTick)*STEP, dL, altL, stL*dL}
    end

    if dR and altR and dR ~= 0 and dR < minR[2] then
        minR = {-0.5+(tick-delayTick)*STEP, dR, altR, stR*dR}
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

    a = ( minL[2]^2 - minR[2]^2 + d^2 ) / ( 2 * d )
    h = math.sqrt( minR[2]^2 - a^2 )

    x2 = rP[2][1] + a * ( rP[2][1] - rP[1][1] ) / d
    y2 = rP[2][2] + a * ( rP[2][2] - rP[1][2] ) / d

    x = ( x2 + h * ( rP[2][2] - rP[1][2] ) / d ) * 4
    y = ( y2 - h * ( rP[2][1] - rP[1][1] ) / d ) * 4
    z = minR[2] * math.sin(minR[3]*2*math.pi) * 4

        --x,y = ddL*4, ddR*4
        --x = minL[2] * math.cos(minL[3]*2*math.pi) * 4
        --y = minR[2] * math.cos(minR[3]*2*math.pi) * 4
    
    if equal(25,minR[4]) and radarBelowOrAbove == 0 then z=z-0.05199+5.12 end
    if equal(12.5,minR[4]) and radarBelowOrAbove == 0 then z=z-0.81188+5.12 end

    if equal(25,minR[4]) and radarBelowOrAbove == 1 then z=z+5.068 end
    if equal(12.5,minR[4]) and radarBelowOrAbove == 1 then z=z+2.508 end

    minL, minR = {-0.5, 3000, 0}, {-0.5, 3000, 0}
    mode = 1

    --aL = math.atan2(y - rP[1][2], x - rP[1][1]) --<> test this 
    --aR = math.atan2(y - rP[2][2], x - rP[2][1]) 
end

modes = { find, track }

function onTick()
    dL, dR, altL, altR, stL, stR = getN(1,6)

    modes[mode]()

    outN(1, x, y, z)
    outN(10, aL, aR, 0.125)
end



-- можно улучшить нахождением угла противолежащего катета (n-x)
-- или найти прямоугольный треугольник к игроку
 
-- и убрать 2 входа strength сигнала и property