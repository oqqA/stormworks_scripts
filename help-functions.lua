function getP(...) local x={} for _,v in ipairs({...}) do table.insert(x, property.getNumber(v)) end; return table.unpack(x) end
function getN(o,s) local x={} for v=o,o+s do table.insert(x, input.getNumber(v))end;return table.unpack(x)end
function outN(o, ...) for i,v in pairs({...}) do output.setNumber(o+i-1,v) end end

function math.sign(v) return v < 0 and -1 or v > 0 and 1 or 0 end
function math.clamp(x,a,b) return x < a and a or x > b and b or x end 
function pid(p,i,d,ci)return{p=p,i=i,d=d,ci=ci,E=0,D=0,I=0,run=function(s,sp,pv)local E,D,I;E=sp-pv;D=E-s.E;I=math.clamp(E*s.i+s.I,-s.ci,s.ci);s.E=E;s.I=I;return E*s.p+s.I+D*s.d end}end

function loop(n,maxN) return (n-maxN) % (maxN*2) - maxN end -- use +-math.pi or +-0.5

function gammaFix(v) local a,y=1.0,2.2 for i=1, #v do v[i]=((a*v[i])^y)/(255^y)*v[i] end return v end -- for real color block use: a,y=0.85,2.4

------ for generate rainbow 
function h2rgb(m1, m2, h)
	if h<0 then h = h+1 end
	if h>1 then h = h-1 end
	if h*6<1 then
		return m1+(m2-m1)*h*6
	elseif h*2<1 then
		return m2
	elseif h*3<2 then
		return m1+(m2-m1)*(2/3-h)*6
	else
		return m1
	end
end

function hsl_to_rgb(h, s, L)
	local m2 = L <= .5 and L*(s+1) or L+s-L*s
	local m1 = L*2-m2
	return
		h2rgb(m1, m2, h+1/3),
		h2rgb(m1, m2, h),
		h2rgb(m1, m2, h-1/3)
end
------