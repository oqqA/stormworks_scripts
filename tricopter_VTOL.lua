function math.clamp(x,a,b) return x < a and a or x > b and b or x end 
function pid(p,i,d,ci)return{p=p,i=i,d=d,ci=ci,E=0,D=0,I=0,run=function(s,sp,pv)local E,D,I;E=sp-pv;D=E-s.E;I=math.clamp(E*s.i+s.I,-s.ci,s.ci);s.E=E;s.I=I;return E*s.p+s.I+D*s.d end}end

--function gj(flag,a,b) local x,fF={},input.getNumber if flag then fF = input.getBool end; for v=a,b do table.insert(x, fF(v))end;return table.unpack(x) end
function getB(a,b) local x={} for v=a,b do table.insert(x, input.getBool(v))end;return table.unpack(x) end
function getN(a,b) local x={} for v=a,b do table.insert(x, input.getNumber(v))end;return table.unpack(x)end
function outN(o, ...) for i,v in pairs({...}) do output.setNumber(o+i-1,v) end end

--function getB(...)local a={}for b,c in ipairs({...})do a[b]=input.getBool(c)end;return tU(a)end
--function outB(o, ...) for i,v in ipairs({...}) do output.setBool(o+i-1,v) end end


-- v - velocity
-- t - tilt
-- pa - pitch amount
-- r - rotate
-- i - input

height = 8.22 + 6


vLateral, vForward, vVertical, tPitch, tRoll, altimeter, vAngular, altL, altR = 0
iAD, iWS, iLR, iUD = 0
paL,paR,paB,rL,rR,rB = 0

isModeList = {} -- 1 - helicopter, 2 - aircraft, 3 - altitudeHold,  4 - autopilot, 

pid1 = pid(0.1, 0, 4, 10000)
pid2 = pid(0.1, 0, 2, 10000)
pid3 = pid(4, 0.01, 4, 10000)

pid4 = pid(0.1, 1, 0.1, 10000)

pidL = pid(0.1, 0, 4, 10000)
pidR = pid(0.1, 0, 4, 10000)
pidB = pid(0.1, 0.001, 4, 10000)


function helicopterMode()
	--tempVal1 = (-vForward)*4 + tRoll*8 --edited
	--tempVal2 = pidL:run(height,altimeter)
	tempVal3 = pid3:run(0,vAngular)
	
	tempValL = pidL:run(0,altL - height)
	tempValR = pidR:run(0,altR - height)
	
	--if vForward < 0 then temptempVal = -temptempVal end
		
	tempValBv = vForward
		
	if vForward < -0.5 then vForward = -0.5 end
	if 0.5 > vForward then  vForward = 0.5 end
		
	tempValB = pidB:run(0, vForward/50 + tPitch*8)

	paL = tempValL*0.4 - vLateral/100 + iLR/10 -- + tRoll*4 
	paR = tempValR*0.4 + vLateral/100 - iLR/10 -- - tRoll*4
	paB = tempValB + iUD/10 -- -vForward -- /4
	
	rL = -tempVal3 - iAD/2
	rR = tempVal3 + iAD/2
	rB = 0
end

function aircraftMode()

	paL = 1 -- + 0.14
    paR = 1 -- + 0.14
    paB = -0.25 -- -1

    rL = -1 + iLR/20
    rR = -1 - iLR/20
    rB = -1

    height = altimeter + 10
end

function altitudeHoldMode()
end

function autopilotMode()
end

modes = {helicopterMode, aircraftMode, altitudeHoldMode, autopilotMode}

lastMode = 0
activeTransitionMode = 0

function onTick()
    -- input
    
	vLateral, vForward, vVertical, tPitch, tRoll, altimeter, vAngular, altL, altR = getN(1,9)
	iAD, iWS, iLR, iUD = getN(10,15)
    isModeList = table.pack(true,getB(2,4))
    
    height = height + iWS/10

    -- act

    for i = 4, 1, -1 do 
        if isModeList[i] then
            modes[i]()
            break
        end
    end
    
	-- output

	outN(1,paL,paR,paB,rL,rR,rB,-iWS,iAD)
end
