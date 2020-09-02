'reinit'
'ini -l'
'open ../obs/EC075_Uprep_DJFMA_time_series.ctl'
'set t 1 last'

'set grads off'
'set cmark 0'
'set ccolor 11'
'set ylint 5'
'set xaxis 1998 2013.993377 2'
'd u'
'draw ylab [m s`a-1`n]'
'draw title Uprep DJFMA'

'off'

'mean = -0.2814124'
'std = 2.777613'

'set cmark 0'
'set ccolor 2'
'set cthick 6'
'd mean'
'q w2xy 00z01feb2014 -0.281412'
x=subwrd(result,3);y=subwrd(result,6)
'set string 2 l '
'set strsiz 0.2'
'draw string 'x' 'y' `3m'

'set cmark 0'
'set cstyle 2'
'set ccolor 2'
'set cthick 6'
'd mean+std'
'q w2xy 00z01feb2014 '%-0.281412+2.777613
x=subwrd(result,3);y=subwrd(result,6)
'set string 2 l '
'set strsiz 0.2'
'draw string 'x' 'y' `3m`5+`3s'

'set cmark 0'
'set cstyle 2'
'set ccolor 2'
'set cthick 6'
'd mean-std'
'q w2xy 00z01feb2014 '%-0.281412-2.777613
x=subwrd(result,3);y=subwrd(result,6)
'set string 2 l '
'set strsiz 0.2'
'draw string 'x' 'y' `3m`5-`3s'

'gxprint fig2_tseries.svg white'
