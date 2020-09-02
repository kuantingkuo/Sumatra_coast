'reinit'
'ini -l'
'open ../obs/EC075_Uprep_DJFMA_PDF.ctl'
'set mproj off'
'set lon -6 12'

'set grads off'
'set gxout bar'
'set ccolor 11'
'set vrange 0 200'
'set xlint 3'
'set ylint 50'
'd n'
'draw xlab [m s`a-1`n]'
** draw outline
'off'
'set baropts outline'
'set vrange 0 200'
'set ccolor 1'
'set cthick 1'
'd n'

mean = -0.281412
std = 2.777613
'q w2xy 'mean' 0'
x=subwrd(result,3)
y1=subwrd(result,6)
'q w2xy 'mean' 200'
y2=subwrd(result,6)
'set line 2 1 6'
'draw line 'x' 'y1' 'x' 'y2
'q w2xy 'mean-std' 0'
x=subwrd(result,3)
'set line 2 2 6'
'draw line 'x' 'y1' 'x' 'y2
'q w2xy 'mean+std' 0'
x=subwrd(result,3)
'set line 2 2 6'
'draw line 'x' 'y1' 'x' 'y2

'gxprint fig2_regimes.svg white'
