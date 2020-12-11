regimes="sE wE wW sW"
'reinit'
'ini -h'
'open /data/W.eddie/Sumatra/CPL64/CPL64.Qprofile.ctl'

'set grads off'
'set lev 1000 150'
'set vrange -1 1'
'set zlog on'
'set cmark 0'
'set cthick 5'
'set ccolor 1'
'd const(qall,0)'
'draw xlab [g kg`a-1`n]'
'draw ylab pressure [hPa]'
'off'
'color 1 3 1'
r=1
while(r<=4)
    reg=subwrd(regimes,r)
    'set cmark 0'
    'set cthick 8'
    'set ccolor 'r+15
    'd (q'reg'-qall)*1000'
    r=r+1
endwhile
'legend tr 4 'regimes' 16 17 18 19'

'gxprint Qprofile_model.png white'
