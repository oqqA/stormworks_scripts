function pid(a,b,c)return{p=a,i=b,d=c,E=0,D=0,I=0,run=function(d,e,f)local g,h,i;g=e-f;h=g-d.E;i=math.abs(h-d.D)d.E=g;d.D=h;d.I=i<g and d.I+g*d.i or d.I*0.5;return g*d.p+(i<g and d.I or 0)+h*d.d end}end
function getN(a,b) local x={} for v=a,b do table.insert(x, input.getNumber(v))end;return table.unpack(x)end

-- v - velocity
-- t - tilt
-- i - input

function onTick()
    tPitch, vForward, vAngular = getN(1,3)
    iAD, iWS = getN(31,32)

    
end