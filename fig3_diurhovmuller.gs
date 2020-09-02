'reinit'
'ini -l'
'set mproj off'
'open ../obs/TRMM3B42_sumatra_Clim.ctl'
'open ../obs/GLOBE_topo_sumatra.ctl'
'set x 1 61'
'set t 1 last'

'pd=prec'
'modify pd diurnal'

regs="SE WE WW SW"
r=1
while(r<=4)
reg=subwrd(regs,r)
'open ../obs/TRMM3B42_sumatra_'reg'.ctl'
'set x 1 61'
'set t 1 last'
'prd=prec.3'
'modify prd diurnal'
'set time 12z01 12z02'

'c'
'on'
'set grads off'
'set yflip on'
'set tlsupp month'
'set xlint 200'
'set ylabs 12|15|18|21|00|03|06|09|12'
'color 0 30 1 -kind cwblgt'
'd prd*24'
'xcbar -fs 3 -unit [mm d`a-1`n] -yo -0.3'
'draw xlab Distance [km]'
'draw ylab Local Solar Time [hr]'

land1=38
land2=52

'q gr2xy 'land1' 5'
x1=subwrd(result,3)
y1=subwrd(result,6)
'q gr2xy 'land2' 13'
x2=subwrd(result,3)
y2=subwrd(result,6)

'off'
'set gxout contour'
'set rgb 100 100 100 100'
'set rgb 200 200 200 200'
'set ccolor 200'
'set cthick 6'
'set clevs 9 15 21'
'set clskip 1 0'
'set clab forced'
'd pd*24'

'set t 1'
'set yflip off'
'set vrange 0 8000'
'set cmark 0'
'set ccolor 1'
'set cthick 8'
'd topo.2'
'set line 1 1 1'
'draw line 'x1' 'y1' 'x1' 'y2
'draw line 'x2' 'y1' 'x2' 'y2

'gxprint fig3_diurhovmuller_'reg'.svg white'
'close 3'
r=r+1
endwhile
