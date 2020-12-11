case="CPL64"
'reinit'
'ini -l'
'set parea 1.3 10 2 7.75'
'set mproj off'
'open ../'case'/'case'.diurprec.ctl'
'set lon -10 5'
'set t 1 last'

'pd=prec'
'modify pd diurnal'

regs="SE WE WW SW"
r=1
while(r<=4)
'set t 1 last'
reg=subwrd(regs,r)
'prd=prec'reg
'modify prd diurnal'
* local 12 to 12
'set time 5z01 5z02'

'c'
'on'
'set grid off'
'set grads off'
'set yflip on'
'set tlsupp month'
'set xlint 2.5'
'set ylabs 12|15|18|21|00|03|06|09|12'
'color 3 15 1 -kind cwblgt -gxout grfill'
'd prd*24'
'xcbar -fs 2 -unit [mm d`a-1`n] -yo -0.3'
'draw xlab Distance [degrees]'
'draw ylab Local Solar Time [hr]'

'q w2xy 0 05Z01'
x1=subwrd(result,3)
y1=subwrd(result,6)
'q w2xy 0 05Z02'
x2=subwrd(result,3)
y2=subwrd(result,6)

'off'
'set gxout contour'
'set rgb 100 100 100 100'
'set rgb 200 200 200 200'
'set ccolor 1'
'set cthick 6'
'set clevs 7 10 13'
'set clskip 1 0'
'set clab off'
'd pd*24'

'set line 0 2 3'
'draw line 'x1' 'y1' 'x1' 'y2

'gxprint fig5_diurhovmuller_'reg'.svg white'
r=r+1
endwhile
