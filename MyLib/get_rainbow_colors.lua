n = 10 -- count colors

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

i = 0
while (i<n) do
    r,g,b = hsl_to_rgb(i/n,1,0.5)
    print(string.format("#%02X%02X%02X", math.ceil(r*255),math.ceil(g*255),math.ceil(b*255)) )
    i = i + 1
end