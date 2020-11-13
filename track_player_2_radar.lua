-- https://steamcommunity.com/sharedfiles/filedetails/?id=2282814996

--<> todo
-- 1. track player every tick
-- 2. abs(detect angle) > pi/2
-- 3. understand how detected hitbox vertical and horizontal // get minus 2 inputs

function equal(a,b) return math.abs(a-b)<0.1 end
function getP(...) local x={} for _,v in ipairs({...}) do table.insert(x, property.getNumber(v)) end; return table.unpack(x) end
function getN(o,s) local x={} for v=o,o+s do table.insert(x, input.getNumber(v))end;return table.unpack(x)end
function outN(o,...) for i,v in ipairs({...}) do output.setNumber(o+i-1,v) end end

delayTick = 4
radarBelowOrAbove, x0, y0, z0 = getP("radar up or down","x0","y0","z0")
rP = { {y0,-x0-3}, {y0,-x0} } --=| radarsPoz 
d = math.sqrt( (rP[2][1]-rP[1][1])^2 + (rP[2][2]-rP[1][2])^2 )


STEP, mode, tick = 0.01, 1, 0
aL, aR, altL, altR, dL, dR, stL, stR = 0, 0, 0, 0, 0, 0, 0, 0
minL, minR = {-0.5, 3000, 0}, {-0.5, 3000, 0}
x, y, z = 0, 0, 0

function find()
    ang = -0.5+tick*STEP
    aL, aR = ang, ang

    if dL and altL and dL ~= 0 and dL < minL[2] then
        minL = {-0.5+(tick-delayTick)*STEP, dL*4, altL, stL*dL}
    end

    if dR and altR and dR ~= 0 and dR < minR[2] then
        minR = {-0.5+(tick-delayTick)*STEP, dR*4, altR, stR*dR}
    end

    if ang > 0.5+delayTick*STEP then
        mode, tick = 2, 0
        return
    end

    tick = tick + 1
end

function track()

    a = ( minL[2]^2 - minR[2]^2 + d^2 ) / ( 2 * d )
    h = math.sqrt( minL[2]^2 - a^2 )

    p2x = rP[2][1] + (a * ( rP[2][1] - rP[1][1] )) / d
    p2y = rP[2][2] + (a * ( rP[2][2] - rP[1][2] )) / d

    x = p2x - (h * ( rP[2][2] - rP[1][2] )) / d
    y = p2y + (h * ( rP[2][1] - rP[1][1] )) / d
    z = minL[2] * math.sin(minL[3]*2*math.pi)

    x = x * math.cos(minL[3]*2*math.pi)
    y = y * math.cos(minR[3]*2*math.pi)
    z = z + z0

    x, y = -y, x --=| rotate coordinate 

    ---
    
    if equal(25,minR[4]) and radarBelowOrAbove == 0 then z=z-0.05199+5.12 end
    if equal(12.5,minR[4]) and radarBelowOrAbove == 0 then z=z-0.81188+5.12 end

    if equal(25,minR[4]) and radarBelowOrAbove == 1 then z=z+5.068 end
    if equal(12.5,minR[4]) and radarBelowOrAbove == 1 then z=z+2.508 end

    minL, minR = {-0.5, 3000, 0}, {-0.5, 3000, 0}
    mode = 1

    --f = math.atan2(y - rP[1][2], x - rP[1][1]) -- radian in 2 point
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