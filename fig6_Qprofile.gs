'reinit'
'ini -h'
'open /data/W.eddie/Sumatra/Qprofile.ctl'
'open /data/W.eddie/Sumatra/obs/EC075_Z_profile_sumatra.ctl'

'set grads off'
'set lev 1000 100'
'set vrange -1 1'
'set zlog on'
'set cmark 0'
'set cthick 5'
'set ccolor 1'
'd const(qall,0)'
'draw xlab [g kg`a-1`n]'
'draw ylab pressure [hPa]'
'off'
'set cmark 0'
'set cthick 8'
'set ccolor 2'
'd (qsw-qall)*1000'
'set cmark 0'
'set cthick 8'
'set ccolor 4'
'd (qwe-qall)*1000'

'set dfile 2'
'set x 1'
'set y 1'
'set t 1'
'set cmark 0'
'set cthick 8'
'set ccolor 2'
'set cstyle 2'
'd qa_sw.2'
'set cmark 0'
'set cthick 8'
'set ccolor 4'
'set cstyle 2'
'd qa_we.2'

