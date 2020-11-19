cltypes="Hc As Ac St Sc Cu Ns Dc"
regimes="SE WE WW SW"
'reinit'
'ini -l'
'set mproj off'
'open clsize_diurnal_DJFMA.ctl'
i=1
while(i<=8)
type=subwrd(cltypes,i)
'set t 1'
'sum'type'=sum('type',t=1,t=48)'
'set t 1 48'
'diur'type'='type'/sum'type'*100'
'modify diur'type' diurnal'
i=i+1
endwhile

r=1
while(r<=4)
reg=subwrd(regimes,r)
'open clsize_diurnal_DJFMA_'reg'.ctl'

i=1
while(i<=8)
type=subwrd(cltypes,i)
'set t 1'
'sum'type%reg'=sum('type'.2,t=1,t=48)'

'set t 1 48'
'diur'type%reg'='type'.2/sum'type%reg'*100'
'modify diur'type%reg' diurnal'
* local 12 to 12
'set time 5z01 5z02'
'c'
'on'
'set grads off'
'set yflip on'
'set tlsupp month'
'set xlint 2.5'
'set ylabs 12|15|18|21|00|03|06|09|12'
'color -levs -0.7 -0.6 -0.5 -0.4 -0.3 -0.2 -0.1 0.1 0.2 0.3 0.4 0.5 0.6 0.7'
'd diur'type%reg'-diur'type
'cbar3 [%]'
'draw title 'type' 'reg' anomaly'
'off'
'set gxout contour'
'set clevs 0'
'set ccolor 1'
'set cthick 6'
'd diur'type%reg'-diur'type
pull xxx
i=i+1
endwhile
'close 2'
r=r+1
endwhile
