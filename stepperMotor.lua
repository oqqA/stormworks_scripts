-- https://steamcommunity.com/sharedfiles/filedetails/?id=2256432144
-- 1 bug: loop mode does not work correctly when the turn process is interrupted

function getP(...) local x={} for _,v in ipairs({...}) do table.insert(x, property.getNumber(v)) end; return table.unpack(x) end
function outN(...) for i,v in ipairs({...}) do output.setNumber(i,v) end end
function equal(a,b) return math.abs(a-b)<0.00001 end
function sgn(v) return v < 0 and -1 or v > 0 and 1 or 0 end

gear, speed= property.getNumber('Gear Ratio'), property.getNumber('Speed')
loopMode = property.getBool('Loop Mode')

speed = speed*(2^gear)
lastN, delayTime, timer, ang = 0,0.00001,0,0

lastKek = 0
kek = 0

saveLastN = 0

function onTick()
    n = input.getNumber(1) % (2*math.pi)

    if not equal(n,lastN) then
		kek = ang-ang*(delayTime - timer)/delayTime
        ang = n - lastN + kek

        if loopMode then
            if math.abs(ang)>math.pi then
                ang = ang+(2*math.pi-kek)*sgn(-ang)
                ang = ang%(2*math.pi*sgn(-ang))
            end

            -- if ang > math.pi then
            --     ang = ang-2*math.pi-kek
            -- end

            -- if ang < -math.pi then
            --     ang = ang+2*math.pi+kek
            -- end
        end

        lastN = n
        lastKek = kek

        delayTime = math.abs(ang) * (1.91) * (2^gear) * (100/speed)
        timer = delayTime
    end

    outPivot = 0

    if math.floor(timer+0.5) > 0 then
        outPivot = sgn(ang)*speed/100
        timer = timer - 1
    end
	
    outN(outPivot, ang, n, kek)
end