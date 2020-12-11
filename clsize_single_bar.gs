case='CPL64'
cltypes="Hc As Ac St Sc Cu Ns Dc"
regimes="SE WE WW SW"
regdays="153 586 500 271"
'reinit'
'ini -l'
i=1
while(i<=4)
    reg=subwrd(regimes,i)
    'open /data/W.eddie/Sumatra/'case'/clsize_diurnal_DJFMA_'reg'.ctl'
    'set x 1'
    'set t 1'
    ty=1
    while(ty<=8)
        type=subwrd(cltypes,ty)
        type%reg'=sum(sum('type'.'i',x=2,x=4),t=1,t=48)/'subwrd(regdays,i)'/48/11'
        ty=ty+1
    endwhile
    i=i+1
endwhile

i=1
while(i<=4)
    reg=subwrd(regimes,i)
    'open /data/W.eddie/Sumatra/'case'/cltype_diurnal_DJFMA_'reg'.ctl'
    'set x 1'
    'set t 1'
    ty=1
    while(ty<=8)
        type=subwrd(cltypes,ty)
        type%reg'='type%reg'/(sum(sum('type'.'i+4',x=2,x=4),t=1,t=48)/'subwrd(regdays,i)'/48/11)'
        ty=ty+1
    endwhile
    i=i+1
endwhile

'set x 1 8'
j=1
while(j<=4)
    reg=subwrd(regimes,j)
    'bar'reg'=const(hc,0,-a)'
    i=1
    while(i<=8)
        type=subwrd(cltypes,i)
        'd 'type%reg
        val=subwrd(result,4)
        'set defval bar'reg' 'i' 1 'val
        i=i+1
    endwhile
    j=j+1
endwhile

gap=80
int=(100-gap)/100
'set grads off'
'set gxout bar'
'set bargap 'gap
'set vrange 0 800'
'set xlabs |Hc|As|Ac|St|Sc|Cu|Ns|Dc|'
'color 1 3 1'
'off'
r=1
while(r<=4)
    if(r=4);'on';'set grid horizontal';endif
    reg=subwrd(regimes,r)
    x1=int/2+int*(2-r)
    x2=x1+9
    'set x 'x1' 'x2
    'set ccolor '15+r
    'd bar'reg
    if(r=4);'draw title mean cross-sectional area of a cloud';'draw ylab [km`a2`n]';endif
    r=r+1
endwhile
'legend_bar tl 4 sE wE wW sW 16 17 18 19'

'gxprint clsize_single_bar.png white'
