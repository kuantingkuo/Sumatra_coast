lona.0=91.922082; lata.0=-6.264138; lonb.0=96.19512; latb.0=-11.623459
lona.1=93.895379; lata.1=-4.724685; lonb.1=98.178298; latb.1=-10.063220
lona.2=95.855887; lata.2=-3.174601; lonb.2=100.146460; latb.2=-8.496310
lona.3=97.806469; lata.3=-1.615759; lonb.3=102.102682; latb.3=-6.924619
lona.4=99.750000; lata.4=-0.050000; lonb.4=104.050000; latb.4=-5.350000
lona.5=101.689368; lata.5=1.520855; lonb.5=105.991411; latb.5=-3.774281
lona.6=103.627478; lata.6=3.095001; lonb.6=107.929882; latb.6=-2.199273


'reinit'
'open /data/W.eddie/SPCAM/CPL64/atm.ctl'
'set lon 'lona.0' 'lonb.6
'set lat 'latb.0' 'lata.6

*'set mproj scaled'
*'ini -eq'
'ini'
'set grads off'
'set gxout grid'
'd q'

'set line 2'
i=0
while(i<=6)
j=i-1
'q w2xy 'lona.i' 'lata.i
xa.i=subwrd(result,3)
ya.i=subwrd(result,6)
'q w2xy 'lonb.i' 'latb.i
xb.i=subwrd(result,3)
yb.i=subwrd(result,6)
m=i-1
'draw line 'xa.i' 'ya.i' 'xb.i' 'yb.i
if(m>=0)
'draw line 'xa.i' 'ya.i' 'xa.m' 'ya.m
'draw line 'xb.i' 'yb.i' 'xb.m' 'yb.m
endif
i=i+1
endwhile

rc=gsfallow('on')
j=43
while(j<=50)
'set y 'j
lato=subwrd(result,4)
i=38
while(i<=44)
'set x 'i
lono=subwrd(result,4)
reg=1
while(reg<=6)
p=reg
m=reg-1
deg1=degree(lono,lato,lona.m,lata.m,lonb.m,latb.m)
deg2=degree(lono,lato,lona.m,lata.m,lona.p,lata.p)
deg3=degree(lono,lato,lonb.p,latb.p,lonb.m,latb.m)
deg4=degree(lono,lato,lona.p,lata.p,lonb.p,latb.p)
degsum=deg1+deg2+deg3+deg4
if(degsum>359.9)
say i' 'j' 'reg
'q w2xy 'lono' 'lato
xo=subwrd(result,3)
yo=subwrd(result,6)
'set line 'reg
'draw mark 3 'xo' 'yo' '0.1
break
endif
reg=reg+1
endwhile
i=i+1
endwhile
j=j+1
endwhile

