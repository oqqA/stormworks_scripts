function getP(...) local x={} for _,v in ipairs({...}) do table.insert(x, property.getNumber(v)) end; return table.unpack(x) end
function outN(...) for i,v in ipairs({...}) do output.setNumber(i,v) end end
function equal(a,b) return math.abs(a-b)<0.00001 end
function math.sign(v) return v < 0 and -1 or v > 0 and 1 or 0 end

gear, speed= property.getNumber('Gear Ratio'), property.getNumber('Speed')
loopMode = property.getBool('Loop Mode')

speed = speed*(2^gear)
lastN, delayTime, timer, ang = 0,0.00001,0,0

kek = 0

function onTick()
    n = input.getNumber(1)

    if not equal(n,lastN) then
		kek = ang-ang*(delayTime - timer)/delayTime
        ang = n - lastN + kek

		lastN = n

        delayTime = math.abs(ang) * (1.91) * (2^gear) * (100/speed)
        timer = delayTime
    end

    outPivot = 0

    if math.floor(timer+0.5) > 0 then
        outPivot = math.sign(ang)*speed/100
        timer = timer - 1
    end
	
    outN(outPivot, ang, n, kek)
end