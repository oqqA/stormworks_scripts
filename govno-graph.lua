local x,y,height,width=0,0,32,32 
local name='' 
local timer=0 
local monitor={} 
monitor.resx,monitor.resy=288,160
local gph={0} 
local min,max,inp1=0,0,0 
local bccol,frcol,grcol,zrcol,fvcol={0,0,0},{0,0,0},{0,0,0},{0,0,0,0},{0,0,0,0} 
local first,second=0,0

local function clamp(numb,min,max)
return math.max(min,math.min(max,numb))
end

local function toSt(numb)
if math.abs(numb)>=1000 then
local sm
if numb<0 then sm=-1 else sm=1 end
local numb=math.abs(numb)
local dec=#tostring(math.floor(numb))-2
return ((math.floor(numb/10^dec)/10*sm).."E"..dec+1)
else return tostring(math.floor(numb*10)/10)
end
end

function onTick()

if property.getBool"Background" then bccol={0,0,0,0} else
bccol={property.getNumber"Background RED"/2.55,property.getNumber"Background GREEN"/2.55,property.getNumber"Background BLUE"/2.55}
end
frcol={property.getNumber"Foreground RED"/2.55,property.getNumber"Foreground GREEN"/2.55,property.getNumber"Foreground BLUE"/2.55}
grcol={property.getNumber"Graph RED"/2.55,property.getNumber"Graph GREEN"/2.55,property.getNumber"Graph BLUE"/2.55}
zrcol={property.getNumber"Zeroline RED"/2.55,property.getNumber"Zeroline GREEN"/2.55,property.getNumber"Zeroline BLUE"/2.55,100}
fvcol={property.getNumber"Fixval RED"/2.55,property.getNumber"Fixval GREEN"/2.55,property.getNumber"Fixval BLUE"/2.55,100}

x=clamp(property.getNumber"X",0,monitor.resx-width-1)
y=clamp(property.getNumber"Y",0,monitor.resy-height-1)
width=clamp(property.getNumber"Width",31,monitor.resx-1)
height=clamp(property.getNumber"Height",31,monitor.resy-1)
inp=clamp(input.getNumber(1),-9999999999,9999999999)
name=property.getText"Graph name"
local speed=math.max(0.1,property.getNumber"Speed")*60

timer=timer+1

if timer>=speed then 
timer=0
table.insert(gph,inp)
if #gph>width then 
table.remove(gph,1)
end 
end

if property.getBool"Fixed min and max" 
then
first=clamp(property.getNumber"Fixed first value",-9999999999,9999999999)
second=clamp(property.getNumber"Fixed second value",-9999999999,9999999999)
if second>first then second,first=first,second end
if first==second then first=first+0.001 end
min=math.min(second,table.unpack(gph))
max=math.max(first,table.unpack(gph))
else
min=math.min(table.unpack(gph))
max=math.max(table.unpack(gph))
end
if max==min then max=max+0.001 end
end

function onDraw()
monitor.resx,monitor.resy=screen.getWidth(),screen.getHeight()

local range=height-18

local mox=toSt(max)
local mon=toSt(min)

screen.setColor(table.unpack(bccol))
screen.drawRectF(x,y,width,height)
screen.setColor(table.unpack(frcol))
screen.drawRect(x,y,width,height)

screen.setColor(table.unpack(grcol))
for i=2,#gph do
screen.drawLine(x+i-1,y+range-(gph[i-1]-min)/(max-min)*range+9,x+i,y+range-(gph[i]-min)/(max-min)*range+9)
end

local name=string.sub(name,1,math.max(math.floor((width-2-#mox*5)/5),0))
screen.drawText(x+width-#name*5,y+2,name)

screen.drawText(x+width-#toSt(inp)*5,y+height-6,toSt(inp))

if #mon*5>=width-#toSt(inp)*5-1 then
screen.setColor(table.unpack(bccol))
screen.drawRectF(x+1,y+height-7,width-1,7)
end

if max==first and property.getBool"Fixed min and max" then screen.setColor(fvcol[1],fvcol[2],fvcol[3]) else screen.setColor(table.unpack(frcol)) end
screen.drawText(x+2,y+2,mox) 
if min==second and property.getBool"Fixed min and max" then screen.setColor(fvcol[1],fvcol[2],fvcol[3]) else screen.setColor(table.unpack(frcol)) end
screen.drawText(x+2,y+height-6,mon)

if max>0 and min<0 then
screen.setColor(table.unpack(zrcol))
screen.drawLine(x+1,y+max/(max+math.abs(min))*range+9,x+#gph,y+max/(max+math.abs(min))*range+9)
end

if property.getBool"Fixed min and max" then
screen.setColor(table.unpack(fvcol))
if first~=max then
screen.drawLine(x+1,y+range-(first-min)/(max-min)*range+9,x+#gph,y+range-(first-min)/(max-min)*range+9)
end
if second~=min then
screen.drawLine(x+1,y+range-(second-min)/(max-min)*range+9,x+#gph,y+range-(second-min)/(max-min)*range+9)
end
end

screen.setColor(table.unpack(frcol))
screen.drawRect(x,y+8,width,height-16)

if #gph<width then
screen.drawLine(x+#gph,y+9,x+#gph,y+height-8)
end
end