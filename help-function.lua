function pid(p,i,d,ci)return{p=p,i=i,d=d,ci=ci,E=0,D=0,I=0,run=function(s,sp,pv)local E,D,I;E=sp-pv;D=E-s.E;I=math.clamp(E*s.i+s.I,-s.ci,s.ci);s.E=E;s.I=I;return E*s.p+s.I+D*s.d end}end
function getB(a,b) local x={} for v=a,b do table.insert(x, input.getBool(v))end;return table.unpack(x) end
function getN(a,b) local x={} for v=a,b do table.insert(x, input.getNumber(v))end;return table.unpack(x)end
function outN(o, ...) for i,v in pairs({...}) do output.setNumber(o+i-1,v) end end

function getP(...) local x={} for _,v in ipairs({...}) do table.insert(x, property.getNumber(v)) end; return table.unpack(x) end
function outN(...) for i,v in ipairs({...}) do output.setNumber(i,v) end end
function equal(a,b) return math.abs(a-b)<0.00001 end
function sgn(v) return v < 0 and -1 or v > 0 and 1 or 0 end


function getP(...) local x={} for _,v in ipairs({...}) do table.insert(x, property.getNumber(v)) end; return table.unpack(x) end
function getN(a,b) local x={} for v=a,b do table.insert(x, input.getNumber(v))end;return table.unpack(x)end
function getB(a,b) local x={} for v=a,b do table.insert(x, input.getBool(v))end;return table.unpack(x) end

function outN(o, ...) for i,v in pairs({...}) do output.setNumber(o+i-1,v) end end





