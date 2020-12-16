This my collection stormworks scripts

---

[p](#projects)

MyLib:
- [Help functions](#help-functions)
  
Projects:
- [Monitoring](#monitoring)
- [Drone](#drone)
- [Cable suspended robot](#cable-suspended-robot)
- [Track player](#track-player)
- [Stepper motor](#stepper-motor)

---
##My Library

- ### Help functions
Source code: [help-functions.lua](MyLib/help-functions.lua)

| Signature      | Desctiption | Example |
| :---        |   :----:   | --- |
| getP(...)      | get property data |
| getN(start, count)   | get number data |
| outN(start, ...) |  output numbers | 
|
| math.sign(number) | get number sign |
| math.clamp(number, min, max) | get number in range
| pid(p, i, d, max_error) | get pid
|
| loop(number, max_value_module) | get looped value
| 
| gammaFix(bad_colors[]) | get fix gamma of the color
| hex2rgb(hex) | get rgb from hex | local r,g,b = hex2rgb('#00FF00')
|
| rotatePoint(radian, lenght, x0, y0) | get rotate point
| drawPixel(x,y) | draw pixel
|
| p(x,y) | get point structure
|
| outCoords(start, data[[x,y,z],[x,y,z],...]) | output coordinates
|
| pack() | 
| unpack() |


---
#Projects

- ## <a id="monitoring"></a> Monitoring

- ## Drone

- ## Cable suspended robot

- ## Track player

- ## Stepper motor
