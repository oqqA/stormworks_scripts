-- Saver data from remote controller
-- https://steamcommunity.com/sharedfiles/filedetails/?id=2320675199

function getN(o,s) local x={} for v=o,o+s do table.insert(x, input.getNumber(v))end;return x end
function outN(o,a) for i,v in pairs(a) do output.setNumber(o+i-1,v) end end

function getB(o,s) local x={} for v=o,o+s do table.insert(x, input.getBool(v))end;return x end
function outB(o,a) for i,v in pairs(a) do output.setBool(o+i-1,v) end end

fSaveN = property.getBool('Saving numbers')

initArrN = {}
initArrB = {}

saveArrN = {}
saveArrB = {}

fInit = true
tick = 0
function onTick()
	signalStr = getN(32,1)[1]
	
	arrN = getN(1,31)
	arrB = getB(1,32)
	
	if signalStr > 0 then
		tick = tick + 1
		if tick > 4 then
			if fInit then
				fInit = false
		
				initArrN = arrN
				initArrB = arrB
			end
		
			for i = 1, 31 do
				saveArrN[i] = arrN[i] - initArrN[i]
			end
			
			for i = 1, 32 do
				saveArrB[i] = arrB[i] ~= initArrB[i]
			end
			
			tick = 4
		end
	else
		tick = 0
	end
	
	if fSaveN then 
		outN(1,saveArrN)
	else
		outN(1,arrN)
	end
	
	outB(1,saveArrB)
end