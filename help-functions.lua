function getP(...) local x={} for _,v in ipairs({...}) do table.insert(x, property.getNumber(v)) end; return table.unpack(x) end
function getN(o,s) local x={} for v=o,o+s do table.insert(x, input.getNumber(v))end;return table.unpack(x)end
function outN(o, ...) for i,v in pairs({...}) do output.setNumber(o+i-1,v) end end

function math.sign(v) return v < 0 and -1 or v > 0 and 1 or 0 end
function math.clamp(x,a,b) return x < a and a or x > b and b or x end 
function pid(p,i,d,ci)return{p=p,i=i,d=d,ci=ci,E=0,D=0,I=0,run=function(s,sp,pv)local E,D,I;E=sp-pv;D=E-s.E;I=math.clamp(E*s.i+s.I,-s.ci,s.ci);s.E=E;s.I=I;return E*s.p+s.I+D*s.d end}end

function loop(n,maxN) return (n-maxN) % (maxN*2) - maxN end -- use +-math.pi or +-0.5

function gammaFix(v) local a,y=1.0,2.2 for i=1, #v do v[i]=((a*v[i])^y)/(255^y)*v[i] end return v end -- for real color block use: a,y=0.85,2.4
function hex2rgb(h) local h = h:gsub("#","") return tonumber(h:sub(1,2),16), tonumber(h:sub(3,4),16), tonumber(h:sub(5,6),16) end

function rotatePoint(r, d, x0, y0) return x0 + d * math.sin(r), y0 - d * math.cos(r) end -- radian, dist, x0, y0
function drawPixel(x,y) screen.drawText(x-1,y-4,".") end
--function drawPixel(x,y,s) screen.drawCircle(X1 + x, Y1 + y, s) end

function p(x,y) return {x=x,y=y} end