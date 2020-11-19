lona.0=89.933144; lata.0=-7.791052; lonb.0=94.193806; latb.0=-13.175095
lona.1=91.922082; lata.1=-6.264138; lonb.1=96.19512; latb.1=-11.623459
lona.2=93.895379; lata.2=-4.724685; lonb.2=98.178298; latb.2=-10.063220
lona.3=95.855887; lata.3=-3.174601; lonb.3=100.146460; latb.3=-8.496310
lona.4=97.806469; lata.4=-1.615759; lonb.4=102.102682; latb.4=-6.924619
lona.5=99.750000; lata.5=-0.050000; lonb.5=104.050000; latb.5=-5.350000
lona.6=101.689368; lata.6=1.520855; lonb.6=105.991411; latb.6=-3.774281
lona.7=103.627478; lata.7=3.095001; lonb.7=107.929882; latb.7=-2.199273
lona.8=105.567260; lata.8=4.670634; lonb.8=109.868350; latb.8=-0.626778

'reinit'
'open /data/W.eddie/SPCAM/CPL64/atm.ctl'
'sdfopen ../obs/GLOBE_topo_0.05_degree_360.nc'
*'set lon 'lona.0' 'lonb.6
'set lon 90 110'
*'set lat 'latb.0' 'lata.6
'set lat -15 5'

'ini -eq'
'set mpdset hires'
'set grads off'
'set xlint 5'
'set ylint 5'
'color 0 2000 100 -kind topo2 -gxout shaded'
'd topo.2(z=1,t=1)'
'off'

'set grads off'
'set gxout grid'
'd q'

'set line 2 1 6'
i=0
while(i<=8)
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
i1=math_nint(qdims(xmin))
i2=math_nint(qdims(xmax))
j1=math_nint(qdims(ymin))
j2=math_nint(qdims(ymax))
'color 1 9 1 -kind sunset'
j=j1
while(j<=j2)
'set y 'j
lato=subwrd(result,4)
i=i1
while(i<=i2)
'set x 'i
lono=subwrd(result,4)
'set line 1'
reg=1
while(reg<=8)
p=reg
m=reg-1
deg1=degree(lono,lato,lona.m,lata.m,lonb.m,latb.m)
deg2=degree(lono,lato,lona.m,lata.m,lona.p,lata.p)
deg3=degree(lono,lato,lonb.p,latb.p,lonb.m,latb.m)
deg4=degree(lono,lato,lona.p,lata.p,lonb.p,latb.p)
degsum=deg1+deg2+deg3+deg4
if(degsum>359.9)
say i' 'j' 'reg-1' 'lono' 'lato
'set line 'reg+15
break
endif
reg=reg+1
endwhile
'q w2xy 'lono' 'lato
xo=subwrd(result,3)
yo=subwrd(result,6)
'draw mark 3 'xo' 'yo' '0.1
i=i+1
endwhile
j=j+1
endwhile
