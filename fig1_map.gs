'reinit'
'ini'
'set mpdset hires'
'sdfopen ../obs/GLOBE_topo_0.05_degree_360.nc'
'set lon 80 150'
'set lat -20 20'

'set mproj scaled'
'ini -eq'
'set grads off'
'set xlint 10'
'set ylint 10'
'set map 1 1 3'
'color 0 2000 100 -kind topo2 -gxout shaded'
'd topo'
*'cbar3 [m]'
'xcbar -fs 5 -edge triangle -unit [m]'

lonA=99.75
latA=-0.05
lonB=104.05
latB=-5.35
'q w2xy 'lonA' 'latA
xA=subwrd(result,3)
yA=subwrd(result,6)
'q w2xy 'lonB' 'latB
xB=subwrd(result,3)
yB=subwrd(result,6)

plat=-(lonB-lonA)
plon=latB-latA
plen=math_sqrt(plon*plon+plat*plat)
c10=10/plen
c75=7.5/plen
lon10=c10*plon
lat10=c10*plat
lon75=c75*plon
lat75=c75*plat

'q w2xy 'lonA+lon10' 'latA+lat10
x1=subwrd(result,3)
y1=subwrd(result,6)
'q w2xy 'lonA-lon10/2' 'latA-lat10/2
x2=subwrd(result,3)
y2=subwrd(result,6)
'q w2xy 'lonB+lon10' 'latB+lat10
x3=subwrd(result,3)
y3=subwrd(result,6)
'q w2xy 'lonB-lon10/2' 'latB-lat10/2
x4=subwrd(result,3)
y4=subwrd(result,6)

'set line 5 1 10'
'draw line 'x1' 'y1' 'x2' 'y2
'draw line 'x2' 'y2' 'x4' 'y4
'draw line 'x4' 'y4' 'x3' 'y3
'draw line 'x3' 'y3' 'x1' 'y1

'q w2xy 'lonA+lon75' 'latA+lat75
x1=subwrd(result,3)
y1=subwrd(result,6)
'q w2xy 'lonB+lon75' 'latB+lat75
x3=subwrd(result,3)
y3=subwrd(result,6)
x2=xA
y2=yA
x4=xB
y4=yB

'set line 12 2 10'
'draw line 'x1' 'y1' 'x2' 'y2
'draw line 'x2' 'y2' 'x4' 'y4
'draw line 'x4' 'y4' 'x3' 'y3
'draw line 'x3' 'y3' 'x1' 'y1

'set line 2'
'draw mark 3 'xA' 'yA' 0.15'
'draw mark 3 'xB' 'yB' 0.15'

'gxprint fig1_map.svg white'
