case="PRSHR"
cltypes="Hc As Ac St Sc Cu Ns Dc"
'reinit'
'ini -l'
'set mproj off'
'open ../'case'/clsize_diurnal_DJFMA.ctl'
'points=const(maskout(const(hc,4),lon<-2.5),3,-u)'
'set t 1 last'
'sumtype=const(hc,0)'
'modify sumtype diurnal'
t=1
while(t<=8)
    'set t 1 last'
    type=subwrd(cltypes,t)
    'mean'type'='type'/3650/points'
    'modify mean'type' diurnal'
    'set time 5z01 5z02'

    'c'
    'set grads off'
    'set tlsupp month'
    'set xlint 2.5'
    'set yflip on'
    'set ylabs 12|15|18|21|00|03|06|09|12'
    'color 0 90 -kind jet'
    'd mean'type
    'cbar3 [km`a-2`n]'
    'draw title 'type
    'draw xlab distance from the coast [degrees]'
    'draw ylab local time [h]'
    'gxprint ../'case'/'case'.clsize_diurnal_'type'.png white'
    'sumtype=sumtype+mean'type
    t=t+1
endwhile
'c'
'set grads off'
'set tlsupp month'
'set xlint 2.5'
'set yflip on'
'set ylabs 12|15|18|21|00|03|06|09|12'
'color 180 270 5 -kind jet'
'd sumtype'
'draw title All cloud types'
'draw xlab distance from the coast [degrees]'
'draw ylab local time [h]'
'cbar3 [km`a-2`n]'
'gxprint ../'case'/'case'.clsize_diurnal_All.png white'

'c'
'set grads off'
'set x 3'
'set time 5z01 5z02'
t=1
while(t<=8)
    type=subwrd(cltypes,t)
    'set vrange 0 50'
    'set ccolor 't+1
    'set cmark 0'
    'set xlabs 12|15|18|21|00|03|06|09|12'
    'd mean'type'/sumtype*100'
    if(t=1)
        'draw title Fraction of cloud types  `0Ocean'
        'draw xlab local time [h]'
        'draw ylab [%]'
    endif
    'off'
    t=t+1
endwhile
'legend tr 8 'cltypes' 2 3 4 5 6 7 8 9'
'gxprint ../'case'/'case'.clfrac_ocn.png white'

'on'
'c'
'set grads off'
'set x 5'
'set time 5z01 5z02'
t=1
while(t<=8)
    type=subwrd(cltypes,t)
    'set vrange 0 50'
    'set ccolor 't+1
    'set cmark 0'
    'set xlabs 12|15|18|21|00|03|06|09|12'
    'd mean'type'/sumtype*100'
    if(t=1)
        'draw title Fraction of cloud types  `0Land'
        'draw xlab local time [h]'
        'draw ylab [%]'
    endif
    'off'
    t=t+1
endwhile
'legend tr 8 'cltypes' 2 3 4 5 6 7 8 9'
'gxprint ../'case'/'case'.clfrac_lnd.png white'
