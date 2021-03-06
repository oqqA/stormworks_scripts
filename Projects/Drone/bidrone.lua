function math.sign(v) return v < 0 and -1 or v > 0 and 1 or 0 end
function math.clamp(x,a,b) return x < a and a or x > b and b or x end 
function getN(o,s) local x={} for v=o,o+s do table.insert(x, input.getNumber(v))end;return table.unpack(x)end
function outN(o, ...) for i,v in pairs({...}) do output.setNumber(o+i-1,v) end end
function pid(p,i,d,ci)return{p=p,i=i,d=d,ci=ci,E=0,D=0,I=0,run=function(s,sp,pv)local E,D,I;E=sp-pv;D=E-s.E;I=math.clamp(E*s.i+s.I,-s.ci,s.ci);s.E=E;s.I=I;return E*s.p+s.I+D*s.d end}end
function loop(n,maxN) return (n-maxN) % (maxN*2) - maxN end
--function deltaNum(last,new,k) return  k end

ad,ws,lr,ud = 0,0,0,0
ox,oy,targetAlt,oCompass = nil,nil,nil,nil

pidFT = pid(0.02,0,2,10)
pidBT = pid(0.02,0,2,10)
pidYow = pid(0.1,0,2,10)
pidPitch = pid(0.02,0,2,10)

function onTick()
	x,y,alt,compass = getN(10,4)
	iad,iws,ilr,iud = ad,ws,lr,ud
	ad,ws,lr,ud = getN(1,4)
	
	if not targetAlt and alt == 0 then return end
	if not targetAlt then ox, oy, targetAlt, oCompass = x, y, alt, compass end

	targetAlt = targetAlt + ud/30
	oCompass = oCompass - lr/100

	radOComp = compass*2*math.pi
	ox = ox + (ad*math.cos(radOComp) - ws*math.sin(radOComp))/10
	oy = oy + (ad*math.sin(radOComp) + ws*math.cos(radOComp))/10
	
	throttleF = pidFT:run(0, alt-targetAlt)
	throttleB = pidBT:run(0, alt-targetAlt)
	
	dx, dy = ox-x,oy-y
	pitch = math.cos(math.atan(dx/dy)+radOComp)

	throttleF = math.clamp(throttleF,0,10) + math.clamp(-pitch, 0, 10)/1000
	throttleB = math.clamp(throttleB,0,10) + math.clamp( pitch, 0, 10)/1000

	deltaCompass = compass-oCompass
	deltaCompass = loop(deltaCompass, 0.5)

	yow = pidYow:run(0, deltaCompass)
	rollF = -yow
	rollB = yow

	pitch = 0

	outN(1, throttleF, throttleB, rollF, rollB, pitch)
end