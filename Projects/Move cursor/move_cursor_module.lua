function getPN(...) local x={} for _,v in ipairs({...}) do table.insert(x, property.getNumber(v)) end; return table.unpack(x) end
function getPT(...) local x={} for _,v in ipairs({...}) do table.insert(x, property.getNumber(v)) end; return table.unpack(x) end
function getN(o,s) local x={} for v=o,o+s do table.insert(x, input.getNumber(v))end;return x end
function getB(o,s) local x={} for v=o,o+s do table.insert(x, input.getBool(v))end;return x end
function outN(o, ...) for i,v in pairs({...}) do output.setNumber(o+i-1,v) end end
function outB(o, ...) for i,v in pairs({...}) do output.setBool(o+i-1,v) end end

function p3(a) return {x=a[1],y=a[2],z=a[3]} end
function split(s, d) local x = {} for m in (s..d):gmatch("(.-)"..d) do table.insert(x, tonumber(m)) end; return x; end

screen_dir, screen_pos = getPN("Screen direction in workbench", "Screen position")
start_point, corner_point = getPT("Start point coordinates", "Coordinates of the top left corner of the screen relative to the starting point (measurement in blocks)")

screen_dir, screen_pos = p3(split(screen_dir,",")), p3(split(screen_pos,","))
start_point, corner_point = p3(split(start_point,",")), p3(split(corner_point,","))

function onTick()
    screen_input_n = getN(1,6)
    screen_input_b = getB(1,2)
    
    pos = p3(getN(11,3))
    look = p3(getN(14,3))
    tilt = p3(getN(21,3))
    start = p3(getN(24,1)[1], getN(27,1)[1], getN(25,1)[1])

    moveX, moveY = 0, 0
    -- magic
    
    table.insert(screen_input_n, moveX)
    table.insert(screen_input_n, moveY)
	
    outN(1, table.unpack(screen_input_n))
	outB(1, table.unpack(screen_input_b))
end