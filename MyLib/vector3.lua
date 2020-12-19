function clamp(x,a,b) return x < a and a or x > b and b or x end 

function v3(x, y, z)
    r = {x=x,y=y,z=z}
    if type(x)=="table" then r={x=x[1],y=x[2],z=x[3]} end 
    
    f = {
        len = function(v) return #v end,
        norm = function(v) local l=#v return v3(v.x/l,v.y/l,v.z/l) end,
        dot = function(v, n) return v.x*n.x+v.y*n.y+v.z*n.z end,
        dist = function(v, n) return #(v-n) end,
        max = function(v, n) return v3(math.max(v.x,n.x),math.max(v.y,n.y),math.max(v.z,n.z)) end,
        min = function(v, n) return v3(math.min(v.x,n.x),math.min(v.y,n.y),math.min(v.z,n.z)) end,
        angle = function(v, n) return math.acos(clamp(( v:norm():dot(n:norm()) ), -1, 1)) end,
        cross = function(v, n) return v3( v.y*n.z - v.z*n.y, v.z*n.x - v.x*n.z, v.x*n.y - v.y*n.x ) end,
        lerp = function(v, n, t) t = clamp(t, 0, 1) return v3(v.x + ((n.x - v.x) * t), v.y + ((n.y - v.y) * t), v.z + ((n.z - v.z) * t)) end,
        reflect = function(v, n) return n*(-2*n:dot(v))+v end,
        project = function(v, n) return n*(v:dot(n)/(#n^2)) end,
        clone = function(v) return v3(v.x, v.y, x.z) end,
        -- todo: smoothDamp, rotateTowards, slerp
    }

    m = {
        __type = "vector3",
        __len = function(v) return ((v.x*v.x)+(v.y*v.y)+(v.z*v.z))^0.5 end,

        __unm = function(v) return v3( -v.x, -v.y, -v.z ) end,
        __add = function(v, n) if type(n)=="table" then return v3(v.x+n.x,v.y+n.y,v.z+n.z) else return v3(v.x+n,v.y+n,v.z+n) end end,
        __sub = function(v, n) if type(n)=="table" then return v3(v.x-n.x,v.y-n.y,v.z-n.z) else return v3(v.x-n,v.y-n,v.z-n) end end,
        __mul = function(v, n) if type(n)=="table" then return v3(v.x*n.x,v.y*n.y,v.z*n.z) else return v3(v.x*n,v.y*n,v.z*n) end end,
        __div = function(v, n) if type(n)=="table" then return v3(v.x/n.x,v.y/n.y,v.z/n.z) else return v3(v.x/n,v.y/n,v.z/n) end end,
        __eq = function(v, n) if type(n)=="table" then return v.x==n.x and v.y==n.y and v.z==n.z else return false end end,
    }

    for k,v in pairs(f) do r[k] = v end
    setmetatable(r, m) 
    return r
end
