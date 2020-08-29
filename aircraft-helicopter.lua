function pid(p,i,d)
    return{p=p,i=i,d=d,E=0,D=0,I=0,
		run=function(s,sp,pv) local E,D,A 
			E = sp-pv
			D = E-s.E
			A = math.abs(D-s.D)
			s.E = E
			s.D = D
			s.I = A<E and s.I +E*s.i or s.I*0.5
			return E*s.p +(A<E and s.I or 0) +D*s.d
		end
	}
end

function getN(a,b)local x={} for v=a,b do table.insert(x, input.getNumber(v))end;return table.unpack(x)end
function outN(o, ...) for i,v in pairs({...}) do output.setNumber(o+i-1,v) end end

--function getB(...)local a={}for b,c in ipairs({...})do a[b]=input.getBool(c)end;return tU(a)end
--function outB(o, ...) for i,v in ipairs({...}) do output.setBool(o+i-1,v) end end


-- v - velocity
-- t - tilt
-- pa - pitch amount
-- r - rotate
-- i - input


pid1 = pid(0.1, 0, 4)
pid2 = pid(0.1, 0, 2)
pid3 = pid(4, 0.01, 4)

pid4 = pid(0.1, 1, 0.1)

pidL = pid(0.1, 0, 4)
pidR = pid(0.1, 0, 4)
pidB = pid(0.1, 0.001, 4)

height = 8.22 + 6


function onTick()
	-- input
	vLateral, vForward, vVertical, tPitch, tRoll, altimeter, vAngular, altL, altR = getN(1,9)
	iAD, iWS, iLR, iUD = getN(10,15)
	
	height = height + iWS/10
	
	mod = input.getBool(2)
	
	-- act
	
	
	tick = 0
	
	if mod then
		
		paL = 0.14 + 1
		paR = 0.14 + 1
		paB = 0.15
	
		rL = -1 + iLR/20
		rR = -1 - iLR/20
		rB = 0
		
		height = altimeter + 15
    else
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
	
	-- output

	outN(1,paL,paR,paB,rL,rR,rB,-iWS,iAD)
end
